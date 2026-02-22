<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    List<Map<String, Object>> report = (List<Map<String, Object>>) request.getAttribute("report");
    int    totalDays = (int)    request.getAttribute("totalDays");
    String fromDate  = (String) request.getAttribute("fromDate");
    String toDate    = (String) request.getAttribute("toDate");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Attendance Report</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: #f0f2f5;
            padding: 40px 20px;
            color: #1a1a2e;
        }

        .wrapper { max-width: 1000px; margin: 0 auto; }

        /* ── Header ── */
        .page-header { margin-bottom: 24px; }

        .page-header a {
            font-size: 13px; color: #888; text-decoration: none;
        }
        .page-header a:hover { color: #333; }

        .page-header h2 {
            font-size: 22px; font-weight: 700;
            margin-top: 8px; color: #111;
        }

        .page-header p { font-size: 13px; color: #888; margin-top: 4px; }

        /* ── Filter bar ── */
        .filter-bar {
            display: flex;
            align-items: flex-end;
            gap: 16px;
            background: #fff;
            padding: 16px 20px;
            border-radius: 6px;
            border: 1px solid #e0e0e0;
            margin-bottom: 24px;
            flex-wrap: wrap;
        }

        .filter-group { display: flex; flex-direction: column; gap: 6px; }

        .filter-group label {
            font-size: 11px; font-weight: 600;
            color: #555; text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .filter-group input[type="date"] {
            padding: 8px 12px;
            border: 1px solid #d0d0d0;
            border-radius: 4px;
            font-family: 'DM Sans', sans-serif;
            font-size: 13px; color: #222;
            background: #fafafa;
        }
        .filter-group input[type="date"]:focus {
            outline: none; border-color: #2c3e50;
        }

        .btn-filter {
            padding: 9px 22px;
            background: #2c3e50; color: #fff;
            border: none; border-radius: 4px;
            font-family: 'DM Sans', sans-serif;
            font-size: 14px; font-weight: 600;
            cursor: pointer; transition: background 0.2s;
            align-self: flex-end;
        }
        .btn-filter:hover { background: #1a252f; }

        /* ── Summary cards ── */
        .summary {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 24px;
        }

        .card {
            background: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 20px 22px;
        }

        .card .card-label {
            font-size: 11px; font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.06em; color: #888;
            margin-bottom: 8px;
        }

        .card .card-value {
            font-size: 28px; font-weight: 700; color: #111;
        }

        .card .card-sub {
            font-size: 12px; color: #aaa; margin-top: 4px;
        }

        /* ── Table ── */
        .table-card {
            background: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            overflow: hidden;
        }

        table { width: 100%; border-collapse: collapse; font-size: 14px; }

        thead tr { background: #2c3e50; }

        thead th {
            padding: 13px 14px;
            text-align: center;
            color: #fff; font-weight: 500;
            font-size: 12px; text-transform: uppercase;
            letter-spacing: 0.06em;
        }

        tbody tr:nth-child(even) { background: #f9f9f9; }
        tbody tr:hover { background: #e8f0fe; }

        tbody td {
            padding: 12px 14px;
            text-align: center;
            color: #333;
            border-bottom: 1px solid #f0f0f0;
        }
        tbody tr:last-child td { border-bottom: none; }

        .muted { font-size: 12px; color: #aaa; }

        /* ── Progress bar ── */
        .progress-wrap {
            display: flex;
            align-items: center;
            gap: 10px;
            justify-content: center;
        }

        .progress-bar {
            width: 100px; height: 8px;
            background: #e0e0e0;
            border-radius: 4px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            border-radius: 4px;
            transition: width 0.3s;
        }

        .progress-label {
            font-size: 13px;
            font-weight: 600;
            min-width: 44px;
            text-align: right;
        }

        /* ── Percentage color ── */
        .high   { color: #2e7d32; }
        .medium { color: #f57c00; }
        .low    { color: #c62828; }

        .fill-high   { background: #4CAF50; }
        .fill-medium { background: #ff9800; }
        .fill-low    { background: #e53935; }

        .no-data {
            text-align: center; padding: 40px;
            color: #aaa; font-size: 14px;
        }

        .table-footer {
            padding: 10px 14px;
            background: #f7f7f7;
            border-top: 1px solid #eee;
            font-size: 12px; color: #888;
            text-align: right;
        }

        @media (max-width: 600px) {
            .summary { grid-template-columns: 1fr; }
            .progress-bar { width: 60px; }
        }
    </style>
</head>
<body>

<div class="wrapper">

    <div class="page-header">
        <a href="<%= request.getContextPath() %>/index.jsp">← Back to Home</a>
        <h2>Attendance Report</h2>
        <p>View attendance summary by date range.</p>
    </div>

    <%-- Date range filter --%>
    <form method="GET" action="<%= request.getContextPath() %>/attendance-report">
        <div class="filter-bar">
            <div class="filter-group">
                <label>From Date</label>
                <input type="date" name="fromDate" value="<%= fromDate %>">
            </div>
            <div class="filter-group">
                <label>To Date</label>
                <input type="date" name="toDate" value="<%= toDate %>">
            </div>
            <button type="submit" class="btn-filter">Generate Report</button>
        </div>
    </form>

    <%-- Summary cards --%>
    <%
        int totalStudents = (report != null) ? report.size() : 0;

        // Calculate class average percentage
        double avgPercentage = 0;
        if (report != null && !report.isEmpty()) {
            double sum = 0;
            for (Map<String, Object> r : report) {
                sum += (double) r.get("percentage");
            }
            avgPercentage = Math.round((sum / report.size()) * 10.0) / 10.0;
        }
    %>
    <div class="summary">
        <div class="card">
            <div class="card-label">Total Students</div>
            <div class="card-value"><%= totalStudents %></div>
            <div class="card-sub">enrolled</div>
        </div>
        <div class="card">
            <div class="card-label">Total Classes Held</div>
            <div class="card-value"><%= totalDays %></div>
            <div class="card-sub"><%= fromDate %> → <%= toDate %></div>
        </div>
        <div class="card">
            <div class="card-label">Class Average</div>
            <div class="card-value <%= avgPercentage >= 75 ? "high" : avgPercentage >= 50 ? "medium" : "low" %>">
                <%= avgPercentage %>%
            </div>
            <div class="card-sub">overall attendance</div>
        </div>
    </div>

    <%-- Report table --%>
    <div class="table-card">
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Roll</th>
                    <th>Name</th>
                    <th>Total Classes</th>
                    <th>Present</th>
                    <th>Absent</th>
                    <th>Attendance %</th>
                </tr>
            </thead>
            <tbody>
                <% if (report == null || report.isEmpty()) { %>
                <tr>
                    <td colspan="7" class="no-data">No data found for selected date range.</td>
                </tr>
                <% } else {
                    int sr = 1;
                    for (Map<String, Object> row : report) {
                        Long    roll         = (Long)    row.get("roll");
                        String name         = (String) row.get("name");
                        int    totalClasses = (int)    row.get("totalClasses");
                        int    presentCount = (int)    row.get("presentCount");
                        int    absentCount  = (int)    row.get("absentCount");
                        double percentage   = (double) row.get("percentage");

                        String colorClass = percentage >= 75 ? "high" : percentage >= 50 ? "medium" : "low";
                        String fillClass  = percentage >= 75 ? "fill-high" : percentage >= 50 ? "fill-medium" : "fill-low";
                %>
                <tr>
                    <td class="muted"><%= sr++ %></td>
                    <td><strong><%= roll %></strong></td>
                    <td><%= name %></td>
                    <td><%= totalClasses %></td>
                    <td style="color:#2e7d32; font-weight:600;"><%= presentCount %></td>
                    <td style="color:#c62828; font-weight:600;"><%= absentCount %></td>
                    <td>
                        <div class="progress-wrap">
                            <div class="progress-bar">
                                <div class="progress-fill <%= fillClass %>"
                                     style="width:<%= Math.min(percentage, 100) %>%"></div>
                            </div>
                            <span class="progress-label <%= colorClass %>"><%= percentage %>%</span>
                        </div>
                    </td>
                </tr>
                <% } } %>
            </tbody>
        </table>
        <div class="table-footer"><%= totalStudents %> student(s) &nbsp;·&nbsp; <%= totalDays %> class day(s) in range</div>
    </div>

</div>

</body>
</html>
