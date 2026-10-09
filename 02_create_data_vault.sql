
CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
CREATE SCHEMA exam_dv;

CREATE FUNCTION exam_dv.hk(p_kind TEXT, p_bk TEXT)
RETURNS CHAR(64)
LANGUAGE sql IMMUTABLE STRICT AS $$
  SELECT encode(public.digest(upper(p_kind) || '|' || p_bk, 'sha256'), 'hex')::CHAR(64);
$$;
COMMENT ON FUNCTION exam_dv.hk(TEXT, TEXT) IS 'Детерминированный SHA-256: вид объекта + бизнес-ключ';

CREATE FUNCTION exam_dv.hashdiff(VARIADIC p_values TEXT[])
RETURNS CHAR(64)
LANGUAGE sql IMMUTABLE AS $$
  SELECT encode(public.digest(to_json(p_values)::TEXT, 'sha256'), 'hex')::CHAR(64);
$$;
COMMENT ON FUNCTION exam_dv.hashdiff(TEXT[]) IS 'SHA-256 по JSON-массиву атрибутов с сохранением порядка и NULL';

-- HUB: бизнес-ключи студентов.
CREATE TABLE exam_dv.hub_student (
    student_hk CHAR(64) PRIMARY KEY,
    student_bk VARCHAR(50) NOT NULL UNIQUE,
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(100) NOT NULL
);
COMMENT ON TABLE exam_dv.hub_student IS 'HUB: уникальные бизнес-ключи студентов';

-- HUB: бизнес-ключи дисциплин.
CREATE TABLE exam_dv.hub_subject (
    subject_hk CHAR(64) PRIMARY KEY,
    subject_bk VARCHAR(50) NOT NULL UNIQUE,
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(100) NOT NULL
);
COMMENT ON TABLE exam_dv.hub_subject IS 'HUB: уникальные бизнес-ключи дисциплин';

-- HUB: бизнес-ключи учебных тем.
CREATE TABLE exam_dv.hub_topic (
    topic_hk CHAR(64) PRIMARY KEY,
    topic_bk VARCHAR(50) NOT NULL UNIQUE,
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(100) NOT NULL
);
COMMENT ON TABLE exam_dv.hub_topic IS 'HUB: уникальные бизнес-ключи учебных тем';

-- HUB: бизнес-ключи экзаменов.
CREATE TABLE exam_dv.hub_exam (
    exam_hk CHAR(64) PRIMARY KEY,
    exam_bk VARCHAR(50) NOT NULL UNIQUE,
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(100) NOT NULL
);
COMMENT ON TABLE exam_dv.hub_exam IS 'HUB: уникальные бизнес-ключи экзаменов';

-- HUB: бизнес-ключи планов подготовки.
CREATE TABLE exam_dv.hub_plan (
    plan_hk CHAR(64) PRIMARY KEY,
    plan_bk VARCHAR(50) NOT NULL UNIQUE,
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(100) NOT NULL
);
COMMENT ON TABLE exam_dv.hub_plan IS 'HUB: уникальные бизнес-ключи планов подготовки';

-- HUB: бизнес-ключи этапов.
CREATE TABLE exam_dv.hub_step (
    step_hk CHAR(64) PRIMARY KEY,
    step_bk VARCHAR(50) NOT NULL UNIQUE,
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(100) NOT NULL
);
COMMENT ON TABLE exam_dv.hub_step IS 'HUB: уникальные бизнес-ключи этапов';

-- HUB: бизнес-ключи пробных тестов.
CREATE TABLE exam_dv.hub_test (
    test_hk CHAR(64) PRIMARY KEY,
    test_bk VARCHAR(50) NOT NULL UNIQUE,
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(100) NOT NULL
);
COMMENT ON TABLE exam_dv.hub_test IS 'HUB: уникальные бизнес-ключи пробных тестов';

