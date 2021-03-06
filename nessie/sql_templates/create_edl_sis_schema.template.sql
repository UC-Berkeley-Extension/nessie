/**
 * Copyright ©2020. The Regents of the University of California (Regents). All Rights Reserved.
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

--------------------------------------------------------------------
-- CREATE EXTERNAL SCHEMA
--------------------------------------------------------------------

CREATE EXTERNAL SCHEMA {redshift_schema_edl_sis}
FROM data catalog
DATABASE '{redshift_schema_edl_sis}'
IAM_ROLE '{redshift_iam_role}'
CREATE EXTERNAL DATABASE IF NOT EXISTS;

--------------------------------------------------------------------
-- External Tables
--------------------------------------------------------------------

CREATE EXTERNAL TABLE {redshift_schema_edl_sis}.student_academic_plan_data
(
    student_id VARCHAR,
    academic_career_cd VARCHAR,
    career_program_sequence_nbr DECIMAL(38,0),
    academic_program_effective_dt TIMESTAMP,
    academic_program_status_cd VARCHAR,
    academic_program_status_desc VARCHAR,
    academic_program_cd VARCHAR,
    academic_program_nm VARCHAR,
    academic_group_desc VARCHAR,
    academic_plan_cd VARCHAR,
    academic_plan_nm VARCHAR,
    academic_plan_formal_desc VARCHAR,
    academic_plan_type_cd VARCHAR,
    academic_plan_type_desc VARCHAR,
    academic_plan_type_category VARCHAR,
    academic_plan_org_desc VARCHAR,
    degree_cd VARCHAR,
    degree_desc VARCHAR,
    degree_short_desc VARCHAR,
    degree_offered_nm VARCHAR,
    current_admit_term VARCHAR,
    degree_expected_year_term_cd VARCHAR,
    transfer_student VARCHAR,
    academic_plan_short_nm VARCHAR,
    major_cd VARCHAR,
    major_nm VARCHAR,
    all_plan_acad_hier_level_nm VARCHAR,
    academic_plan_type_shrt_nm VARCHAR,
    academic_plan_type_nm VARCHAR,
    academic_department_cd VARCHAR,
    academic_department_short_nm VARCHAR,
    academic_department_nm VARCHAR,
    academic_division_cd VARCHAR,
    academic_division_shrt_nm VARCHAR,
    academic_division_nm VARCHAR,
    reporting_college_school_cd VARCHAR,
    reporting_college_school_letter_cd VARCHAR,
    reporting_clg_school_short_nm VARCHAR,
    reporting_college_school_nm VARCHAR,
    cip_classification_insr_pgm_cd VARCHAR,
    cip_classification_insr_pgm_nm VARCHAR,
    academic_career_short_nm VARCHAR,
    academic_career_nm VARCHAR,
    academic_program_shrt_nm VARCHAR,
    degree_offered_cd VARCHAR,
    funding_source_cd VARCHAR,
    funding_source_shrt_nm VARCHAR,
    funding_source_desc VARCHAR,
    plan_category_cd VARCHAR,
    plan_category_desc VARCHAR,
    load_dt DATE
)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat'
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION '{loch_s3_edl_data_path}/analytics/cs/STUDENT_ACADEMIC_PLAN_DATA/';

CREATE EXTERNAL TABLE {redshift_schema_edl_sis}.student_academic_progress_data
(
    student_id VARCHAR,
    analysis_db_seq_nbr DECIMAL(38,0),
    saa_career_rpt_cd VARCHAR,
    reporting_dt TIMESTAMP,
    tscrpt_type_cd VARCHAR,
    requirement_group_cd VARCHAR,
    requirement_cd VARCHAR,
    requirement_status_cd VARCHAR,
    requirement_desc VARCHAR,
    in_progress_grade_flg VARCHAR,
    load_dt DATE
)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat'
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION '{loch_s3_edl_data_path}/analytics/cs/STUDENT_ACADEMIC_PROGRESS_DATA/';

CREATE EXTERNAL TABLE {redshift_schema_edl_sis}.student_academic_terms_data
(
    academic_career_cd VARCHAR,
    semester_year_term_cd VARCHAR,
    term_category_cd VARCHAR,
    term_desc VARCHAR,
    term_yr VARCHAR,
    academic_yr VARCHAR,
    term_cd VARCHAR,
    semester_year_name_concat VARCHAR,
    semester_year_name_concat_2 VARCHAR,
    semester_first_day_of_insr_dt TIMESTAMP,
    term_end_dt TIMESTAMP,
    term_cancel_end_dt TIMESTAMP,
    term_withdraw_with_penalty_end_dt TIMESTAMP,
    term_withdraw_without_penalty_end_dt TIMESTAMP,
    load_dt DATE
)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat'
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION '{loch_s3_edl_data_path}/analytics/cs/STUDENT_ACADEMIC_TERMS_DATA/';

CREATE EXTERNAL TABLE {redshift_schema_edl_sis}.student_academic_terms_session_data(
    academic_career_cd VARCHAR,
    semester_year_term_cd VARCHAR,
    session_nbr VARCHAR,
    session_desc VARCHAR,
    session_begin_dt TIMESTAMP,
    session_end_dt TIMESTAMP,
    session_first_enrollment_dt TIMESTAMP,
    session_last_enrollment_dt TIMESTAMP,
    session_last_wait_list_dt TIMESTAMP,
    session_instruction_begin_dt TIMESTAMP,
    session_end_5th_week_dt TIMESTAMP,
    session_end_formal_instruction_dt TIMESTAMP,
    session_end_rrr_week_dt TIMESTAMP,
    session_begin_exam_week_dt DATE,
    midterm_grade_begin_dt TIMESTAMP,
    midterm_grade_end_dt TIMESTAMP,
    final_grade_begin_dt TIMESTAMP,
    final_grade_end_dt TIMESTAMP,
    session_drop_delete_end_dt TIMESTAMP,
    session_drop_retain_end_dt TIMESTAMP,
    session_drop_with_penalty_end_dt TIMESTAMP,
    session_cancel_end_dt TIMESTAMP,
    session_withdraw_without_penalty_end_dt TIMESTAMP,
    session_withdraw_with_penalty_end_dt TIMESTAMP,
    load_dt DATE
)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat'
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION '{loch_s3_edl_data_path}/analytics/cs/STUDENT_ACADEMIC_TERMS_SESSION_DATA/';

CREATE EXTERNAL TABLE {redshift_schema_edl_sis}.student_advisor_data(
    student_id VARCHAR,
    advisor_effective_dt TIMESTAMP,
    advisor_role VARCHAR,
    advisor_role_desc VARCHAR,
    student_advisor_nbr DECIMAL(38,0),
    academic_career_cd VARCHAR,
    academic_program_cd VARCHAR,
    academic_plan_cd VARCHAR,
    academic_plan_nm VARCHAR,
    advisor_id VARCHAR,
    advisor_name VARCHAR,
    academic_plan_short_nm VARCHAR,
    major_cd VARCHAR,
    major_nm VARCHAR,
    all_plan_acad_hier_level_nm VARCHAR,
    academic_plan_type_cd VARCHAR,
    academic_plan_type_shrt_nm VARCHAR,
    academic_plan_type_nm VARCHAR,
    academic_department_cd VARCHAR,
    academic_department_short_nm VARCHAR,
    academic_department_nm VARCHAR,
    academic_division_cd VARCHAR,
    academic_division_shrt_nm VARCHAR,
    academic_division_nm VARCHAR,
    reporting_college_school_cd VARCHAR,
    reporting_college_school_letter_cd VARCHAR,
    reporting_clg_school_short_nm VARCHAR,
    reporting_college_school_nm VARCHAR,
    cip_classification_insr_pgm_cd VARCHAR,
    cip_classification_insr_pgm_nm VARCHAR,
    academic_career_short_nm VARCHAR,
    academic_career_nm VARCHAR,
    academic_program_shrt_nm VARCHAR,
    academic_program_nm VARCHAR,
    degree_offered_cd VARCHAR,
    degree_offered_nm VARCHAR,
    funding_source_cd VARCHAR,
    funding_source_shrt_nm VARCHAR,
    funding_source_desc VARCHAR,
    plan_category_cd VARCHAR,
    plan_category_desc VARCHAR,
    load_dt DATE
)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat'
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION '{loch_s3_edl_data_path}/analytics/cs//STUDENT_ADVISOR_DATA/';

CREATE EXTERNAL TABLE {redshift_schema_edl_sis}.student_athlete_data(
    student_id VARCHAR,
    athlete_sport_cd VARCHAR,
    athlete_sport_desc VARCHAR,
    athlete_sport_effective_dt TIMESTAMP,
    athlete_participation_cd VARCHAR,
    athlete_participation_desc VARCHAR,
    athlete_current_participant_flg VARCHAR,
    load_dt DATE
)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat'
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION '{loch_s3_edl_data_path}/analytics/cs/STUDENT_ATHLETE_DATA/';

CREATE EXTERNAL TABLE {redshift_schema_edl_sis}.student_awarded_degree_data(
    student_id VARCHAR,
    prsn_schl_degree_sequence_nbr VARCHAR,
    degree_cd VARCHAR,
    degree_desc VARCHAR,
    degree_offered_nm VARCHAR,
    academic_career_cd VARCHAR,
    actual_grad_year_term_desc VARCHAR,
    degree_conferred_dt TIMESTAMP,
    academic_degree_status_cd VARCHAR,
    academic_degree_status_desc VARCHAR,
    degree_status_dt TIMESTAMP,
    academic_program_cd VARCHAR,
    academic_program_nm VARCHAR,
    academic_group_desc VARCHAR,
    academic_plan_cd VARCHAR,
    academic_plan_nm VARCHAR,
    academic_plan_transcr_desc VARCHAR,
    academic_org_desc VARCHAR,
    academic_subplan_cd VARCHAR,
    academic_subplan_nm VARCHAR,
    academic_plan_short_nm VARCHAR,
    major_cd VARCHAR,
    major_nm VARCHAR,
    all_plan_acad_hier_level_nm VARCHAR,
    academic_plan_type_cd VARCHAR,
    academic_plan_type_shrt_nm VARCHAR,
    academic_plan_type_nm VARCHAR,
    academic_department_cd VARCHAR,
    academic_department_short_nm VARCHAR,
    academic_department_nm VARCHAR,
    academic_division_cd VARCHAR,
    academic_division_shrt_nm VARCHAR,
    academic_division_nm VARCHAR,
    reporting_college_school_cd VARCHAR,
    reporting_college_school_letter_cd VARCHAR,
    reporting_clg_school_short_nm VARCHAR,
    reporting_college_school_nm VARCHAR,
    cip_classification_insr_pgm_cd VARCHAR,
    cip_classification_insr_pgm_nm VARCHAR,
    academic_career_short_nm VARCHAR,
    academic_career_nm VARCHAR,
    academic_program_shrt_nm VARCHAR,
    degree_offered_cd VARCHAR,
    funding_source_cd VARCHAR,
    funding_source_shrt_nm VARCHAR,
    funding_source_desc VARCHAR,
    plan_category_cd VARCHAR,
    plan_category_desc VARCHAR,
    load_dt DATE
)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat'
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION '{loch_s3_edl_data_path}/analytics/cs/STUDENT_AWARDED_DEGREE_DATA/';

CREATE EXTERNAL TABLE {redshift_schema_edl_sis}.student_citizenship_data(
    student_id VARCHAR,
    dependent_id VARCHAR,
    citizenship_country_cd VARCHAR,
    citizenship_country_desc VARCHAR,
    citizenship_status_cd VARCHAR,
    citizenship_status_desc VARCHAR,
    load_dt DATE
)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat'
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION '{loch_s3_edl_data_path}/analytics/cs/STUDENT_CITIZENSHIP_DATA/';

CREATE EXTERNAL TABLE {redshift_schema_edl_sis}.student_enrollment_data(
    student_id VARCHAR,
    academic_career_cd VARCHAR,
    institution_cd VARCHAR,
    applied_year_term_cd VARCHAR,
    class_number DECIMAL(38,0),
    official_cross_list_bundle_nbr VARCHAR,
    course_offer_number DECIMAL(38,0),
    course_subject_cd VARCHAR,
    course_number VARCHAR,
    class_section_cd VARCHAR,
    associated_class_nbr DECIMAL(38,0),
    course_career_cd VARCHAR,
    summer_session_cd VARCHAR,
    enrollment_action_cd VARCHAR,
    enrolllment_status_desc VARCHAR,
    enrollment_status_dt TIMESTAMP,
    enrollment_effective_dt TIMESTAMP,
    enrollment_drop_dt TIMESTAMP,
    wait_list_position_cd BIGINT,
    units DECIMAL(5,2),
    grading_basis_enrollment_cd VARCHAR,
    grading_basis_enrollment_desc VARCHAR,
    instructional_format_nm VARCHAR,
    instructional_format_desc VARCHAR,
    enrollment_section_flg VARCHAR,
    graded_section_flg VARCHAR,
    midterm_course_grade_input_cd VARCHAR,
    grd VARCHAR,
    final_grade_points DECIMAL(9,3),
    requirement_designation VARCHAR,
    unit_earned DECIMAL(5,2),
    repeat_cd VARCHAR,
    earn_credit_flg VARCHAR,
    include_in_gpa_flg VARCHAR,
    relate_class_1_nbr DECIMAL(38,0),
    relate_class_2_nbr DECIMAL(38,0),
    completion_status_desc VARCHAR,
    last_enrollment_tmsp TIMESTAMP,
    last_drop_action_tmsp TIMESTAMP,
    last_update_tmsp TIMESTAMP,
    load_dt DATE
)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat'
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION '{loch_s3_edl_data_path}/analytics/cs/STUDENT_ENROLLMENT_DATA/';

CREATE EXTERNAL TABLE {redshift_schema_edl_sis}.student_ethnicity_data(
    student_id VARCHAR,
    regulatory_region VARCHAR,
    ethnic_cd VARCHAR,
    ethnic_desc VARCHAR,
    ethnic_rollup_cd VARCHAR,
    ethnic_rollup_desc VARCHAR,
    ethnic_hispanic_latino_flg VARCHAR,
    load_dt DATE
)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat'
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION '{loch_s3_edl_data_path}/analytics/cs/STUDENT_ETHNICITY_DATA/';

CREATE EXTERNAL TABLE {redshift_schema_edl_sis}.student_personal_data(
    student_id VARCHAR,
    gender_cd VARCHAR,
    birth_dt TIMESTAMP,
    person_first_nm VARCHAR,
    person_middle_nm VARCHAR,
    person_last_nm VARCHAR,
    person_display_nm VARCHAR,
    person_last_first_nm VARCHAR,
    person_preferred_first_nm VARCHAR,
    person_preferred_last_nm VARCHAR,
    person_preferred_middle_nm VARCHAR,
    person_preferred_display_nm VARCHAR,
    person_preferred_nm VARCHAR,
    campus_email_address_nm VARCHAR,
    preferred_email_address_nm VARCHAR,
    load_dt DATE
)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat'
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION '{loch_s3_edl_data_path}/analytics/cs/STUDENT_PERSONAL_DATA/';

CREATE EXTERNAL TABLE {redshift_schema_edl_sis}.student_registration_term_data(
    student_id VARCHAR,
    semester_year_term_cd VARCHAR,
    academic_career_cd VARCHAR,
    registrn_eligibility_status_cd VARCHAR,
    eligibility_status_desc VARCHAR,
    eligible_to_enroll_flag VARCHAR,
    registered_flag VARCHAR,
    academic_level_beginning_of_term_cd VARCHAR,
    academic_level_beginning_of_term_desc VARCHAR,
    academic_level_end_of_term_cd VARCHAR,
    academic_level_end_of_term_desc VARCHAR,
    expected_graduation_term VARCHAR,
    intends_to_graduate_flag VARCHAR,
    current_term_gpa_nbr DECIMAL(8,3),
    term_enrolled_units DECIMAL(8,3),
    total_cumulative_gpa_nbr DECIMAL(8,3),
    total_units_completed_qty DECIMAL(8,3),
    maximum_term_enrollment_units_limit DECIMAL(5,2),
    minimum_term_enrollment_units_limit DECIMAL(5,2),
    terms_in_attendance VARCHAR,
    load_dt DATE
)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat'
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION '{loch_s3_edl_data_path}/analytics/cs/STUDENT_REGISTRATION_TERM_DATA/';

CREATE EXTERNAL TABLE {redshift_schema_edl_sis}.student_visa_permit_data(
    student_id VARCHAR,
    dependent_id VARCHAR,
    country_cd VARCHAR,
    citizenship_status_cd VARCHAR,
    citizenship_status_desc VARCHAR,
    visa_workpermit_status_cd VARCHAR,
    visa_workpermit_status_desc VARCHAR,
    visa_permit_type_cd VARCHAR,
    visa_type_description VARCHAR,
    visa_type_formal_desc VARCHAR,
    load_dt DATE
)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat'
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION '{loch_s3_edl_data_path}/analytics/cs/STUDENT_VISA_PERMIT_DATA/';

--------------------------------------------------------------------
-- Internal schema
--------------------------------------------------------------------

DROP SCHEMA IF EXISTS {redshift_schema_edl_sis_internal} CASCADE;
CREATE SCHEMA {redshift_schema_edl_sis_internal};
GRANT USAGE ON SCHEMA {redshift_schema_edl_sis_internal} TO GROUP {redshift_dblink_group};
ALTER DEFAULT PRIVILEGES IN SCHEMA {redshift_schema_edl_sis_internal} GRANT SELECT ON TABLES TO GROUP {redshift_dblink_group};

--------------------------------------------------------------------
-- Internal tables
--------------------------------------------------------------------

CREATE TABLE {redshift_schema_edl_sis_internal}.student_degree_progress_index
SORTKEY (sid)
AS (
    SELECT
      student_id AS sid,
      reporting_dt AS report_date,
      CASE
        WHEN requirement_cd = '000000001' THEN 'entryLevelWriting'
        WHEN requirement_cd = '000000002' THEN 'americanHistory'
        WHEN requirement_cd = '000000003' THEN 'americanCultures'
        WHEN requirement_cd = '000000018' THEN 'americanInstitutions'
        ELSE NULL
      END AS requirement,
      requirement_desc,
      CASE
        WHEN requirement_status_cd = 'COMP' AND in_progress_grade_flg = 'Y' THEN 'In Progress'
        WHEN requirement_status_cd = 'COMP' AND in_progress_grade_flg = 'N' THEN 'Satisfied'
        ELSE 'Not Satisfied'
      END AS status,
      load_dt AS edl_load_date
    FROM {redshift_schema_edl_sis}.student_academic_progress_data
    WHERE requirement_group_cd = '000131'
    AND requirement_cd in ('000000001', '000000002', '000000003', '000000018')
);

CREATE TABLE IF NOT EXISTS {redshift_schema_edl_sis_internal}.student_degree_progress
(
    sid VARCHAR NOT NULL,
    feed VARCHAR(max) NOT NULL
)
DISTKEY (sid)
SORTKEY (sid);
