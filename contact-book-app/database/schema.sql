-- ============================================================
-- Mini Contact Book - MySQL Schema
-- Run in MySQL Workbench: File > Open SQL Script > Execute (⚡)
-- ============================================================

CREATE DATABASE IF NOT EXISTS contact_book_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE contact_book_db;

DROP TABLE IF EXISTS contacts;

CREATE TABLE contacts (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  full_name    VARCHAR(150) NOT NULL,
  phone_number VARCHAR(20)  NOT NULL,
  category     ENUM('Family', 'Friend', 'Work') NOT NULL,
  is_favorite  TINYINT(1)   NOT NULL DEFAULT 0,
  created_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  -- Unique after trimming spaces is enforced in the API;
  -- store a normalized unique value for safety:
  UNIQUE KEY uq_phone (phone_number)
);

-- Sample data (optional)
INSERT INTO contacts (full_name, phone_number, category, is_favorite) VALUES
  ('Amina Hassan', '0788123456', 'Family', 1),
  ('Omar Ali',     '0799111222', 'Friend', 0),
  ('Sara Noor',    '0700333444', 'Work',   0);
