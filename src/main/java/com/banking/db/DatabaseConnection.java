package com.banking.db;

import java.io.IOException;
import java.io.InputStream;
import java.sql.*;

public abstract class DatabaseConnection {
    private final static String URL="jdbc:mysql://localhost:3306/db_web_based_banking";
    private final static String USERNAME="root";
    private final static String PASSWORD="";
    private final static String DRIVER="com.mysql.cj.jdbc.Driver";
    public static Connection connect;
    public Statement statement;
    public ResultSet resultSet;
    public PreparedStatement preparedStatement;

    public static void connect(){
        try{
            Class.forName(DRIVER);
            connect= DriverManager.getConnection(URL, USERNAME, PASSWORD);
            initializeDatabase(connect);

//            System.out.println("Successfully connected to database!");
        }

        catch(Exception e){
            System.out.println("Connection Failed "+e.getMessage());
        }
    }

    private static void initializeDatabase(Connection conn) {
        try {
            // Execute schema.sql to create tables
            try (InputStream schemaStream = DatabaseConnection.class.getClassLoader().getResourceAsStream("schema.sql")) {
                if (schemaStream == null) {
                    throw new RuntimeException("Unable to find schema.sql");
                }
                String schema = new String(schemaStream.readAllBytes());
                // Split and execute each statement separately
                for (String statement : schema.split(";")) {
                    if (!statement.trim().isEmpty()) {
                        conn.createStatement().execute(statement);
                    }
                }
            }
//            System.out.println("Database schema initialized successfully");
        } catch (IOException | SQLException e) {
            throw new RuntimeException("Failed to initialize database schema", e);
        }
    }

//    public static void main(String[] args) {
//        connect();
//    }
}
