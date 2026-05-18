-- =============================================
-- ONLINE JOB PORTAL - SECURITY SETUP
-- =============================================

-- Create application user (not root!)
CREATE USER IF NOT EXISTS 'jobportal_app'@'localhost' IDENTIFIED BY 'app_password_123';

-- Grant limited permissions
GRANT SELECT, INSERT, UPDATE ON JobPortal.* TO 'jobportal_app'@'localhost';
GRANT EXECUTE ON JobPortal.* TO 'jobportal_app'@'localhost';

-- Create read-only user for reporting
CREATE USER IF NOT EXISTS 'jobportal_readonly'@'localhost' IDENTIFIED BY 'readonly_123';
GRANT SELECT ON JobPortal.* TO 'jobportal_readonly'@'localhost';

-- Create view for public job listing (hides sensitive data)
CREATE OR REPLACE VIEW public_jobs AS
SELECT jp.job_id, jp.title, e.company_name, jp.location_city,
       jp.min_salary, jp.max_salary, jp.job_type, jp.experience_level
FROM job_postings jp
JOIN employers e ON jp.employer_id = e.employer_id
WHERE jp.status = 'Published' AND e.is_verified = TRUE;

-- Grant public access to view only
GRANT SELECT ON JobPortal.public_jobs TO 'jobportal_readonly'@'localhost';

FLUSH PRIVILEGES;

SELECT '✅ SECURITY CONFIGURED!' AS status;