-- =============================================
-- ONLINE JOB PORTAL - COMPLETE SAMPLE DATA
-- =============================================

USE JobPortal;

-- Disable FK checks for clean insert
SET FOREIGN_KEY_CHECKS = 0;

-- Clear existing data
TRUNCATE TABLE notifications;
TRUNCATE TABLE interviews;
TRUNCATE TABLE saved_jobs;
TRUNCATE TABLE applications;
TRUNCATE TABLE work_experience;
TRUNCATE TABLE education;
TRUNCATE TABLE job_skills;
TRUNCATE TABLE seeker_skills;
TRUNCATE TABLE job_postings;
TRUNCATE TABLE skills;
TRUNCATE TABLE employers;
TRUNCATE TABLE job_seekers;
TRUNCATE TABLE job_categories;
TRUNCATE TABLE users;

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================
-- JOB CATEGORIES
-- =============================================
INSERT INTO job_categories (category_name, description) VALUES
('Information Technology', 'Software, IT services, tech roles'),
('Banking & Finance', 'Banking and financial services'),
('Healthcare', 'Medical and healthcare'),
('Education', 'Teaching and training'),
('Manufacturing', 'Production and operations'),
('E-Commerce', 'Online retail'),
('Consulting', 'Business consulting'),
('Marketing', 'Digital marketing and PR'),
('Human Resources', 'HR and recruitment'),
('Sales', 'Business development');

-- =============================================
-- SKILLS
-- =============================================
INSERT INTO skills (skill_name, category) VALUES
('Java', 'Programming'),
('Python', 'Programming'),
('JavaScript', 'Programming'),
('C++', 'Programming'),
('TypeScript', 'Programming'),
('Go', 'Programming'),
('React.js', 'Web Development'),
('Angular', 'Web Development'),
('Node.js', 'Web Development'),
('HTML/CSS', 'Web Development'),
('Django', 'Web Development'),
('Flask', 'Web Development'),
('MySQL', 'Database'),
('PostgreSQL', 'Database'),
('MongoDB', 'Database'),
('Redis', 'Database'),
('AWS', 'Cloud Computing'),
('Docker', 'DevOps'),
('Kubernetes', 'DevOps'),
('Jenkins', 'DevOps'),
('Azure', 'Cloud Computing'),
('Machine Learning', 'Data Science'),
('Deep Learning', 'Data Science'),
('Data Analysis', 'Data Science'),
('Android', 'Mobile Development'),
('Flutter', 'Mobile Development'),
('React Native', 'Mobile Development'),
('Communication', 'Soft Skills'),
('Leadership', 'Soft Skills'),
('Problem Solving', 'Soft Skills'),
('Team Management', 'Soft Skills'),
('Agile Methodology', 'Soft Skills');

-- =============================================
-- USERS
-- =============================================
INSERT INTO users (email, password, user_type, phone, city, state) VALUES
('rahul.sharma@gmail.com', 'pass123', 'job_seeker', '9876543210', 'Bangalore', 'Karnataka'),
('priya.patel@gmail.com', 'pass123', 'job_seeker', '9876543211', 'Mumbai', 'Maharashtra'),
('amit.kumar@gmail.com', 'pass123', 'job_seeker', '9876543212', 'Delhi', 'Delhi'),
('sneha.reddy@gmail.com', 'pass123', 'job_seeker', '9876543213', 'Hyderabad', 'Telangana'),
('vikram.singh@gmail.com', 'pass123', 'job_seeker', '9876543214', 'Pune', 'Maharashtra'),
('neha.gupta@gmail.com', 'pass123', 'job_seeker', '9876543215', 'Chennai', 'Tamil Nadu'),
('arjun.nair@gmail.com', 'pass123', 'job_seeker', '9876543216', 'Kochi', 'Kerala'),
('divya.verma@gmail.com', 'pass123', 'job_seeker', '9876543217', 'Jaipur', 'Rajasthan'),
('karan.mehta@gmail.com', 'pass123', 'job_seeker', '9876543218', 'Ahmedabad', 'Gujarat'),
('pooja.agarwal@gmail.com', 'pass123', 'job_seeker', '9876543219', 'Kolkata', 'West Bengal'),
('rohit.joshi@gmail.com', 'pass123', 'job_seeker', '9876543220', 'Indore', 'Madhya Pradesh'),
('ananya.iyer@gmail.com', 'pass123', 'job_seeker', '9876543221', 'Coimbatore', 'Tamil Nadu'),
('suresh.rao@gmail.com', 'pass123', 'job_seeker', '9876543222', 'Visakhapatnam', 'Andhra Pradesh'),
('meera.desai@gmail.com', 'pass123', 'job_seeker', '9876543223', 'Surat', 'Gujarat'),
('deepak.malhotra@gmail.com', 'pass123', 'job_seeker', '9876543224', 'Lucknow', 'Uttar Pradesh'),
('hr@tcs.com', 'pass123', 'employer', '9811000001', 'Mumbai', 'Maharashtra'),
('jobs@infosys.com', 'pass123', 'employer', '9811000002', 'Bangalore', 'Karnataka'),
('careers@wipro.com', 'pass123', 'employer', '9811000003', 'Bangalore', 'Karnataka'),
('recruitment@hcl.com', 'pass123', 'employer', '9811000004', 'Noida', 'Uttar Pradesh'),
('hr@techmahindra.com', 'pass123', 'employer', '9811000005', 'Pune', 'Maharashtra'),
('jobs@flipkart.com', 'pass123', 'employer', '9811000006', 'Bangalore', 'Karnataka'),
('careers@amazon.in', 'pass123', 'employer', '9811000007', 'Bangalore', 'Karnataka'),
('hr@reliance.com', 'pass123', 'employer', '9811000008', 'Mumbai', 'Maharashtra'),
('jobs@zomato.com', 'pass123', 'employer', '9811000009', 'Gurugram', 'Haryana'),
('careers@swiggy.com', 'pass123', 'employer', '9811000010', 'Bangalore', 'Karnataka'),
('admin@jobportal.com', 'admin123', 'admin', '9999999991', 'Mumbai', 'Maharashtra'),
('moderator@jobportal.com', 'admin123', 'admin', '9999999992', 'Bangalore', 'Karnataka');

