package com.banking.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class AccountDTO {
    private String account_id;
    private String account_type;
    private BigDecimal balance;
    private Timestamp transaction_date;

    public AccountDTO(String account_id, String account_type, BigDecimal balance, Timestamp transaction_date) {
        this.account_id = account_id;
        this.account_type = account_type;
        this.balance = balance;
        this.transaction_date = transaction_date;
    }

    public String getAccount_id() {
        return account_id;
    }

    public String getAccount_type() {
        return account_type;
    }

    public BigDecimal getBalance() {
        return balance;
    }

    public Timestamp getTransaction_date() {
        return transaction_date;
    }
}