-- HUB: бизнес-ключи результатов экзаменов.
CREATE TABLE exam_dv.hub_result (
    result_hk CHAR(64) PRIMARY KEY,
    result_bk VARCHAR(50) NOT NULL UNIQUE,
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(100) NOT NULL
);
COMMENT ON TABLE exam_dv.hub_result IS 'HUB: уникальные бизнес-ключи результатов экзаменов';

-- LINK: Дисциплина и тема.
CREATE TABLE exam_dv.lnk_subject_topic (
    subject_topic_hk CHAR(64) PRIMARY KEY,
    subject_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_subject(subject_hk),
    topic_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_topic(topic_hk),
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(100) NOT NULL,
    CONSTRAINT uq_lnk_subject_topic UNIQUE (subject_hk, topic_hk)
);
COMMENT ON TABLE exam_dv.lnk_subject_topic IS 'LINK: Дисциплина и тема';

-- LINK: Дисциплина и экзамен.
CREATE TABLE exam_dv.lnk_subject_exam (
    subject_exam_hk CHAR(64) PRIMARY KEY,
    subject_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_subject(subject_hk),
    exam_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_exam(exam_hk),
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(100) NOT NULL,
    CONSTRAINT uq_lnk_subject_exam UNIQUE (subject_hk, exam_hk)
);
COMMENT ON TABLE exam_dv.lnk_subject_exam IS 'LINK: Дисциплина и экзамен';

-- LINK: Студент и план подготовки.
CREATE TABLE exam_dv.lnk_student_plan (
    student_plan_hk CHAR(64) PRIMARY KEY,
    student_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_student(student_hk),
    plan_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_plan(plan_hk),
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(100) NOT NULL,
    CONSTRAINT uq_lnk_student_plan UNIQUE (student_hk, plan_hk)
);
COMMENT ON TABLE exam_dv.lnk_student_plan IS 'LINK: Студент и план подготовки';

-- LINK: Экзамен и план подготовки.
CREATE TABLE exam_dv.lnk_exam_plan (
    exam_plan_hk CHAR(64) PRIMARY KEY,
    exam_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_exam(exam_hk),
    plan_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_plan(plan_hk),
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(100) NOT NULL,
    CONSTRAINT uq_lnk_exam_plan UNIQUE (exam_hk, plan_hk)
);
COMMENT ON TABLE exam_dv.lnk_exam_plan IS 'LINK: Экзамен и план подготовки';

-- LINK: План подготовки и этап.
CREATE TABLE exam_dv.lnk_plan_step (
    plan_step_hk CHAR(64) PRIMARY KEY,
    plan_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_plan(plan_hk),
    step_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_step(step_hk),
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(100) NOT NULL,
    CONSTRAINT uq_lnk_plan_step UNIQUE (plan_hk, step_hk)
);
COMMENT ON TABLE exam_dv.lnk_plan_step IS 'LINK: План подготовки и этап';

-- LINK: Тема и этап подготовки.
CREATE TABLE exam_dv.lnk_topic_step (
    topic_step_hk CHAR(64) PRIMARY KEY,
    topic_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_topic(topic_hk),
    step_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_step(step_hk),
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(100) NOT NULL,
    CONSTRAINT uq_lnk_topic_step UNIQUE (topic_hk, step_hk)
);
COMMENT ON TABLE exam_dv.lnk_topic_step IS 'LINK: Тема и этап подготовки';

-- LINK: План подготовки и пробный тест.
CREATE TABLE exam_dv.lnk_plan_test (
    plan_test_hk CHAR(64) PRIMARY KEY,
    plan_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_plan(plan_hk),
    test_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_test(test_hk),
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(100) NOT NULL,
    CONSTRAINT uq_lnk_plan_test UNIQUE (plan_hk, test_hk)
);
COMMENT ON TABLE exam_dv.lnk_plan_test IS 'LINK: План подготовки и пробный тест';