-- =============================================
-- JOB SEEKERS
-- =============================================
INSERT INTO job_seekers (user_id, first_name, last_name, headline, total_experience_years, current_salary, expected_salary, notice_period_days, is_actively_looking) VALUES
(1, 'Rahul', 'Sharma', 'Senior Software Engineer | Java & Spring Boot', 5.0, 1800000, 2500000, 30, TRUE),
(2, 'Priya', 'Patel', 'Full Stack Developer | React & Node.js', 3.0, 1200000, 1800000, 15, TRUE),
(3, 'Amit', 'Kumar', 'Data Scientist | ML & AI', 4.0, 2000000, 2800000, 30, TRUE),
(4, 'Sneha', 'Reddy', 'DevOps Engineer | AWS & Kubernetes', 4.0, 1600000, 2200000, 30, TRUE),
(5, 'Vikram', 'Singh', 'Frontend Developer | Angular', 2.0, 800000, 1200000, 15, TRUE),
(6, 'Neha', 'Gupta', 'Python Developer | Django', 3.0, 1100000, 1600000, 15, TRUE),
(7, 'Arjun', 'Nair', 'Mobile Developer | Flutter', 3.0, 1300000, 1800000, 30, TRUE),
(8, 'Divya', 'Verma', 'UI/UX Designer', 4.0, 1400000, 2000000, 15, TRUE),
(9, 'Karan', 'Mehta', 'Database Administrator | MySQL', 6.0, 1500000, 2100000, 30, TRUE),
(10, 'Pooja', 'Agarwal', 'HR Professional', 5.0, 900000, 1400000, 30, TRUE),
(11, 'Rohit', 'Joshi', 'Java Developer | Spring Boot', 2.0, 700000, 1100000, 15, TRUE),
(12, 'Ananya', 'Iyer', 'Data Analyst | SQL & Power BI', 3.0, 1000000, 1500000, 15, TRUE),
(13, 'Suresh', 'Rao', 'Software Engineer | C++', 4.0, 1200000, 1700000, 30, TRUE),
(14, 'Meera', 'Desai', 'Digital Marketing Specialist', 3.0, 800000, 1200000, 15, TRUE),
(15, 'Deepak', 'Malhotra', 'Project Manager | Agile', 7.0, 2200000, 3000000, 45, TRUE);

