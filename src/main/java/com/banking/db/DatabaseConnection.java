package com.banking.db;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.io.IOException;
import java.io.InputStream;
import java.sql.*;

public abstract class DatabaseConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DATABASE_NAME = "db_web_based_banking";
    public static Connection connect;
    public Statement statement;
    public ResultSet resultSet;
    public PreparedStatement preparedStatement;

    private static HikariDataSource dataSource;

    static {
        try {
            Class.forName(DRIVER);

            // Step 1: Create database if not exists
            Connection tempConn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            createDatabaseIfNotExists(tempConn);
            tempConn.close();

            // Step 2: Initialize HikariCP
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(URL + DATABASE_NAME);
            config.setUsername(USERNAME);
            config.setPassword(PASSWORD);
            config.setDriverClassName(DRIVER);
            config.setMaximumPoolSize(20);
            config.setMinimumIdle(2);
            config.setIdleTimeout(30000);
            config.setMaxLifetime(1800000);
            config.setLeakDetectionThreshold(2000);  // This will log connections that are not closed within 2 seconds

            dataSource = new HikariDataSource(config);

            // Step 3: Initialize database schema
            try (Connection conn = dataSource.getConnection()) {
                initializeDatabase(conn);
            }

            System.out.println("Successfully connected to database!");
        } catch (Exception e) {
            System.out.println("Connection Failed " + e.getMessage());
            throw new RuntimeException("Failed to initialize database", e);
        }
    }

    public static void connect() {
        try {
            connect = dataSource.getConnection();
        } catch (SQLException e) {
            throw new RuntimeException("Failed to get database connection", e);
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
            System.out.println("Database schema initialized successfully.");
        } catch (IOException | SQLException e) {
            throw new RuntimeException("Failed to initialize database schema", e);
        }
    }

    public static void closeConnection() {
        try {
            if (connect != null && !connect.isClosed()) {
                connect.close();
            }
        } catch (SQLException e) {
            System.err.println("Error closing connection: " + e.getMessage());
        }
    }
}
