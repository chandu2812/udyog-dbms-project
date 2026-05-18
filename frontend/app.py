# =============================================
# UDYOG - Online Job Portal
# Main Flask Application
# =============================================

# 1. IMPORTS
from flask import Flask, render_template, request, redirect, url_for
import mysql.connector
import requests

# 2. CREATE FLASK APP
app = Flask(__name__)
app.secret_key = 'jobportal-secret-key-2024'

# 3. DATABASE CONNECTION
def get_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="NewPassword123",  # CHANGE TO YOUR MYSQL PASSWORD
        database="JobPortal"
    )

# =============================================
# 4. ROUTES
# =============================================

# 🏠 HOMEPAGE
@app.route('/')
def index():
    db = get_db()
    cursor = db.cursor(dictionary=True)
    cursor.execute("""
        SELECT jp.job_id, jp.title, e.company_name, jp.location_city, 
               jp.min_salary, jp.max_salary, jp.job_type, jp.experience_level,
               jp.posted_date
        FROM job_postings jp
        JOIN employers e ON jp.employer_id = e.employer_id
        WHERE jp.status = 'Published'
        ORDER BY jp.posted_date DESC
    """)
    jobs = cursor.fetchall()
    cursor.close()
    db.close()
    return render_template('index.html', jobs=jobs)

# 🔍 SEARCH JOBS
@app.route('/search')
def search():
    query = request.args.get('q', '')
    db = get_db()
    cursor = db.cursor(dictionary=True)
    
    if query:
        cursor.execute("""
            SELECT jp.job_id, jp.title, e.company_name, jp.location_city,
                   jp.min_salary, jp.max_salary, jp.job_type,
                   MATCH(jp.title, jp.description, jp.requirements) AGAINST(%s) AS relevance
            FROM job_postings jp
            JOIN employers e ON jp.employer_id = e.employer_id
            WHERE MATCH(jp.title, jp.description, jp.requirements) AGAINST(%s)
                AND jp.status = 'Published'
            ORDER BY relevance DESC
        """, (query, query))
    else:
        cursor.execute("""
            SELECT jp.job_id, jp.title, e.company_name, jp.location_city,
                   jp.min_salary, jp.max_salary, jp.job_type
            FROM job_postings jp
            JOIN employers e ON jp.employer_id = e.employer_id
            WHERE jp.status = 'Published'
            ORDER BY jp.posted_date DESC
        """)
    
    jobs = cursor.fetchall()
    cursor.close()
    db.close()
    return render_template('jobs.html', jobs=jobs, query=query)

