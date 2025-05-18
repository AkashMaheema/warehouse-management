package servlets;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import java.sql.SQLException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dao.ReportDAO;
import models.ReportCriteria;

@WebServlet("/ReportServlet")
public class ReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ReportDAO reportDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        reportDAO = new ReportDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("generate".equals(action)) {
            try {
                ReportCriteria criteria = new ReportCriteria();
                criteria.setReportType(request.getParameter("reportType"));

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                criteria.setStartDate(sdf.parse(request.getParameter("startDate")));
                criteria.setEndDate(sdf.parse(request.getParameter("endDate")));

                if (request.getParameter("categoryId") != null && !request.getParameter("categoryId").isEmpty()) {
                    criteria.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
                }

                if (request.getParameter("productId") != null && !request.getParameter("productId").isEmpty()) {
                    criteria.setProductId(Integer.parseInt(request.getParameter("productId")));
                }

                List<Object[]> reportData = null;
                String reportTitle = "";

                if ("inventory".equals(criteria.getReportType())) {
                    reportData = reportDAO.generateInventoryReport(criteria);
                    reportTitle = "Inventory Report";
                } else if ("stockMovement".equals(criteria.getReportType())) {
                    reportData = reportDAO.generateStockMovementReport(criteria);
                    reportTitle = "Stock Movement Report";
                }

                request.setAttribute("reportData", reportData);
                request.setAttribute("reportTitle", reportTitle);
                request.setAttribute("startDate", request.getParameter("startDate"));
                request.setAttribute("endDate", request.getParameter("endDate"));

                request.getRequestDispatcher("reports.jsp").forward(request, response);

            } catch (ParseException | NumberFormatException | SQLException e) {
                e.printStackTrace();
                request.setAttribute("error", "Error generating report: " + e.getMessage());
                request.getRequestDispatcher("reports.jsp").forward(request, response);
            }
        } else if ("export".equals(action)) {
            // Handle export to CSV or Excel
            // This would be similar to the generate action but would write directly to response output stream
        }
    }
}