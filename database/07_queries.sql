-- =============================================
-- ONLINE JOB PORTAL - COMPLEX QUERIES
-- =============================================

USE JobPortal;

-- Query 1: All active jobs with company names
SELECT jp.title, e.company_name, jp.location_city, jp.min_salary, jp.max_salary
FROM job_postings jp
JOIN employers e ON jp.employer_id = e.employer_id
WHERE jp.status = 'Published'
ORDER BY jp.posted_date DESC;

-- Query 2: Jobs by company count
SELECT e.company_name, COUNT(jp.job_id) AS total_jobs
FROM employers e
LEFT JOIN job_postings jp ON e.employer_id = jp.employer_id
GROUP BY e.company_name
ORDER BY total_jobs DESC;

-- Query 3: Top in-demand skills
SELECT s.skill_name, COUNT(*) AS demand_count
FROM skills s
JOIN job_skills js ON s.skill_id = js.skill_id
JOIN job_postings jp ON js.job_id = jp.job_id
WHERE jp.status = 'Published'
GROUP BY s.skill_name
ORDER BY demand_count DESC
LIMIT 10;

-- Query 4: Full-text search for Java jobs
SELECT jp.title, e.company_name,
       MATCH(jp.title, jp.description, jp.requirements) AGAINST('Java') AS relevance
FROM job_postings jp
JOIN employers e ON jp.employer_id = e.employer_id
WHERE MATCH(jp.title, jp.description, jp.requirements) AGAINST('Java')
ORDER BY relevance DESC;

-- Query 5: Jobs with salary above average
SELECT jp.title, e.company_name, jp.min_salary
FROM job_postings jp
JOIN employers e ON jp.employer_id = e.employer_id
WHERE jp.min_salary > (SELECT AVG(min_salary) FROM job_postings WHERE status = 'Published')
ORDER BY jp.min_salary DESC;

-- Query 6: Seeker profiles with skills
SELECT js.first_name, js.last_name, js.headline,
       GROUP_CONCAT(s.skill_name SEPARATOR ', ') AS skills
FROM job_seekers js
LEFT JOIN seeker_skills ss ON js.seeker_id = ss.seeker_id
LEFT JOIN skills s ON ss.skill_id = s.skill_id
GROUP BY js.seeker_id;

-- Query 7: Salary bracket analysis
SELECT 
    CASE 
        WHEN min_salary < 1000000 THEN 'Entry (3-10 LPA)'
        WHEN min_salary BETWEEN 1000000 AND 2000000 THEN 'Mid (10-20 LPA)'
        ELSE 'High (20+ LPA)'
    END AS salary_bracket,
    COUNT(*) AS job_count
FROM job_postings
WHERE status = 'Published'
GROUP BY salary_bracket
ORDER BY job_count DESC;

SELECT '✅ ALL QUERIES READY!' AS status;