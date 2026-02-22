package dao;

import db.DBConnection;
import model.Attendance;

import java.sql.*;
import java.util.*;

public class AttendanceDAO {

    // Save attendance for a date (delete + re-insert)
    public boolean saveAttendance(List<Attendance> attendanceList, java.sql.Date date) {
        try (Connection con = DBConnection.getConnection()) {

            // Delete existing records for this date
            PreparedStatement del = con.prepareStatement(
                    "DELETE FROM attendance WHERE attendance_date = ?");
            del.setDate(1, date);
            del.executeUpdate();

            // Insert new records
            PreparedStatement ins = con.prepareStatement(
                    "INSERT INTO attendance (student_id, attendance_date, present) VALUES (?, ?, ?)");

            for (Attendance a : attendanceList) {
                ins.setInt(1,     a.getStudentId());
                ins.setDate(2,    date);
                ins.setBoolean(3, a.isPresent());
                ins.addBatch();
            }
            ins.executeBatch();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Fetch students + their attendance for a given date
    public List<Map<String, Object>> getAttendanceByDate(java.sql.Date date) {
        List<Map<String, Object>> rows = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                    "SELECT s.id AS student_id, s.roll, s.name, " +
                            "       COALESCE(a.present, FALSE) AS present " +
                            "FROM students s " +
                            "LEFT JOIN attendance a " +
                            "       ON a.student_id = s.id " +
                            "      AND a.attendance_date = ? " +
                            "ORDER BY s.roll");
            ps.setDate(1, date);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("studentId", rs.getInt("student_id"));
                row.put("roll",      rs.getLong("roll"));
                row.put("name",      rs.getString("name"));
                row.put("present",   rs.getBoolean("present"));
                rows.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return rows;
    }
}
