package com.warehouse.controllers;
import com.warehouse.dao.UserDAO;
import com.warehouse.models.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect("dashboard.jsp");
        } else {
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userDAO.getUserByUsername(username);
        System.out.println(user);

        if (user != null && BCrypt.checkpw(password, user.getPassword())) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // Get user role
            String role = user.getRole();
            System.out.println(role);

            // Redirect based on specific role
            if ("admin".equals(role)) {
                // Admin specific redirection
                response.sendRedirect("dashboard.jsp");
            }
            else if ("stock_manager".equals(role)) {
                // Stock Manager specific redirection
                response.sendRedirect("dashboard.jsp");
            }
            else if ("viewer".equals(role)) {
                // Viewer specific redirection
                response.sendRedirect("dashboard.jsp");
            }
            else {
                // Default fallback for unknown roles
                response.sendRedirect("dashboard.jsp");
            }
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}