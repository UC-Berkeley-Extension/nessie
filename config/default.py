"""
Copyright ©2018. The Regents of the University of California (Regents). All Rights Reserved.

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


import logging
import os


# Base directory for the application (one level up from this config file).
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))

# Some defaults.
CSRF_ENABLED = True
CSRF_SESSION_KEY = 'secret'
# Used to encrypt session cookie.
SECRET_KEY = 'secret'

# Override in local configs.
HOST = '0.0.0.0'
PORT = 1234

AWS_ACCESS_KEY_ID = 'key'
AWS_SECRET_ACCESS_KEY = 'secret'
AWS_REGION = 'aws region'

CANVAS_DATA_API_KEY = 'some key'
CANVAS_DATA_API_SECRET = 'some secret'
CANVAS_DATA_HOST = 'foo.instructure.com'

LOCH_CANVAS_DATA_BUCKET_CURRENT_TERM = 's3/path/to/current/term/bucket'
LOCH_CANVAS_DATA_BUCKET_DAILY = 's3/path/to/daily/bucket'
LOCH_CANVAS_DATA_BUCKET_HISTORICAL = 's3/path/to/historical/bucket'
LOCH_CANVAS_DATA_IAM_ROLE = 'iam role'
LOCH_CANVAS_DATA_REQUESTS_TERM_REGEXP = 'regexp for requests file url parsing'

LOCH_S3_BUCKET = 'bucket_name'
LOCH_S3_REGION = 'aws_region'

LOGGING_FORMAT = '[%(asctime)s] - %(levelname)s: %(message)s [in %(pathname)s:%(lineno)d]'
LOGGING_LOCATION = 'nessie.log'
LOGGING_LEVEL = logging.DEBUG

REDSHIFT_DATABASE = 'database'
REDSHIFT_HOST = 'redshift cluster'
REDSHIFT_PASSWORD = 'password'
REDSHIFT_PORT = 1234
REDSHIFT_USER = 'username'

REDSHIFT_SCHEMA_BOAC = 'BOAC schema name'
REDSHIFT_SCHEMA_CANVAS = 'Canvas schema name'

WORKER_HOST = 'app url'
WORKER_USERNAME = 'username'
WORKER_PASSWORD = 'password'
