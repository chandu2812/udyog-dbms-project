-- =============================================
-- ONLINE JOB PORTAL - PERFORMANCE INDEXES
-- =============================================

USE JobPortal;

-- Composite index for job filtering (status + location)
CREATE INDEX idx_job_status_location ON job_postings(status, location_city);

-- Foreign key index for faster joins with employers
CREATE INDEX idx_job_employer ON job_postings(employer_id);

-- Index for job skills join queries
CREATE INDEX idx_jobskill_job ON job_skills(job_id);
CREATE INDEX idx_jobskill_skill ON job_skills(skill_id);

-- Index for seeker skills join queries
CREATE INDEX idx_seekerskill_seeker ON seeker_skills(seeker_id);
CREATE INDEX idx_seekerskill_skill ON seeker_skills(skill_id);

-- Index for application queries
CREATE INDEX idx_app_status ON applications(status);
CREATE INDEX idx_app_job ON applications(job_id);
CREATE INDEX idx_app_seeker ON applications(seeker_id);

-- Index for notifications
CREATE INDEX idx_notif_user ON notifications(user_id, is_read);

-- Index for education
CREATE INDEX idx_edu_seeker ON education(seeker_id);

-- Index for work experience
CREATE INDEX idx_exp_seeker ON work_experience(seeker_id);

SELECT '✅ ALL INDEXES CREATED SUCCESSFULLY!' AS status;

-- Show all indexes
SHOW INDEX FROM job_postings;