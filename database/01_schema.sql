-- =============================================
-- ONLINE JOB PORTAL - COMPLETE DATABASE SCHEMA
-- =============================================

DROP DATABASE IF EXISTS JobPortal;
CREATE DATABASE JobPortal;
USE JobPortal;

-- Users table (Superclass)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    user_type ENUM('job_seeker', 'employer', 'admin') NOT NULL,
    phone VARCHAR(15) UNIQUE,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100) DEFAULT 'India',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Job Seekers (Subclass)
CREATE TABLE job_seekers (
    seeker_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    headline VARCHAR(255),
    total_experience_years DECIMAL(3,1) DEFAULT 0,
    current_salary DECIMAL(12,2),
    expected_salary DECIMAL(12,2),
    notice_period_days INT DEFAULT 30,
    resume_url VARCHAR(500),
    is_actively_looking BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Employers (Subclass)
CREATE TABLE employers (
    employer_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    company_name VARCHAR(200) NOT NULL,
    industry VARCHAR(100),
    company_size ENUM('1-10', '11-50', '51-200', '201-500', '501-1000', '1000+'),
    company_website VARCHAR(300),
    company_description TEXT,
    headquarters_city VARCHAR(100),
    founded_year YEAR,
    is_verified BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Job Categories
CREATE TABLE job_categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
) ENGINE=InnoDB;

-- Job Postings
CREATE TABLE job_postings (
    job_id INT AUTO_INCREMENT PRIMARY KEY,
    employer_id INT NOT NULL,
    category_id INT,
    title VARCHAR(300) NOT NULL,
    description TEXT NOT NULL,
    requirements TEXT,
    job_type ENUM('Full-time', 'Part-time', 'Contract', 'Freelance', 'Internship', 'Remote'),
    experience_level ENUM('Entry Level', 'Mid Level', 'Senior Level', 'Manager', 'Director'),
    min_salary DECIMAL(12,2),
    max_salary DECIMAL(12,2),
    is_salary_visible BOOLEAN DEFAULT TRUE,
    location_city VARCHAR(100),
    location_state VARCHAR(100),
    is_remote BOOLEAN DEFAULT FALSE,
    vacancies INT DEFAULT 1,
    application_deadline DATE,
    status ENUM('Draft', 'Published', 'Closed', 'Archived') DEFAULT 'Draft',
    posted_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_views INT DEFAULT 0,
    total_applications INT DEFAULT 0,
    FOREIGN KEY (employer_id) REFERENCES employers(employer_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (category_id) REFERENCES job_categories(category_id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_job_title (title),
    INDEX idx_job_type (job_type),
    INDEX idx_job_location (location_city, location_state),
    INDEX idx_job_status (status),
    INDEX idx_salary (min_salary, max_salary),
    FULLTEXT INDEX ft_job_search (title, description, requirements)
) ENGINE=InnoDB;

-- Skills
CREATE TABLE skills (
    skill_id INT AUTO_INCREMENT PRIMARY KEY,
    skill_name VARCHAR(100) UNIQUE NOT NULL,
    category VARCHAR(100)
) ENGINE=InnoDB;

-- Seeker Skills (M:N)
CREATE TABLE seeker_skills (
    seeker_id INT,
    skill_id INT,
    proficiency ENUM('Beginner', 'Intermediate', 'Advanced', 'Expert') DEFAULT 'Intermediate',
    years_experience DECIMAL(3,1),
    PRIMARY KEY (seeker_id, skill_id),
    FOREIGN KEY (seeker_id) REFERENCES job_seekers(seeker_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Job Skills (M:N)
CREATE TABLE job_skills (
    job_id INT,
    skill_id INT,
    is_mandatory BOOLEAN DEFAULT TRUE,
    importance ENUM('Nice to Have', 'Preferred', 'Required') DEFAULT 'Required',
    PRIMARY KEY (job_id, skill_id),
    FOREIGN KEY (job_id) REFERENCES job_postings(job_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Education
CREATE TABLE education (
    education_id INT AUTO_INCREMENT PRIMARY KEY,
    seeker_id INT NOT NULL,
    degree VARCHAR(200) NOT NULL,
    field_of_study VARCHAR(200),
    institution VARCHAR(300) NOT NULL,
    start_year YEAR,
    end_year YEAR,
    grade_percentage DECIMAL(5,2),
    FOREIGN KEY (seeker_id) REFERENCES job_seekers(seeker_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Work Experience
CREATE TABLE work_experience (
    experience_id INT AUTO_INCREMENT PRIMARY KEY,
    seeker_id INT NOT NULL,
    job_title VARCHAR(200) NOT NULL,
    company_name VARCHAR(200) NOT NULL,
    is_current BOOLEAN DEFAULT FALSE,
    start_date DATE NOT NULL,
    end_date DATE,
    description TEXT,
    FOREIGN KEY (seeker_id) REFERENCES job_seekers(seeker_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Applications
CREATE TABLE applications (
    application_id INT AUTO_INCREMENT PRIMARY KEY,
    job_id INT NOT NULL,
    seeker_id INT NOT NULL,
    cover_letter TEXT,
    expected_salary DECIMAL(12,2),
    status ENUM('Applied', 'Viewed', 'Shortlisted', 'Interview Scheduled', 'Interviewed', 'Offered', 'Accepted', 'Rejected', 'Withdrawn') DEFAULT 'Applied',
    applied_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (job_id) REFERENCES job_postings(job_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (seeker_id) REFERENCES job_seekers(seeker_id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY unique_application (job_id, seeker_id)
) ENGINE=InnoDB;

-- Saved Jobs
CREATE TABLE saved_jobs (
    seeker_id INT,
    job_id INT,
    saved_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (seeker_id, job_id),
    FOREIGN KEY (seeker_id) REFERENCES job_seekers(seeker_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (job_id) REFERENCES job_postings(job_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Interviews
CREATE TABLE interviews (
    interview_id INT AUTO_INCREMENT PRIMARY KEY,
    application_id INT NOT NULL,
    scheduled_date DATETIME NOT NULL,
    interview_type ENUM('Phone', 'Video', 'In-person', 'Technical', 'HR'),
    location_or_link VARCHAR(500),
    status ENUM('Scheduled', 'Completed', 'Cancelled', 'Rescheduled') DEFAULT 'Scheduled',
    feedback TEXT,
    FOREIGN KEY (application_id) REFERENCES applications(application_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Notifications
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(300) NOT NULL,
    message TEXT,
    type ENUM('Application', 'Interview', 'Job Alert', 'System', 'Message'),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

SELECT '✅ Database Schema Created!' AS status;