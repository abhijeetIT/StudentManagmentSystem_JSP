package servlet;

import dao.AttendanceDAO;
import model.Attendance;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/attendance")
public class AttendanceServlet extends HttpServlet {

    // ── GET: load attendance for selected date and forward to JSP ──
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Determine selected date (default = today)
        String selectedDate = request.getParameter("attendanceDate");
        if (selectedDate == null || selectedDate.isEmpty()) {
            selectedDate = new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
        }

        AttendanceDAO dao = new AttendanceDAO();
        List<Map<String, Object>> rows = dao.getAttendanceByDate(Date.valueOf(selectedDate));

        // Read flash from session if any
        String flash     = (String) request.getSession().getAttribute("flash");
        String flashType = (String) request.getSession().getAttribute("flashType");
        request.getSession().removeAttribute("flash");
        request.getSession().removeAttribute("flashType");

        request.setAttribute("rows",         rows);
        request.setAttribute("selectedDate", selectedDate);
        request.setAttribute("flash",        flash);
        request.setAttribute("flashType",    flashType);

        request.getRequestDispatcher("attendance.jsp").forward(request, response);
    }

    // ── POST: save attendance, redirect back to GET ────────────────
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dateParam   = request.getParameter("attendanceDate");
        String[] studentIds = request.getParameterValues("studentId");

        try {
            Date date = Date.valueOf(dateParam);
            List<Attendance> attendanceList = new ArrayList<>();

            if (studentIds != null) {
                for (String sid : studentIds) {
                    String presentParam = request.getParameter("present_" + sid);
                    boolean isPresent   = "on".equals(presentParam);

                    Attendance a = new Attendance();
                    a.setStudentId(Integer.parseInt(sid));
                    a.setAttendanceDate(date);
                    a.setPresent(isPresent);
                    attendanceList.add(a);
                }
            }

            AttendanceDAO dao = new AttendanceDAO();
            boolean success   = dao.saveAttendance(attendanceList, date);

            if (success) {
                request.getSession().setAttribute("flash",     "Attendance saved for " + dateParam + ".");
                request.getSession().setAttribute("flashType", "success");
            } else {
                request.getSession().setAttribute("flash",     "Something went wrong! Try again.");
                request.getSession().setAttribute("flashType", "error");
            }

        } catch (Exception e) {
            request.getSession().setAttribute("flash",     "Error: " + e.getMessage());
            request.getSession().setAttribute("flashType", "error");
        }

        // PRG — redirect back to GET with same date
        response.sendRedirect(request.getContextPath() + "/attendance?attendanceDate=" + dateParam);
    }
}
