package com.warehouse.controllers;

import com.google.gson.Gson;
import com.warehouse.dao.CustomerDAO;
import com.warehouse.models.Customer;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.io.PrintWriter;

@WebServlet("/manageCustomer")
public class CustomerServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String action = req.getParameter("action");
        CustomerDAO dao = new CustomerDAO();

        switch (action) {
            case "create":
                try {
                    String name = req.getParameter("name");
                    String contactNumber = req.getParameter("contactNumber");
                    String email = req.getParameter("email");
                    String address = req.getParameter("address");

                    Customer customer = new Customer(name, contactNumber, email, address);
                    int customerId = dao.add(customer);

                    res.setContentType("application/json");
                    res.setCharacterEncoding("UTF-8");

                    PrintWriter out = res.getWriter();

                    if (customerId != -1) {
                        customer.setCustomerId(customerId);
                        Gson gson = new Gson();
                        String json = gson.toJson(customer);
                        out.write(json);
                    } else {
                        res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                        out.write("{\"error\": \"Failed to add customer\"}");
                    }

                    out.flush();
                    out.close();
                } catch (Exception e) {
                    e.printStackTrace();
                    res.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    res.getWriter().write("{\"error\": \"Server exception occurred\"}");
                }
                break;
            case "update":
                dao.update(
                        Integer.parseInt(req.getParameter("id")),
                        req.getParameter("name"),
                        req.getParameter("contactNumber"),
                        req.getParameter("email"),
                        req.getParameter("address")
                );
                break;
            case "delete":
                dao.delete(Integer.parseInt(req.getParameter("id")));
                break;
            default:
                res.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
                return;
        }

        res.sendRedirect(req.getContextPath() + "/manageCustomer");
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        CustomerDAO dao = new CustomerDAO();
        List<Customer> customers = dao.getAll();

        req.setAttribute("customers", customers);
        RequestDispatcher dispatcher = req.getRequestDispatcher("/manageCustomer.jsp");
        dispatcher.forward(req, res);
    }
}