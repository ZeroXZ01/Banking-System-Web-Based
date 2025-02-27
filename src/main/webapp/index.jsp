<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <script>
        if (performance.navigation.type === 1) {
            // If the page is refreshed, redirect to index.jsp
            window.location.href = "index.jsp";
        }
    </script>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Online Banking Portal</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/styles.css">
    <style>
        :root {
            --primary: #00529B;
            --primary-dark: #003A70;
            --primary-light: #EBF4FA;
            --secondary: #0072CE;
            --accent: #F2A900;
            --success: #18844F;
            --danger: #D73F30;
            --warning: #FFC64D;
            --light: #F8F9FA;
            --dark: #1A2439;
            --gray-dark: #495057;
            --gray: #6C757D;
            --gray-light: #E9ECEF;
            --border-radius: 8px;
            --box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            --transition: all 0.3s ease;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif;
            background-color: #F8F9FA;
            color: var(--dark);
            line-height: 1.6;
        }

        .page-wrapper {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .header {
            background: linear-gradient(120deg, var(--primary), var(--secondary));
            color: white;
            padding: 1.25rem 0;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 1000;
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
            margin-right: 0.75rem;
            color: var(--accent);
            font-size: 2rem;
        }

        .header-subtitle {
            font-size: 1rem;
            font-weight: 500;
            color: rgba(255, 255, 255, 0.9);
            letter-spacing: 0.5px;
        }

        .main-content {
            flex: 1;
            max-width: 1200px;
            margin: 2.5rem auto;
            padding: 0 1.5rem;
        }

        .welcome-banner {
            background: linear-gradient(to right, var(--primary-light), #fff);
            border-left: 4px solid var(--primary);
            border-radius: var(--border-radius);
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--box-shadow);
        }

        .welcome-banner h1 {
            color: var(--primary);
            font-size: 1.6rem;
            margin-bottom: 0.5rem;
        }

        .welcome-banner p {
            color: var(--gray-dark);
            margin-bottom: 0;
        }

        .dashboard {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .dashboard-card {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            padding: 1.75rem;
            transition: var(--transition);
            border: 1px solid var(--gray-light);
        }

        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
        }

        .card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding-bottom: 1rem;
            border-bottom: 1px solid var(--gray-light);
            margin-bottom: 1.25rem;
        }

        .card-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--primary);
            display: flex;
            align-items: center;
        }

        .card-title i {
            margin-right: 0.75rem;
            font-size: 1.3em;
            color: var(--secondary);
            background: var(--primary-light);
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
        }

        .success-message {
            background-color: #E5F6EF;
            color: var(--success);
            border-left: 4px solid var(--success);
            padding: 1rem 1.5rem;
            margin-bottom: 1.5rem;
            border-radius: var(--border-radius);
            display: flex;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            opacity: 0;
            animation: fadeInOut 8s forwards; /* Increased from 5s to 8s */
        }

        @keyframes fadeInOut {
            0% {
                opacity: 0;
                transform: translateY(-10px);
            }
            10% {
                opacity: 1;
                transform: translateY(0);
            }
            95% { /* Keep message visible longer */
                opacity: 1;
                transform: translateY(0);
            }
            100% {
                opacity: 0;
                transform: translateY(-10px);
            }
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--gray-dark);
            font-size: 0.95rem;
        }

        input, select {
            width: 100%;
            padding: 0.85rem 1rem;
            border: 1px solid var(--gray-light);
            border-radius: var(--border-radius);
            font-size: 1rem;
            transition: var(--transition);
            margin-bottom: 1.25rem;
            box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.05);
        }

        input:focus, select:focus {
            border-color: var(--secondary);
            box-shadow: 0 0 0 3px rgba(0, 114, 206, 0.25);
            outline: none;
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        .btn {
            display: inline-block;
            padding: 0.85rem 1.5rem;
            font-size: 0.95rem;
            font-weight: 500;
            border: none;
            border-radius: var(--border-radius);
            cursor: pointer;
            transition: var(--transition);
            text-align: center;
            text-decoration: none;
            letter-spacing: 0.5px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
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
            background-color: #146A3E;
        }

        .btn-danger {
            background-color: var(--danger);
            color: white;
        }

        .btn-danger:hover {
            background-color: #B83425;
        }

        .btn-warning {
            background-color: var(--warning);
            color: var(--dark);
        }

        .btn-warning:hover {
            background-color: #F0B800;
        }

        .btn-block {
            display: block;
            width: 100%;
        }

        .btn-group {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(130px, 1fr));
            gap: 0.75rem;
            margin-top: 1rem;
        }

        .btn i {
            margin-right: 0.5rem;
        }

        .footer {
            background-color: var(--dark);
            color: white;
            padding: 2rem 0;
            text-align: center;
            font-size: 0.85rem;
            margin-top: auto;
        }

        .footer-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 1.5rem;
        }

        .footer-links {
            display: flex;
            justify-content: center;
            margin-bottom: 1rem;
        }

        .footer-links a {
            color: #CCD;
            margin: 0 1rem;
            text-decoration: none;
            transition: var(--transition);
        }

        .footer-links a:hover {
            color: white;
        }

        .developer {
            font-weight: 500;
            color: var(--accent);
        }

        /* Media Queries */
        @media (max-width: 992px) {
            .dashboard {
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

        /* Animations */
        .fade-in {
            animation: fadeIn 0.5s ease-in-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
<div class="page-wrapper">
    <header class="header">
        <div class="header-content">
            <div class="logo">
                <i class="fas fa-landmark"></i>
                <span>Secure Banking Portal</span>
            </div>
            <div class="header-subtitle">Your Trusted Financial Partner</div>
        </div>
    </header>

    <main class="main-content">
        <%-- Welcome banner --%>
        <div class="welcome-banner fade-in">
            <h1>Welcome to Your Banking Dashboard</h1>
            <p>Manage your accounts, make transactions, and access financial services securely.</p>
        </div>

            <%
                String successType = request.getParameter("success");
                String accountNumber = request.getParameter("accountNumber");
                String message = request.getParameter("message"); // For general success messages
                String errorMessage = (String) request.getAttribute("error"); // Error messages from servlet
            %>

            <%-- Success Message --%>
            <% if ("true".equals(successType) && accountNumber != null && !accountNumber.isEmpty()) { %>
            <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 5px; border: 1px solid #c3e6cb; margin-bottom: 15px;">
                <i class="fas fa-check-circle"></i>
                <strong>Success:</strong> Account <strong><%= accountNumber %></strong> has been created successfully!
            </div>
            <% } else if ("true".equals(successType) && message != null && !message.isEmpty()) { %>
            <div style="background-color: #d4edda; color: #155724; padding: 10px; border-radius: 5px; border: 1px solid #c3e6cb; margin-bottom: 15px;">
                <i class="fas fa-check-circle"></i>
                <strong>Success:</strong> <%= message %>
            </div>
            <% } %>

            <%-- Error Message --%>
            <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
            <div style="background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; border: 1px solid #f5c6cb; margin-bottom: 15px;">
                <i class="fas fa-exclamation-triangle"></i>
                <strong>Error:</strong> <%= errorMessage %>
            </div>
            <% } %>

            <div class="dashboard">
            <div class="dashboard-card fade-in">
                <div class="card-header">
                    <h2 class="card-title">
                        <i class="fas fa-plus-circle"></i>
                        Create New Account
                    </h2>
                </div>
                <form action="<%= request.getContextPath() %>/accounts" method="post">
                    <div class="form-group">
                        <label for="accountType">Account Type:</label>
                        <select id="accountType" name="accountType">
                            <option value="SAVINGS">Savings Account</option>
                            <option value="CHECKING">Checking Account</option>
                            <%--                            <option value="MONEY_MARKET">Money Market Account</option>--%>
                            <%--                            <option value="CERTIFICATE">Certificate of Deposit</option>--%>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="initialBalance">Initial Deposit Amount:</label>
                        <input type="number" id="initialBalance" name="initialBalance" min="0" step="0.01"
                               placeholder="0.00" required>
                    </div>

                    <button type="submit" class="btn btn-primary btn-block">
                        <i class="fas fa-check"></i> Create Account
                    </button>
                </form>
            </div>

            <div class="dashboard-card fade-in">
                <div class="card-header">
                    <h2 class="card-title">
                        <i class="fas fa-exchange-alt"></i>
                        Account Operations
                    </h2>
                </div>
                <div class="form-group">
                    <label for="accountIdInput">Account Number:</label>
                    <input type="text" id="accountIdInput" placeholder="Enter your account number">
                </div>
                <div class="btn-group">
                    <button class="btn btn-primary" onclick="goToDeposit()">
                        <i class="fas fa-arrow-down"></i> Deposit
                    </button>
                    <button class="btn btn-warning" onclick="goToWithdraw()">
                        <i class="fas fa-arrow-up"></i> Withdraw
                    </button>
                    <button class="btn btn-success" onclick="goToTransactionsWithID()">
                        <i class="fas fa-list"></i> History
                    </button>
                    <button class="btn btn-primary" onclick="goViewAllAccounts()">
                        <i class="fas fa-eye"></i> All Accounts
                    </button>
                </div>
            </div>

            <div class="dashboard-card fade-in">
                <div class="card-header">
                    <h2 class="card-title">
                        <i class="fas fa-tasks"></i>
                        Additional Services
                    </h2>
                </div>
                <div class="btn-group">
                    <button class="btn btn-success" onclick="goToTransfer()">
                        <i class="fas fa-exchange-alt"></i> Transfer Money
                    </button>
                    <button class="btn btn-primary" onclick="goToTransactions()">
                        <i class="fas fa-history"></i> All Transactions
                    </button>
                    <button class="btn btn-warning" onclick="goToReports()">
                        <i class="fas fa-chart-line"></i> Financial Reports
                    </button>
                    <form action="accounts" method="post">
                        <input type="hidden" name="action" value="processFees">
                        <button type="submit" class="btn btn-success">
                            <i class="fa fa-credit-card-alt" aria-hidden="true"></i> Process Monthly Fees
                        </button>
                    </form>
                </div>
            </div>

        </div>
    </main>

    <footer class="footer">
        <div class="footer-content">
            <div class="footer-links">
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Service</a>
                <a href="#">Security</a>
                <a href="#">Contact Us</a>
                <a href="#">Help Center</a>
            </div>
            <p>&copy; <%= java.time.Year.now() %> Secure Banking Portal. All rights reserved.</p>
            <p>Developed by <span class="developer">Rolando Cruz</span>. Special thanks to Joysis and Stratpoint for
                providing this learning opportunity.</p>
        </div>
    </footer>
</div>

<script>
    function goToDeposit() {
        var accountId = document.getElementById("accountIdInput").value;
        if (accountId) {
            window.location.href = "<%= request.getContextPath() %>/accounts/deposit.jsp?accountId=" + accountId;
        } else {
            alert("Please enter an Account Number before proceeding.");
        }
    }

    function goToWithdraw() {
        var accountId = document.getElementById("accountIdInput").value;
        if (accountId) {
            window.location.href = "<%= request.getContextPath() %>/accounts/withdraw.jsp?accountId=" + accountId;
        } else {
            alert("Please enter an Account Number before proceeding.");
        }
    }

    function goViewAllAccounts() {
        window.location.href = "<%= request.getContextPath() %>/accounts/list.jsp";
    }

    function goToTransfer() {
        window.location.href = "<%= request.getContextPath() %>/accounts/transfer.jsp";
    }

    function goToTransactionsWithID() {
        var accountId = document.getElementById("accountIdInput").value;
        if (accountId) {
            window.location.href = "<%= request.getContextPath() %>/transactions/transactions.jsp?accountId=" + accountId;
        } else {
            alert("Please enter an Account Number before proceeding.");
        }
    }

    function goToTransactions() {
        window.location.href = "<%= request.getContextPath() %>/transactions/transactions.jsp";
    }

    function goToReports() {
        window.location.href = "<%= request.getContextPath() %>/reports/generate_reports.jsp";
    }

    function processMonthlyFees() {
        window.location.href = "<%= request.getContextPath() %>/accounts/process_monthly_fees";
    }

    // Auto-hide success message after 5 seconds
    document.addEventListener('DOMContentLoaded', function () {
        var successMessage = document.querySelector('.success-message');
        if (successMessage) {
            setTimeout(function () {
                successMessage.style.display = 'none';
            }, 5000);
        }
    });
</script>
</body>
</html>