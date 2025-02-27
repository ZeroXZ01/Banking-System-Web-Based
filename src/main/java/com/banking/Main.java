package com.banking;

import com.banking.model.AccountType;

import java.io.IOException;
import java.math.BigDecimal;

public class Main {
    public static void main(String[] args) throws IOException {
        BankingSystem bank=BankingSystem.getInstance();
        // 1. Create test accounts
        System.out.println("Creating test accounts...");
        bank.createAccount(AccountType.SAVINGS, "SAV003",
                new BigDecimal("5000.00"));  // Rich account
        bank.createAccount(AccountType.CHECKING, "CHK004",
                new BigDecimal("1000.00"));  // Active account
        bank.createAccount(AccountType.SAVINGS, "SAV005",
                new BigDecimal("500.00"));   // Small account

        // 2. Do test transactions
        System.out.println("Performing test transactions...");
        bank.deposit("CHK001", new BigDecimal("2000.00"));
        bank.withdraw("SAV002", new BigDecimal("100.00"));
        bank.transfer("SAV001", "CHK001", new BigDecimal("1000.00"));

        // 3. Show reports
        System.out.println("\n=== Account Summary ===");
        System.out.println(bank.getAccountSummaryReport());

        System.out.println("=== Daily Transactions ===");
        System.out.println(bank.getDailyTransactionReport());

        System.out.println("=== Account Activity ===");
        System.out.println(bank.getAccountActivityReport());
    }
}
