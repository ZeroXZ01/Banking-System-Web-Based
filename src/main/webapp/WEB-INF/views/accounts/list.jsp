<%@ page import="java.util.List" %>
<%@ page import="com.banking.model.AccountDTO" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
    <title>All Accounts | SecureBank</title>
    <style>
        :root {
            --primary: #1a5276;
            --primary-header: #00529B;
            --primary-light: #2980b9;
            --secondary: #2ecc71;
            --secondary-header: #0072CE;
            --accent: #3498db;
            --accent-developer: #F2A900;
            --light-gray: #f8f9fa;
            --medium-gray: #e9ecef;
            --dark: #1A2439;
            --dark-gray: #495057;
            --danger: #e74c3c;
            --text-primary: #2c3e50;
            --text-secondary: #7f8c8d;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --radius: 8px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background-color: var(--light-gray);
            color: var(--text-primary);
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* Header styles from transactions.jsp */
        .header {
            background: linear-gradient(120deg, var(--primary-header), var(--secondary-header));
            color: white;
            padding: 1rem 0;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .header-content {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .bank-logo {
            font-size: 1.8rem;
            font-weight: 700;
            display: flex;
            align-items: center;
        }

        .bank-logo i {
            margin-right: 0.5rem;
            color: #ffb300;
        }

        .page-title {
            font-size: 28px;
            margin-bottom: 8px;
            color: white;
        }

        .breadcrumb {
            font-size: 14px;
            opacity: 0.8;
        }

        .breadcrumb a {
            color: white;
            text-decoration: none;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        .main-content {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto 30px;
            flex: 1;
        }

        .card {
            background: white;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 30px;
        }

        .card-header {
            background-color: var(--primary-light);
            color: white;
            padding: 15px 20px;
            font-size: 18px;
            font-weight: 600;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-body {
            padding: 20px;
        }

        .table-responsive {
            overflow-x: auto;
            width: 100%;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        th, td {
            padding: 14px;
            text-align: left;
            border-bottom: 1px solid var(--medium-gray);
        }

        th {
            background-color: var(--primary);
            color: white;
            font-weight: 600;
            position: sticky;
            top: 0;
        }

        tr:nth-child(even) {
            background-color: var(--light-gray);
        }

        tr:hover {
            background-color: rgba(46, 204, 113, 0.1);
        }

        .amount {
            font-weight: 600;
        }

        .negative {
            color: var(--danger);
        }

        .positive {
            color: var(--secondary);
        }

        .empty-state {
            padding: 30px;
            text-align: center;
            color: var(--text-secondary);
        }

        .empty-state-icon {
            font-size: 48px;
            margin-bottom: 10px;
            opacity: 0.5;
        }

        .button {
            display: inline-block;
            padding: 10px 20px;
            background-color: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: var(--radius);
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
        }

        .button:hover {
            background-color: var(--primary-light);
            transform: translateY(-2px);
        }

        .button.secondary {
            background-color: var(--secondary);
        }

        .button.secondary:hover {
            background-color: #27ae60;
        }

        .button .icon {
            margin-right: 8px;
        }

        .actions {
            margin-top: 20px;
            display: flex;
            gap: 15px;
        }

        /* Footer styles from transactions.jsp */
        footer {
            background-color: var(--dark);
            color: white;
            padding: 1rem 0;
            margin-top: auto;
            text-align: center;
            font-size: 0.85rem;
        }

        .footer-content {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
        }

        .developer {
            font-weight: 500;
            color: var(--accent-developer);
        }

        .account-type-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .account-type-checking {
            background-color: var(--primary-light);
            color: white;
        }

        .account-type-savings {
            background-color: var(--secondary);
            color: white;
        }

        .account-type-credit {
            background-color: #e67e22;
            color: white;
        }

        .account-summary {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        .summary-card {
            flex: 1;
            min-width: 200px;
            background-color: white;
            border-radius: var(--radius);
            padding: 15px;
            box-shadow: var(--shadow);
        }

        .summary-card-title {
            font-size: 14px;
            color: var(--text-secondary);
            margin-bottom: 8px;
        }

        .summary-card-value {
            font-size: 24px;
            font-weight: 600;
            color: var(--primary);
        }

        .summary-card-footer {
            margin-top: 10px;
            font-size: 12px;
            color: var(--text-secondary);
        }

        @media (max-width: 768px) {
            .header-content, .footer-content {
                flex-direction: column;
                text-align: center;
                gap: 10px;
            }

            .actions {
                flex-direction: column;
            }

            .button {
                width: 100%;
                text-align: center;
            }

            .account-summary {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<!-- Header from transactions.jsp -->
<header class="header">
    <div class="header-content">
        <div class="bank-logo">
            <i class="fas fa-landmark"></i>
            <span>Secure Banking Portal</span>
        </div>
        <div class="header-title">
            <h1 class="page-title">All Bank Accounts</h1>
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/index.jsp">Home</a> / All Accounts
            </div>
        </div>
    </div>
</header>

<main class="main-content">
    <%
        List<AccountDTO> accounts = (List<AccountDTO>) request.getAttribute("accounts");
        if (accounts != null && !accounts.isEmpty()) {
            // Calculate summary statistics
            int totalAccounts = accounts.size();
            BigDecimal totalBalance = BigDecimal.ZERO;
            int checkingCount = 0;
            int savingsCount = 0;

            for (AccountDTO account : accounts) {
                try {
//                    totalBalance += account.getBalance().doubleValue();
                    totalBalance =totalBalance.add(account.getBalance());

                    if ("CHECKING".equalsIgnoreCase(account.getAccount_type())) {
                        checkingCount++;
                    } else if ("SAVINGS".equalsIgnoreCase(account.getAccount_type())) {
                        savingsCount++;
                    }
                } catch (Exception e) {
                    // Handle any conversion errors
                }
            }
    %>

    <div class="account-summary">
        <div class="summary-card">
            <div class="summary-card-title">Total Accounts</div>
            <div class="summary-card-value"><%= totalAccounts %></div>
            <div class="summary-card-footer">Active accounts</div>
        </div>
        <div class="summary-card">
            <div class="summary-card-title">Total Balance</div>
            <div class="summary-card-value <%= totalBalance.compareTo(BigDecimal.ZERO) < 0 ? "negative" : "positive" %>">
                <%= totalBalance.compareTo(BigDecimal.ZERO) < 0 ? "-$" + totalBalance.abs(): "$" + totalBalance %>
            </div>
            <div class="summary-card-footer">Combined balance</div>
        </div>
        <div class="summary-card">
            <div class="summary-card-title">Account Types</div>
            <div class="summary-card-value">
                <%= checkingCount %> Checking | <%= savingsCount %> Savings
            </div>
            <div class="summary-card-footer">Distribution</div>
        </div>
    </div>

    <div class="card">
        <div class="card-header">
            <span>Account Details</span>
            <span id="current-date"></span>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table>
                    <thead>
                    <tr>
                        <th>Account ID</th>
                        <th>Account Type</th>
                        <th>Balance</th>
                        <th>Created At</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (AccountDTO account : accounts) {
                        String accountType = account.getAccount_type();
                        String badgeClass = "account-type-credit";

                        if ("CHECKING".equalsIgnoreCase(accountType)) {
                            badgeClass = "account-type-checking";
                        } else if ("SAVINGS".equalsIgnoreCase(accountType)) {
                            badgeClass = "account-type-savings";
                        }

                        boolean isNegative = account.getBalance().signum() == -1;
                    %>
                    <tr>
                        <td><%= account.getAccount_id() %></td>
                        <td>
                <span class="account-type-badge <%= badgeClass %>">
                  <%= accountType %>
                </span>
                        </td>
                        <td class="amount <%= isNegative ? "negative" : "positive" %>">
                            <%= isNegative ? "-$" + account.getBalance().abs() : "$" + account.getBalance() %>
                        </td>
                        <td><%= account.getTransaction_date() %></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/transactions?accountId=<%= account.getAccount_id() %>" class="button" style="padding: 5px 10px; font-size: 12px;">View Transactions</a>
                        </td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="actions">
        <a href="${pageContext.request.contextPath}/index.jsp" class="button"><span class="icon">←</span> Back to Dashboard</a>
        <a href="#" class="button secondary" id="exportBtn"><span class="icon">↓</span> Export Accounts</a>
    </div>

    <% } else { %>
    <div class="card">
        <div class="card-header">
            <span>Account Details</span>
        </div>
        <div class="card-body">
            <div class="empty-state">
                <div class="empty-state-icon">🏦</div>
                <h3>No Accounts Found</h3>
                <p>There are no bank accounts to display.</p>
            </div>
        </div>
    </div>

    <div class="actions">
        <a href="${pageContext.request.contextPath}/index.jsp" class="button"><span class="icon">←</span> Back to Dashboard</a>
    </div>
    <% } %>
</main>

<!-- Footer from transactions.jsp -->
<footer>
    <div class="footer-content">
        <p>&copy; <%= java.time.Year.now() %> Secure Banking Portal. All rights reserved.</p>
        <p>Developed by <span class="developer">Rolando Cruz</span>. Special thanks to Joysis and Stratpoint for providing this learning opportunity.</p>
    </div>
</footer>

<script>
    // Display current date
    document.getElementById('current-date').textContent = new Date().toLocaleDateString('en-US', {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    });

    // Add functionality to export button
    document.getElementById('exportBtn')?.addEventListener('click', function(e) {
        e.preventDefault();
        alert('Accounts would be exported here. This is a demo feature.');
    });
</script>

</body>
</html>