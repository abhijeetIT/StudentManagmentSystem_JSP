package dao;

import model.Student;
import db.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    public boolean insertStudent(Student student) {

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO students (roll, name, dob, gender, contact_no, department) " +
                            "VALUES (?, ?, ?, ?, ?, ?)");
            ps.setLong(1,    student.getRoll());
            ps.setString(2, student.getName());
            ps.setDate(3,   student.getDob());
            ps.setString(4, student.getGender());
            ps.setLong(5,  student.getContactNo());
            ps.setString(6, student.getDepartment());
            ps.executeUpdate();

            con.close();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Student> displayStudent(){
        try{
            Connection connection = DBConnection.getConnection();
            String sql = "SELECT * FROM students";
            PreparedStatement preparedStatement = connection.prepareStatement(sql);
            ResultSet resultSet = preparedStatement.executeQuery();

            List<Student> studentList = new ArrayList<>();
            while (resultSet.next()){
                Student student = new Student();
                student.setName(resultSet.getString("name"));
                student.setId(resultSet.getInt("id"));
                student.setRoll(resultSet.getLong("roll"));
                student.setDob(resultSet.getDate("dob"));
                student.setGender(resultSet.getString("gender"));
                student.setContactNo(resultSet.getLong("contact_no"));
                student.setDepartment(resultSet.getString("department"));
                studentList.add(student);
            }

            connection.close();
            return studentList;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public boolean DeleteStudent(int id) throws SQLException {
        try(Connection connection = DBConnection.getConnection()){
            PreparedStatement ps = connection.prepareStatement(
                    "DELETE FROM students WHERE id=?");
            ps.setInt(1,id);
            ps.executeUpdate();
            connection.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public boolean UpdateStudent(Student student){
        try(Connection connection = DBConnection.getConnection()){
            PreparedStatement ps = connection.prepareStatement(
                    "UPDATE students SET roll=?, name=?, dob=?, gender=?, " +
                            "contact_no=?, department=? WHERE id=?");
            ps.setLong(1,    student.getRoll());
            ps.setString(2, student.getName());
            ps.setDate(3,   student.getDob());
            ps.setString(4, student.getGender());
            ps.setLong(5,  student.getContactNo());
            ps.setString(6, student.getDepartment());
            ps.setInt(7,student.getId());
            ps.executeUpdate();

            connection.close();
            return true;
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            return false;
        }
    }
}