

-- 1. HUB: записываются только устойчивые бизнес-ключи.
INSERT INTO exam_dv.hub_student (student_hk, student_bk, load_dts, record_source) VALUES
  (exam_dv.hk('student', 'ST-001'), 'ST-001', TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf');

INSERT INTO exam_dv.hub_subject (subject_hk, subject_bk, load_dts, record_source) VALUES
  (exam_dv.hk('subject', 'SUB-001'), 'SUB-001', TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf');

INSERT INTO exam_dv.hub_topic (topic_hk, topic_bk, load_dts, record_source) VALUES
  (exam_dv.hk('topic', 'TOP-001'), 'TOP-001', TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf'),
  (exam_dv.hk('topic', 'TOP-002'), 'TOP-002', TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf'),
  (exam_dv.hk('topic', 'TOP-003'), 'TOP-003', TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf');

INSERT INTO exam_dv.hub_exam (exam_hk, exam_bk, load_dts, record_source) VALUES
  (exam_dv.hk('exam', 'EX-001'), 'EX-001', TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf');

INSERT INTO exam_dv.hub_plan (plan_hk, plan_bk, load_dts, record_source) VALUES
  (exam_dv.hk('plan', 'PL-001'), 'PL-001', TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf');

INSERT INTO exam_dv.hub_step (step_hk, step_bk, load_dts, record_source) VALUES
  (exam_dv.hk('step', 'STEP-001'), 'STEP-001', TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf'),
  (exam_dv.hk('step', 'STEP-002'), 'STEP-002', TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf'),
  (exam_dv.hk('step', 'STEP-003'), 'STEP-003', TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf');

INSERT INTO exam_dv.hub_test (test_hk, test_bk, load_dts, record_source) VALUES
  (exam_dv.hk('test', 'TEST-001'), 'TEST-001', TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf'),
  (exam_dv.hk('test', 'TEST-002'), 'TEST-002', TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf');

INSERT INTO exam_dv.hub_result (result_hk, result_bk, load_dts, record_source) VALUES
  (exam_dv.hk('result', 'RESULT-001'), 'RESULT-001', TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf');

-- 2. LINK: фиксируются связи между Hub, без описательных атрибутов.
INSERT INTO exam_dv.lnk_subject_topic
  (subject_topic_hk, subject_hk, topic_hk, load_dts, record_source) VALUES
  (exam_dv.hk('lnk_subject_topic', 'SUB-001|TOP-001'), exam_dv.hk('subject', 'SUB-001'), exam_dv.hk('topic', 'TOP-001'), TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf'),
  (exam_dv.hk('lnk_subject_topic', 'SUB-001|TOP-002'), exam_dv.hk('subject', 'SUB-001'), exam_dv.hk('topic', 'TOP-002'), TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf'),
  (exam_dv.hk('lnk_subject_topic', 'SUB-001|TOP-003'), exam_dv.hk('subject', 'SUB-001'), exam_dv.hk('topic', 'TOP-003'), TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf');

INSERT INTO exam_dv.lnk_subject_exam
  (subject_exam_hk, subject_hk, exam_hk, load_dts, record_source) VALUES
  (exam_dv.hk('lnk_subject_exam', 'SUB-001|EX-001'), exam_dv.hk('subject', 'SUB-001'), exam_dv.hk('exam', 'EX-001'), TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf');

INSERT INTO exam_dv.lnk_student_plan
  (student_plan_hk, student_hk, plan_hk, load_dts, record_source) VALUES
  (exam_dv.hk('lnk_student_plan', 'ST-001|PL-001'), exam_dv.hk('student', 'ST-001'), exam_dv.hk('plan', 'PL-001'), TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf');

INSERT INTO exam_dv.lnk_exam_plan
  (exam_plan_hk, exam_hk, plan_hk, load_dts, record_source) VALUES
  (exam_dv.hk('lnk_exam_plan', 'EX-001|PL-001'), exam_dv.hk('exam', 'EX-001'), exam_dv.hk('plan', 'PL-001'), TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf');

INSERT INTO exam_dv.lnk_plan_step
  (plan_step_hk, plan_hk, step_hk, load_dts, record_source) VALUES
  (exam_dv.hk('lnk_plan_step', 'PL-001|STEP-001'), exam_dv.hk('plan', 'PL-001'), exam_dv.hk('step', 'STEP-001'), TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf'),
  (exam_dv.hk('lnk_plan_step', 'PL-001|STEP-002'), exam_dv.hk('plan', 'PL-001'), exam_dv.hk('step', 'STEP-002'), TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf'),
  (exam_dv.hk('lnk_plan_step', 'PL-001|STEP-003'), exam_dv.hk('plan', 'PL-001'), exam_dv.hk('step', 'STEP-003'), TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf');

INSERT INTO exam_dv.lnk_topic_step
  (topic_step_hk, topic_hk, step_hk, load_dts, record_source) VALUES
  (exam_dv.hk('lnk_topic_step', 'TOP-001|STEP-001'), exam_dv.hk('topic', 'TOP-001'), exam_dv.hk('step', 'STEP-001'), TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf'),
  (exam_dv.hk('lnk_topic_step', 'TOP-002|STEP-002'), exam_dv.hk('topic', 'TOP-002'), exam_dv.hk('step', 'STEP-002'), TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf'),
  (exam_dv.hk('lnk_topic_step', 'TOP-003|STEP-003'), exam_dv.hk('topic', 'TOP-003'), exam_dv.hk('step', 'STEP-003'), TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf');

INSERT INTO exam_dv.lnk_plan_test
  (plan_test_hk, plan_hk, test_hk, load_dts, record_source) VALUES
  (exam_dv.hk('lnk_plan_test', 'PL-001|TEST-001'), exam_dv.hk('plan', 'PL-001'), exam_dv.hk('test', 'TEST-001'), TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf'),
  (exam_dv.hk('lnk_plan_test', 'PL-001|TEST-002'), exam_dv.hk('plan', 'PL-001'), exam_dv.hk('test', 'TEST-002'), TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf');

INSERT INTO exam_dv.lnk_plan_result
  (plan_result_hk, plan_hk, result_hk, load_dts, record_source) VALUES
  (exam_dv.hk('lnk_plan_result', 'PL-001|RESULT-001'), exam_dv.hk('plan', 'PL-001'), exam_dv.hk('result', 'RESULT-001'), TIMESTAMP '2026-10-01 10:00:00', 'demo_3nf');

-- 3. SATELLITES: описания и несколько последовательных версий для плана/этапов.
INSERT INTO exam_dv.sat_student_details (student_hk, load_dts, full_name, email, hashdiff, record_source) VALUES
  (exam_dv.hk('student', 'ST-001'), TIMESTAMP '2026-10-01 10:05:00', 'Учебный студент', 'student@example.com', exam_dv.hashdiff('Учебный студент'::TEXT, 'student@example.com'::TEXT), 'demo_3nf');

INSERT INTO exam_dv.sat_subject_details (subject_hk, load_dts, subject_name, hashdiff, record_source) VALUES
  (exam_dv.hk('subject', 'SUB-001'), TIMESTAMP '2026-10-01 10:05:00', 'Базы данных', exam_dv.hashdiff('Базы данных'::TEXT), 'demo_3nf');

INSERT INTO exam_dv.sat_topic_details (topic_hk, load_dts, topic_name, difficulty_level, hashdiff, record_source) VALUES
  (exam_dv.hk('topic', 'TOP-001'), TIMESTAMP '2026-10-01 10:05:00', 'Реляционная модель', 2, exam_dv.hashdiff('Реляционная модель'::TEXT, 2::TEXT), 'demo_3nf'),
  (exam_dv.hk('topic', 'TOP-002'), TIMESTAMP '2026-10-01 10:05:00', 'Нормализация данных', 3, exam_dv.hashdiff('Нормализация данных'::TEXT, 3::TEXT), 'demo_3nf'),
  (exam_dv.hk('topic', 'TOP-003'), TIMESTAMP '2026-10-01 10:05:00', 'Язык SQL', 3, exam_dv.hashdiff('Язык SQL'::TEXT, 3::TEXT), 'demo_3nf');

INSERT INTO exam_dv.sat_exam_details (exam_hk, load_dts, exam_name, exam_date, excellent_threshold, hashdiff, record_source) VALUES
  (exam_dv.hk('exam', 'EX-001'), TIMESTAMP '2026-10-01 10:05:00', 'Экзамен по базам данных', '2026-12-20', 90, exam_dv.hashdiff('Экзамен по базам данных'::TEXT, '2026-12-20'::TEXT, 90::TEXT), 'demo_3nf');

INSERT INTO exam_dv.sat_plan_details (plan_hk, load_dts, target_grade, start_date, status, hashdiff, record_source) VALUES
  (exam_dv.hk('plan', 'PL-001'), TIMESTAMP '2026-11-01 09:00:00', 5, '2026-11-01', 'planned', exam_dv.hashdiff(5::TEXT, '2026-11-01'::TEXT, 'planned'::TEXT), 'demo_3nf'),
  (exam_dv.hk('plan', 'PL-001'), TIMESTAMP '2026-11-05 09:00:00', 5, '2026-11-01', 'in_progress', exam_dv.hashdiff(5::TEXT, '2026-11-01'::TEXT, 'in_progress'::TEXT), 'demo_3nf'),
  (exam_dv.hk('plan', 'PL-001'), TIMESTAMP '2026-12-20 18:00:00', 5, '2026-11-01', 'completed', exam_dv.hashdiff(5::TEXT, '2026-11-01'::TEXT, 'completed'::TEXT), 'demo_3nf');

INSERT INTO exam_dv.sat_step_details (step_hk, load_dts, step_order, activity_type, planned_date, planned_hours, completed_at, hashdiff, record_source) VALUES
  (exam_dv.hk('step', 'STEP-001'), TIMESTAMP '2026-11-01 09:05:00', 1, 'theory', '2026-11-05', '4.00', NULL, exam_dv.hashdiff(1::TEXT, 'theory'::TEXT, '2026-11-05'::TEXT, '4.00'::TEXT, NULL::TEXT), 'demo_3nf'),
  (exam_dv.hk('step', 'STEP-001'), TIMESTAMP '2026-11-05 18:00:00', 1, 'theory', '2026-11-05', '4.00', '2026-11-05 18:00:00', exam_dv.hashdiff(1::TEXT, 'theory'::TEXT, '2026-11-05'::TEXT, '4.00'::TEXT, '2026-11-05 18:00:00'::TEXT), 'demo_3nf');

INSERT INTO exam_dv.sat_step_details (step_hk, load_dts, step_order, activity_type, planned_date, planned_hours, completed_at, hashdiff, record_source) VALUES
  (exam_dv.hk('step', 'STEP-002'), TIMESTAMP '2026-11-01 09:05:00', 2, 'practice', '2026-11-12', '6.00', NULL, exam_dv.hashdiff(2::TEXT, 'practice'::TEXT, '2026-11-12'::TEXT, '6.00'::TEXT, NULL::TEXT), 'demo_3nf'),
  (exam_dv.hk('step', 'STEP-002'), TIMESTAMP '2026-11-12 19:00:00', 2, 'practice', '2026-11-12', '6.00', '2026-11-12 19:00:00', exam_dv.hashdiff(2::TEXT, 'practice'::TEXT, '2026-11-12'::TEXT, '6.00'::TEXT, '2026-11-12 19:00:00'::TEXT), 'demo_3nf');

INSERT INTO exam_dv.sat_step_details (step_hk, load_dts, step_order, activity_type, planned_date, planned_hours, completed_at, hashdiff, record_source) VALUES
  (exam_dv.hk('step', 'STEP-003'), TIMESTAMP '2026-11-01 09:05:00', 3, 'practice', '2026-11-20', '8.00', NULL, exam_dv.hashdiff(3::TEXT, 'practice'::TEXT, '2026-11-20'::TEXT, '8.00'::TEXT, NULL::TEXT), 'demo_3nf'),
  (exam_dv.hk('step', 'STEP-003'), TIMESTAMP '2026-11-20 20:00:00', 3, 'practice', '2026-11-20', '8.00', '2026-11-20 20:00:00', exam_dv.hashdiff(3::TEXT, 'practice'::TEXT, '2026-11-20'::TEXT, '8.00'::TEXT, '2026-11-20 20:00:00'::TEXT), 'demo_3nf');

INSERT INTO exam_dv.sat_test_details (test_hk, load_dts, attempt_no, taken_at, score_percent, hashdiff, record_source) VALUES
  (exam_dv.hk('test', 'TEST-001'), TIMESTAMP '2026-12-10 13:00:00', 1, '2026-12-10 12:00:00', '82.00', exam_dv.hashdiff(1::TEXT, '2026-12-10 12:00:00'::TEXT, '82.00'::TEXT), 'demo_3nf'),
  (exam_dv.hk('test', 'TEST-002'), TIMESTAMP '2026-12-18 13:00:00', 2, '2026-12-18 12:00:00', '96.00', exam_dv.hashdiff(2::TEXT, '2026-12-18 12:00:00'::TEXT, '96.00'::TEXT), 'demo_3nf');

INSERT INTO exam_dv.sat_result_details (result_hk, load_dts, taken_on, score_percent, grade, hashdiff, record_source) VALUES
  (exam_dv.hk('result', 'RESULT-001'), TIMESTAMP '2026-12-20 17:00:00', '2026-12-20', '95.00', 5, exam_dv.hashdiff('2026-12-20'::TEXT, '95.00'::TEXT, 5::TEXT), 'demo_3nf');

-- В 3NF хранится только текущий статус completed.
-- В Data Vault версия planned/in_progress остается в sat_plan_details.
-- Для получения актуальных атрибутов: ORDER BY load_dts DESC LIMIT 1.