-- LINK: План подготовки и итоговый результат.
CREATE TABLE exam_dv.lnk_plan_result (
    plan_result_hk CHAR(64) PRIMARY KEY,
    plan_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_plan(plan_hk),
    result_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_result(result_hk),
    load_dts TIMESTAMP NOT NULL,
    record_source VARCHAR(100) NOT NULL,
    CONSTRAINT uq_lnk_plan_result UNIQUE (plan_hk, result_hk)
);
COMMENT ON TABLE exam_dv.lnk_plan_result IS 'LINK: План подготовки и итоговый результат';

-- SATELLITE: История ФИО и email студента.
CREATE TABLE exam_dv.sat_student_details (
    student_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_student(student_hk),
    load_dts TIMESTAMP NOT NULL,
    full_name VARCHAR(200) NOT NULL,
    email VARCHAR(255) NOT NULL,
    hashdiff CHAR(64) NOT NULL,
    record_source VARCHAR(100) NOT NULL,
    CONSTRAINT pk_sat_student_details PRIMARY KEY (student_hk, load_dts)
);
COMMENT ON TABLE exam_dv.sat_student_details IS 'SATELLITE: История ФИО и email студента. Новая версия = новая строка';

-- SATELLITE: История названия дисциплины.
CREATE TABLE exam_dv.sat_subject_details (
    subject_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_subject(subject_hk),
    load_dts TIMESTAMP NOT NULL,
    subject_name VARCHAR(200) NOT NULL,
    hashdiff CHAR(64) NOT NULL,
    record_source VARCHAR(100) NOT NULL,
    CONSTRAINT pk_sat_subject_details PRIMARY KEY (subject_hk, load_dts)
);
COMMENT ON TABLE exam_dv.sat_subject_details IS 'SATELLITE: История названия дисциплины. Новая версия = новая строка';

-- SATELLITE: История атрибутов темы.
CREATE TABLE exam_dv.sat_topic_details (
    topic_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_topic(topic_hk),
    load_dts TIMESTAMP NOT NULL,
    topic_name VARCHAR(200) NOT NULL,
    difficulty_level INTEGER NOT NULL CHECK (difficulty_level BETWEEN 1 AND 5),
    hashdiff CHAR(64) NOT NULL,
    record_source VARCHAR(100) NOT NULL,
    CONSTRAINT pk_sat_topic_details PRIMARY KEY (topic_hk, load_dts)
);
COMMENT ON TABLE exam_dv.sat_topic_details IS 'SATELLITE: История атрибутов темы. Новая версия = новая строка';

-- SATELLITE: История условий экзамена.
CREATE TABLE exam_dv.sat_exam_details (
    exam_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_exam(exam_hk),
    load_dts TIMESTAMP NOT NULL,
    exam_name VARCHAR(200) NOT NULL,
    exam_date DATE NOT NULL,
    excellent_threshold INTEGER NOT NULL CHECK (excellent_threshold BETWEEN 0 AND 100),
    hashdiff CHAR(64) NOT NULL,
    record_source VARCHAR(100) NOT NULL,
    CONSTRAINT pk_sat_exam_details PRIMARY KEY (exam_hk, load_dts)
);
COMMENT ON TABLE exam_dv.sat_exam_details IS 'SATELLITE: История условий экзамена. Новая версия = новая строка';

-- SATELLITE: История целевой оценки и состояния плана.
CREATE TABLE exam_dv.sat_plan_details (
    plan_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_plan(plan_hk),
    load_dts TIMESTAMP NOT NULL,
    target_grade INTEGER NOT NULL CHECK (target_grade = 5),
    start_date DATE NOT NULL,
    status VARCHAR(30) NOT NULL CHECK (status IN ('planned','in_progress','completed','cancelled')),
    hashdiff CHAR(64) NOT NULL,
    record_source VARCHAR(100) NOT NULL,
    CONSTRAINT pk_sat_plan_details PRIMARY KEY (plan_hk, load_dts)
);
COMMENT ON TABLE exam_dv.sat_plan_details IS 'SATELLITE: История целевой оценки и состояния плана. Новая версия = новая строка';

