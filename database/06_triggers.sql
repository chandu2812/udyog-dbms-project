-- =============================================
-- ONLINE JOB PORTAL - TRIGGERS
-- =============================================

USE JobPortal;

DELIMITER //

-- Trigger 1: Auto-update total_applications when new application inserted
CREATE OR REPLACE TRIGGER after_application_insert
AFTER INSERT ON applications
FOR EACH ROW
BEGIN
    UPDATE job_postings 
    SET total_applications = total_applications + 1 
    WHERE job_id = NEW.job_id;
END //

-- Trigger 2: Auto-update total_applications when application deleted
CREATE OR REPLACE TRIGGER after_application_delete
AFTER DELETE ON applications
FOR EACH ROW
BEGIN
    UPDATE job_postings 
    SET total_applications = total_applications - 1 
    WHERE job_id = OLD.job_id;
END //

-- Trigger 3: Send notification when application status changes
CREATE OR REPLACE TRIGGER after_application_update
AFTER UPDATE ON applications
FOR EACH ROW
BEGIN
    IF NEW.status != OLD.status THEN
        INSERT INTO notifications (user_id, title, message, type)
        SELECT js.user_id,
               CONCAT('Application Status Updated'),
               CONCAT('Your application for job #', NEW.job_id, ' is now: ', NEW.status),
               'Application'
        FROM job_seekers js
        WHERE js.seeker_id = NEW.seeker_id;
    END IF;
END //

DELIMITER ;

SELECT '✅ ALL TRIGGERS CREATED!' AS status;