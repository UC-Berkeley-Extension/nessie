/**
 * Copyright ©2019. The Regents of the University of California (Regents). All Rights Reserved.
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

CREATE SCHEMA IF NOT EXISTS {rds_schema_metadata};

-- - 'created': the master node has dispatched a term for processing and is waiting for a worker node to pick it up.
-- - 'started': the worker node has started the job.
-- - 'success': the worker node has finished the job.
-- - 'error': an error occurred.
DO $$ BEGIN
    CREATE TYPE merged_enrollment_term_job_status AS ENUM ('created', 'started', 'success', 'error');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

CREATE TABLE IF NOT EXISTS {rds_schema_metadata}.merged_enrollment_term_job_queue
(
    id SERIAL PRIMARY KEY,
    master_job_id VARCHAR NOT NULL,
    term_id VARCHAR NOT NULL,
    status merged_enrollment_term_job_status NOT NULL,
    details VARCHAR,
    instance_id VARCHAR,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL
);

CREATE INDEX IF NOT EXISTS merged_enrollment_term_job_idx
ON {rds_schema_metadata}.merged_enrollment_term_job_queue (master_job_id, term_id);
CREATE INDEX IF NOT EXISTS merged_enrollment_term_job_status_idx
ON {rds_schema_metadata}.merged_enrollment_term_job_queue (status);
