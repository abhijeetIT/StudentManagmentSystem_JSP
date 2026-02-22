package servlet;

import dao.AttendanceReportDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;

@WebServlet("/attendance-report")
public class AttendanceReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Default: current month
        String fromParam = request.getParameter("fromDate");
        String toParam   = request.getParameter("toDate");

        if (fromParam == null || fromParam.isEmpty()) {
            // Default from = 1st of current month
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.set(java.util.Calendar.DAY_OF_MONTH, 1);
            fromParam = new SimpleDateFormat("yyyy-MM-dd").format(cal.getTime());
        }

        if (toParam == null || toParam.isEmpty()) {
            // Default to = today
            toParam = new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
        }

        Date fromDate = Date.valueOf(fromParam);
        Date toDate   = Date.valueOf(toParam);

        AttendanceReportDAO dao = new AttendanceReportDAO();
        List<Map<String, Object>> report = dao.getReport(fromDate, toDate);
        int totalDays = dao.getTotalDays(fromDate, toDate);

        request.setAttribute("report",    report);
        request.setAttribute("totalDays", totalDays);
        request.setAttribute("fromDate",  fromParam);
        request.setAttribute("toDate",    toParam);

        request.getRequestDispatcher("attendance-report.jsp").forward(request, response);
    }
}