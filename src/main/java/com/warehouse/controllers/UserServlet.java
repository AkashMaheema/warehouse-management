package com.warehouse.controllers;

import com.warehouse.dao.UserDAO;
import com.warehouse.models.User;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/manageUser")
public class UserServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String action = req.getParameter("action");
        UserDAO dao = new UserDAO();

        switch (action) {
            case "create":
                // Get parameters from the form
                String username = req.getParameter("username");
                String password = req.getParameter("password");
                String role = req.getParameter("role");

                // Add new user to database
                dao.add(username, password, role);
                break;

            case "update":
                // Get parameters for update
                int id = Integer.parseInt(req.getParameter("id"));
                username = req.getParameter("username");
                password = req.getParameter("password");
                role = req.getParameter("role");

                // Update user in database
                dao.update(id, username, password, role);
                break;

            case "delete":
                // Delete user from database
                dao.delete(Integer.parseInt(req.getParameter("id")));
                break;

            default:
                res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }

        // Redirect back to the user management page after operation
        res.sendRedirect(req.getContextPath() + "/manageUser");
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        UserDAO dao = new UserDAO();
        List<User> users = dao.getAll();

        req.setAttribute("users", users);

        // Forward the request to the JSP
        RequestDispatcher dispatcher = req.getRequestDispatcher("/manageUser.jsp");
        dispatcher.forward(req, res);
    }
}