-- =============================================
-- UDYOG - COMPLEX QUERY TESTS
-- Demonstrates: JOINs, Subqueries, Aggregation, Views
-- =============================================

USE JobPortal;

-- =============================================
-- TEST 1: MULTI-TABLE JOIN
-- =============================================
SELECT 
    jp.title AS job_title,
    e.company_name,
    jp.location_city,
    jp.min_salary,
    COUNT(a.application_id) AS applicants
FROM job_postings jp
JOIN employers e ON jp.employer_id = e.employer_id
LEFT JOIN applications a ON jp.job_id = a.job_id
WHERE jp.status = 'Published'
GROUP BY jp.job_id
ORDER BY applicants DESC;

-- =============================================
-- TEST 2: CORRELATED SUBQUERY
-- =============================================
SELECT jp.title, e.company_name, jp.min_salary
FROM job_postings jp
JOIN employers e ON jp.employer_id = e.employer_id
WHERE jp.min_salary > (
    SELECT AVG(min_salary) 
    FROM job_postings 
    WHERE status = 'Published'
);

-- =============================================
-- TEST 3: SKILL DEMAND ANALYSIS
-- =============================================
SELECT 
    s.skill_name,
    COUNT(js.job_id) AS jobs_requiring,
    ROUND(AVG(jp.min_salary), 0) AS avg_salary
FROM skills s
JOIN job_skills js ON s.skill_id = js.skill_id
JOIN job_postings jp ON js.job_id = jp.job_id
WHERE jp.status = 'Published'
GROUP BY s.skill_name
ORDER BY jobs_requiring DESC
LIMIT 10;

-- =============================================
-- TEST 4: FULL-TEXT SEARCH
-- =============================================
SELECT 
    jp.title,
    e.company_name,
    MATCH(jp.title, jp.description, jp.requirements) AGAINST('Java developer') AS relevance
FROM job_postings jp
JOIN employers e ON jp.employer_id = e.employer_id
WHERE MATCH(jp.title, jp.description, jp.requirements) AGAINST('Java developer')
ORDER BY relevance DESC;

-- =============================================
-- TEST 5: INDEX PERFORMANCE COMPARISON
-- =============================================

-- Without custom index
EXPLAIN SELECT * FROM job_postings WHERE location_city = 'Bangalore';

-- With index
CREATE INDEX IF NOT EXISTS idx_test_location ON job_postings(location_city);
EXPLAIN SELECT * FROM job_postings WHERE location_city = 'Bangalore';

-- Cleanup
DROP INDEX IF EXISTS idx_test_location ON job_postings;

SELECT '✅ Query Tests Complete!' AS status;