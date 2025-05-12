package com.warehouse.controllers;

import com.warehouse.dao.ASNDAO;
import com.warehouse.dao.ProductDAO;
import com.warehouse.dao.SupplierDAO;
import com.warehouse.dao.WeightDAO;
import com.warehouse.models.ASN;
import com.warehouse.models.ASNItem;
import com.warehouse.models.Product;
import com.warehouse.models.Supplier;
import com.warehouse.models.Weight;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.net.URLEncoder;


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

            List<ASN> asnList = asnDao.getAllASNs();
            List<Product> products = productDao.getAll();
            List<Supplier> suppliers = supplierDao.getAll();
            List<Weight> weights = weightDao.getAll();

            request.setAttribute("asnList", asnList);
            request.setAttribute("products", products);
            request.setAttribute("suppliers", suppliers);
            request.setAttribute("weights", weights);

            request.getRequestDispatcher("asn_management.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Failed to load ASN list: " + e.getMessage(), e);
        }
    }

    private void viewASNDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int asnId = Integer.parseInt(request.getParameter("asnId"));
            ASNDAO asnDao = new ASNDAO();
            ASN asn = asnDao.getASNById(asnId);

            if (asn == null) {
                throw new ServletException("ASN not found");
            }

            request.setAttribute("asn", asn);
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

            html.append("<h5 class='mt-4'>Items</h5>");
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

            response.setContentType("text/html");
            response.getWriter().write(html.toString());
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request: " + e.getMessage());
        }
    }

    private void createASN(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            String referenceNumber = request.getParameter("referenceNumber");
            Date expectedArrivalDate = dateFormat.parse(request.getParameter("expectedArrivalDate"));

            ASN asn = new ASN();
            asn.setSupplierId(supplierId);
            asn.setReferenceNumber(referenceNumber);
            asn.setExpectedArrivalDate(expectedArrivalDate);
            asn.setStatus("PENDING");

            List<ASNItem> items = new ArrayList<>();
            String[] productIds = request.getParameterValues("productId");
            String[] weightIds = request.getParameterValues("weightId");
            String[] quantities = request.getParameterValues("quantity");

            if (productIds == null || productIds.length == 0) {
                throw new ServletException("At least one item is required");
            }

            for (int i = 0; i < productIds.length; i++) {
                ASNItem item = new ASNItem();
                item.setProductId(Integer.parseInt(productIds[i]));
                item.setWeightId(Integer.parseInt(weightIds[i]));
                item.setExpectedQuantity(Integer.parseInt(quantities[i]));
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
        } catch (ParseException e) {
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
            int asnId = Integer.parseInt(request.getParameter("asnId"));
            int supplierId = Integer.parseInt(request.getParameter("supplierId"));
            String referenceNumber = request.getParameter("referenceNumber");
            Date expectedArrivalDate = dateFormat.parse(request.getParameter("expectedArrivalDate"));

            ASN asn = new ASN();
            asn.setAsnId(asnId);
            asn.setSupplierId(supplierId);
            asn.setReferenceNumber(referenceNumber);
            asn.setExpectedArrivalDate(expectedArrivalDate);

            List<ASNItem> items = new ArrayList<>();

            // Parse items from request
            int index = 0;
            while (request.getParameter("items[" + index + "].productId") != null) {
                ASNItem item = new ASNItem();
                item.setAsnItemId(Integer.parseInt(request.getParameter("items[" + index + "].asnItemId")));
                item.setProductId(Integer.parseInt(request.getParameter("items[" + index + "].productId")));
                item.setWeightId(Integer.parseInt(request.getParameter("items[" + index + "].weightId")));
                item.setExpectedQuantity(Integer.parseInt(request.getParameter("items[" + index + "].expectedQuantity")));
                items.add(item);
                index++;
            }

            ASNDAO asnDao = new ASNDAO();
            boolean success = asnDao.updateASNWithItems(asn, items);

            if (success) {
                // Get updated ASN data to return
                ASN updatedASN = asnDao.getASNById(asnId);
                SupplierDAO supplierDao = new SupplierDAO();
                Supplier supplier = supplierDao.getSupplierById(updatedASN.getSupplierId());

                // Prepare response data
                StringBuilder responseData = new StringBuilder();
                responseData.append("asnId=").append(updatedASN.getAsnId())
                        .append("&status=").append(updatedASN.getStatus())
                        .append("&supplierName=").append(supplier != null ? URLEncoder.encode(supplier.getName(), "UTF-8") : "N/A")
                        .append("&referenceNumber=").append(URLEncoder.encode(updatedASN.getReferenceNumber(), "UTF-8"))
                        .append("&expectedArrivalDate=").append(dateFormat.format(updatedASN.getExpectedArrivalDate()));

                // Add items data
                for (ASNItem item : updatedASN.getItems()) {
                    responseData.append("&items=").append(URLEncoder.encode(
                            (item.getProduct() != null ? item.getProduct().getProductName() : "N/A") + "," +
                                    (item.getWeight() != null ? item.getWeight().getWeightValue() : "N/A") + "," +
                                    item.getExpectedQuantity(), "UTF-8"));
                }

                response.setContentType("text/plain");
                response.getWriter().write(responseData.toString());
            } else {
                throw new ServletException("Failed to update ASN");
            }
        } catch (ParseException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid date format");
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update ASN: " + e.getMessage());
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
}