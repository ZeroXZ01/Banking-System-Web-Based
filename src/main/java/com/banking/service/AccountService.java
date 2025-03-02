package com.banking.service;

import com.banking.db.DatabaseConnection;
import com.banking.exception.AccountNotFoundException;
import com.banking.exception.BankingException;
import com.banking.exception.InsufficientFundsException;
import com.banking.exception.OverdraftLimitExceededException;
import com.banking.model.*;
import com.banking.util.TransactionLogger;

import java.math.BigDecimal;
import java.sql.*;
import java.time.Instant;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AccountService extends DatabaseConnection {
    private final TransactionLogger transactionLogger;

    public AccountService() {
        this.transactionLogger = new TransactionLogger();
    }

    public Account createAccount(AccountType type, String accountId, BigDecimal initialBalance) throws BankingException {
        Account account = AccountFactory.createAccount(type, accountId, initialBalance);
        try {
            connect();
            preparedStatement = connect.prepareStatement("INSERT INTO accounts (account_id, account_type, balance) VALUES (?, ?, ?)");

            preparedStatement.setString(1, accountId);
            preparedStatement.setString(2, type.toString());
            preparedStatement.setBigDecimal(3, initialBalance);
            preparedStatement.executeUpdate();

            // Log initial deposit
            transactionLogger.logTransaction(accountId, initialBalance);
            return account;
        } catch (SQLException e) {
            throw new BankingException("Failed to create account: " + e.getMessage());
        } finally {
            try {
                if (preparedStatement != null) preparedStatement.close();
            } catch (SQLException e) {
                // Log the exception (don't rethrow unless necessary)
                System.err.println("Error closing PreparedStatement: " + e.getMessage());
            }
        }
    }

    public void deposit(String accountId, BigDecimal amount) throws BankingException {
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BankingException("Deposit amount must be positive");
        }

        try {
            connect();
            preparedStatement = connect.prepareStatement("UPDATE accounts SET balance = balance + ? WHERE account_id = ?");

            preparedStatement.setBigDecimal(1, amount);
            preparedStatement.setString(2, accountId);
            int updated = preparedStatement.executeUpdate();
            if (updated == 0) {
                throw new AccountNotFoundException(accountId);
            }

            // Log transaction
            transactionLogger.logTransaction(accountId, amount);

        } catch (SQLException e) {
            throw new BankingException("Failed to process deposit: " + e.getMessage());
        } finally {
            try {
                if (preparedStatement != null) preparedStatement.close();
            } catch (SQLException e) {
                // Log the exception (don't rethrow unless necessary)
                System.err.println("Error closing PreparedStatement: " + e.getMessage());
            }
        }
    }

    public void withdraw(String accountId, BigDecimal amount) throws BankingException {
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BankingException("Withdrawal amount must be positive");
        }

        String accountType=getAccountTypeById(accountId);

        try {
            connect();

            // Check balance
            BigDecimal currentBalance = getBalance(accountId);

            if (accountType.equals("SAVINGS")) {
                if (currentBalance.compareTo(amount) < 0) {
                    throw new InsufficientFundsException(accountId, amount, currentBalance);
                }
            } else if (accountType.equals("CHECKING")) {
                BigDecimal overdraftLimit = new BigDecimal("-100.00");
                if (currentBalance.subtract(amount).compareTo(overdraftLimit) < 0) {
                    throw new OverdraftLimitExceededException(accountId, amount, currentBalance);
                }
            }

            // Update account balance
            preparedStatement = connect.prepareStatement("UPDATE accounts SET balance = balance - ? WHERE account_id = ?");
            preparedStatement.setBigDecimal(1, amount);
            preparedStatement.setString(2, accountId);
            preparedStatement.executeUpdate();

            // Log transaction
            transactionLogger.logTransaction(accountId, amount.negate());

        } catch (SQLException e) {
            throw new BankingException("Failed to process withdrawal: " + e.getMessage());
        } finally {
            try {
                if (preparedStatement != null) preparedStatement.close();
            } catch (SQLException e) {
                // Log the exception (don't rethrow unless necessary)
                System.err.println("Error closing PreparedStatement: " + e.getMessage());
            }
        }
    }

    public String getAccountTypeById(String accountId) {
        String accountType = null;
        String sql = "SELECT account_type FROM accounts WHERE account_id = ?";

        try  {
            connect();
            preparedStatement = connect.prepareStatement(sql);

            preparedStatement.setString(1, accountId);
            resultSet= preparedStatement.executeQuery();

            if (resultSet.next()) {
                accountType = resultSet.getString("account_type");
            }

        } catch (SQLException e) {
            System.out.println("Error fetching account type: " + e.getMessage());
            throw new AccountNotFoundException(accountId);
        }

        return accountType;
    }

    public void transfer(String fromAccountId, String toAccountId, BigDecimal amount) throws BankingException {
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BankingException("Transfer amount must be positive");
        }

        PreparedStatement withdrawStatement = null;
        PreparedStatement depositStatement = null;

        String accountType=getAccountTypeById(fromAccountId);

        try {
            connect();

            // Check balance
            BigDecimal fromBalance = getBalance(fromAccountId);

            if (accountType.equals("SAVINGS")) {
                if (fromBalance.compareTo(amount) < 0) {
                    throw new InsufficientFundsException(fromAccountId, amount, fromBalance);
                }
            } else if (accountType.equals("CHECKING")) {
                BigDecimal overdraftLimit = new BigDecimal("-100.00");
                if (fromBalance.subtract(amount).compareTo(overdraftLimit) < 0) {
                    throw new OverdraftLimitExceededException(fromAccountId, amount, fromBalance);
                }
            }

            // Update both accounts
            withdrawStatement = connect.prepareStatement("UPDATE accounts SET balance = balance - ? WHERE account_id = ?");
            withdrawStatement.setBigDecimal(1, amount);
            withdrawStatement.setString(2, fromAccountId);
            withdrawStatement.executeUpdate();

            depositStatement = connect.prepareStatement("UPDATE accounts SET balance = balance + ? WHERE account_id = ?");
            depositStatement.setBigDecimal(1, amount);
            depositStatement.setString(2, toAccountId);
            depositStatement.executeUpdate();

            // Log transactions
            Instant now = Instant.now();
            Timestamp timestamp1 = Timestamp.from(now);
            Timestamp timestamp2 = Timestamp.from(now.plusSeconds(1)); // Add 1 second

            transactionLogger.logTransaction(fromAccountId, amount.negate(), timestamp1);
            transactionLogger.logTransaction(toAccountId, amount, timestamp2);

            // Log transactions
//            transactionLogger.logTransaction(fromAccountId, amount.negate());
//            transactionLogger.logTransaction(toAccountId, amount);
            transactionLogger.logTransfer(fromAccountId, toAccountId, amount);
        } catch (SQLException e) {
            throw new BankingException("Failed to process transfer: " + e.getMessage());
        } finally {
            try {
                if (withdrawStatement != null) withdrawStatement.close();
                if (depositStatement != null) depositStatement.close();
            } catch (SQLException e) {
                // Log the exception (don't rethrow unless necessary)
                System.err.println("Error closing PreparedStatements: " + e.getMessage());
            }
        }
    }

    public BigDecimal getBalance(String accountId) throws BankingException {
        try {
            connect();
            preparedStatement = connect.prepareStatement("SELECT balance FROM accounts WHERE account_id = ?");
            preparedStatement.setString(1, accountId);

            resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getBigDecimal("balance");
            } else {
                throw new AccountNotFoundException(accountId);
            }
        } catch (SQLException e) {
            throw new BankingException("Failed to get balance: " + e.getMessage());
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (preparedStatement != null) preparedStatement.close();
            } catch (SQLException e) {
                // Log the exception (don't rethrow unless necessary)
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }
    }

    public List<AccountDTO> displayAllAccounts() throws SQLException {
        List<AccountDTO> accountList = new ArrayList<>();
        try {
            connect();
            // execute query;
            String query = "SELECT account_id, account_type, balance, created_at FROM accounts ORDER BY created_at DESC";
            preparedStatement = connect.prepareStatement(query);
            resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                String account_id = resultSet.getString("account_id");
                String account_type = resultSet.getString("account_type");
                BigDecimal balance = resultSet.getBigDecimal("balance");
                Timestamp created_at = resultSet.getTimestamp("created_at");

                // Create AccountDTO object and add it to the list
                AccountDTO account = new AccountDTO(account_id, account_type, balance, created_at);
                accountList.add(account);
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        } finally {
            try {
                if (resultSet != null) resultSet.close();
                if (preparedStatement != null) preparedStatement.close();
            } catch (SQLException e) {
                // Log the exception (don't rethrow unless necessary)
                System.err.println("Error closing resources: " + e.getMessage());
            }
        }

        return accountList;
    }


    public List<String> getTransactionHistory(String accountId) {
        return transactionLogger.readTransactionHistory(accountId);
    }

    public List<String> getAllTransactions() {
        return transactionLogger.readTransactionHistory();
    }


    public void deleteAccount(String accountId) throws BankingException {
        try {
            connect();

            // First delete related transactions (due to foreign key)
            preparedStatement = connect.prepareStatement("DELETE FROM transactions WHERE account_id = ?");
            preparedStatement.setString(1, accountId);
            preparedStatement.executeUpdate();

            // Then delete the account
            preparedStatement = connect.prepareStatement("DELETE FROM accounts WHERE account_id = ?");
            preparedStatement.setString(1, accountId);
            int updated = preparedStatement.executeUpdate();
            if (updated == 0) {
                throw new AccountNotFoundException(accountId);
            }
        } catch (SQLException e) {
            throw new BankingException("Database error while deleting account: " + e.getMessage());
        } finally {
            try {
                if (preparedStatement != null) preparedStatement.close();
            } catch (SQLException e) {
                // Log the exception (don't rethrow unless necessary)
                System.err.println("Error closing PreparedStatement: " + e.getMessage());
            }
        }
    }

    // Add this method for Account Summary Report
    public Map<String, Object> getAccountSummary() {
        Map<String, Object> summary = new HashMap<>();

        try {
            connect();

            // Count total accounts
            String sql = "SELECT COUNT(*) as total FROM accounts";
            preparedStatement = connect.prepareStatement(sql);
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                summary.put("totalAccounts", resultSet.getInt("total"));
            }

            // Get total balance
            sql = "SELECT SUM(balance) as total FROM accounts";
            preparedStatement = connect.prepareStatement(sql);
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                BigDecimal total = resultSet.getBigDecimal("total");
                summary.put("totalBalance", total != null ? total : BigDecimal.ZERO);
            }
        } catch (SQLException e) {
            throw new BankingException("Could not create summary", e);
        } finally {
            try {
                if (preparedStatement != null) preparedStatement.close();
            } catch (SQLException e) {
                // Log the exception (don't rethrow unless necessary)
                System.err.println("Error closing PreparedStatement: " + e.getMessage());
            }
        }
        return summary;
    }

    // Add this method for Daily Transactions Report
    public Map<String, Object> getDailyTransactions() {
        Map<String, Object> report = new HashMap<>();

        try {
            connect();

            // Get today's deposits
            String sql = "SELECT SUM(amount) as total " + "FROM transactions " + "WHERE DATE(transaction_date) = CURRENT_DATE " + "AND amount > 0";
            preparedStatement = connect.prepareStatement(sql);
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                BigDecimal total = resultSet.getBigDecimal("total");
                report.put("totalDeposits", total != null ? total : BigDecimal.ZERO);
            }

            // Get today's withdrawals
            sql = "SELECT SUM(amount) as total " + "FROM transactions " + "WHERE DATE(transaction_date) = CURRENT_DATE " + "AND amount < 0";
            preparedStatement = connect.prepareStatement(sql);
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                BigDecimal total = resultSet.getBigDecimal("total");
                report.put("totalWithdrawals", total != null ? total : BigDecimal.ZERO);
            }

        } catch (SQLException e) {
            throw new BankingException("Could not create daily report", e);
        } finally {
            try {
                if (preparedStatement != null) preparedStatement.close();
            } catch (SQLException e) {
                // Log the exception (don't rethrow unless necessary)
                System.err.println("Error closing PreparedStatement: " + e.getMessage());
            }
        }

        return report;
    }

    // Add this method for Account Activity Report
    public Map<String, Object> getAccountActivity() {
        Map<String, Object> report = new HashMap<>();

        try {
            connect();

            // Find most active account
            String sql = "SELECT account_id, COUNT(*) as tx_count " + "FROM transactions " + "GROUP BY account_id " + "ORDER BY tx_count DESC " + "LIMIT 1";
            preparedStatement = connect.prepareStatement(sql);
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                report.put("mostActiveAccount", resultSet.getString("account_id"));
                report.put("transactionCount", resultSet.getInt("tx_count"));
            }

            // Find highest balance account
            sql = "SELECT account_id, balance " + "FROM accounts " + "ORDER BY balance DESC " + "LIMIT 1";
            preparedStatement = connect.prepareStatement(sql);
            resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                report.put("highestBalanceAccount", resultSet.getString("account_id"));
                report.put("highestBalance", resultSet.getBigDecimal("balance"));
            }

        } catch (SQLException e) {
            throw new BankingException("Could not create activity report", e);
        } finally {
            try {
                if (preparedStatement != null) preparedStatement.close();
            } catch (SQLException e) {
                // Log the exception (don't rethrow unless necessary)
                System.err.println("Error closing PreparedStatement: " + e.getMessage());
            }
        }
        return report;
    }

    // Added method to process monthly fess for all accounts
    public void processMonthlyFees() {
        String sql = "SELECT account_id, account_type, balance, created_at FROM accounts ORDER BY created_at ASC";
        try  {

            connect();
            statement = connect.createStatement();
            resultSet=statement.executeQuery(sql);

            Timestamp currentTimestamp = Timestamp.valueOf(LocalDateTime.now());

            while (resultSet.next()) {
                String accountId = resultSet.getString("account_id");
                String account_type = resultSet.getString("account_type");
                BigDecimal balance = resultSet.getBigDecimal("balance");
                currentTimestamp = Timestamp.valueOf(currentTimestamp.toLocalDateTime().plusSeconds(1));

                if ("SAVINGS".equals(account_type)) {
                    SavingsAccount savingsAccount = new SavingsAccount(accountId, balance);
                    savingsAccount.processMonthlyFees();
                    updateAccountBalance(savingsAccount.getAccountNumber(), savingsAccount.getBalance());
                    BigDecimal deducted = savingsAccount.getBalance().subtract(balance);
                    transactionLogger.logTransaction(savingsAccount.getAccountNumber(), deducted, currentTimestamp);

                } else if ("CHECKING".equals(account_type)) {
                    CheckingAccount checkingAccount = new CheckingAccount(accountId, balance);
                    checkingAccount.processMonthlyFees();
                    updateAccountBalance(checkingAccount.getAccountNumber(), checkingAccount.getBalance());
                    BigDecimal deducted = checkingAccount.getBalance().subtract(balance);
                    transactionLogger.logTransaction(checkingAccount.getAccountNumber(), deducted, currentTimestamp);
                }
            }
            System.out.println("Monthly fees and interest applied successfully.");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateAccountBalance(String accountNumber, BigDecimal newBalance) {
        String sql = "UPDATE accounts SET balance = ? WHERE account_id = ?";
        try  {
            connect();
            preparedStatement = connect.prepareStatement(sql);
            preparedStatement.setBigDecimal(1, newBalance);
            preparedStatement.setString(2, accountNumber);
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
