package com.warehouse.controllers;

import com.warehouse.dao.*;
import com.warehouse.models.*;
import com.warehouse.config.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;

import java.util.List;
import java.net.URLEncoder;
import java.sql.Date;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.Set;
import java.util.HashSet;






@WebServlet("/ASNManagement")
public class ASNManagementServlet extends HttpServlet {

    private SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("getASNDetails".equals(action)) {
                getASNDetails(request, response);
            } else if ("view".equals(action)) {
                viewASNDetails(request, response);
            } else {
                listASNs(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("create".equals(action)) {
                createASN(request, response);
            } else if ("approve".equals(action)) {
                approveASN(request, response);
            } else if ("reject".equals(action)) {
                rejectASN(request, response);
            } else if ("update".equals(action)) {
                updateASN(request, response);
            } else if ("deleteItem".equals(action)) {
                deleteASNItem(request, response);
            }else if ("sendToStock".equals(action)) {
                sendToStock(request, response);
            } else {
                response.sendRedirect("ASNManagement?action=list");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error processing request: " + e.getMessage());
            response.sendRedirect("ASNManagement?action=list");
        }
    }

    private void listASNs(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            ASNDAO asnDao = new ASNDAO();
            ProductDAO productDao = new ProductDAO();
            SupplierDAO supplierDao = new SupplierDAO();
            WeightDAO weightDao = new WeightDAO();
            CategoryDAO categoryDAO = new CategoryDAO();

            List<ASN> asnList = asnDao.getAllASNs();
            List<Product> products = productDao.getAll();
            List<Supplier> suppliers = supplierDao.getAll();
            List<Weight> weights = weightDao.getAll();
            List<Category> categories = categoryDAO.getAll();


            request.setAttribute("asnList", asnList);
            request.setAttribute("products", products);
            request.setAttribute("suppliers", suppliers);
            request.setAttribute("weights", weights);
            request.setAttribute("categoryList", categories);

            request.getRequestDispatcher("asn_management.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Failed to load ASN list: " + e.getMessage(), e);
        }
    }

    private void viewASNDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Initialize DAOs
            ProductDAO productDAO = new ProductDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            WeightDAO weightDAO = new WeightDAO();
            SupplierDAO supplierDAO = new SupplierDAO();

            // Fetch lists of products, categories, weights, and suppliers
            List<Product> products = productDAO.getAll();
            List<Category> categories = categoryDAO.getAll();
            List<Weight> weights = weightDAO.getAll();
            List<Supplier> suppliers = supplierDAO.getAll();

            request.setAttribute("productList", products);
            request.setAttribute("categoryList", categories);
            request.setAttribute("weightList", weights);
            request.setAttribute("supplierList", suppliers);

            // Get ASN ID from request parameters
            int asnId = Integer.parseInt(request.getParameter("asnId"));

            ASNDAO asnDao = new ASNDAO();
            ASN asn = asnDao.getASNById(asnId);

            if (asn == null) {
                throw new ServletException("ASN not found");
            }

            // Get incident items for this ASN
            List<IncidentItem> incidentItems = asnDao.getIncidentItems(asnId);
            request.setAttribute("incidentItems", incidentItems);

            // Set ASN details
            request.setAttribute("asn", asn);

