package com.banking.webservlet;

import com.banking.exception.BankingException;
import com.banking.exception.InsufficientFundsException;
import com.banking.model.AccountDTO;
import com.banking.model.AccountType;
import com.banking.service.AccountService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet to handle account operations
 */
@WebServlet("/accounts/*")
public class AccountServlet extends HttpServlet {
    private final AccountService accountService = new AccountService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo(); // Get URL path after /accounts/

        if (pathInfo == null || pathInfo.equals("/")) {
            // Show all accounts
            req.getRequestDispatcher("/WEB-INF/views/accounts/list.jsp").forward(req, resp);
        } else if (pathInfo.equals("/deposit.jsp")) {
            // Show deposit.jsp
            req.getRequestDispatcher("/WEB-INF/views/accounts/deposit.jsp").forward(req, resp);
        } else if (pathInfo.equals("/withdraw.jsp")) {
            // Show withdraw.jsp
            req.getRequestDispatcher("/WEB-INF/views/accounts/withdraw.jsp").forward(req, resp);
        } else if (pathInfo.equals("/list.jsp")) {
            try {
                List<AccountDTO> accountList = accountService.displayAllAccounts();
                req.setAttribute("accounts", accountList);
                // Show list.jsp
                req.getRequestDispatcher("/WEB-INF/views/accounts/list.jsp").forward(req, resp);
            } catch (SQLException e) {
                throw new ServletException("Error retrieving accounts", e);
            }
        } else if (pathInfo.startsWith("/transfer.jsp")) {
            // Show withdraw.jsp
            req.getRequestDispatcher("/WEB-INF/views/accounts/transfer.jsp").forward(req, resp);
        } else {
            // Invalid path -> Send 404 error
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Page not found");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String action = request.getParameter("action");

        // 🛠️ Fix: Check if it's a processFees request BEFORE reading accountType!
        if ("processFees".equals(action)) {
            try {
                accountService.processMonthlyFees(); // Calls your method to process fees
                response.sendRedirect(request.getContextPath() + "/index.jsp?success=true&message=Monthly fees processed successfully");
            } catch (InsufficientFundsException e) {
                // 🛠️ Handle InsufficientFundsException and show error on index.jsp
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            } catch (Exception e) {
                // 🛠️ Catch any unexpected exceptions and prevent app crash
                request.setAttribute("error", "An unexpected error occurred: " + e.getMessage());
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            }
            return; // Exit method to prevent further execution
        }

        if (pathInfo == null || pathInfo.equals("/")) {
            // Create a new account from index.jsp
            String accountId;
            String accountTypeStr = request.getParameter("accountType");
            String initialBalanceStr = request.getParameter("initialBalance");

            try {
                AccountType accountType = AccountType.valueOf(accountTypeStr);
                BigDecimal initialBalance = new BigDecimal(initialBalanceStr);

                // Auto-generate account number
                String accountNumber;
                if (accountType == AccountType.SAVINGS) {
                    accountId = "SAV" + (System.currentTimeMillis() % 10000);
                } else if (accountType == AccountType.CHECKING) {
                    accountId = "CHK" + (System.currentTimeMillis() % 10000);
                } else {
                    throw new IllegalArgumentException("Invalid account type selected.");
                }

                // Create Account
                accountService.createAccount(accountType, accountId, initialBalance);

                // Redirect back to index.jsp with success message
                response.sendRedirect(request.getContextPath() + "/index.jsp?success=true&accountNumber=" + accountId);


            } catch (IllegalArgumentException | BankingException e) {
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            }
        } else if (pathInfo.startsWith("/deposit")) {
            System.out.println("DEBUG: Deposit request received");

            String accountId = request.getParameter("accountId");
            String amountStr = request.getParameter("amount");

            System.out.println("DEBUG: accountId = " + accountId);
            System.out.println("DEBUG: amount = " + amountStr);

            try {
                if (accountId == null || amountStr == null) {
                    throw new IllegalArgumentException("Account ID and Amount are required!");
                }

                BigDecimal amount = new BigDecimal(amountStr);
                accountService.deposit(accountId, amount);

                response.sendRedirect(request.getContextPath() + "/accounts/deposit.jsp?success=true");
            } catch (IllegalArgumentException | BankingException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/accounts/deposit.jsp?accountId=" + accountId + "&error=" + e.getMessage());
            }
        } else if (pathInfo.startsWith("/withdraw")) {
            // Handle withdrawal
            String accountId = request.getParameter("accountId");
            String amountStr = request.getParameter("amount");

            try {
                BigDecimal amount = new BigDecimal(amountStr);
                accountService.withdraw(accountId, amount);

                response.sendRedirect(request.getContextPath() + "/accounts/withdraw.jsp?success=true");
            } catch (IllegalArgumentException | BankingException e) {
                response.sendRedirect(request.getContextPath() + "/accounts/withdraw.jsp?error=" + e.getMessage());
            }
        } else if (pathInfo.equals("/transfer")) {
            // Handle money transfer
            String fromAccountId = request.getParameter("fromAccountId");
            String toAccountId = request.getParameter("toAccountId");
            String amountStr = request.getParameter("amount");

            try {
                BigDecimal amount = new BigDecimal(amountStr);
                accountService.transfer(fromAccountId, toAccountId, amount);

                response.sendRedirect(request.getContextPath() + "/accounts/transfer.jsp?success=true");
            } catch (IllegalArgumentException | BankingException e) {
                response.sendRedirect(request.getContextPath() + "/accounts/transfer.jsp?error=" + e.getMessage());
            }
        }
    }
}
