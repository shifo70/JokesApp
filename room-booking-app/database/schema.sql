-- ============================================================
-- Room Booking App - MySQL Database Schema
-- Run this script in MySQL Workbench (File > Open SQL Script)
-- ============================================================

CREATE DATABASE IF NOT EXISTS room_booking_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE room_booking_db;

-- Drop tables in reverse dependency order (safe re-run)
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,
  email         VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role          ENUM('admin', 'customer') NOT NULL DEFAULT 'customer'
);

CREATE TABLE rooms (
  id     INT AUTO_INCREMENT PRIMARY KEY,
  name   VARCHAR(100) NOT NULL,
  price  DECIMAL(10, 2) NOT NULL,
  status ENUM('available', 'occupied') NOT NULL DEFAULT 'available'
);

CREATE TABLE bookings (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  room_id     INT NOT NULL,
  customer_id INT NOT NULL,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_bookings_room
    FOREIGN KEY (room_id) REFERENCES rooms(id)
    ON DELETE RESTRICT,
  CONSTRAINT fk_bookings_customer
    FOREIGN KEY (customer_id) REFERENCES users(id)
    ON DELETE RESTRICT
);

-- Admin account (password: admin123)
-- Or run: npm run seed  (in backend folder) to create admin automatically
INSERT INTO users (name, email, password_hash, role) VALUES (
  'Admin',
  'admin@hotel.com',
  '$2a$10$fl2eaYRxW0rhK29WlGPDKuocaxH8FNMVsBpJIAc7eObda38mHgb.a',
  'admin'
);

-- Sample rooms (optional — remove if you prefer to add via the app)
INSERT INTO rooms (name, price, status) VALUES
  ('Room 101', 50.00, 'available'),
  ('Room 102', 75.00, 'available'),
  ('Room 103', 100.00, 'available');
