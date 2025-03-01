package com.banking.db;

import java.io.IOException;
import java.io.InputStream;
import java.sql.*;

public abstract class DatabaseConnection {
    private final static String URL = "jdbc:mysql://localhost:3306/"; // Note: No database specified here
    private final static String USERNAME = "root";
    private final static String PASSWORD = "";
    private final static String DRIVER = "com.mysql.cj.jdbc.Driver";
    private final static String DATABASE_NAME = "db_web_based_banking"; // Database name
    public static Connection connect;
    public Statement statement;
    public ResultSet resultSet;
    public PreparedStatement preparedStatement;

    public static void connect() {
        try {
            Class.forName(DRIVER);
            connect = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            createDatabaseIfNotExists(connect); // Create database first
            connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + DATABASE_NAME, USERNAME, PASSWORD); // Connect to specific database
            initializeDatabase(connect);
             System.out.println("Successfully connected to database!");
        } catch (Exception e) {
            System.out.println("Connection Failed " + e.getMessage());
        }
    }

    private static void createDatabaseIfNotExists(Connection conn) throws SQLException, IOException {
        try (InputStream createDbStream = DatabaseConnection.class.getClassLoader().getResourceAsStream("create_database.sql")) {
            if (createDbStream == null) {
                throw new RuntimeException("Unable to find create_database.sql");
            }
            String createDbScript = new String(createDbStream.readAllBytes());
            conn.createStatement().execute(createDbScript);
             System.out.println("Database created or already exists.");
        }
    }

    private static void initializeDatabase(Connection conn) {
        try {
            try (InputStream schemaStream = DatabaseConnection.class.getClassLoader().getResourceAsStream("schema.sql")) {
                if (schemaStream == null) {
                    throw new RuntimeException("Unable to find schema.sql");
                }
                String schema = new String(schemaStream.readAllBytes());
                for (String statement : schema.split(";")) {
                    if (!statement.trim().isEmpty()) {
                        conn.createStatement().execute(statement);
                    }
                }
            }
             System.out.println("Database schema initialized successfully");
        } catch (IOException | SQLException e) {
            throw new RuntimeException("Failed to initialize database schema", e);
        }
    }

//    public static void main(String[] args) {
//        connect();
//    }
}
