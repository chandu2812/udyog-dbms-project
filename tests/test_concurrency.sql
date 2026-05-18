-- =============================================
-- UDYOG - CONCURRENCY CONTROL TEST
-- Demonstrates: Transactions, Locking, Deadlock
-- =============================================
-- 
-- HOW TO RUN:
-- Open TWO MySQL Workbench tabs
-- Run Session 1 and Session 2 SIMULTANEOUSLY
-- =============================================

USE JobPortal;

-- =============================================
-- TEST 1: LOST UPDATE PREVENTION
-- =============================================

-- Session 1 (Run First):
START TRANSACTION;
SELECT job_id, title, total_applications 
FROM job_postings WHERE job_id = 1;
-- Shows: total_applications = X

UPDATE job_postings 
SET total_applications = total_applications + 1 
WHERE job_id = 1;
-- DON'T COMMIT YET!

-- Session 2 (Run while Session 1 is uncommitted):
START TRANSACTION;
SELECT job_id, title, total_applications 
FROM job_postings WHERE job_id = 1 FOR UPDATE;
-- This will WAIT until Session 1 commits/rollbacks

-- Session 1:
COMMIT;
-- Now Session 2 proceeds with updated value

-- Session 2:
UPDATE job_postings 
SET total_applications = total_applications + 1 
WHERE job_id = 1;
COMMIT;

-- VERIFY: total_applications should be X + 2
SELECT job_id, total_applications FROM job_postings WHERE job_id = 1;


-- =============================================
-- TEST 2: DEADLOCK SIMULATION
-- =============================================

-- Session 1:
START TRANSACTION;
UPDATE job_postings SET total_views = total_views + 1 WHERE job_id = 1;
SELECT 'Session 1 locked job_id=1' AS status;
SELECT SLEEP(5);  -- Wait 5 seconds
UPDATE job_postings SET total_views = total_views + 1 WHERE job_id = 2;
-- This will cause DEADLOCK!

-- Session 2 (Run IMMEDIATELY after Session 1):
START TRANSACTION;
UPDATE job_postings SET total_views = total_views + 1 WHERE job_id = 2;
SELECT 'Session 2 locked job_id=2' AS status;
UPDATE job_postings SET total_views = total_views + 1 WHERE job_id = 1;
-- DEADLOCK! One session will be rolled back

-- Check which transaction survived:
SELECT job_id, total_views FROM job_postings WHERE job_id IN (1,2);


-- =============================================
-- TEST 3: ISOLATION LEVELS
-- =============================================

-- Session 1:
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
START TRANSACTION;
UPDATE job_postings SET min_salary = 999999 WHERE job_id = 1;
-- DON'T COMMIT

-- Session 2:
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT job_id, min_salary FROM job_postings WHERE job_id = 1;
-- Shows 999999 (DIRTY READ - uncommitted data!)

-- Session 1:
ROLLBACK;

-- Now try with SERIALIZABLE:
-- Session 1:
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
SELECT * FROM job_postings WHERE job_id = 1;

-- Session 2:
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;
START TRANSACTION;
UPDATE job_postings SET min_salary = 888888 WHERE job_id = 1;
-- This will WAIT or fail

SELECT '✅ Concurrency Tests Complete!' AS status;