<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Transaction History | Secure Banking Portal</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css">
  <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/styles.css">
  <style>
    :root {
      --primary: #00529B;
      --primary-light: #2980b9;
      --secondary: #0072CE;
      --secondary-button-amount: #2ecc71;
      --accent: #F2A900;
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

    /* Header styles from generate_reports.jsp */
    .header {
      background: linear-gradient(120deg, var(--primary), var(--secondary));
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

    /* Keeping the original main content styles */
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

    .debit {
      color: var(--danger);
    }

    .credit {
      color: var(--secondary-button-amount);
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
      background-color: var(--secondary-button-amount);
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

    .pagination {
      display: flex;
      justify-content: center;
      margin-top: 20px;
      gap: 10px;
    }

    .pagination a {
      padding: 8px 12px;
      background-color: white;
      border: 1px solid var(--medium-gray);
      border-radius: var(--radius);
      color: var(--text-primary);
      text-decoration: none;
      transition: all 0.3s ease;
    }

    .pagination a:hover, .pagination a.active {
      background-color: var(--primary);
      color: white;
    }

    .pagination a.disabled {
      opacity: 0.5;
      pointer-events: none;
    }

    /* Footer styles from generate_reports.jsp */
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
      color: var(--accent);
    }

    @media (max-width: 768px) {
      .header-content {
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
    }

    .hidden {
      display: none;
    }
  </style>
</head>
<body>

<!-- Header from generate_reports.jsp -->
<header class="header">
  <div class="header-content">
    <div class="bank-logo">
      <i class="fas fa-landmark"></i>
      <span>Secure Banking Portal</span>
    </div>
    <div class="header-title">
      <h1 class="page-title">Transaction History</h1>
      <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a> / Transaction History
      </div>
    </div>
  </div>
</header>

<main class="main-content">
  <div class="card">
    <div class="card-header">
      <span>Recent Transactions</span>
      <span id="current-date"></span>
    </div>
    <div class="card-body">
      <div class="table-responsive">
        <%-- Check if transactions exist --%>
        <% if (request.getAttribute("transactions") != null && !((List<String>) request.getAttribute("transactions")).isEmpty()) {
          List<String> transactions = (List<String>) request.getAttribute("transactions");
          int totalTransactions = transactions.size();
          int itemsPerPage = 10; // Number of transactions per page
          int totalPages = (int) Math.ceil((double) totalTransactions / itemsPerPage);

          // Get current page from request parameter or default to 1
          int currentPage = 1;
          String pageParam = request.getParameter("page");
          if (pageParam != null && !pageParam.isEmpty()) {
            try {
              currentPage = Integer.parseInt(pageParam);
              if (currentPage < 1) currentPage = 1;
              if (currentPage > totalPages) currentPage = totalPages;
            } catch (NumberFormatException e) {
              // Invalid page parameter, default to 1
              currentPage = 1;
            }
          }

          // Calculate start and end indices for the current page
          int startIndex = (currentPage - 1) * itemsPerPage;
          int endIndex = Math.min(startIndex + itemsPerPage, totalTransactions);
        %>
        <table>
          <thead>
          <tr>
            <th>Date</th>
            <th>Account ID</th>
            <th>Description</th>
            <th>Amount</th>
          </tr>
          </thead>
          <tbody id="transactionTable">
          <%-- Display transactions for the current page only --%>
          <% for (int i = startIndex; i < endIndex; i++) {
            String transaction = transactions.get(i);
            String[] details = transaction.split(",");
            boolean isDebit = details[2].startsWith("-");
            String formattedAmount = isDebit ? "-$" + details[2].substring(1) : "$" + details[2];
            // For demonstration, we're adding a description column with placeholder text
            String description = isDebit ? "Withdraw" : "Deposit";
          %>
          <tr>
            <td><%= details[0] %></td>
            <td><%= details[1] %></td>
            <td><%= description %></td>
            <td class="amount <%= isDebit ? "debit" : "credit" %>"><%= formattedAmount %></td>
          </tr>
          <% } %>
          </tbody>
        </table>

        <%-- Pagination controls --%>
        <% if (totalPages > 1) { %>
        <div class="pagination">
          <a href="${pageContext.request.contextPath}/transactions?page=<%= currentPage-1 %>"
             class="<%= currentPage == 1 ? "disabled" : "" %>">&laquo; Prev</a>

          <%
            // Display at most 5 page links
            int startPage = Math.max(1, currentPage - 2);
            int endPage = Math.min(startPage + 4, totalPages);

            // Adjust startPage if endPage is at the maximum
            startPage = Math.max(1, endPage - 4);

            for (int i = startPage; i <= endPage; i++) {
          %>
          <a href="${pageContext.request.contextPath}/transactions?page=<%= i %>"
             class="<%= i == currentPage ? "active" : "" %>"><%= i %></a>
          <% } %>

          <a href="${pageContext.request.contextPath}/transactions?page=<%= currentPage+1 %>"
             class="<%= currentPage == totalPages ? "disabled" : "" %>">Next &raquo;</a>
        </div>
        <% } %>
        <% } else { %>
        <div class="empty-state">
          <div class="empty-state-icon">📊</div>
          <h3>No transactions found</h3>
          <p>There are no transactions to display for this account.</p>
        </div>
        <% } %>
      </div>
    </div>
  </div>

  <div class="actions">
    <a href="${pageContext.request.contextPath}/index.jsp" class="button"><span class="icon">←</span> Back to Dashboard</a>
    <a href="#" class="button secondary" id="exportBtn"><span class="icon">↓</span> Export Transactions</a>
  </div>
</main>

<!-- Footer from generate_reports.jsp -->
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

  // Add functionality to export button (demo functionality)
  document.getElementById('exportBtn').addEventListener('click', function(e) {
    e.preventDefault();
    alert('Transactions would be exported here. This is a demo feature.');
  });
</script>

</body>
</html>