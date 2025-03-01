package com.banking.util;

import com.banking.db.DatabaseConnection;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class TransactionLogger extends DatabaseConnection {
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"); // added DateTimeFormatter for log to file

    // Log Transaction for Create Account, Deposit and Withdraw
    public void logTransaction(String accountId, BigDecimal amount) {
        try {
            connect();
            preparedStatement = connect.prepareStatement("INSERT INTO transactions (account_id, amount) VALUES (?, ?)");
            preparedStatement.setString(1, accountId);
            preparedStatement.setBigDecimal(2, amount);
            preparedStatement.executeUpdate();

            // Also log to file*
            String activityType = amount.compareTo(BigDecimal.ZERO) > 0 ? "DEPOSIT" : "WITHDRAWAL";
            String logEntry = String.format("[%s] %s: Account %s - $%.2f", LocalDateTime.now().format(FORMATTER), activityType, accountId, amount.abs());

            try {
                FileReporter.logActivity(logEntry);
            } catch (IOException e) {
                System.err.println("Failed to log activity to file: " + e.getMessage());
            }
        } catch (SQLException e) {
            System.err.println("Failed to log transaction: " + e.getMessage());
        } finally {
            try {
                if (preparedStatement != null) preparedStatement.close();
            } catch (SQLException e) {
                // Log the exception (don't rethrow unless necessary)
                System.err.println("Error closing PreparedStatement: " + e.getMessage());
            }
        }
    }

    // Log Transaction for Transfer
    public void logTransaction(String accountId, BigDecimal amount, Timestamp timestamp) {
        try {
            connect();
            preparedStatement = connect.prepareStatement("INSERT INTO transactions (account_id, amount, transaction_date) VALUES (?, ?, ?)");
            preparedStatement.setString(1, accountId);
            preparedStatement.setBigDecimal(2, amount);
            preparedStatement.setTimestamp(3, timestamp);
            preparedStatement.executeUpdate();

            // Also log to file*
            String activityType = amount.compareTo(BigDecimal.ZERO) > 0 ? "DEPOSIT" : "WITHDRAWAL";
            String logEntry = String.format("[%s] %s: Account %s - $%.2f", timestamp, activityType, accountId, amount.abs());

            try {
                FileReporter.logActivity(logEntry);
            } catch (IOException e) {
                System.err.println("Failed to log activity to file: " + e.getMessage());
            }
        } catch (SQLException e) {
            System.err.println("Failed to log transaction: " + e.getMessage());
        } finally {
            try {
                if (preparedStatement != null) preparedStatement.close();
            } catch (SQLException e) {
                // Log the exception (don't rethrow unless necessary)
                System.err.println("Error closing PreparedStatement: " + e.getMessage());
            }
        }
    }

    public void logTransfer(String fromAccountId, String toAccountId, BigDecimal amount) {
        // Log transfer activity to file*
        String logEntry = String.format("[%s] TRANSFER: From %s to %s - $%.2f", LocalDateTime.now().format(FORMATTER), fromAccountId, toAccountId, amount);

        try {
            FileReporter.logActivity(logEntry);
        } catch (IOException e) {
            System.err.println("Failed to log transfer activity to file: " + e.getMessage());
        }
    }

    public List<String> readTransactionHistory() {
        List<String> history = new ArrayList<>();

        try {
            connect();
            preparedStatement = connect.prepareStatement("SELECT transaction_date, account_id, amount FROM transactions ORDER BY transaction_date DESC");
            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                history.add(String.format("%s,%s,%.2f", resultSet.getTimestamp("transaction_date"), resultSet.getString("account_id"), resultSet.getBigDecimal("amount")));
            }
        } catch (SQLException e) {
            System.err.println("Failed to read transaction history: " + e.getMessage());
        } finally {
            try {
                if (preparedStatement != null) preparedStatement.close();
            } catch (SQLException e) {
                // Log the exception (don't rethrow unless necessary)
                System.err.println("Error closing PreparedStatement: " + e.getMessage());
            }
        }

        return history;
    }

    public List<String> readTransactionHistory(String accountId) {
        List<String> history = new ArrayList<>();

        try {
            connect();
            preparedStatement = connect.prepareStatement("SELECT transaction_date, amount FROM transactions WHERE account_id = ? ORDER BY transaction_date DESC");
            preparedStatement.setString(1, accountId);

            resultSet = preparedStatement.executeQuery();
            while (resultSet.next()) {
                history.add(String.format("%s,%s,%.2f", resultSet.getTimestamp("transaction_date"), accountId, resultSet.getBigDecimal("amount")));
            }

        } catch (SQLException e) {
            System.err.println("Failed to read transaction history: " + e.getMessage());
        } finally {
            try {
                if (preparedStatement != null) preparedStatement.close();
            } catch (SQLException e) {
                // Log the exception (don't rethrow unless necessary)
                System.err.println("Error closing PreparedStatement: " + e.getMessage());
            }
        }

        return history;
    }

    public void clearTransactions() {
        try {
            connect();
            preparedStatement = connect.prepareStatement("DELETE FROM transactions");
            preparedStatement.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Failed to clear transactions: " + e.getMessage());
        } finally {
            try {
                if (preparedStatement != null) preparedStatement.close();
            } catch (SQLException e) {
                // Log the exception (don't rethrow unless necessary)
                System.err.println("Error closing PreparedStatement: " + e.getMessage());
            }
        }
    }
}
