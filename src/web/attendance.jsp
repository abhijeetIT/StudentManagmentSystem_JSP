<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    // All data prepared by AttendanceServlet — just read attributes here
    List<Map<String, Object>> rows = (List<Map<String, Object>>) request.getAttribute("rows");
    String selectedDate = (String) request.getAttribute("selectedDate");
    String flash        = (String) request.getAttribute("flash");
    String flashType    = (String) request.getAttribute("flashType");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Attendance</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: #f0f2f5;
            color: #1a1a2e;
            padding: 40px 20px;
        }

        .wrapper { max-width: 860px; margin: 0 auto; }

        .page-header { margin-bottom: 24px; }

        .page-header a {
            font-size: 13px; color: #888; text-decoration: none;
        }
        .page-header a:hover { color: #333; }

        .page-header h2 {
            font-size: 22px; font-weight: 700;
            margin-top: 8px; color: #111;
        }

        .page-header p {
            font-size: 13px; color: #888; margin-top: 4px;
        }

        .controls {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 20px;
            background: #fff;
            padding: 14px 18px;
            border-radius: 6px;
            border: 1px solid #e0e0e0;
        }

        .controls label { font-size: 13px; font-weight: 500; color: #444; }

        .controls input[type="date"] {
            padding: 7px 10px;
            border: 1px solid #d0d0d0;
            border-radius: 4px;
            font-family: 'DM Sans', sans-serif;
            font-size: 13px;
            color: #222;
            background: #fafafa;
        }
        .controls input[type="date"]:focus {
            outline: none; border-color: #4CAF50;
        }

        form {
            background: #fff;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            overflow: hidden;
        }

        table { width: 100%; border-collapse: collapse; font-size: 14px; }

        thead { background: #f7f7f7; border-bottom: 2px solid #e0e0e0; }

        thead th {
            padding: 12px 16px;
            text-align: left;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            color: #666;
        }

        tbody tr { border-bottom: 1px solid #f0f0f0; transition: background 0.15s; }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: #fafafa; }

        tbody td { padding: 12px 16px; color: #222; vertical-align: middle; }

        .muted { font-size: 12px; color: #aaa; }

        .toggle-wrap { display: flex; align-items: center; gap: 10px; }

        .toggle-wrap input[type="checkbox"] { display: none; }

        .toggle {
            width: 44px; height: 24px;
            background: #e0e0e0;
            border-radius: 12px;
            position: relative;
            cursor: pointer;
            transition: background 0.2s;
            flex-shrink: 0;
        }

        .toggle::after {
            content: '';
            position: absolute;
            width: 18px; height: 18px;
            background: #fff;
            border-radius: 50%;
            top: 3px; left: 3px;
            transition: transform 0.2s;
            box-shadow: 0 1px 3px rgba(0,0,0,0.2);
        }

        input[type="checkbox"]:checked + .toggle { background: #4CAF50; }
        input[type="checkbox"]:checked + .toggle::after { transform: translateX(20px); }

        .status-label { font-size: 13px; font-weight: 500; min-width: 48px; }
        .status-label.present { color: #2e7d32; }
        .status-label.absent  { color: #c62828; }

        .save-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 14px 18px;
            background: #fff;
            border: 1px solid #e0e0e0;
            border-top: none;
            border-radius: 0 0 6px 6px;
        }

        .save-bar span { font-size: 13px; color: #888; }

        .btn-save {
            padding: 10px 28px;
            background: #4CAF50; color: #fff;
            border: none; border-radius: 4px;
            font-family: 'DM Sans', sans-serif;
            font-size: 14px; font-weight: 600;
            cursor: pointer; transition: background 0.2s;
        }
        .btn-save:hover { background: #388e3c; }

        .msg {
            padding: 12px 16px; border-radius: 5px;
            font-size: 13px; margin-bottom: 16px;
        }
        .msg.success { background: #e8f5e9; color: #2e7d32; border: 1px solid #c8e6c9; }
        .msg.error   { background: #fce4e4; color: #c62828; border: 1px solid #ffcdd2; }

        .no-data { text-align: center; padding: 40px; color: #aaa; font-size: 14px; }
    </style>
</head>
<body>

<div class="wrapper">

    <div class="page-header">
        <a href="<%= request.getContextPath() %>/index.jsp">← Back to Home</a>
        <h2>Student Attendance</h2>
        <p>Mark attendance for a date and click Save.</p>
    </div>

    <%-- Flash message from servlet --%>
    <% if (flash != null) { %>
        <div class="msg <%= "error".equals(flashType) ? "error" : "success" %>"><%= flash %></div>
    <% } %>

    <%-- Date picker — GET request to servlet --%>
    <form method="GET" action="<%= request.getContextPath() %>/attendance">
        <div class="controls">
            <label for="dateInput">Select Date:</label>
            <input type="date" id="dateInput" name="attendanceDate"
                   value="<%= selectedDate %>"
                   onchange="this.form.submit()">
        </div>
    </form>

    <%-- Attendance form — POST to servlet --%>
    <form method="POST" action="<%= request.getContextPath() %>/attendance">
        <input type="hidden" name="attendanceDate" value="<%= selectedDate %>">

        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Roll</th>
                    <th>Name</th>
                    <th>Present</th>
                </tr>
            </thead>
            <tbody>
                <% if (rows == null || rows.isEmpty()) { %>
                <tr>
                    <td colspan="4" class="no-data">No students found.</td>
                </tr>
                <% } else {
                    int serial = 1;
                    for (Map<String, Object> row : rows) {
                        int     sid     = (int)     row.get("studentId");
                        Long     roll    = (Long)     row.get("roll");
                        String  name    = (String)  row.get("name");
                        boolean present = (boolean) row.get("present");
                %>
                <tr>
                    <td class="muted"><%= serial++ %></td>
                    <td><strong><%= roll %></strong></td>
                    <td><%= name %></td>
                    <td>
                        <input type="hidden" name="studentId" value="<%= sid %>">
                        <div class="toggle-wrap">
                            <input type="checkbox"
                                   id="chk_<%= sid %>"
                                   name="present_<%= sid %>"
                                   <%= present ? "checked" : "" %>
                                   onchange="updateLabel(this, <%= sid %>)">
                            <label class="toggle" for="chk_<%= sid %>"></label>
                            <span class="status-label <%= present ? "present" : "absent" %>"
                                  id="lbl_<%= sid %>">
                                <%= present ? "Yes" : "No" %>
                            </span>
                        </div>
                    </td>
                </tr>
                <% } } %>
            </tbody>
        </table>

        <% if (rows != null && !rows.isEmpty()) { %>
        <div class="save-bar">
            <span><%= rows.size() %> student(s) &nbsp;·&nbsp; Date: <%= selectedDate %></span>
            <button type="submit" class="btn-save">Save Attendance</button>
        </div>
        <% } %>
    </form>

</div>

<script>
    function updateLabel(chk, sid) {
        const lbl = document.getElementById('lbl_' + sid);
        if (chk.checked) {
            lbl.textContent = 'Yes';
            lbl.className   = 'status-label present';
        } else {
            lbl.textContent = 'No';
            lbl.className   = 'status-label absent';
        }
    }
</script>

</body>
</html>