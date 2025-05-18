<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="template/layout.jsp" %>

<div class="report-container">
    <h2>Generate Reports</h2>

    <form id="reportForm" method="post" action="GenerateReportServlet">
        <div class="form-group">
            <label for="reportType">Report Type:</label>
            <select id="reportType" name="reportType" required>
                <option value="">--Select--</option>
                <option value="inventory">Inventory Report</option>
                <option value="order">Order Report</option>
                <option value="stock">Stock Report</option>
            </select>
        </div>

        <div class="form-group">
            <label for="fromDate">From Date:</label>
            <input type="date" id="fromDate" name="fromDate" required>
        </div>

        <div class="form-group">
            <label for="toDate">To Date:</label>
            <input type="date" id="toDate" name="toDate" required>
        </div>

        <div class="form-actions">
            <button type="submit" name="action" value="view">View Report</button>
            <button type="submit" name="action" value="download">Download Report</button>
            <button type="button" onclick="window.print();">Print Report</button>
        </div>
    </form>

    <div id="reportResult">
        <%-- Placeholder where your backend servlet will inject the generated report content --%>
    </div>
</div>

<style>
.report-container {
    max-width: 800px;
    margin: 30px auto;
    background: #fff;
    padding: 30px;
    border-radius: 10px;

}
.report-container h2 {
    text-align: center;
    margin-bottom: 20px;
}
.form-group {
    margin-bottom: 15px;
}
label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
}
select, input[type="date"] {
    width: 100%;
    padding: 8px;
    box-sizing: border-box;
}
.form-actions {
    display: flex;
    justify-content: space-between;
    gap: 10px;
}
button {
    padding: 10px 20px;
    background-color: #0066cc;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}
button:hover {
    background-color: #004a99;
}
</style>
