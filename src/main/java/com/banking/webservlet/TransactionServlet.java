package com.banking.webservlet;

import com.banking.util.TransactionLogger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Servlet to display all transactions
 */
@WebServlet("/transactions/*")
public class TransactionServlet extends HttpServlet {
    private final TransactionLogger transactionService = new TransactionLogger();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String accountId = req.getParameter("accountId");
        List<String> transactions;

        if (accountId != null && !accountId.isEmpty()) {
            // If accountId is provided, fetch transactions for that account
            transactions = transactionService.readTransactionHistory(accountId);
        } else {
            // Otherwise, fetch all transactions
            transactions = transactionService.readTransactionHistory();
        }

        req.setAttribute("transactions", transactions);
        req.getRequestDispatcher("/WEB-INF/views/transactions/transactions.jsp").forward(req, resp);
    }
}
