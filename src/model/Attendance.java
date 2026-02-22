package model;

import java.sql.Date;

public class Attendance {

    private int attendanceId;
    private int studentId;
    private Date attendanceDate;
    private boolean present;

    public Attendance() {}

    public Attendance(int studentId, Date attendanceDate, boolean present) {
        this.studentId = studentId;
        this.attendanceDate = attendanceDate;
        this.present = present;
    }

    // Getters and Setters

    public int getAttendanceId() { return attendanceId; }
    public void setAttendanceId(int attendanceId) { this.attendanceId = attendanceId; }

    public int getStudentId() { return studentId; }
    public void setStudentId(int studentId) { this.studentId = studentId; }

    public Date getAttendanceDate() { return attendanceDate; }
    public void setAttendanceDate(Date attendanceDate) { this.attendanceDate = attendanceDate; }

    public boolean isPresent() { return present; }
    public void setPresent(boolean present) { this.present = present; }
}