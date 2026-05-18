-- =============================================
-- ONLINE JOB PORTAL - USEFUL VIEWS
-- =============================================

USE JobPortal;

-- View 1: Active jobs with company info
CREATE OR REPLACE VIEW active_jobs AS
SELECT jp.job_id, jp.title, e.company_name, e.industry,
       jp.location_city, jp.min_salary, jp.max_salary, 
       jp.job_type, jp.experience_level, jp.posted_date
FROM job_postings jp
JOIN employers e ON jp.employer_id = e.employer_id
WHERE jp.status = 'Published';

-- View 2: Job market summary
CREATE OR REPLACE VIEW job_market_summary AS
SELECT e.industry,
       COUNT(DISTINCT e.employer_id) AS total_companies,
       COUNT(jp.job_id) AS total_jobs,
       ROUND(AVG(jp.min_salary), 0) AS avg_min_salary,
       ROUND(AVG(jp.max_salary), 0) AS avg_max_salary
FROM employers e
LEFT JOIN job_postings jp ON e.employer_id = jp.employer_id AND jp.status = 'Published'
GROUP BY e.industry
ORDER BY total_jobs DESC;

-- View 3: Seeker profiles with skills
CREATE OR REPLACE VIEW seeker_profiles AS
SELECT js.seeker_id, js.first_name, js.last_name, js.headline,
       js.total_experience_years, u.city, u.state,
       GROUP_CONCAT(DISTINCT s.skill_name ORDER BY ss.proficiency SEPARATOR ', ') AS skills
FROM job_seekers js
JOIN users u ON js.user_id = u.user_id
LEFT JOIN seeker_skills ss ON js.seeker_id = ss.seeker_id
LEFT JOIN skills s ON ss.skill_id = s.skill_id
GROUP BY js.seeker_id;

SELECT '✅ ALL VIEWS CREATED!' AS status;