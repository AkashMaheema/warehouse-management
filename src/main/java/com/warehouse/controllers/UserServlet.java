package com.warehouse.controllers;

import com.warehouse.dao.UserDAO;
import com.warehouse.models.User;
import com.warehouse.utils.SecurityUtils;
import com.warehouse.utils.PasswordUtils;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/manageUser")
public class UserServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
        String action = req.getParameter("action");
        UserDAO dao = new UserDAO();
        String errorMessage = null;
        String successMessage = null;

        switch (action) {
            case "create":
                String username = req.getParameter("username");
                String password = req.getParameter("password");
                String role = req.getParameter("role");

                if (!SecurityUtils.isValidUsername(username)) {
                    errorMessage = "Invalid username. Username cannot be only numbers and must be 3-20 characters with only letters, numbers, underscores, or hyphens.";
                    break;
                }

                try {
                    if (isDuplicateUsername(username, -1, dao)) {
                        errorMessage = "Username '" + username + "' already exists. Please choose a different username.";
                        break;
                    }
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }

                // Hash the password using BCrypt
                String hashedPassword = PasswordUtils.hashPassword(password);

                if (!dao.add(username, hashedPassword, role)) {
                    errorMessage = "Failed to create user. Please try again.";
                } else {
                    successMessage = "User '" + username + "' created successfully!";
                }
                break;

            case "update":
                int id = Integer.parseInt(req.getParameter("id"));
                username = req.getParameter("username");
                password = req.getParameter("password"); // May be blank
                role = req.getParameter("role");

                if (!SecurityUtils.isValidUsername(username)) {
                    errorMessage = "Invalid username. Username cannot be only numbers and must be 3-20 characters with only letters, numbers, underscores, or hyphens.";
                    break;
                }

                try {
                    if (isDuplicateUsername(username, id, dao)) {
                        errorMessage = "Username '" + username + "' already exists. Please choose a different username.";
                        break;
                    }
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }

                // Fetch existing user to retain old password if new one is not provided
                User existingUser = dao.getById(id);
                if (existingUser == null) {
                    errorMessage = "User not found.";
                    break;
                }

                String updateHashedPassword;
                if (password != null && !password.trim().isEmpty()) {
                    updateHashedPassword = PasswordUtils.hashPassword(password);
                } else {
                    updateHashedPassword = existingUser.getPassword(); // Keep existing hashed password
                }

                try {
                    if (!dao.update(id, username, updateHashedPassword, role)) {
                        errorMessage = "Failed to update user. Please try again.";
                    } else {
                        successMessage = "User '" + username + "' updated successfully!";
                    }
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
                break;



            case "delete":
                int userId = Integer.parseInt(req.getParameter("id"));
                User userToDelete = dao.getById(userId);
                String deletedUsername = userToDelete != null ? userToDelete.getUsername() : "User";

                if (!dao.delete(userId)) {
                    errorMessage = "Failed to delete user. Please try again.";
                } else {
                    successMessage = "User '" + deletedUsername + "' deleted successfully!";
                }
                break;

            default:
                res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                return;
        }

        List<User> users;
        try {
            users = dao.getAll();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        req.setAttribute("users", users);

        if (errorMessage != null) {
            req.setAttribute("errorMessage", errorMessage);
        }
        if (successMessage != null) {
            req.setAttribute("successMessage", successMessage);
        }

        RequestDispatcher dispatcher = req.getRequestDispatcher("/manageUser.jsp");
        dispatcher.forward(req, res);
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        UserDAO dao = new UserDAO();
        List<User> users;
        try {
            users = dao.getAll();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        req.setAttribute("users", users);
        RequestDispatcher dispatcher = req.getRequestDispatcher("/manageUser.jsp");
        dispatcher.forward(req, res);
    }

    private boolean isDuplicateUsername(String username, int currentUserId, UserDAO dao) throws SQLException {
        List<User> allUsers = dao.getAll();

        for (User user : allUsers) {
            if (user.getUserId() == currentUserId) continue;
            if (user.getUsername().equalsIgnoreCase(username)) return true;
        }

        return false;
    }
}
