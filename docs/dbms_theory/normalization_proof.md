 
# 📚 NORMALIZATION PROOF - ONLINE JOB PORTAL

## What is Normalization?

Normalization is the process of organizing data to:
- **Reduce redundancy** (no duplicate data)
- **Avoid anomalies** (insert, update, delete problems)
- **Ensure data integrity**

---

## Example: If We Had ONE BIG TABLE (Unnormalized)

### ❌ BAD DESIGN: All data in one table

| user_id | email | seeker_name | skill1 | skill2 | skill3 | company | job_title | apply_status |
|---------|-------|-------------|--------|--------|--------|---------|-----------|--------------|
| 1 | rahul@gmail.com | Rahul Sharma | Java | MySQL | Docker | TCS | Java Dev | Applied |
| 1 | rahul@gmail.com | Rahul Sharma | Java | MySQL | Docker | Infosys | FS Dev | Applied |
| 2 | priya@gmail.com | Priya Patel | React | Node.js | NULL | TCS | Java Dev | Applied |

### Problems:
1. **Duplicate data**: Rahul's name repeated for every application
2. **Update Anomaly**: If Rahul changes email, must update ALL rows
3. **Delete Anomaly**: Delete last application → Lose Rahul's data
4. **Insert Anomaly**: Can't add a skill without a job application

---

## Our Normalized Design

### ✅ 1NF (First Normal Form)
**Rule: All columns contain atomic (single) values, no repeating groups**

| Check | Our Design | Status |
|-------|-----------|--------|
| No multiple values in one cell | ❌ skills would be multiple | ✅ We have separate `seeker_skills` table |
| No repeating columns | ❌ skill1, skill2, skill3 | ✅ We have rows, not columns |
| Each row is unique | Primary key on every table | ✅ |

**Solution**: We moved skills to separate `skills` table and created `seeker_skills` junction table.

---

### ✅ 2NF (Second Normal Form)
**Rule: 1NF + No partial dependency (non-key must depend on WHOLE primary key)**

**Example in `seeker_skills` table:**
- Primary Key: (seeker_id, skill_id)
- `proficiency` depends on BOTH seeker_id AND skill_id ✅
- `years_experience` depends on BOTH seeker_id AND skill_id ✅

If we had `seeker_name` in this table:
- `seeker_name` depends ONLY on seeker_id (partial dependency) ❌
- We put `seeker_name` in `job_seekers` table instead ✅

---

### ✅ 3NF (Third Normal Form)
**Rule: 2NF + No transitive dependency (non-key must NOT depend on another non-key)**

**Example**: In `users` table:
- `city` → `state` (state depends on city? Not always!)
- So `state` does NOT depend on `city` ✅

**If we had**: `user_id → city → mayor_name`
- `mayor_name` depends on `city`, not on `user_id`
- This would violate 3NF ❌
- Solution: Move mayor to separate `city` table

**Our tables are in 3NF**: Every non-key column depends DIRECTLY on the primary key.

---

### ✅ BCNF (Boyce-Codd Normal Form)
**Rule: 3NF + Every determinant must be a candidate key**

**Example check on `job_seekers`:**
- Determinant: `user_id` → `first_name`, `last_name`, `headline`
- `user_id` is a candidate key (UNIQUE) ✅

**Example check on `applications`:**
- Determinant: `(job_id, seeker_id)` → `status`, `applied_date`
- `(job_id, seeker_id)` is a candidate key (UNIQUE constraint) ✅

**All our tables pass BCNF!**

---

## Why This Design is Better

| Problem | Unnormalized | Normalized |
|---------|-------------|------------|
| Rahul changes email | Update 10 rows | Update 1 row in `users` |
| Add new skill 'Rust' | Can't without job | Just INSERT into `skills` |
| Delete last application | Lose user data | User data safe in `users` |
| Storage space | Duplicate data everywhere | Each fact stored ONCE |

---

## Summary

| Table | PK | Normal Form | Proof |
|-------|-----|-------------|-------|
| users | user_id | BCNF | All FDs: user_id → everything |
| job_seekers | seeker_id | BCNF | user_id is candidate key |
| employers | employer_id | BCNF | user_id is candidate key |
| job_postings | job_id | BCNF | All FDs from job_id |
| skills | skill_id | BCNF | All FDs from skill_id |
| seeker_skills | (seeker_id, skill_id) | BCNF | Composite PK covers all FDs |
| job_skills | (job_id, skill_id) | BCNF | Composite PK covers all FDs |
| applications | application_id | BCNF | (job_id, seeker_id) is UNIQUE |