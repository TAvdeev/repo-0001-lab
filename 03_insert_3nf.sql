-- Демонстрационные данные 3NF: обучение SQL, 3 этапа, 2 теста, оценка 5.
-- Даты вымышленные, нужны для демонстрации последовательности подготовки.
INSERT INTO exam_3nf.students (student_id, full_name, email, created_at) VALUES
  (1, 'Учебный студент', 'student@example.com', TIMESTAMP '2026-10-01 10:00:00');
INSERT INTO exam_3nf.subjects (subject_id, subject_name) VALUES
  (1, 'Базы данных');
INSERT INTO exam_3nf.topics (topic_id, subject_id, topic_name, difficulty_level) VALUES
  (1, 1, 'Реляционная модель', 2),
  (2, 1, 'Нормализация данных', 3),
  (3, 1, 'Язык SQL', 3);
INSERT INTO exam_3nf.exams
  (exam_id, subject_id, exam_name, exam_date, excellent_threshold) VALUES
  (1, 1, 'Экзамен по базам данных', DATE '2026-12-20', 90);
INSERT INTO exam_3nf.preparation_plans
  (plan_id, student_id, exam_id, target_grade, start_date, status) VALUES
  (1, 1, 1, 5, DATE '2026-11-01', 'completed');
INSERT INTO exam_3nf.plan_steps
  (step_id, plan_id, topic_id, step_order, activity_type,
   planned_date, planned_hours, completed_at) VALUES
  (1, 1, 1, 1, 'theory', DATE '2026-11-05', 4.00, TIMESTAMP '2026-11-05 18:00:00'),
  (2, 1, 2, 2, 'practice', DATE '2026-11-12', 6.00, TIMESTAMP '2026-11-12 19:00:00'),
  (3, 1, 3, 3, 'practice', DATE '2026-11-20', 8.00, TIMESTAMP '2026-11-20 20:00:00');
INSERT INTO exam_3nf.practice_tests
  (test_id, plan_id, attempt_no, taken_at, score_percent) VALUES
  (1, 1, 1, TIMESTAMP '2026-12-10 12:00:00', 82.00),
  (2, 1, 2, TIMESTAMP '2026-12-18 12:00:00', 96.00);
INSERT INTO exam_3nf.exam_results
  (result_id, plan_id, taken_on, score_percent, grade) VALUES
  (1, 1, DATE '2026-12-20', 95.00, 5);

-- Обновление identity-последовательностей после явного задания идентификаторов.
SELECT setval(pg_get_serial_sequence('exam_3nf.students', 'student_id'), 1, TRUE);
SELECT setval(pg_get_serial_sequence('exam_3nf.subjects', 'subject_id'), 1, TRUE);
SELECT setval(pg_get_serial_sequence('exam_3nf.topics', 'topic_id'), 3, TRUE);
SELECT setval(pg_get_serial_sequence('exam_3nf.exams', 'exam_id'), 1, TRUE);
SELECT setval(pg_get_serial_sequence('exam_3nf.preparation_plans', 'plan_id'), 1, TRUE);
SELECT setval(pg_get_serial_sequence('exam_3nf.plan_steps', 'step_id'), 3, TRUE);
SELECT setval(pg_get_serial_sequence('exam_3nf.practice_tests', 'test_id'), 2, TRUE);
SELECT setval(pg_get_serial_sequence('exam_3nf.exam_results', 'result_id'), 1, TRUE);
