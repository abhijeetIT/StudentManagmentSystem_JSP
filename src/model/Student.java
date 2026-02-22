package model;

import java.sql.Date;

public class Student {

    private int id;
    private Long roll;
    private String name;
    private Date dob;
    private String gender;
    private long contactNo;
    private String department;

    public Student() {}

    public Student(Long roll, String name, Date dob,
                   String gender, long contactNo, String department) {
        this.roll = roll;
        this.name = name;
        this.dob = dob;
        this.gender = gender;
        this.contactNo = contactNo;
        this.department = department;
    }

    // Getters and Setters

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Long getRoll() { return roll; }
    public void setRoll(Long roll) { this.roll = roll; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Date getDob() { return dob; }
    public void setDob(Date dob) { this.dob = dob; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public long getContactNo() { return contactNo; }
    public void setContactNo(long contactNo) { this.contactNo = contactNo; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
}