CREATE DATABASE IF NOT EXISTS ticket_db;
USE ticket_db;

-- Table for the actual tickets available
CREATE TABLE IF NOT EXISTS tickets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    status ENUM('available', 'sold') DEFAULT 'available'
);

-- Table for users/bookings (as per your snippet)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);