# 📋 JOB DETAILS
@app.route('/job/<int:job_id>')
def job_detail(job_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    
    cursor.execute("""
        SELECT jp.*, e.company_name, e.company_website, e.industry, 
               e.company_description, e.headquarters_city
        FROM job_postings jp
        JOIN employers e ON jp.employer_id = e.employer_id
        WHERE jp.job_id = %s
    """, (job_id,))
    job = cursor.fetchone()
    
    if not job:
        return "Job not found", 404
    
    cursor.execute("""
        SELECT s.skill_name, js.importance, js.is_mandatory
        FROM job_skills js
        JOIN skills s ON js.skill_id = s.skill_id
        WHERE js.job_id = %s
    """, (job_id,))
    skills = cursor.fetchall()
    
    cursor.close()
    db.close()
    return render_template('job_detail.html', job=job, skills=skills)

# 📝 APPLY FOR JOB
@app.route('/apply/<int:job_id>', methods=['GET', 'POST'])
def apply_job(job_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    
    cursor.execute("""
        SELECT jp.*, e.company_name
        FROM job_postings jp
        JOIN employers e ON jp.employer_id = e.employer_id
        WHERE jp.job_id = %s
    """, (job_id,))
    job = cursor.fetchone()
    
    if not job:
        return "Job not found", 404
    
    if request.method == 'POST':
        seeker_id = 1
        cover_letter = request.form.get('cover_letter', '')
        expected_salary = request.form.get('expected_salary', 0)
        
        cursor.execute("""
            SELECT application_id FROM applications 
            WHERE job_id = %s AND seeker_id = %s
        """, (job_id, seeker_id))
        
        if cursor.fetchone():
            cursor.close()
            db.close()
            return """
            <div style='max-width:500px; margin:100px auto; text-align:center; padding:30px; background:#fff3cd; border-radius:8px;'>
                <h2>⚠️ Already Applied!</h2>
                <p>You have already applied for this job.</p>
                <a href='/' style='color:#2563eb;'>Back to Jobs</a>
            </div>
            """
        
        cursor.execute("""
            INSERT INTO applications (job_id, seeker_id, cover_letter, expected_salary)
            VALUES (%s, %s, %s, %s)
        """, (job_id, seeker_id, cover_letter, expected_salary))
        
        db.commit()
        app_id = cursor.lastrowid
        cursor.close()
        db.close()
        
        return f"""
        <div style='max-width:500px; margin:50px auto; text-align:center; padding:30px; background:white; border-radius:16px; box-shadow:0 8px 30px rgba(0,0,0,0.08);'>
            <h1>🎉 Application Submitted!</h1>
            <p>Application ID: <strong>#{app_id}</strong></p>
            <p>Job: <strong>{job['title']}</strong> at <strong>{job['company_name']}</strong></p>
            <br>
            <a href='/' style='padding:12px 24px; background:#2563eb; color:white; text-decoration:none; border-radius:30px;'>🏠 More Jobs</a>
            <a href='/profile/1' style='padding:12px 24px; background:#10b981; color:white; text-decoration:none; border-radius:30px; margin-left:10px;'>👤 My Profile</a>
        </div>
        """
    
    cursor.execute("SELECT * FROM job_seekers WHERE seeker_id = 1")
    seeker = cursor.fetchone()
    cursor.close()
    db.close()
    return render_template('apply.html', job=job, seeker=seeker)

# 👤 USER PROFILE
@app.route('/profile/<int:user_id>')
def profile(user_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    
    cursor.execute("""
        SELECT u.*, 
               CASE 
                   WHEN u.user_type = 'job_seeker' THEN js.first_name
                   WHEN u.user_type = 'employer' THEN e.company_name
                   ELSE 'Admin'
               END as display_name
        FROM users u
        LEFT JOIN job_seekers js ON u.user_id = js.user_id AND u.user_type = 'job_seeker'
        LEFT JOIN employers e ON u.user_id = e.user_id AND u.user_type = 'employer'
        WHERE u.user_id = %s
    """, (user_id,))
    user = cursor.fetchone()
    
    if not user:
        return "User not found", 404
    
    profile_data = {}
    
    if user['user_type'] == 'job_seeker':
        cursor.execute("""
            SELECT js.*, 
                   GROUP_CONCAT(DISTINCT s.skill_name ORDER BY ss.proficiency SEPARATOR ', ') AS skills_list
            FROM job_seekers js
            LEFT JOIN seeker_skills ss ON js.seeker_id = ss.seeker_id
            LEFT JOIN skills s ON ss.skill_id = s.skill_id
            WHERE js.user_id = %s
            GROUP BY js.seeker_id
        """, (user_id,))
        profile_data = cursor.fetchone()
        
        if profile_data:
            cursor.execute("""SELECT * FROM education WHERE seeker_id = %s ORDER BY end_year DESC""", (profile_data['seeker_id'],))
            profile_data['education'] = cursor.fetchall()
            
            cursor.execute("""SELECT * FROM work_experience WHERE seeker_id = %s ORDER BY start_date DESC""", (profile_data['seeker_id'],))
            profile_data['experience'] = cursor.fetchall()
            
            cursor.execute("""
                SELECT a.*, jp.title as job_title, e.company_name
                FROM applications a
                JOIN job_postings jp ON a.job_id = jp.job_id
                JOIN employers e ON jp.employer_id = e.employer_id
                WHERE a.seeker_id = %s
                ORDER BY a.applied_date DESC
            """, (profile_data['seeker_id'],))
            profile_data['applications'] = cursor.fetchall()
            
    elif user['user_type'] == 'employer':
        cursor.execute("""SELECT * FROM employers WHERE user_id = %s""", (user_id,))
        profile_data = cursor.fetchone()
        
        if profile_data:
            cursor.execute("""
                SELECT jp.*, COUNT(a.application_id) as application_count
                FROM job_postings jp
                LEFT JOIN applications a ON jp.job_id = a.job_id
                WHERE jp.employer_id = %s
                GROUP BY jp.job_id
                ORDER BY jp.posted_date DESC
            """, (profile_data['employer_id'],))
            profile_data['jobs'] = cursor.fetchall()
    
    cursor.close()
    db.close()
    return render_template('profile.html', user=user, profile=profile_data)

# 📋 VIEW APPLICATIONS
@app.route('/applications/<int:job_id>')
def view_applications(job_id):
    db = get_db()
    cursor = db.cursor(dictionary=True)
    
    cursor.execute("""
        SELECT jp.title, e.company_name
        FROM job_postings jp
        JOIN employers e ON jp.employer_id = e.employer_id
        WHERE jp.job_id = %s
    """, (job_id,))
    job = cursor.fetchone()
    
    cursor.execute("""
        SELECT a.*, js.first_name, js.last_name, js.headline, 
               js.total_experience_years, u.email, u.phone
        FROM applications a
        JOIN job_seekers js ON a.seeker_id = js.seeker_id
        JOIN users u ON js.user_id = u.user_id
        WHERE a.job_id = %s
        ORDER BY a.applied_date DESC
    """, (job_id,))
    applications = cursor.fetchall()
    
    cursor.close()
    db.close()
    return render_template('applications.html', job=job, applications=applications, job_id=job_id)

# 📊 DASHBOARD
@app.route('/dashboard')
def dashboard():
    db = get_db()
    cursor = db.cursor(dictionary=True)
    
    cursor.execute("SELECT COUNT(*) as total FROM job_postings WHERE status='Published'")
    total_jobs = cursor.fetchone()['total']
    
    cursor.execute("SELECT COUNT(*) as total FROM employers WHERE is_verified=TRUE")
    total_companies = cursor.fetchone()['total']
    
    cursor.execute("SELECT COUNT(*) as total FROM job_seekers WHERE is_actively_looking=TRUE")
    total_seekers = cursor.fetchone()['total']
    
    cursor.execute("""
        SELECT s.skill_name, COUNT(*) as demand
        FROM skills s
        JOIN job_skills js ON s.skill_id = js.skill_id
        GROUP BY s.skill_name
        ORDER BY demand DESC LIMIT 5
    """)
    top_skills = cursor.fetchall()
    
    cursor.execute("""
        SELECT location_city, COUNT(*) as count
        FROM job_postings WHERE status='Published'
        GROUP BY location_city ORDER BY count DESC
    """)
    jobs_by_city = cursor.fetchall()
    
    cursor.close()
    db.close()
    return render_template('dashboard.html',
                         total_jobs=total_jobs,
                         total_companies=total_companies,
                         total_seekers=total_seekers,
                         top_skills=top_skills,
                         jobs_by_city=jobs_by_city)

# 🔐 LOGIN
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        user_type = request.form['user_type']
        
        db = get_db()
        cursor = db.cursor(dictionary=True)
        cursor.execute("""
            SELECT user_id, email, user_type FROM users 
            WHERE email = %s AND password = %s AND user_type = %s
        """, (email, password, user_type))
        user = cursor.fetchone()
        cursor.close()
        db.close()
        
        if user:
            return f"""
            <div style='max-width:500px; margin:100px auto; text-align:center; padding:30px; background:white; border-radius:16px; box-shadow:0 8px 30px rgba(0,0,0,0.08);'>
                <h1>✅ Login Successful!</h1>
                <p>Welcome back, <strong>{email}</strong></p>
                <br>
                <a href='/' style='padding:12px 24px; background:#2563eb; color:white; text-decoration:none; border-radius:30px;'>🏠 Home</a>
                <a href='/dashboard' style='padding:12px 24px; background:#10b981; color:white; text-decoration:none; border-radius:30px; margin-left:10px;'>📊 Dashboard</a>
            </div>
            """
        else:
            return """
            <div style='max-width:500px; margin:100px auto; text-align:center; padding:30px; background:white; border-radius:16px; box-shadow:0 8px 30px rgba(0,0,0,0.08);'>
                <h1>❌ Login Failed!</h1>
                <p>Invalid email or password.</p>
                <a href='/login' style='color:#2563eb;'>Try Again</a>
            </div>
            """
    
    return render_template('login.html')

# 📝 REGISTER
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        user_type = request.form['user_type']
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        email = request.form['email']
        phone = request.form['phone']
        password = request.form['password']
        confirm_password = request.form['confirm_password']
        city = request.form['city']
        state = request.form['state']
        
        if password != confirm_password:
            return "<h2>❌ Passwords do not match! <a href='/register'>Try Again</a></h2>"
        
        db = get_db()
        cursor = db.cursor()
        
        try:
            cursor.execute("""
                INSERT INTO users (email, password, user_type, phone, city, state)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (email, password, user_type, phone, city, state))
            
            user_id = cursor.lastrowid
            
            if user_type == 'job_seeker':
                cursor.execute("""
                    INSERT INTO job_seekers (user_id, first_name, last_name)
                    VALUES (%s, %s, %s)
                """, (user_id, first_name, last_name))
            elif user_type == 'employer':
                company_name = request.form.get('company_name', 'Not Specified')
                cursor.execute("""
                    INSERT INTO employers (user_id, company_name)
                    VALUES (%s, %s)
                """, (user_id, company_name))
            
            db.commit()
            cursor.close()
            db.close()
            
            return f"""
            <div style='max-width:500px; margin:50px auto; text-align:center; padding:30px; background:white; border-radius:16px; box-shadow:0 8px 30px rgba(0,0,0,0.08);'>
                <h1>🎉 Registration Successful!</h1>
                <p>Welcome to Udyog, <strong>{first_name} {last_name}</strong>!</p>
                <br>
                <a href='/login' style='padding:12px 24px; background:#10b981; color:white; text-decoration:none; border-radius:30px;'>🔐 Go to Login</a>
                <a href='/' style='padding:12px 24px; background:#2563eb; color:white; text-decoration:none; border-radius:30px; margin-left:10px;'>🏠 Home</a>
            </div>
            """
        except mysql.connector.IntegrityError:
            cursor.close()
            db.close()
            return "<h2>❌ Email already registered! <a href='/login'>Login here</a></h2>"
    
    return render_template('register.html')

# =============================================
# 🌐 LIVE JOBS (API Integration)
# =============================================

@app.route('/live-jobs')
def live_jobs():
    all_jobs = []
    
    # Source 1: Remotive API
    try:
        response = requests.get(
            "https://remotive.com/api/remote-jobs",
            params={"limit": 15, "search": "developer"},
            timeout=5
        )
        if response.status_code == 200:
            data = response.json()
            for job in data.get('jobs', []):
                all_jobs.append({
                    'title': job.get('title', 'N/A'),
                    'company': job.get('company_name', 'N/A'),
                    'location': job.get('candidate_required_location', 'Remote'),
                    'type': job.get('job_type', 'Full-time'),
                    'salary': job.get('salary', 'Not disclosed'),
                    'description': job.get('description', '')[:300] + '...',
                    'url': job.get('url', '#'),
                    'source': 'Remotive',
                    'category': job.get('category', 'Tech')
                })
    except Exception as e:
        print(f"Remotive API error: {e}")

    # Source 2: Our database
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        cursor.execute("""
            SELECT jp.title, e.company_name as company, jp.location_city as location,
                   jp.job_type as type, 
                   CONCAT('₹', FORMAT(jp.min_salary/100000, 1), 'L - ₹', FORMAT(jp.max_salary/100000, 1), 'L') as salary,
                   jp.description, jp.job_id,
                   'Udyog' as source, 'Local' as category
            FROM job_postings jp
            JOIN employers e ON jp.employer_id = e.employer_id
            WHERE jp.status = 'Published'
            ORDER BY jp.posted_date DESC
            LIMIT 10
        """)
        db_jobs = cursor.fetchall()
        
        for job in db_jobs:
            all_jobs.append({
                'title': job['title'],
                'company': job['company'],
                'location': job['location'],
                'type': job['type'],
                'salary': job['salary'],
                'description': job['description'][:300] + '...',
                'url': f"/job/{job['job_id']}",
                'source': 'Udyog',
                'category': 'Local'
            })
        
        cursor.close()
        db.close()
    except Exception as e:
        print(f"Database error: {e}")
    
    return render_template('live_jobs.html', jobs=all_jobs, total=len(all_jobs))


@app.route('/search-live')
def search_live():
    query = request.args.get('q', 'developer')
    jobs = []
    
    try:
        response = requests.get(
            "https://remotive.com/api/remote-jobs",
            params={"limit": 20, "search": query},
            timeout=5
        )
        if response.status_code == 200:
            data = response.json()
            for job in data.get('jobs', []):
                jobs.append({
                    'title': job.get('title', 'N/A'),
                    'company': job.get('company_name', 'N/A'),
                    'location': job.get('candidate_required_location', 'Remote'),
                    'type': job.get('job_type', 'Full-time'),
                    'salary': job.get('salary', 'Not disclosed'),
                    'description': job.get('description', '')[:300] + '...',
                    'url': job.get('url', '#'),
                    'source': 'Remotive'
                })
    except Exception as e:
        print(f"Search error: {e}")
    
    return render_template('live_jobs.html', jobs=jobs, total=len(jobs), query=query)


@app.route('/market-stats')
def market_stats():
    stats = {'remote_jobs': 0, 'local_jobs': 0, 'total_companies': 0}
    
    try:
        response = requests.get(
            "https://remotive.com/api/remote-jobs",
            params={"limit": 1},
            timeout=5
        )
        if response.status_code == 200:
            data = response.json()
            stats['remote_jobs'] = data.get('total-jobs', 0)
    except:
        pass
    
    try:
        db = get_db()
        cursor = db.cursor(dictionary=True)
        cursor.execute("SELECT COUNT(*) as count FROM job_postings WHERE status='Published'")
        stats['local_jobs'] = cursor.fetchone()['count']
        cursor.execute("SELECT COUNT(*) as count FROM employers WHERE is_verified=TRUE")
        stats['total_companies'] = cursor.fetchone()['count']
        cursor.close()
        db.close()
    except:
        pass
    
    return render_template('market_stats.html', stats=stats)


# =============================================
# 🎯 ADVANCED JOB FILTERS
# =============================================

@app.route('/filter')
def filter_jobs():
    """Filter jobs by multiple criteria"""
    
    # Get filter parameters
    location = request.args.get('location', '').strip()
    job_type = request.args.get('job_type', '').strip()
    experience = request.args.get('experience', '').strip()
    min_salary = request.args.get('min_salary', '').strip()
    max_salary = request.args.get('max_salary', '').strip()
    keyword = request.args.get('keyword', '').strip()
    sort_by = request.args.get('sort_by', 'newest')
    
    db = get_db()
    cursor = db.cursor(dictionary=True)
    
    # Build dynamic query
    base_query = """
        SELECT jp.job_id, jp.title, e.company_name, jp.location_city,
               jp.min_salary, jp.max_salary, jp.job_type, jp.experience_level,
               jp.posted_date
        FROM job_postings jp
        JOIN employers e ON jp.employer_id = e.employer_id
        WHERE jp.status = 'Published'
    """
    
    conditions = []
    params = []
    
    # Location filter
    if location:
        conditions.append("jp.location_city = %s")
        params.append(location)
    
    # Job type filter
    if job_type:
        conditions.append("jp.job_type = %s")
        params.append(job_type)
    
    # Experience level filter
    if experience:
        conditions.append("jp.experience_level = %s")
        params.append(experience)
    
    # Salary range filter
    if min_salary:
        conditions.append("jp.min_salary >= %s")
        params.append(float(min_salary))
    
    if max_salary:
        conditions.append("jp.max_salary <= %s")
        params.append(float(max_salary))
    
    # Keyword search
    if keyword:
        conditions.append("""
            (jp.title LIKE %s OR jp.description LIKE %s OR e.company_name LIKE %s)
        """)
        like_pattern = f"%{keyword}%"
        params.extend([like_pattern, like_pattern, like_pattern])
    
    # Add conditions to query
    if conditions:
        base_query += " AND " + " AND ".join(conditions)
    
    # Sorting
    if sort_by == 'salary_high':
        base_query += " ORDER BY jp.min_salary DESC"
    elif sort_by == 'salary_low':
        base_query += " ORDER BY jp.min_salary ASC"
    elif sort_by == 'newest':
        base_query += " ORDER BY jp.posted_date DESC"
    elif sort_by == 'oldest':
        base_query += " ORDER BY jp.posted_date ASC"
    else:
        base_query += " ORDER BY jp.posted_date DESC"
    
    cursor.execute(base_query, tuple(params))
    jobs = cursor.fetchall()
    
    # Get filter options for dropdowns
    cursor.execute("""
        SELECT DISTINCT location_city FROM job_postings 
        WHERE status='Published' AND location_city IS NOT NULL
        ORDER BY location_city
    """)
    locations = [row['location_city'] for row in cursor.fetchall()]
    
    cursor.close()
    db.close()
    
    return render_template('filter.html', 
                         jobs=jobs, 
                         locations=locations,
                         filters={
                             'location': location,
                             'job_type': job_type,
                             'experience': experience,
                             'min_salary': min_salary,
                             'max_salary': max_salary,
                             'keyword': keyword,
                             'sort_by': sort_by
                         },
                         total=len(jobs))


# =============================================
# 5. RUN APP
# =============================================
if __name__ == '__main__':
    print("=" * 50)
    print("🇮🇳 Udyog - Apna Udyog, Apna Bhavishya")
    print("🌐 http://localhost:5000")
    print("📊 http://localhost:5000/dashboard")
    print("🌐 http://localhost:5000/live-jobs")
    print("=" * 50)
    app.run(debug=True, host='127.0.0.1', port=5000)