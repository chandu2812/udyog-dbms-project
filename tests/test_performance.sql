-- =============================================
-- UDYOG - PERFORMANCE TESTING
-- Demonstrates: Index impact, EXPLAIN analysis
-- =============================================

USE JobPortal;

-- =============================================
-- COMPARE: Full Scan vs Index Scan
-- =============================================

-- Test 1: Without index (if removed)
SELECT '=== TEST 1: Full Table Scan ===' AS test;
EXPLAIN FORMAT=JSON
SELECT * FROM job_postings 
WHERE status = 'Published' AND location_city = 'Bangalore';

-- Test 2: With composite index
SELECT '=== TEST 2: Index Seek ===' AS test;
EXPLAIN FORMAT=JSON
SELECT * FROM job_postings USE INDEX (idx_job_status_location)
WHERE status = 'Published' AND location_city = 'Bangalore';

-- =============================================
-- CHECK EXISTING INDEXES
-- =============================================
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    INDEX_TYPE,
    NON_UNIQUE
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'JobPortal'
    AND TABLE_NAME = 'job_postings'
ORDER BY INDEX_NAME, SEQ_IN_INDEX;

-- =============================================
-- ANALYZE TABLE FOR UPDATED STATISTICS
-- =============================================
ANALYZE TABLE job_postings;
ANALYZE TABLE applications;
ANALYZE TABLE job_seekers;

SELECT '✅ Performance Tests Complete!' AS status;