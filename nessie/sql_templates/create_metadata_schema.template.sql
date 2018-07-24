/**
 * Copyright ©2018. The Regents of the University of California (Regents). All Rights Reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its documentation
 * for educational, research, and not-for-profit purposes, without fee and without a
 * signed licensing agreement, is hereby granted, provided that the above copyright
 * notice, this paragraph and the following two paragraphs appear in all copies,
 * modifications, and distributions.
 *
 * Contact The Office of Technology Licensing, UC Berkeley, 2150 Shattuck Avenue,
 * Suite 510, Berkeley, CA 94720-1620, (510) 643-7201, otl@berkeley.edu,
 * http://ipira.berkeley.edu/industry-info for commercial licensing opportunities.
 *
 * IN NO EVENT SHALL REGENTS BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL,
 * INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING LOST PROFITS, ARISING OUT OF
 * THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF REGENTS HAS BEEN ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * REGENTS SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
 * SOFTWARE AND ACCOMPANYING DOCUMENTATION, IF ANY, PROVIDED HEREUNDER IS PROVIDED
 * "AS IS". REGENTS HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
 * ENHANCEMENTS, OR MODIFICATIONS.
 */

CREATE SCHEMA IF NOT EXISTS {redshift_schema_metadata};

CREATE TABLE IF NOT EXISTS {redshift_schema_metadata}.background_job_status
(
    job_id VARCHAR NOT NULL,
    -- Possible 'status' values: 'started', 'succeeded', 'failed'
    status VARCHAR NOT NULL,
    instance_id VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    details VARCHAR(4096),
    -- Primary key constraints are not enforced by Redshift but are used in query planning.
    -- https://docs.aws.amazon.com/redshift/latest/dg/t_Defining_constraints.html
    PRIMARY KEY (job_id)
);

CREATE TABLE IF NOT EXISTS {redshift_schema_metadata}.canvas_sync_job_status
(
    job_id VARCHAR NOT NULL,
    filename VARCHAR NOT NULL,
    canvas_table VARCHAR NOT NULL,
    source_url VARCHAR(4096) NOT NULL,
    source_size BIGINT,
    destination_url VARCHAR(1024),
    destination_size BIGINT,
    -- Possible 'status' values:
    -- - 'created': the master node has identified a source file in Canvas and will dispatch a sync job
    -- - 'received': the worker node has received the dispatch request
    -- - 'started': the worker node has started a background thread for the sync job
    -- - 'streaming': the worker node has started streaming the file to S3
    -- - 'complete': the worker node has completed the file upload to S3
    -- - 'duplicate': the worker node has found a duplicate file in S3 and will not upload
    -- - 'error': an error occurred.
    status VARCHAR NOT NULL,
    -- Further details on job status. Currently used only for errors.
    details VARCHAR(4096),
    instance_id VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    PRIMARY KEY (job_id, filename)
)
DISTKEY (job_id)
INTERLEAVED SORTKEY (job_id, filename);

CREATE TABLE IF NOT EXISTS {redshift_schema_metadata}.canvas_synced_snapshots
(
    filename VARCHAR NOT NULL,
    canvas_table VARCHAR NOT NULL,
    url VARCHAR NOT NULL,
    size BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP
)
SORTKEY (filename);

CREATE TABLE IF NOT EXISTS {redshift_schema_metadata}.merged_feed_status
(
    sid VARCHAR NOT NULL,
    term_id VARCHAR(4) NOT NULL,
    -- Possible 'status' values: 'succeeded', 'failed'
    status VARCHAR NOT NULL,
    updated_at TIMESTAMP NOT NULL
)
SORTKEY (sid, term_id);