-- =============================================
-- EMPLOYERS
-- =============================================
INSERT INTO employers (user_id, company_name, industry, company_size, company_website, company_description, headquarters_city, founded_year, is_verified) VALUES
(16, 'Tata Consultancy Services', 'Information Technology', '1000+', 'https://www.tcs.com', 'TCS is a global leader in IT services with 500,000+ employees.', 'Mumbai', 1968, TRUE),
(17, 'Infosys Limited', 'Information Technology', '1000+', 'https://www.infosys.com', 'Infosys is a global leader in digital services.', 'Bangalore', 1981, TRUE),
(18, 'Wipro Technologies', 'Information Technology', '1000+', 'https://www.wipro.com', 'Wipro is a leading technology services company.', 'Bangalore', 1945, TRUE),
(19, 'HCL Technologies', 'Information Technology', '1000+', 'https://www.hcltech.com', 'HCL is a global technology company.', 'Noida', 1976, TRUE),
(20, 'Tech Mahindra', 'Information Technology', '1000+', 'https://www.techmahindra.com', 'Tech Mahindra enables digital transformation.', 'Pune', 1986, TRUE),
(21, 'Flipkart', 'E-Commerce', '1000+', 'https://www.flipkart.com', 'Flipkart is India''s leading e-commerce marketplace.', 'Bangalore', 2007, TRUE),
(22, 'Amazon India', 'E-Commerce', '1000+', 'https://www.amazon.in', 'Amazon India offers e-commerce and cloud services.', 'Bangalore', 2013, TRUE),
(23, 'Reliance Industries', 'Manufacturing', '1000+', 'https://www.ril.com', 'Reliance is India''s largest private sector company.', 'Mumbai', 1973, TRUE),
(24, 'Zomato', 'E-Commerce', '501-1000', 'https://www.zomato.com', 'Zomato is India''s leading food delivery platform.', 'Gurugram', 2008, TRUE),
(25, 'Swiggy', 'E-Commerce', '501-1000', 'https://www.swiggy.com', 'Swiggy is India''s leading on-demand delivery platform.', 'Bangalore', 2014, TRUE);

-- =============================================
-- JOB POSTINGS
-- =============================================
INSERT INTO job_postings (employer_id, category_id, title, description, requirements, job_type, experience_level, min_salary, max_salary, location_city, vacancies, application_deadline, status) VALUES
(1, 1, 'Senior Java Developer', 'Looking for experienced Java Developer for digital transformation team. Build enterprise applications using Spring Boot and microservices.', '5+ years Java, Spring Boot, Microservices, AWS, REST APIs', 'Full-time', 'Senior Level', 1800000, 2800000, 'Mumbai', 3, '2024-12-31', 'Published'),
(1, 1, 'Python Developer', 'Join AI/ML team for machine learning solutions. Work on NLP and computer vision projects.', '3+ years Python, ML frameworks, SQL', 'Full-time', 'Mid Level', 1200000, 2000000, 'Bangalore', 5, '2024-12-31', 'Published'),
(2, 1, 'Full Stack Developer', 'Build web applications using React.js and Node.js in an agile environment.', '3+ years React.js, Node.js, MongoDB, REST APIs', 'Full-time', 'Mid Level', 1200000, 2200000, 'Bangalore', 4, '2024-11-30', 'Published'),
(2, 1, 'DevOps Engineer', 'Manage cloud infrastructure and CI/CD pipelines. Work with Docker and Kubernetes.', '4+ years AWS, Docker, Kubernetes, Jenkins, Terraform', 'Full-time', 'Senior Level', 1600000, 2500000, 'Pune', 2, '2024-12-15', 'Published'),
(3, 1, 'Data Scientist', 'Develop predictive models and perform advanced analytics on large datasets.', '4+ years Python, ML, Deep Learning, SQL, Statistics', 'Full-time', 'Mid Level', 1500000, 2500000, 'Hyderabad', 3, '2024-12-31', 'Published'),
(3, 1, 'Cloud Architect', 'Design and implement cloud solutions for enterprise clients. Lead migration projects.', '8+ years IT, AWS/Azure/GCP, Microservices', 'Full-time', 'Senior Level', 2500000, 4000000, 'Bangalore', 1, '2024-12-31', 'Published'),
(4, 1, 'React Native Developer', 'Build cross-platform mobile applications with millions of users.', '3+ years React Native, JavaScript, Redux', 'Full-time', 'Mid Level', 1000000, 1800000, 'Noida', 3, '2024-11-30', 'Published'),
(4, 1, 'Cybersecurity Analyst', 'Protect systems from cyber threats. Perform security assessments.', '3+ years cybersecurity, Network security, CEH/CISSP', 'Full-time', 'Mid Level', 1200000, 2000000, 'Delhi', 2, '2024-12-31', 'Published'),
(5, 1, 'QA Automation Engineer', 'Develop automated test frameworks for enterprise applications.', '3+ years Selenium, Java/Python, CI/CD', 'Full-time', 'Mid Level', 1000000, 1800000, 'Pune', 3, '2024-12-15', 'Published'),
(6, 1, 'Backend Developer', 'Build robust backend systems handling millions of transactions.', '4+ years Java/Python/Go, MySQL, Redis, Kafka', 'Full-time', 'Senior Level', 2000000, 3500000, 'Bangalore', 2, '2024-12-15', 'Published'),
(6, 1, 'Product Manager', 'Lead product development for e-commerce platform. Define product vision.', '5+ years PM, E-commerce, Agile', 'Full-time', 'Senior Level', 2500000, 4000000, 'Bangalore', 1, '2024-12-31', 'Published'),
(7, 1, 'Software Development Engineer', 'Design innovative technologies in distributed computing environment.', '3+ years Java/C++/Python, Algorithms', 'Full-time', 'Mid Level', 1800000, 3000000, 'Bangalore', 5, '2024-12-31', 'Published'),
(7, 1, 'Data Engineer', 'Build data pipelines processing petabytes of data using big data technologies.', '4+ years SQL, Python, Spark, AWS', 'Full-time', 'Senior Level', 2000000, 3500000, 'Hyderabad', 3, '2024-12-15', 'Published'),
(8, 8, 'Digital Marketing Manager', 'Lead digital marketing campaigns. Manage SEO, SEM, and social media strategies.', '5+ years SEO/SEM, Google Analytics', 'Full-time', 'Senior Level', 1500000, 2200000, 'Mumbai', 1, '2024-12-31', 'Published'),
(9, 1, 'Frontend Developer', 'Create responsive user interfaces for food delivery platform.', '2+ years React.js, HTML/CSS, JavaScript', 'Full-time', 'Entry Level', 800000, 1500000, 'Gurugram', 4, '2024-11-30', 'Published'),
(10, 1, 'Android Developer', 'Build and maintain Android app used by millions of users.', '3+ years Android, Kotlin/Java, Firebase', 'Full-time', 'Mid Level', 1200000, 2200000, 'Bangalore', 2, '2024-12-31', 'Published');

