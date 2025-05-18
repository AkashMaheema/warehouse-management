package com.warehouse.controllers;

import com.warehouse.dao.UserDAO;
import com.warehouse.models.User;
import com.warehouse.utils.SecurityUtils;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
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
                // Get parameters from the form
                String username = req.getParameter("username");
                String password = req.getParameter("password");
                String role = req.getParameter("role");

                // Validate username
                if (!SecurityUtils.isValidUsername(username)) {
                    errorMessage = "Invalid username. Username cannot be only numbers and must be 3-20 characters with only letters, numbers, underscores, or hyphens.";
                    break;
                }

                // Check for duplicate username (case-insensitive)
                if (isDuplicateUsername(username, -1, dao)) {
                    errorMessage = "Username '" + username + "' already exists. Please choose a different username.";
                    break;
                }

                // Add new user to database
                if (!dao.add(username, password, role)) {
                    errorMessage = "Failed to create user. Please try again.";
                } else {
                    successMessage = "User '" + username + "' created successfully!";
                }
                break;

            case "update":
                // Get parameters for update
                int id = Integer.parseInt(req.getParameter("id"));
                username = req.getParameter("username");
                password = req.getParameter("password");
                role = req.getParameter("role");

                // Validate username
                if (!SecurityUtils.isValidUsername(username)) {
                    errorMessage = "Invalid username. Username cannot be only numbers and must be 3-20 characters with only letters, numbers, underscores, or hyphens.";
                    break;
                }

                // Check for duplicate username (case-insensitive), excluding current user
                if (isDuplicateUsername(username, id, dao)) {
                    errorMessage = "Username '" + username + "' already exists. Please choose a different username.";
                    break;
                }

                // Update user in database
                if (!dao.update(id, username, password, role)) {
                    errorMessage = "Failed to update user. Please try again.";
                } else {
                    successMessage = "User '" + username + "' updated successfully!";
                }
                break;

            case "delete":
                // Get user info before deletion for the message
                int userId = Integer.parseInt(req.getParameter("id"));
                User userToDelete = dao.getById(userId);
                String deletedUsername = userToDelete != null ? userToDelete.getUsername() : "User";

                // Delete user from database
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

        // Get updated user list
        List<User> users = dao.getAll();
        req.setAttribute("users", users);

        // Set appropriate message attributes
        if (errorMessage != null) {
            req.setAttribute("errorMessage", errorMessage);
        }
        if (successMessage != null) {
            req.setAttribute("successMessage", successMessage);
        }

        // Forward to the JSP page to display messages
        RequestDispatcher dispatcher = req.getRequestDispatcher("/manageUser.jsp");
        dispatcher.forward(req, res);
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        UserDAO dao = new UserDAO();
        List<User> users = dao.getAll();

        req.setAttribute("users", users);

        // Forward the request to the JSP
        RequestDispatcher dispatcher = req.getRequestDispatcher("/manageUser.jsp");
        dispatcher.forward(req, res);
    }

    /**
     * Check if a username already exists (case-insensitive)
     *
     * @param username The username to check
     * @param currentUserId The ID of the current user (for updates, to exclude self)
     * @param dao The UserDAO instance
     * @return true if the username already exists, false otherwise
     */
    private boolean isDuplicateUsername(String username, int currentUserId, UserDAO dao) {
        List<User> allUsers = dao.getAll();

        for (User user : allUsers) {
            // Skip current user when updating (allows keeping same username)
            if (user.getUserId() == currentUserId) {
                continue;
            }

            // Case-insensitive comparison
            if (user.getUsername().equalsIgnoreCase(username)) {
                return true;
            }
        }

        return false;
    }
}