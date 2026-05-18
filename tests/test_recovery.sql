-- =============================================
-- UDYOG - RECOVERY MECHANISM TEST
-- Demonstrates: UNDO, REDO, Rollback, Crash Recovery
-- =============================================

USE JobPortal;

-- =============================================
-- TEST 1: TRANSACTION ROLLBACK (UNDO)
-- =============================================

-- Check initial value
SELECT job_id, total_applications 
FROM job_postings WHERE job_id = 1;

-- Start transaction and make changes
START TRANSACTION;
UPDATE job_postings SET total_applications = 999 WHERE job_id = 1;

-- Verify inside transaction (shows 999)
SELECT job_id, total_applications 
FROM job_postings WHERE job_id = 1;

-- ROLLBACK instead of COMMIT
ROLLBACK;

-- Verify after rollback (back to original value)
SELECT job_id, total_applications 
FROM job_postings WHERE job_id = 1;
-- UNDO log restored original value!


-- =============================================
-- TEST 2: COMMIT PERSISTENCE (REDO)
-- =============================================

-- Check initial value
SELECT job_id, total_views FROM job_postings WHERE job_id = 1;

-- Update and commit
START TRANSACTION;
UPDATE job_postings SET total_views = total_views + 100 WHERE job_id = 1;
COMMIT;

-- Even if server crashes now, this change survives
SELECT job_id, total_views FROM job_postings WHERE job_id = 1;
-- REDO log ensures committed data persists!


-- =============================================
-- TEST 3: SAVEPOINT DEMONSTRATION
-- =============================================

START TRANSACTION;

-- First update
UPDATE job_postings SET min_salary = 500000 WHERE job_id = 1;
SAVEPOINT update1;

-- Second update
UPDATE job_postings SET max_salary = 5000000 WHERE job_id = 1;
SAVEPOINT update2;

-- Third update
UPDATE job_postings SET vacancies = 10 WHERE job_id = 1;

-- Rollback to savepoint (undo third update only)
ROLLBACK TO SAVEPOINT update2;

COMMIT;

-- Verify: min_salary and max_salary changed, but vacancies reverted
SELECT job_id, min_salary, max_salary, vacancies 
FROM job_postings WHERE job_id = 1;


-- =============================================
-- TEST 4: CRASH RECOVERY SIMULATION
-- =============================================
-- 
-- To simulate crash recovery:
-- 1. Start a transaction
-- 2. Make changes but DON'T COMMIT
-- 3. Kill MySQL service (simulate crash)
-- 4. Restart MySQL
-- 5. Check: uncommitted changes are GONE (UNDO)
-- 6. Check: previously committed data is SAFE (REDO)
-- =============================================

-- Step 1: Check current state
SELECT '=== BEFORE CRASH SIMULATION ===' AS stage;
SELECT job_id, title, total_applications FROM job_postings WHERE job_id = 1;

-- Step 2: Start uncommitted transaction
START TRANSACTION;
UPDATE job_postings SET total_applications = 88888 WHERE job_id = 1;
SELECT 'Uncommitted change made (88888) - NOW KILL MYSQL SERVICE' AS instruction;

-- Step 3: Kill MySQL (Windows: services.msc → Stop MySQL80)
-- Step 4: Restart MySQL
-- Step 5: Run this after restart:

-- SELECT '=== AFTER CRASH RECOVERY ===' AS stage;
-- SELECT job_id, title, total_applications FROM job_postings WHERE job_id = 1;
-- Value should be ORIGINAL (not 88888) - UNDO worked!


-- =============================================
-- TEST 5: CHECKPOINT DEMONSTRATION
-- =============================================

-- Show InnoDB status (includes checkpoint info)
SHOW ENGINE INNODB STATUS\G

-- Show binary log status
SHOW MASTER STATUS;

-- Show InnoDB buffer pool stats
SHOW STATUS LIKE 'Innodb_buffer_pool%';


SELECT '✅ Recovery Tests Complete!' AS status;