            // Forward to the JSP page
            request.getRequestDispatcher("asn_details.jsp").forward(request, response);

        } catch (Exception e) {
            throw new ServletException("Failed to view ASN details: " + e.getMessage(), e);
        }
    }


    private void getASNDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int asnId = Integer.parseInt(request.getParameter("asnId"));
            ASNDAO asnDao = new ASNDAO();
            ASN asn = asnDao.getASNById(asnId);

            if (asn == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "ASN not found");
                return;
            }

            // Get incident items if they exist
            List<IncidentItem> incidentItems = asnDao.getIncidentItems(asnId);

            StringBuilder html = new StringBuilder();
            html.append("<div class='row'>");
            html.append("<div class='col-md-6'><strong>ASN ID:</strong> ASN-").append(asn.getAsnId()).append("</div>");
            html.append("<div class='col-md-6'><strong>Status:</strong> <span class='status-").append(asn.getStatus().toLowerCase())
                    .append("'>").append(asn.getStatus()).append("</span></div>");
            html.append("</div>");

            html.append("<div class='row mt-3'>");
            html.append("<div class='col-md-6'><strong>Supplier:</strong> ").append(asn.getSupplier() != null ? asn.getSupplier().getName() : "N/A").append("</div>");
            html.append("<div class='col-md-6'><strong>Reference:</strong> ").append(asn.getReferenceNumber()).append("</div>");
            html.append("</div>");

            html.append("<div class='row mt-3'>");
            html.append("<div class='col-md-6'><strong>Expected Arrival:</strong> ").append(dateFormat.format(asn.getExpectedArrivalDate())).append("</div>");
            html.append("<div class='col-md-6'><strong>Created Date:</strong> ").append(dateFormat.format(asn.getCreatedAt())).append("</div>");
            html.append("</div>");

            // ASN Items Table
            html.append("<h5 class='mt-4'>ASN Items</h5>");
            html.append("<table class='table table-bordered'>");
            html.append("<thead><tr><th>Product</th><th>Weight</th><th>Quantity</th></tr></thead>");
            html.append("<tbody>");

            for (ASNItem item : asn.getItems()) {
                html.append("<tr>");
                html.append("<td>").append(item.getProduct() != null ? item.getProduct().getProductName() : "N/A").append("</td>");
                html.append("<td>").append(item.getWeight() != null ? item.getWeight().getWeightValue() : "N/A").append(" Kg</td>");
                html.append("<td>").append(item.getExpectedQuantity()).append("</td>");
                html.append("</tr>");
            }

            html.append("</tbody></table>");

            // Incident Report (only if there are incidents)
            if (incidentItems != null && !incidentItems.isEmpty()) {
                html.append("<div class='card border-danger mt-4'>");
                html.append("<div class='card-header bg-danger text-white'>");
                html.append("<h5 class='mb-0'>Incident Report (").append(incidentItems.size()).append(")</h5>");
                html.append("</div>");
                html.append("<div class='card-body p-0'>");
                html.append("<table class='table table-hover mb-0'>");
                html.append("<thead class='table-light'><tr>");
                html.append("<th>Product</th><th>Type</th><th>Qty Affected</th><th>Remaining</th>");
                html.append("</tr></thead><tbody>");

                for (IncidentItem incident : incidentItems) {
                    html.append("<tr class='").append(incident.getIncidentType().equals("damaged") ? "table-danger" : "table-warning").append("'>");
                    html.append("<td>").append(incident.getAsnItem().getProduct().getProductName()).append("</td>");
                    html.append("<td>");
                    html.append("<span class='badge ").append(incident.getIncidentType().equals("damaged") ? "bg-danger" : "bg-warning").append("'>");
                    html.append(incident.getIncidentType().substring(0, 1).toUpperCase())
                            .append(incident.getIncidentType().substring(1).toLowerCase());
                    html.append("</span></td>");
                    html.append("<td>").append(incident.getIncidentQuantity()).append("</td>");
                    html.append("<td>").append(incident.getAsnItem().getExpectedQuantity()).append("</td>");
                    html.append("</tr>");
                }

                html.append("</tbody></table>");
                html.append("</div>"); // card-body
                html.append("<div class='card-footer bg-light'>");
                html.append("<small class='text-muted'>");
                html.append("<i class='fas fa-info-circle me-1'></i>");
                html.append("Damaged items marked in red, missing items in yellow");
                html.append("</small>");
                html.append("</div>"); // card-footer
                html.append("</div>"); // card
            }

            response.setContentType("text/html");
            response.getWriter().write(html.toString());
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void createASN(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            String referenceNumber = request.getParameter("referenceNumber");
            Date expectedArrivalDate = Date.valueOf(request.getParameter("expectedArrivalDate"));
//            Date expiryDate = dateFormat.parse(request.getParameter("expiryDate"));
//            int categoryId = Integer.parseInt(request.getParameter("categoryId"));

            ASN asn = new ASN();
            asn.setSupplierId(supplierId);
            asn.setReferenceNumber(referenceNumber);
            asn.setExpectedArrivalDate(expectedArrivalDate);
            asn.setStatus("PENDING");

            List<ASNItem> items = new ArrayList<>();
            String[] productIds = request.getParameterValues("productId");
            String[] weightIds = request.getParameterValues("weightId");
            String[] quantities = request.getParameterValues("quantity");
            String[] categoryIds = request.getParameterValues("categoryId");
            String[] expiry_dates = request.getParameterValues("expiryDate");

            if (productIds == null || productIds.length == 0) {
                throw new ServletException("At least one item is required");
            }

            for (int i = 0; i < productIds.length; i++) {
                ASNItem item = new ASNItem();
                item.setProductId(Integer.parseInt(productIds[i]));
                item.setWeightId(Integer.parseInt(weightIds[i]));
                item.setExpectedQuantity(Integer.parseInt(quantities[i]));
                item.setCategoryId(Integer.parseInt(categoryIds[i]));
                item.setExpiryDate(Date.valueOf(expiry_dates[i]));
                items.add(item);
            }

            ASNDAO asnDao = new ASNDAO();
            boolean success = asnDao.createASNWithItems(asn, items);

            if (success) {
                request.getSession().setAttribute("successMessage", "ASN created successfully");
            } else {
                throw new ServletException("Failed to create ASN");
            }

            response.sendRedirect("ASNManagement?action=list");
        } catch (IllegalArgumentException e) {
            request.getSession().setAttribute("errorMessage", "Invalid date format. Please use YYYY-MM-DD");
            response.sendRedirect("ASNManagement?action=list");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Failed to create ASN: " + e.getMessage());
            response.sendRedirect("ASNManagement?action=list");
        }
    }

    private void approveASN(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int asnId = Integer.parseInt(request.getParameter("asnId"));
            ASNDAO asnDao = new ASNDAO();
            ASN asn = asnDao.getASNById(asnId);

            if (asn == null) {
                throw new ServletException("ASN not found");
            }

            SupplierDAO supplierDao = new SupplierDAO();
            Supplier supplier = supplierDao.getSupplierById(asn.getSupplierId());
            if (supplier == null) {
                request.getSession().setAttribute("errorMessage", "Supplier does not exist. Please create supplier first.");
                response.sendRedirect("ASNManagement?action=list");
                return;
            }

            boolean success = asnDao.approveASN(asnId);

            if (success) {
                request.getSession().setAttribute("successMessage", "ASN approved successfully");
            } else {
                throw new ServletException("Failed to approve ASN");
            }

            response.sendRedirect("ASNManagement?action=list");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Failed to approve ASN: " + e.getMessage());
            response.sendRedirect("ASNManagement?action=list");
        }
    }

    private void rejectASN(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int asnId = Integer.parseInt(request.getParameter("asnId"));
            ASNDAO asnDao = new ASNDAO();

            boolean success = asnDao.rejectASN(asnId);

            if (success) {
                request.getSession().setAttribute("successMessage", "ASN rejected successfully");
            } else {
                throw new ServletException("Failed to reject ASN");
            }

            response.sendRedirect("ASNManagement?action=list");
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Failed to reject ASN: " + e.getMessage());
            response.sendRedirect("ASNManagement?action=list");
        }
    }

    private void updateASN(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Parse basic ASN data
            int asnId = Integer.parseInt(request.getParameter("asnId"));
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            String referenceNumber = request.getParameter("referenceNumber");
            Date expectedArrivalDate = Date.valueOf(request.getParameter("expectedArrivalDate"));

            ASN asn = new ASN();
            asn.setAsnId(asnId);
            asn.setSupplierId(supplierId);
            asn.setReferenceNumber(referenceNumber);
            asn.setExpectedArrivalDate(expectedArrivalDate);

            List<ASNItem> items = new ArrayList<>();
            List<IncidentItem> incidents = new ArrayList<>();

            // Handle ASN items
            String[] asnItemIds = request.getParameterValues("items[].asnItemId");
            if (asnItemIds != null) {
                for (int i = 0; i < asnItemIds.length; i++) {
                    ASNItem item = new ASNItem();
                    item.setAsnItemId(Integer.parseInt(asnItemIds[i]));
                    item.setProductId(Integer.parseInt(request.getParameterValues("items[].productId")[i]));
                    item.setWeightId(Integer.parseInt(request.getParameterValues("items[].weightId")[i]));
                    item.setExpectedQuantity(Integer.parseInt(request.getParameterValues("items[].expectedQuantity")[i]));
                    item.setCategoryId(Integer.parseInt(request.getParameterValues("items[].categoryId")[i]));
                    item.setExpiryDate(Date.valueOf(request.getParameterValues("items[].expiryDate")[i]));
                    items.add(item);
                }
            }

            // Handle incident items
            String[] incidentAsnItemIds = request.getParameterValues("incidents[].asnItemId");
            if (incidentAsnItemIds != null) {
                for (int i = 0; i < incidentAsnItemIds.length; i++) {
                    IncidentItem incident = new IncidentItem();
                    incident.setAsnItemId(Integer.parseInt(incidentAsnItemIds[i]));
                    incident.setIncidentType(request.getParameterValues("incidents[].incidentType")[i]);
                    incident.setIncidentQuantity(Integer.parseInt(request.getParameterValues("incidents[].incidentQuantity")[i]));
                    incidents.add(incident);
                }
            }

            // Use DAO to update
            ASNDAO asnDao = new ASNDAO();
            boolean success = asnDao.updateASNWithItemsAndIncidents(asn, items, incidents);

            if (success) {
                response.setContentType("text/plain");
                response.getWriter().write("success");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update ASN");
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
    private void deleteASNItem(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int asnItemId = Integer.parseInt(request.getParameter("asnItemId"));
            ASNDAO asnDao = new ASNDAO();

            boolean success = asnDao.deleteASNItem(asnItemId);

            if (success) {
                response.setContentType("text/plain");
                response.getWriter().write("success");
            } else {
                throw new ServletException("Failed to delete ASN item");
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to delete ASN item: " + e.getMessage());
        }
    }

    private void sendToStock(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int asnId = Integer.parseInt(request.getParameter("asnId"));
            ASNDAO asnDao = new ASNDAO();
            StockInDAO stockInDao = new StockInDAO();

            // Get the ASN with its items
            ASN asn = asnDao.getASNById(asnId);

            if (asn == null) {
                throw new ServletException("ASN not found");
            }

            if (!"approved".equalsIgnoreCase(asn.getStatus())) {
                throw new ServletException("Only approved ASNs can be sent to stock");
            }

            // Start transaction
            Connection connection = DBConnection.getConnection();
            try {
                connection.setAutoCommit(false);

                // Create stock in record
                int stockInId = stockInDao.insertMainStock(asn.getSupplierId(),
                        new java.sql.Date(System.currentTimeMillis()),
                        "pending");

                if (stockInId <= 0) {
                    throw new SQLException("Failed to create stock in record");
                }

                // Process each ASN item
                for (ASNItem asnItem : asn.getItems()) {
                    // Use the current expected_quantity which already accounts for incidents
                    int quantityToStock = asnItem.getExpectedQuantity();

                    if (quantityToStock > 0) {
                        // Insert stock item
                        int stockItemId = stockInDao.insertStockItem(stockInId,
                                asnItem.getProductId(),
                                quantityToStock,
                                asnItem.getExpiryDate());

                        if (stockItemId <= 0) {
                            throw new SQLException("Failed to create stock item");
                        }

                        // Insert space management record (with default location)
                        boolean spaceAdded = stockInDao.insertStockManage(stockItemId,
                                1, // Default zone ID
                                1, // Default rack ID
                                quantityToStock,
                                asnItem.getWeightId());

                        if (!spaceAdded) {
                            throw new SQLException("Failed to allocate space for stock item");
                        }
                    }
                }

                // Mark ASN as completed
                if (!asnDao.completeASN(asnId)) {
                    throw new SQLException("Failed to update ASN status");
                }

                // Commit transaction
                connection.commit();

                request.getSession().setAttribute("successMessage", "ASN items successfully sent to stock");
                response.sendRedirect("ASNManagement?action=list");

            } catch (SQLException e) {
                // Rollback on error
                if (connection != null) {
                    try {
                        connection.rollback();
                    } catch (SQLException ex) {
                        // Log rollback error
                    }
                }
                throw new ServletException("Failed to process ASN: " + e.getMessage(), e);
            } finally {
                if (connection != null) {
                    try {
                        connection.setAutoCommit(true);
                        connection.close();
                    } catch (SQLException e) {
                        // Log close error
                    }
                }
            }

        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error sending to stock: " + e.getMessage());
            response.sendRedirect("ASNManagement?action=list");
        }
    }


}