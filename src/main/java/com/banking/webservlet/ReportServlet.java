package com.banking.webservlet;

import com.banking.service.AccountService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Map;

/**
 * Servlet to handle banking reports
 */
@WebServlet("/reports/*")
public class ReportServlet extends HttpServlet {
    private final AccountService reportService = new AccountService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // Fetch reports from service
            Map<String, Object> accountSummary = reportService.getAccountSummary();
            Map<String, Object> dailyTransactions = reportService.getDailyTransactions();
            Map<String, Object> accountActivity = reportService.getAccountActivity();

            // Pass reports to JSP
            req.setAttribute("accountSummary", accountSummary);
            req.setAttribute("dailyTransactions", dailyTransactions);
            req.setAttribute("accountActivity", accountActivity);

            // Forward to reports.jsp
            req.getRequestDispatcher("/WEB-INF/views/reports/generate_reports.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Error retrieving reports", e);
        }
    }
}

