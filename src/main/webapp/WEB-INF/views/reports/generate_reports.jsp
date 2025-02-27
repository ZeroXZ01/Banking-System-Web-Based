<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Financial Reports | Secure Banking Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/styles.css">
    <style>
        :root {
            --primary: #1e88e5;
            --primary-header: #00529B;
            --primary-dark: #1565c0;
            --secondary: #00acc1;
            --secondary-header: #0072CE;
            --success: #43a047;
            --danger: #e53935;
            --warning: #ffb300;
            --light: #f5f5f5;

            --dark: #1A2439;
            --gray-dark: #424242;
            --gray: #757575;
            --gray-light: #bdbdbd;
            --accent: #F2A900;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif;
            background-color: #f0f2f5;
            color: var(--dark);
            line-height: 1.6;
        }

        .page-wrapper {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .header {
            background: linear-gradient(120deg, var(--primary-header), var(--secondary-header));
            color: white;
            padding: 1rem 0;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .header-content {
            display: flex;
            align-items: center;
            justify-content: space-between;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1.5rem;
        }

        .logo {
            font-size: 1.8rem;
            font-weight: 700;
            display: flex;
            align-items: center;
        }

        .logo i {
            margin-right: 0.5rem;
            color: var(--warning);
        }

        .main-content {
            flex: 1;
            max-width: 1000px;
            margin: 2rem auto;
            padding: 0 1.5rem;
        }

        .page-title {
            text-align: center;
            margin-bottom: 2rem;
            color: var(--primary-dark);
            font-weight: 600;
            font-size: 2rem;
            position: relative;
            padding-bottom: 0.75rem;
        }

        .page-title:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 4px;
            background: linear-gradient(to right, var(--primary), var(--secondary));
            border-radius: 2px;
        }

        .reports-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .report-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .report-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.1);
        }

        .report-header {
            background: linear-gradient(120deg, var(--primary), var(--primary-dark));
            color: white;
            padding: 1rem 1.5rem;
            font-size: 1.2rem;
            font-weight: 600;
            display: flex;
            align-items: center;
        }

        .report-header i {
            margin-right: 0.75rem;
            font-size: 1.2em;
        }

        .report-body {
            padding: 1.5rem;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .data-table th,
        .data-table td {
            padding: 0.75rem 1rem;
            text-align: left;
            border-bottom: 1px solid var(--gray-light);
        }

        .data-table th {
            background-color: var(--light);
            color: var(--gray-dark);
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .data-table tr:last-child td {
            border-bottom: none;
        }

        .data-table td {
            font-weight: 500;
        }

        .data-highlight {
            color: var(--primary-dark);
            font-weight: 600;
        }

        .amount-positive {
            color: var(--success);
            font-weight: 600;
        }

        .amount-negative {
            color: var(--danger);
            font-weight: 600;
        }

        .btn {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            font-size: 1rem;
            font-weight: 500;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.2s, transform 0.1s;
            text-align: center;
            text-decoration: none;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        .btn:active {
            transform: translateY(0);
        }

        .btn-primary {
            background-color: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background-color: var(--primary-dark);
        }

        .btn-success {
            background-color: var(--success);
            color: white;
        }

        .btn-success:hover {
            background-color: #388e3c;
        }

        .btn i {
            margin-right: 0.5rem;
        }

        .btn-container {
            text-align: center;
            margin-top: 2rem;
        }

        /* Footer styles from transactions.jsp */
        footer {
            background-color: var(--dark);
            color: white;
            padding: 1rem 0;
            margin-top: auto;
            text-align: center;
            font-size: 0.85rem;
            width: 100%;
        }

        .footer-content {
            width: 90%;
            max-width: 1200px;
            margin: 0 auto;
        }

        .developer {
            font-weight: 500;
            color: var(--accent);
        }

        /* Animations */
        .fade-in {
            animation: fadeIn 0.5s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Media Queries */
        @media (max-width: 768px) {
            .reports-container {
                grid-template-columns: 1fr;
            }

            .header-content {
                flex-direction: column;
                text-align: center;
            }

            .logo {
                margin-bottom: 0.5rem;
            }
        }
    </style>
</head>

<body>
<%!
    // Properly formats currency with negative sign BEFORE dollar sign
    public String formatCurrency(Object value) {
        if (value == null) return "N/A";
        try {
            double amount = Double.parseDouble(value.toString());
            DecimalFormat df = new DecimalFormat("#,##0.00");
            return (amount < 0 ? "-$" : "$") + df.format(Math.abs(amount));
        } catch (NumberFormatException e) {
            return "N/A";
        }
    }
%>

<div class="page-wrapper">
    <header class="header">
        <div class="header-content">
            <div class="logo">
                <i class="fas fa-landmark"></i>
                <span>Secure Banking Portal</span>
            </div>
            <div class="header-subtitle">Financial Reports Dashboard</div>
        </div>
    </header>

    <main class="main-content">
        <h1 class="page-title fade-in">Financial Insights & Analytics</h1>

        <div class="reports-container">
            <div class="report-card fade-in">
                <div class="report-header">
                    <i class="fas fa-university"></i>
                    Account Summary
                </div>
                <div class="report-body">
                    <table class="data-table">
                        <tr>
                            <th>Total Accounts</th>
                            <td class="data-highlight">
                                <i class="fas fa-users"></i>
                                <%= request.getAttribute("accountSummary") != null ? ((Map<String, Object>) request.getAttribute("accountSummary")).get("totalAccounts") : "N/A" %>
                            </td>
                        </tr>
                        <tr>
                            <th>Total Balance</th>
                            <td class="amount-positive">
                                <i class="fas fa-money-bill-wave"></i>
                                <%= formatCurrency(((Map<String, Object>) request.getAttribute("accountSummary")).get("totalBalance")) %>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>

            <div class="report-card fade-in">
                <div class="report-header">
                    <i class="fas fa-chart-bar"></i>
                    Daily Transactions
                </div>
                <div class="report-body">
                    <table class="data-table">
                        <tr>
                            <th>Total Deposits Today</th>
                            <td class="amount-positive">
                                <i class="fas fa-arrow-down"></i>
                                <%= formatCurrency(((Map<String, Object>) request.getAttribute("dailyTransactions")).get("totalDeposits")) %>
                            </td>
                        </tr>
                        <tr>
                            <th>Total Withdrawals Today</th>
                            <td class="amount-negative">
                                <i class="fas fa-arrow-up"></i>
                                <%= formatCurrency(((Map<String, Object>) request.getAttribute("dailyTransactions")).get("totalWithdrawals")) %>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>

            <div class="report-card fade-in">
                <div class="report-header">
                    <i class="fas fa-chart-line"></i>
                    Account Activity
                </div>
                <div class="report-body">
                    <table class="data-table">
                        <tr>
                            <th>Most Active Account</th>
                            <td class="data-highlight">
                                <i class="fas fa-bolt"></i>
                                <%= request.getAttribute("accountActivity") != null ? ((Map<String, Object>) request.getAttribute("accountActivity")).get("mostActiveAccount") : "N/A" %>
                            </td>
                        </tr>
                        <tr>
                            <th>Number of Transactions</th>
                            <td class="data-highlight">
                                <i class="fas fa-exchange-alt"></i>
                                <%= request.getAttribute("accountActivity") != null ? ((Map<String, Object>) request.getAttribute("accountActivity")).get("transactionCount") : "N/A" %>
                            </td>
                        </tr>
                        <tr>
                            <th>Highest Balance Account</th>
                            <td class="data-highlight">
                                <i class="fas fa-trophy"></i>
                                <%= request.getAttribute("accountActivity") != null ? ((Map<String, Object>) request.getAttribute("accountActivity")).get("highestBalanceAccount") : "N/A" %>
                            </td>
                        </tr>
                        <tr>
                            <th>Highest Balance</th>
                            <td class="amount-positive">
                                <i class="fas fa-gem"></i>
                                <%= formatCurrency(((Map<String, Object>) request.getAttribute("accountActivity")).get("highestBalance")) %>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>

        <div class="btn-container">
            <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-primary">
                <i class="fas fa-home"></i> Return to Dashboard
            </a>
        </div>
    </main>

    <footer class="footer">
        <div class="footer-content">
            <p>&copy; <%= java.time.Year.now() %> Secure Banking Portal. All rights reserved.</p>
            <p>Developed by <span class="developer">Rolando Cruz</span>. Special thanks to Joysis and Stratpoint for providing this learning opportunity.</p>
        </div>
    </footer>
</div>
</body>
</html>