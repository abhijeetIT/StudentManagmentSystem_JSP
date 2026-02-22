<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Student" %>
<%
    // Read flash from session, then clear it
    String flash     = (String) session.getAttribute("flash");
    String flashType = (String) session.getAttribute("flashType");
    session.removeAttribute("flash");
    session.removeAttribute("flashType");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Records</title>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'DM Sans', sans-serif;
            background: #f4f6f9;
            padding: 40px 20px;
        }

        .container { max-width: 1100px; margin: auto; }

        /* ── Header ── */
        .page-header {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 12px;
        }

        .page-header-left a.back {
            font-size: 13px;
            color: #888;
            text-decoration: none;
            display: block;
            margin-bottom: 8px;
        }
        .page-header-left a.back:hover { color: #333; }

        .page-header-left h1 {
            font-size: 22px;
            font-weight: 700;
            color: #111;
        }

        .btn-add {
            padding: 10px 22px;
            background: #2c3e50;
            color: #fff;
            border: none;
            border-radius: 5px;
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
            white-space: nowrap;
        }
        .btn-add:hover { background: #1a252f; }

        /* ── Flash message ── */
        .msg {
            padding: 12px 16px;
            border-radius: 5px;
            font-size: 13px;
            margin-bottom: 16px;
        }
        .msg.success { background: #e8f5e9; color: #2e7d32; border: 1px solid #c8e6c9; }
        .msg.error   { background: #fce4e4; color: #c62828; border: 1px solid #ffcdd2; }

        /* ── Table ── */
        .table-card {
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 10px rgba(0,0,0,0.06);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }

        thead tr { background: #2c3e50; }

        thead th {
            padding: 13px 14px;
            text-align: center;
            color: #fff;
            font-weight: 500;
            font-size: 12px;
            text-transform: uppercase;
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

        .dept-badge {
            display: inline-block;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
            background: #e8f0fe;
            color: #1a56db;
        }

        .no-data {
            text-align: center;
            padding: 36px;
            color: #aaa;
            font-size: 14px;
        }

        /* ── Action buttons ── */
        .actions { display: flex; gap: 8px; justify-content: center; }

        .btn-edit, .btn-delete {
            padding: 6px 14px;
            border: none;
            border-radius: 4px;
            font-family: 'DM Sans', sans-serif;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }

        .btn-edit   { background: #e3f2fd; color: #1565c0; }
        .btn-edit:hover { background: #bbdefb; }

        .btn-delete { background: #fce4e4; color: #c62828; }
        .btn-delete:hover { background: #ffcdd2; }

        .table-footer {
            padding: 10px 14px;
            background: #f7f7f7;
            border-top: 1px solid #eee;
            font-size: 12px;
            color: #888;
            text-align: right;
        }

        /* ── MODAL ── */
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.45);
            z-index: 100;
            align-items: center;
            justify-content: center;
        }
        .modal-overlay.active { display: flex; }

        .modal {
            background: #fff;
            border-radius: 8px;
            width: min(520px, 95vw);
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 20px 60px rgba(0,0,0,0.2);
            animation: modalIn 0.22s ease;
        }

        @keyframes modalIn {
            from { opacity: 0; transform: translateY(-14px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .modal-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 18px 22px;
            border-bottom: 1px solid #eee;
        }
        .modal-header h3 { font-size: 16px; font-weight: 700; color: #111; }

        .modal-close {
            background: none; border: none;
            font-size: 22px; cursor: pointer;
            color: #aaa; line-height: 1; padding: 0 4px;
        }
        .modal-close:hover { color: #333; }

        .modal-body { padding: 22px; }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        .form-group { display: flex; flex-direction: column; gap: 6px; }

        .form-group label {
            font-size: 11px;
            font-weight: 600;
            color: #555;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .form-group input,
        .form-group select {
            padding: 9px 12px;
            border: 1px solid #d0d0d0;
            border-radius: 4px;
            font-family: 'DM Sans', sans-serif;
            font-size: 14px;
            color: #222;
            background: #fafafa;
            transition: border-color 0.2s;
        }
        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #2c3e50;
            background: #fff;
        }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            padding: 16px 22px;
            border-top: 1px solid #eee;
        }

        .btn-cancel {
            padding: 9px 20px;
            background: #f0f0f0; color: #444;
            border: none; border-radius: 4px;
            font-family: 'DM Sans', sans-serif;
            font-size: 14px; font-weight: 500; cursor: pointer;
        }
        .btn-cancel:hover { background: #e0e0e0; }

        .btn-submit {
            padding: 9px 24px;
            background: #2c3e50; color: #fff;
            border: none; border-radius: 4px;
            font-family: 'DM Sans', sans-serif;
            font-size: 14px; font-weight: 600; cursor: pointer;
        }
        .btn-submit:hover { background: #1a252f; }

        /* ── Delete modal ── */
        .del-modal {
            background: #fff;
            border-radius: 8px;
            width: min(380px, 95vw);
            box-shadow: 0 20px 60px rgba(0,0,0,0.2);
            animation: modalIn 0.22s ease;
            padding: 28px 24px 22px;
            text-align: center;
        }
        .del-modal h3 { font-size: 16px; font-weight: 700; margin-bottom: 10px; }
        .del-modal p  { font-size: 13px; color: #666; margin-bottom: 24px; }
        .del-modal .actions { justify-content: center; }

        .btn-confirm-del {
            padding: 9px 22px;
            background: #e53935; color: #fff;
            border: none; border-radius: 4px;
            font-family: 'DM Sans', sans-serif;
            font-size: 14px; font-weight: 600; cursor: pointer;
        }
        .btn-confirm-del:hover { background: #b71c1c; }
    </style>
</head>
<body>

<div class="container">

    <%-- Flash — already read from session at the top, just display here --%>
    <% if (flash != null) { %>
        <div class="msg <%= "error".equals(flashType) ? "error" : "success" %>"><%= flash %></div>
    <% } %>

    <div class="page-header">
        <div class="page-header-left">
            <a href="<%= request.getContextPath() %>/index.jsp" class="back">← Back to Home</a>
            <h1>Student Records</h1>
        </div>
        <button class="btn-add" onclick="openAddModal()">+ Add Student</button>
    </div>

    <%
        List<Student> list = (List<Student>) request.getAttribute("students");
        int totalCount = (list != null) ? list.size() : 0;
    %>

    <div class="table-card">
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Roll</th>
                    <th>Name</th>
                    <th>DOB</th>
                    <th>Gender</th>
                    <th>Contact No</th>
                    <th>Department</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (list == null || list.isEmpty()) { %>
                <tr>
                    <td colspan="8" class="no-data">No student records found. Click "+ Add Student" to get started.</td>
                </tr>
                <% } else {
                    int sr = 1;
                    for (Student s : list) { %>
                <tr>
                    <td><%= sr++ %></td>
                    <td><strong><%= s.getRoll() %></strong></td>
                    <td><%= s.getName() %></td>
                    <td><%= s.getDob() %></td>
                    <td><%= s.getGender() %></td>
                    <td><%= s.getContactNo() %></td>
                    <td><span class="dept-badge"><%= s.getDepartment() %></span></td>
                    <td>
                        <div class="actions">
                            <button class="btn-edit" onclick="openEditModal(
                                '<%= s.getId() %>',
                                '<%= s.getRoll() %>',
                                '<%= s.getName().replace("'", "\\'") %>',
                                '<%= s.getDob() %>',
                                '<%= s.getGender() %>',
                                '<%= s.getContactNo() %>',
                                '<%= s.getDepartment().replace("'", "\\'") %>'
                            )">Edit</button>
                            <button class="btn-delete" onclick="openDeleteModal(
                                '<%= s.getId() %>',
                                '<%= s.getName().replace("'", "\\'") %>'
                            )">Delete</button>
                        </div>
                    </td>
                </tr>
                <% } } %>
            </tbody>
        </table>
        <div class="table-footer"><%= totalCount %> student(s) total</div>
    </div>

</div><!-- /container -->


<!-- ── ADD / EDIT MODAL ─────────────────────────────────── -->
<div class="modal-overlay" id="studentModal">
    <div class="modal">
        <div class="modal-header">
            <h3 id="modalTitle">Add Student</h3>
            <button class="modal-close" onclick="closeModal('studentModal')">×</button>
        </div>

        <form method="POST" action="<%= request.getContextPath() %>/students">
            <input type="hidden" name="action" id="formAction" value="add">
            <input type="hidden" name="id"     id="formId"     value="">

            <div class="modal-body">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Roll No.</label>
                        <input type="number" name="roll" id="formRoll" required placeholder="e.g. 101">
                    </div>
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="name" id="formName" required placeholder="Student name">
                    </div>
                    <div class="form-group">
                        <label>Date of Birth</label>
                        <input type="date" name="dob" id="formDob" required>
                    </div>
                    <div class="form-group">
                        <label>Gender</label>
                        <select name="gender" id="formGender" required>
                            <option value="">Select</option>
                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Contact No.</label>
                        <input type="number" name="contactNo" id="formContact" required placeholder="10-digit number">
                    </div>
                    <div class="form-group">
                        <label>Department</label>
                        <select name="department" id="formDept" required>
                            <option value="">Select</option>
                            <option value="BCA">B.C.A</option>
                            <option value="BBA">B.B.A</option>
                            <option value="BHM">B.H.M</option>
                        </select>
                    </div>
                </div>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal('studentModal')">Cancel</button>
                <button type="submit" class="btn-submit" id="modalSaveBtn">Save Student</button>
            </div>
        </form>
    </div>
</div>


<!-- ── DELETE CONFIRM MODAL ─────────────────────────────── -->
<div class="modal-overlay" id="deleteModal">
    <div class="del-modal">
        <h3>Delete Student?</h3>
        <p id="deleteMsg">This action cannot be undone.</p>
        <form method="POST" action="<%= request.getContextPath() %>/students">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="id"     id="deleteId" value="">
            <div class="actions">
                <button type="button" class="btn-cancel" onclick="closeModal('deleteModal')">Cancel</button>
                <button type="submit" class="btn-confirm-del">Yes, Delete</button>
            </div>
        </form>
    </div>
</div>


<script>
    function openAddModal() {
        document.getElementById('modalTitle').textContent   = 'Add Student';
        document.getElementById('modalSaveBtn').textContent = 'Save Student';
        document.getElementById('formAction').value = 'add';
        document.getElementById('formId').value      = '';
        document.getElementById('formRoll').value    = '';
        document.getElementById('formName').value    = '';
        document.getElementById('formDob').value     = '';
        document.getElementById('formGender').value  = '';
        document.getElementById('formContact').value = '';
        document.getElementById('formDept').value    = '';
        document.getElementById('studentModal').classList.add('active');
    }

    function openEditModal(id, roll, name, dob, gender, contact, dept) {
        document.getElementById('modalTitle').textContent   = 'Edit Student';
        document.getElementById('modalSaveBtn').textContent = 'Update Student';
        document.getElementById('formAction').value = 'edit';
        document.getElementById('formId').value      = id;
        document.getElementById('formRoll').value    = roll;
        document.getElementById('formName').value    = name;
        document.getElementById('formDob').value     = dob;
        document.getElementById('formGender').value  = gender;
        document.getElementById('formContact').value = contact;
        document.getElementById('formDept').value    = dept;
        document.getElementById('studentModal').classList.add('active');
    }

    function openDeleteModal(id, name) {
        document.getElementById('deleteId').value  = id;
        document.getElementById('deleteMsg').textContent =
            'Are you sure you want to delete "' + name + '"? This cannot be undone.';
        document.getElementById('deleteModal').classList.add('active');
    }

    function closeModal(id) {
        document.getElementById(id).classList.remove('active');
    }

    // Close on backdrop click
    document.querySelectorAll('.modal-overlay').forEach(function(overlay) {
        overlay.addEventListener('click', function(e) {
            if (e.target === this) this.classList.remove('active');
        });
    });
</script>

</body>
</html>