-- =============================================
-- SEEKER SKILLS
-- =============================================
INSERT INTO seeker_skills (seeker_id, skill_id, proficiency, years_experience) VALUES
(1, 1, 'Expert', 5.0), (1, 13, 'Advanced', 4.0), (1, 3, 'Intermediate', 2.0),
(2, 7, 'Advanced', 3.0), (2, 9, 'Advanced', 3.0), (2, 3, 'Advanced', 3.0),
(3, 2, 'Advanced', 4.0), (3, 22, 'Advanced', 3.0), (3, 23, 'Intermediate', 2.0),
(4, 18, 'Expert', 4.0), (4, 19, 'Advanced', 3.0), (4, 17, 'Advanced', 3.0),
(5, 7, 'Advanced', 2.0), (5, 10, 'Advanced', 2.0), (5, 3, 'Advanced', 2.0),
(6, 2, 'Advanced', 3.0), (6, 11, 'Advanced', 2.0), (6, 13, 'Advanced', 3.0),
(7, 26, 'Advanced', 3.0), (7, 27, 'Advanced', 3.0),
(8, 10, 'Expert', 4.0),
(9, 13, 'Expert', 6.0), (9, 14, 'Expert', 5.0),
(10, 28, 'Expert', 5.0), (10, 29, 'Advanced', 4.0),
(11, 1, 'Intermediate', 2.0),
(12, 2, 'Intermediate', 2.0), (12, 24, 'Advanced', 3.0),
(13, 4, 'Expert', 4.0),
(14, 28, 'Advanced', 3.0),
(15, 29, 'Expert', 7.0), (15, 31, 'Expert', 6.0), (15, 32, 'Expert', 5.0);

-- =============================================
-- JOB SKILLS
-- =============================================
INSERT INTO job_skills (job_id, skill_id, is_mandatory, importance) VALUES
(1, 1, TRUE, 'Required'), (1, 13, TRUE, 'Required'),
(2, 2, TRUE, 'Required'), (2, 22, TRUE, 'Required'),
(3, 7, TRUE, 'Required'), (3, 9, TRUE, 'Required'), (3, 15, TRUE, 'Required'),
(4, 18, TRUE, 'Required'), (4, 19, TRUE, 'Required'), (4, 17, TRUE, 'Required'),
(5, 2, TRUE, 'Required'), (5, 22, TRUE, 'Required'),
(6, 17, TRUE, 'Required'), (6, 19, TRUE, 'Required'),
(7, 27, TRUE, 'Required'),
(9, 1, TRUE, 'Required'), (9, 2, TRUE, 'Required'),
(10, 1, TRUE, 'Required'), (10, 13, TRUE, 'Required'),
(11, 29, TRUE, 'Required'), (11, 32, TRUE, 'Required'),
(12, 1, TRUE, 'Required'), (12, 4, FALSE, 'Preferred'),
(13, 2, TRUE, 'Required'), (13, 13, TRUE, 'Required'), (13, 17, TRUE, 'Required'),
(14, 28, TRUE, 'Required'),
(15, 7, TRUE, 'Required'), (15, 10, TRUE, 'Required'),
(16, 25, TRUE, 'Required');

SELECT '✅ ALL SAMPLE DATA INSERTED SUCCESSFULLY!' AS status;