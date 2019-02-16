"""
Copyright ©2019. The Regents of the University of California (Regents). All Rights Reserved.

Permission to use, copy, modify, and distribute this software and its documentation
for educational, research, and not-for-profit purposes, without fee and without a
signed licensing agreement, is hereby granted, provided that the above copyright
notice, this paragraph and the following two paragraphs appear in all copies,
modifications, and distributions.

Contact The Office of Technology Licensing, UC Berkeley, 2150 Shattuck Avenue,
Suite 510, Berkeley, CA 94720-1620, (510) 643-7201, otl@berkeley.edu,
http://ipira.berkeley.edu/industry-info for commercial licensing opportunities.

IN NO EVENT SHALL REGENTS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL,
INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF
THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF REGENTS HAS BEEN ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.

REGENTS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED HEREUNDER IS PROVIDED
"AS IS". REGENTS HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
ENHANCEMENTS, OR MODIFICATIONS.
"""


from datetime import datetime, timedelta

from flask import current_app as app
from nessie.externals import canvas_data, redshift, s3
from nessie.jobs.background_job import BackgroundJob, BackgroundJobError
from nessie.lib.util import get_s3_canvas_daily_path
import pandas as pd


"""Logic for generate canvas data catalog job."""


class RefreshCanvasDataCatalog(BackgroundJob):

    def run(self):
        # Retrieve latest schema definitions from Canvas data API
        response = canvas_data.get_canvas_data_schema()
        external_schema = app.config['REDSHIFT_SCHEMA_CANVAS']
        redshift_iam_role = app.config['REDSHIFT_IAM_ROLE']
        canvas_schema = []

        # Parse and isolate table and column details
        for key, value in response['schema'].items():
            for column in value['columns']:
                # Not every column has description and length.
                description = None
                if 'description' in column:
                    description = column['description']

                length = None
                if 'length' in column:
                    length = column['length']

                canvas_schema.append([
                    value['tableName'],
                    column['name'],
                    column['type'],
                    description,
                    length,
                ])
        # create a dataframe to
        schema_df = pd.DataFrame(canvas_schema)
        schema_df.columns = [
            'table_name',
            'column_name',
            'column_type',
            'column_description',
            'column_length',
        ]

        # The schema definitions received from Canvas are Redshift compliant. We update
        # cetain column types to match glue and spectrum data types
        schema_df['glue_type'] = schema_df['column_type'].replace({
            'enum': 'varchar',
            'guid': 'varchar',
            'text': 'varchar(max)',
            'date': 'timestamp',
            'datetime': 'timestamp',
        })

        schema_df['transformed_column_name'] = schema_df['column_name'].replace({
                                                                                'default': '"default"',
                                                                                'percent': '"percent"',
                                                                                })
        # create hive compliant storage descriptors
        canvas_external_catalog_ddl = self.generate_external_catalog(external_schema, schema_df)

        # clean up and recreate refreshed tables on Glue using Spectrum
        redshift.drop_external_schema(external_schema)
        redshift.create_external_schema(external_schema, redshift_iam_role)

        if redshift.execute_ddl_script(canvas_external_catalog_ddl):
            app.logger.info(f'Canvas schema creation job completed.')
            return self.verify_external_data_catalog()
        else:
            app.logger.error(f'Canvas schema creation job failed.')
            raise BackgroundJobError(f'Canvas schema creation job failed.')

    def generate_external_catalog(self, external_schema, schema_df):
        canvas_path = get_s3_canvas_daily_path(datetime.now() - timedelta(days=1))
        canvas_tables = schema_df.table_name.unique()
        s3_canvas_data_url = 's3://' + app.config['LOCH_S3_BUCKET'] + '/' + canvas_path
        s3_requests_url = 's3://{}/{}'.format(app.config['LOCH_S3_BUCKET'], app.config['LOCH_S3_CANVAS_DATA_PATH_CURRENT_TERM'])
        external_table_ddl = ''

        for table in canvas_tables:
            table_columns = schema_df.loc[schema_df['table_name'] == table].reset_index()
            storage_descriptor_df = table_columns[['transformed_column_name', 'glue_type']]

            create_ddl = 'CREATE EXTERNAL TABLE {}.{}\n(\n'.format(external_schema, table)
            storage_descriptors = ''
            for index in storage_descriptor_df.index:
                storage_descriptors = '{}    {} {}'.format(
                    storage_descriptors,
                    storage_descriptor_df['transformed_column_name'][index],
                    storage_descriptor_df['glue_type'][index],
                )
                if (index != (len(storage_descriptor_df.index) - 1)):
                    storage_descriptors = storage_descriptors + ',\n'

            table_properties = '\n) \nROW FORMAT DELIMITED FIELDS \nTERMINATED BY \'\t\' \nSTORED AS TEXTFILE'
            if (table != 'requests'):
                table_location = '\nLOCATION \'{}/{}\''.format(s3_canvas_data_url, table)
            else:
                table_location = '\nLOCATION \'{}/{}\''.format(s3_requests_url, table)

            external_table_ddl = '{}\n{}{}{}{};\n\n'.format(
                external_table_ddl,
                create_ddl,
                storage_descriptors,
                table_properties,
                table_location,
            )

        # For debugging process, export to external_table_ddl to file to get a well formed SQL template for canvas-data
        return external_table_ddl

    # Gets an inventory of all the tables by tracking the S3 canvas-data daily location and run count verification to ensure migration was successful
    def verify_external_data_catalog(self):
        s3_client = s3.get_client()
        bucket = app.config['LOCH_S3_BUCKET']
        external_schema = app.config['REDSHIFT_SCHEMA_CANVAS']
        prefix = get_s3_canvas_daily_path(datetime.now() - timedelta(days=1))
        app.logger.info(f'Daily path = {prefix}')
        directory_names = []
        s3_objects = s3_client.list_objects_v2(Bucket=bucket, Prefix=prefix)
        for object_summary in s3_objects['Contents']:
            # parse table names from the S3 object URLs
            directory_names.append(object_summary['Key'].split('/')[3])

        # get unique table names from s3 object list
        tables = list(set(directory_names))

        for table in tables:
            result = redshift.fetch(f'SELECT COUNT(*) FROM {external_schema}.{table}')
            if result and result[0] and result[0]['count']:
                count = result[0]['count']
                app.logger.info(f'Verified external table {table} ({count} rows).')
            else:
                raise BackgroundJobError(f'Failed to verify external table {table}: aborting job.')