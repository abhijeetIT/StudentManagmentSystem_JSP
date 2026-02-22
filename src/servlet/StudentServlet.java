package servlet;

import dao.StudentDAO;
import model.Student;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/students")
public class StudentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        StudentDAO studentDAO = new StudentDAO();

        List<Student> students = studentDAO.displayStudent();

        request.setAttribute("students", students);
        request.getRequestDispatcher("students.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        StudentDAO studentDAO = new StudentDAO();

        String action = request.getParameter("action");
        try {
            if ("add".equals(action)){
                Student student = new Student();
                student.setRoll(Long.parseLong(request.getParameter("roll")));
                student.setName(request.getParameter("name"));
                student.setDob(Date.valueOf(request.getParameter("dob")));
                student.setGender(request.getParameter("gender"));
                student.setContactNo(Long.parseLong(request.getParameter("contactNo")));
                student.setDepartment(request.getParameter("department"));

                if(studentDAO.insertStudent(student)){
                    request.getSession().setAttribute("flash",     "Student added successfully.");
                    request.getSession().setAttribute("flashType", "success");
                }else {
                    request.getSession().setAttribute("flash",     "something went wrong! Try again!");
                    request.getSession().setAttribute("flashType", "error");
                }
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));

                if(studentDAO.DeleteStudent(id)){
                    request.getSession().setAttribute("flash",     "Student deleted successfully.");
                    request.getSession().setAttribute("flashType", "success");
                }else {
                    request.getSession().setAttribute("flash",     "something went wrong! Try again!");
                    request.getSession().setAttribute("flashType", "error");
                }
            } else if ("edit".equals(action)) {
                Student student = new Student();
                student.setRoll(Long.parseLong(request.getParameter("roll")));
                student.setName(request.getParameter("name"));
                student.setDob(Date.valueOf(request.getParameter("dob")));
                student.setGender(request.getParameter("gender"));
                student.setContactNo(Long.parseLong(request.getParameter("contactNo")));
                student.setDepartment(request.getParameter("department"));
                student.setId(Integer.parseInt(request.getParameter("id")));

                if(studentDAO.UpdateStudent(student)){
                    request.getSession().setAttribute("flash",     "Student Updated successfully.");
                    request.getSession().setAttribute("flashType", "success");
                }else {
                    request.getSession().setAttribute("flash",     "something went wrong! Try again!");
                    request.getSession().setAttribute("flashType", "error");
                }
            }

            response.sendRedirect(request.getContextPath() + "/students");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
