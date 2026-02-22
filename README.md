# 🎓 College Management System

> A **Java Servlet + JSP + MySQL** based Student Management and Attendance Tracking Application built for college administration.  
> Clean MVC architecture with DAO pattern — no frameworks, pure Java EE. ☕

![Java](https://img.shields.io/badge/Java-EE-orange)
![JSP](https://img.shields.io/badge/JSP-Servlet-red)
![MySQL](https://img.shields.io/badge/Database-MySQL-blue)
![Tomcat](https://img.shields.io/badge/Server-Apache%20Tomcat-yellow)
![Maven](https://img.shields.io/badge/Build-Maven-brightgreen)

---

## 🧠 Overview

**College Management System** is a web-based administration portal built using core Java EE technologies.  
It allows college staff to manage student records, mark daily attendance, and generate detailed attendance reports — all from a clean, responsive interface.

---

## ⚙️ Key Features

✅ **Student Management** — Add, edit, and delete student records with full details.  
✅ **Attendance Marking** — Mark present/absent for each student by date with toggle switches.  
✅ **Attendance Report** — Date range filter with per-student percentage, present/absent count, and color-coded progress bars.  
✅ **MVC Architecture** — Clean separation of Servlet (Controller), JSP (View), and DAO (Model).  
✅ **DAO Pattern** — All database operations isolated in dedicated DAO classes.  
✅ **PRG Pattern** — Post-Redirect-Get implemented to prevent form re-submission on refresh.  
✅ **Session Flash Messages** — Success/error feedback messages after every action.  
✅ **Responsive UI** — Clean, minimal design with DM Sans font and consistent styling.

---

## 🛠️ Tech Stack

| Layer | Technology |
|:------|:-----------|
| 🧩 **Language** | Java (JDK 17+) |
| 🌐 **Web Layer** | JSP + Java Servlets |
| 🗄️ **Database** | MySQL |
| 🔗 **DB Connectivity** | JDBC |
| 🧱 **Architecture** | MVC + DAO Pattern |
| 🖥️ **Server** | Apache Tomcat 9 |
| 🧰 **Build Tool** | Maven |

---

## 📁 Project Structure

```
CollegeManagement/
├── src/
│   └── main/
│       └── java/
│           ├── db/
│           │   └── DBConnection.java          # JDBC connection utility
│           ├── model/
│           │   ├── Student.java               # Student model
│           │   └── Attendance.java            # Attendance model
│           ├── dao/
│           │   ├── StudentDAO.java            # Student DB operations
│           │   ├── AttendanceDAO.java         # Attendance DB operations
│           │   └── AttendanceReportDAO.java   # Report queries
│           └── servlet/
│               ├── StudentServlet.java        # /students
│               ├── AttendanceServlet.java     # /attendance
│               └── AttendanceReportServlet.java # /attendance-report
└── src/
    └── main/
        └── webapp/
            ├── index.jsp                      # Home page
            ├── students.jsp                   # Student records page
            ├── attendance.jsp                 # Attendance marking page
            ├── attendance-report.jsp          # Attendance report page
            └── assets/
                └── college.jpg                # Background image
```

---

## 🗄️ Database Schema

```sql
CREATE DATABASE college_db;
USE college_db;

-- Students table
CREATE TABLE students (
    id          INT PRIMARY KEY AUTO_INCREMENT,
    roll        BIGINT NOT NULL,
    name        VARCHAR(100) NOT NULL,
    dob         DATE,
    gender      VARCHAR(10),
    contact_no  BIGINT,
    department  VARCHAR(100)
);

-- Attendance table
CREATE TABLE attendance (
    attendance_id   INT PRIMARY KEY AUTO_INCREMENT,
    student_id      INT NOT NULL,
    attendance_date DATE NOT NULL,
    present         TINYINT(1) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES students(id)
);
```

---

## 🚀 Getting Started

### Prerequisites
- JDK 17+
- Apache Tomcat 9
- MySQL 8+
- Maven

### Setup Steps

**1. Clone the repository**
```bash
git clone https://github.com/abhijeetIT/CollegeManagement.git
cd CollegeManagement
```

**2. Configure database**

Update DB credentials in `DBConnection.java`:
```java
private static final String URL  = "jdbc:mysql://localhost:3306/college_db";
private static final String USER = "root";
private static final String PASS = "your_password";
```

**3. Run the SQL schema**
```bash
mysql -u root -p < schema.sql
```

**4. Build with Maven**
```bash
mvn clean package
```

**5. Deploy to Tomcat**

Copy the generated `.war` file from `target/` into Tomcat's `webapps/` directory and start the server.

**6. Open in browser**
```
http://localhost:8080/CollegeManagement/
```

---

## 📸 Pages

| Page | URL | Description |
|:-----|:----|:------------|
| 🏠 Home | `/index.jsp` | Landing page with navigation |
| 👨‍🎓 Students | `/students` | View, add, edit, delete students |
| ✅ Attendance | `/attendance` | Mark daily attendance by date |
| 📊 Report | `/attendance-report` | Attendance % report with date filter |

---

## 📊 Attendance Report Features

- Select **From Date** and **To Date** to filter
- Shows **Total Classes Held** in range
- Per student: **Present**, **Absent**, **Percentage**
- Color-coded progress bar:
    - 🟢 ≥ 75% — Good
    - 🟡 ≥ 50% — Average
    - 🔴 < 50% — Low
- **Class Average %** summary card

---

## 🔄 Application Flow

```
Browser
  │
  ├── GET  /students          → StudentServlet.doGet()  → students.jsp
  ├── POST /students (add)    → StudentServlet.doPost() → redirect → GET
  ├── POST /students (edit)   → StudentServlet.doPost() → redirect → GET
  ├── POST /students (delete) → StudentServlet.doPost() → redirect → GET
  │
  ├── GET  /attendance        → AttendanceServlet.doGet()  → attendance.jsp
  ├── POST /attendance        → AttendanceServlet.doPost() → redirect → GET
  │
  └── GET  /attendance-report → AttendanceReportServlet.doGet() → attendance-report.jsp
```

---

## 🧑‍💻 Developer

| | |
|:--|:--|
| 👨‍💻 **Name** | Abhijeet Jha |
| 🎓 **Course** | BCA — 3rd Semester |
| 💼 **Aspiration** | Backend Developer · Java & Spring Boot Enthusiast |

---

## 🌐 Connect With Me

<p>
  <a href="mailto:abhijeetj4324@gmail.com">
    <img src="https://img.shields.io/badge/Email-abhijeetj4324%40gmail.com-red?style=flat&logo=gmail&logoColor=white"/>
  </a>
  &nbsp;
  <a href="https://www.linkedin.com/in/abhijeet-jha19" target="_blank">
    <img src="https://img.shields.io/badge/LinkedIn-abhijeet--jha19-blue?style=flat&logo=linkedin&logoColor=white"/>
  </a>
  &nbsp;
  <a href="https://github.com/abhijeetIT" target="_blank">
    <img src="https://img.shields.io/badge/GitHub-abhijeetIT-black?style=flat&logo=github&logoColor=white"/>
  </a>
  &nbsp;
  <a href="https://instagram.com/_abhijeet_jha_" target="_blank">
    <img src="https://img.shields.io/badge/Instagram-@__abhijeet__jha__-E4405F?style=flat&logo=instagram&logoColor=white"/>
  </a>
</p>

---

<p align="center">Made with ☕ and Java · ABC College of Engineering</p>