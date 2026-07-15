-- ============================================================
-- Mini Contact Book - MySQL Schema
-- Run in MySQL Workbench: File > Open SQL Script > Execute (⚡)
-- ============================================================

CREATE DATABASE IF NOT EXISTS contact_book_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE contact_book_db;

CREATE TABLE IF NOT EXISTS contacts (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  full_name    VARCHAR(150) NOT NULL,
  phone_number VARCHAR(20)  NOT NULL,
  category     ENUM('Family', 'Friend', 'Work') NOT NULL,
  is_favorite  TINYINT(1)   NOT NULL DEFAULT 0,
  created_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_phone (phone_number)
);

-- No seed rows — add contacts from the app (avoids duplicate phone errors).
