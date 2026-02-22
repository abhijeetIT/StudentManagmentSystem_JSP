package dao;

import db.DBConnection;

import java.sql.*;
import java.util.*;
import java.sql.Date;

public class AttendanceReportDAO {

    // Get attendance report for a date range
    // Returns list of: studentId, roll, name, totalClasses, presentCount, percentage
    public List<Map<String, Object>> getReport(Date fromDate, Date toDate) {
        List<Map<String, Object>> report = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                    "SELECT s.id AS student_id, s.roll, s.name, " +
                            "       COUNT(a.attendance_id)                          AS total_classes, " +
                            "       SUM(CASE WHEN a.present = 1 THEN 1 ELSE 0 END) AS present_count " +
                            "FROM students s " +
                            "LEFT JOIN attendance a " +
                            "       ON a.student_id = s.id " +
                            "      AND a.attendance_date BETWEEN ? AND ? " +
                            "GROUP BY s.id, s.roll, s.name " +
                            "ORDER BY s.roll");

            ps.setDate(1, fromDate);
            ps.setDate(2, toDate);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int totalClasses  = rs.getInt("total_classes");
                int presentCount  = rs.getInt("present_count");
                double percentage = (totalClasses > 0)
                        ? Math.round((presentCount * 100.0 / totalClasses) * 10.0) / 10.0
                        : 0.0;

                Map<String, Object> row = new HashMap<>();
                row.put("studentId",   rs.getInt("student_id"));
                row.put("roll",        rs.getLong("roll"));
                row.put("name",        rs.getString("name"));
                row.put("totalClasses", totalClasses);
                row.put("presentCount", presentCount);
                row.put("absentCount",  totalClasses - presentCount);
                row.put("percentage",   percentage);
                report.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return report;
    }

    // Get total unique class days held in date range
    public int getTotalDays(Date fromDate, Date toDate) {
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                    "SELECT COUNT(DISTINCT attendance_date) AS days " +
                            "FROM attendance WHERE attendance_date BETWEEN ? AND ?");
            ps.setDate(1, fromDate);
            ps.setDate(2, toDate);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("days");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}