-- SATELLITE: История порядка, содержания и выполнения этапа.
CREATE TABLE exam_dv.sat_step_details (
    step_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_step(step_hk),
    load_dts TIMESTAMP NOT NULL,
    step_order INTEGER NOT NULL CHECK (step_order > 0),
    activity_type VARCHAR(50) NOT NULL CHECK (activity_type IN ('theory','practice','review')),
    planned_date DATE NOT NULL,
    planned_hours NUMERIC(5,2) NOT NULL CHECK (planned_hours > 0),
    completed_at TIMESTAMP,
    hashdiff CHAR(64) NOT NULL,
    record_source VARCHAR(100) NOT NULL,
    CONSTRAINT pk_sat_step_details PRIMARY KEY (step_hk, load_dts)
);
COMMENT ON TABLE exam_dv.sat_step_details IS 'SATELLITE: История порядка, содержания и выполнения этапа. Новая версия = новая строка';

-- SATELLITE: Результат и история загрузок пробного теста.
CREATE TABLE exam_dv.sat_test_details (
    test_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_test(test_hk),
    load_dts TIMESTAMP NOT NULL,
    attempt_no INTEGER NOT NULL CHECK (attempt_no > 0),
    taken_at TIMESTAMP NOT NULL,
    score_percent NUMERIC(5,2) NOT NULL CHECK (score_percent BETWEEN 0 AND 100),
    hashdiff CHAR(64) NOT NULL,
    record_source VARCHAR(100) NOT NULL,
    CONSTRAINT pk_sat_test_details PRIMARY KEY (test_hk, load_dts)
);
COMMENT ON TABLE exam_dv.sat_test_details IS 'SATELLITE: Результат и история загрузок пробного теста. Новая версия = новая строка';

-- SATELLITE: Результат и история загрузок итоговой оценки.
CREATE TABLE exam_dv.sat_result_details (
    result_hk CHAR(64) NOT NULL REFERENCES exam_dv.hub_result(result_hk),
    load_dts TIMESTAMP NOT NULL,
    taken_on DATE NOT NULL,
    score_percent NUMERIC(5,2) NOT NULL CHECK (score_percent BETWEEN 0 AND 100),
    grade INTEGER NOT NULL CHECK (grade BETWEEN 2 AND 5),
    hashdiff CHAR(64) NOT NULL,
    record_source VARCHAR(100) NOT NULL,
    CONSTRAINT pk_sat_result_details PRIMARY KEY (result_hk, load_dts)
);
COMMENT ON TABLE exam_dv.sat_result_details IS 'SATELLITE: Результат и история загрузок итоговой оценки. Новая версия = новая строка';

CREATE INDEX idx_sat_student_details_latest ON exam_dv.sat_student_details (student_hk, load_dts DESC);
CREATE INDEX idx_sat_subject_details_latest ON exam_dv.sat_subject_details (subject_hk, load_dts DESC);
CREATE INDEX idx_sat_topic_details_latest ON exam_dv.sat_topic_details (topic_hk, load_dts DESC);
CREATE INDEX idx_sat_exam_details_latest ON exam_dv.sat_exam_details (exam_hk, load_dts DESC);
CREATE INDEX idx_sat_plan_details_latest ON exam_dv.sat_plan_details (plan_hk, load_dts DESC);
CREATE INDEX idx_sat_step_details_latest ON exam_dv.sat_step_details (step_hk, load_dts DESC);
CREATE INDEX idx_sat_test_details_latest ON exam_dv.sat_test_details (test_hk, load_dts DESC);
CREATE INDEX idx_sat_result_details_latest ON exam_dv.sat_result_details (result_hk, load_dts DESC);

-- В этом учебном сценарии связи LINK не историзируются отдельно.
-- При изменении описаний ETL добавляет новые строки в SATELLITE; UPDATE старых версий не требуется.
