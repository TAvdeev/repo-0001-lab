-- Проверка наличия таблиц, связей, истории изменений и результата "отлично".

-- 1. Ожидается 8 таблиц для 3NF и 24 для Data Vault.
SELECT table_schema, count(*)::INTEGER AS table_count
FROM information_schema.tables
WHERE table_schema IN ('exam_3nf','exam_dv') AND table_type = 'BASE TABLE'
GROUP BY table_schema ORDER BY table_schema;

-- 2. Этапы в 3NF: теория -> практика -> практика.
SELECT p.plan_id, ps.step_order, t.topic_name, ps.activity_type,
       ps.planned_date, ps.planned_hours, ps.completed_at
FROM exam_3nf.plan_steps ps
JOIN exam_3nf.preparation_plans p ON p.plan_id = ps.plan_id
JOIN exam_3nf.topics t ON t.topic_id = ps.topic_id
ORDER BY p.plan_id, ps.step_order;

-- 3. Финальная оценка 3NF: 5, процент: 95.00, цель: 5.
SELECT st.full_name, sub.subject_name, e.exam_name, p.target_grade,
       p.status, r.score_percent, r.grade,
       (r.grade >= p.target_grade AND
        r.score_percent >= e.excellent_threshold) AS achieved_excellent
FROM exam_3nf.preparation_plans p
JOIN exam_3nf.students st ON st.student_id = p.student_id
JOIN exam_3nf.exams e ON e.exam_id = p.exam_id
JOIN exam_3nf.subjects sub ON sub.subject_id = e.subject_id
JOIN exam_3nf.exam_results r ON r.plan_id = p.plan_id;

-- 4. История статуса подготовки в Data Vault: три версии.
SELECT hp.plan_bk, sat.load_dts, sat.status, sat.target_grade
FROM exam_dv.sat_plan_details sat
JOIN exam_dv.hub_plan hp ON hp.plan_hk = sat.plan_hk
ORDER BY sat.load_dts;

-- 5. Data Vault: восстановление актуального результата, через LINK+HUB+SAT.
SELECT hp.plan_bk, p.status, p.target_grade, res.grade,
       res.score_percent, (res.grade >= p.target_grade) AS achieved_excellent
FROM exam_dv.hub_plan hp
JOIN LATERAL (
  SELECT target_grade, status FROM exam_dv.sat_plan_details s
  WHERE s.plan_hk = hp.plan_hk
  ORDER BY s.load_dts DESC LIMIT 1
) p ON TRUE
JOIN exam_dv.lnk_plan_result lpr ON lpr.plan_hk = hp.plan_hk
JOIN exam_dv.hub_result hr ON hr.result_hk = lpr.result_hk
JOIN LATERAL (
  SELECT grade, score_percent FROM exam_dv.sat_result_details s
  WHERE s.result_hk = hr.result_hk
  ORDER BY s.load_dts DESC LIMIT 1
) res ON TRUE;

-- 6. Автоматическая проверка (ошибка при несоответствии).
DO $check$
DECLARE
  count_3nf INT;
  count_dv INT;
  score_3nf NUMERIC;
  score_dv NUMERIC;
  dv_versions INT;
BEGIN
  SELECT count(*) INTO count_3nf
  FROM information_schema.tables
  WHERE table_schema = 'exam_3nf' AND table_type = 'BASE TABLE';
  SELECT count(*) INTO count_dv
  FROM information_schema.tables
  WHERE table_schema = 'exam_dv' AND table_type = 'BASE TABLE';
  SELECT score_percent INTO score_3nf FROM exam_3nf.exam_results WHERE plan_id = 1;
  SELECT score_percent INTO score_dv
  FROM exam_dv.sat_result_details ORDER BY load_dts DESC LIMIT 1;
  SELECT count(*) INTO dv_versions FROM exam_dv.sat_plan_details;
  IF count_3nf <> 8 OR count_dv <> 24
     OR score_3nf IS DISTINCT FROM 95 OR score_dv IS DISTINCT FROM 95
     OR dv_versions <> 3 THEN
    RAISE EXCEPTION 'Verification failed: tables 3NF=%, DV=%, scores=(%,%), DV plan versions=%',
      count_3nf, count_dv, score_3nf, score_dv, dv_versions;
  END IF;
  RAISE NOTICE 'OK: 8 tables in 3NF, 24 tables in Data Vault, score 95, 3 historical plan versions';
END;
$check$;
