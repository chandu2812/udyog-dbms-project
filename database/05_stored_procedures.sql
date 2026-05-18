-- =============================================
-- ONLINE JOB PORTAL - STORED PROCEDURES
-- =============================================

USE JobPortal;

DELIMITER //

-- Procedure 1: Search jobs by keyword
CREATE OR REPLACE PROCEDURE search_jobs(IN search_term VARCHAR(255))
BEGIN
    SELECT jp.job_id, jp.title, e.company_name, jp.location_city,
           jp.min_salary, jp.max_salary,
           MATCH(jp.title, jp.description, jp.requirements) AGAINST(search_term) AS relevance
    FROM job_postings jp
    JOIN employers e ON jp.employer_id = e.employer_id
    WHERE MATCH(jp.title, jp.description, jp.requirements) AGAINST(search_term)
        AND jp.status = 'Published'
    ORDER BY relevance DESC;
END //

-- Procedure 2: Get job details with skills
CREATE OR REPLACE PROCEDURE get_job_details(IN job_id_param INT)
BEGIN
    SELECT jp.*, e.company_name, e.company_website, e.industry
    FROM job_postings jp
    JOIN employers e ON jp.employer_id = e.employer_id
    WHERE jp.job_id = job_id_param;
    
    SELECT s.skill_name, js.importance
    FROM job_skills js
    JOIN skills s ON js.skill_id = s.skill_id
    WHERE js.job_id = job_id_param;
END //

-- Procedure 3: Apply for job
CREATE OR REPLACE PROCEDURE apply_for_job(
    IN p_job_id INT,
    IN p_seeker_id INT,
    IN p_cover_letter TEXT
)
BEGIN
    DECLARE already_applied INT;
    
    SELECT COUNT(*) INTO already_applied 
    FROM applications 
    WHERE job_id = p_job_id AND seeker_id = p_seeker_id;
    
    IF already_applied > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Already applied for this job';
    ELSE
        INSERT INTO applications (job_id, seeker_id, cover_letter)
        VALUES (p_job_id, p_seeker_id, p_cover_letter);
        
        UPDATE job_postings 
        SET total_applications = total_applications + 1 
        WHERE job_id = p_job_id;
        
        SELECT 'Application submitted successfully!' AS message;
    END IF;
END //

DELIMITER ;

SELECT '✅ ALL PROCEDURES CREATED!' AS status;