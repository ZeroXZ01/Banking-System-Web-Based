<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Deposit Money | Secure Banking Portal</title>
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
      --box-shadow: 0 4px 12px rgba(0,0,0,0.08);
      --transition: all 0.3s ease;
    }

    /* Header styles from transactions.jsp */
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

    /* Keep original form styling */
    /* General Page Styling */
    body {
      font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', sans-serif;
      margin: 0;
      padding: 0;
      background: url('<%= request.getContextPath() %>/images/calculator money.jpg') no-repeat center center fixed;
      background-size: cover;
      color: #333;
      line-height: 1.6;
      display: flex;
      flex-direction: column;
      min-height: 100vh;
    }

    .container {
      width: 90%;
      max-width: 500px;
      margin: 60px auto;
      background: rgba(255, 255, 255, 0.95);
      padding: 30px;
      border-radius: 8px;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
      text-align: center;
      flex: 1;
    }

    .form-header {
      margin-bottom: 30px;
      border-bottom: 1px solid #eee;
      padding-bottom: 15px;
    }

    h2 {
      color: #27ae60;
      margin-bottom: 5px;
      font-weight: 600;
    }

    .subtitle {
      color: #555;
      font-size: 14px;
      margin-bottom: 20px;
    }

    /* Form Styling */
    .form-group {
      margin-bottom: 20px;
      text-align: left;
    }

    label {
      display: block;
      font-size: 14px;
      margin-bottom: 5px;
      font-weight: 500;
      color: #2C3E50;
    }

    input {
      width: 100%;
      padding: 12px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 15px;
      transition: border 0.3s;
      box-sizing: border-box;
    }

    input:focus {
      border-color: #3498db;
      outline: none;
      box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
    }

    input[readonly] {
      background: #f9f9f9;
      color: #666;
    }

    .submit-button {
      background-color: #27ae60;
      color: white;
      font-size: 16px;
      border: none;
      border-radius: 4px;
      padding: 12px 24px;
      cursor: pointer;
      transition: background-color 0.3s;
      width: 100%;
      font-weight: 500;
    }

    .submit-button:hover {
      background-color: #219653;
    }

    .message {
      font-size: 14px;
      padding: 12px 15px;
      border-radius: 4px;
      margin: 20px 0;
      text-align: left;
      display: flex;
      align-items: center;
    }

    .message i {
      margin-right: 10px;
      font-size: 18px;
    }

    .success {
      background-color: #d4edda;
      color: #155724;
      border: 1px solid #c3e6cb;
    }

    .error {
      background-color: #f8d7da;
      color: #721c24;
      border: 1px solid #f5c6cb;
    }

    .back-button {
      display: inline-block;
      margin-top: 15px;
      padding: 10px 15px;
      font-size: 14px;
      color: #6c757d;
      background-color: rgba(255, 255, 255, 0.8);
      text-decoration: none;
      border-radius: 4px;
      transition: all 0.3s;
      border: 1px solid #ddd;
    }

    .back-button:hover {
      color: #343a40;
      border-color: #6c757d;
      background-color: #fff;
    }

    .icon-circle {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 70px;
      height: 70px;
      border-radius: 50%;
      background-color: rgba(39, 174, 96, 0.1);
      color: #27ae60;
      margin-bottom: 15px;
      border: 2px solid rgba(39, 174, 96, 0.3);
    }

    .icon-circle i {
      font-size: 32px;
    }

    /* Media queries from transactions.jsp */
    @media (max-width: 768px) {
      .header-content {
        flex-direction: column;
        text-align: center;
        gap: 10px;
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
      <h1 class="page-title">Deposit Money</h1>
      <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a> / Deposit Money
      </div>
    </div>
  </div>
</header>

<div class="container">
  <div class="form-header">
    <div class="icon-circle">
      <i class="fas fa-money-bill-wave"></i>
    </div>
    <h2>Deposit Money</h2>
    <p class="subtitle">Add funds to your account securely</p>
  </div>

  <%-- Show success message if deposit was completed --%>
  <% if ("true".equals(request.getParameter("success"))) { %>
  <div class="message success">
    <i class="fas fa-check-circle"></i>
    <span>Your deposit was processed successfully. Redirecting to Home...</span>
  </div>
  <script>
    setTimeout(function() {
      window.location.href = "<%= request.getContextPath() %>/index.jsp";
    }, 3000); // Redirect after 3 seconds
  </script>
  <% } %>

  <% if (request.getParameter("error") != null) { %>
  <div class="message error">
    <i class="fas fa-exclamation-circle"></i>
    <span><%= request.getParameter("error") %> Redirecting to Home...</span>
  </div>

  <script>
    setTimeout(function() {
      window.location.href = "<%= request.getContextPath() %>/index.jsp";
    }, 5000); // Redirect after 5 seconds
  </script>
  <% } %>

  <form action="<%= request.getContextPath() %>/accounts/deposit" method="post">
    <div class="form-group">
      <label for="accountId">Account ID</label>
      <input id="accountId" type="text" name="accountId" value="<%= request.getParameter("accountId") != null ? request.getParameter("accountId") : "" %>" readonly>
    </div>

    <div class="form-group">
      <label for="amount">Amount ($)</label>
      <input id="amount" type="number" name="amount" step="0.01" min="0.01" required>
    </div>

    <button type="submit" class="submit-button">
      <i class="fas fa-check"></i> Complete Deposit
    </button>
  </form>

  <a href="<%= request.getContextPath() %>/index.jsp" class="back-button">
    <i class="fas fa-arrow-left"></i> Return to Dashboard
  </a>
</div>

<!-- Footer from transactions.jsp -->
<footer>
  <div class="footer-content">
    <p>&copy; <%= java.time.Year.now() %> Secure Banking Portal. All rights reserved.</p>
    <p>Developed by <span class="developer">Rolando Cruz</span>. Special thanks to Joysis and Stratpoint for providing this learning opportunity.</p>
  </div>
</footer>

</body>
</html>