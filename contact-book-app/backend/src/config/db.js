require('dotenv').config();
const mysql = require('mysql2/promise');

async function ensureDatabase() {
  const host = process.env.DB_HOST || 'localhost';
  const port = parseInt(process.env.DB_PORT || '3306', 10);
  const user = process.env.DB_USER || 'root';
  const password = process.env.DB_PASSWORD || '';
  const database = process.env.DB_NAME || 'contact_book_db';

  // Connect without DB first so we can create it if missing
  const bootstrap = await mysql.createConnection({ host, port, user, password });
  await bootstrap.query(
    `CREATE DATABASE IF NOT EXISTS \`${database}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci`
  );
  await bootstrap.end();

  const pool = mysql.createPool({
    host,
    port,
    user,
    password,
    database,
    waitForConnections: true,
    connectionLimit: 10,
  });

  await pool.query(`
    CREATE TABLE IF NOT EXISTS contacts (
      id           INT AUTO_INCREMENT PRIMARY KEY,
      full_name    VARCHAR(150) NOT NULL,
      phone_number VARCHAR(20)  NOT NULL,
      category     ENUM('Family', 'Friend', 'Work') NOT NULL,
      is_favorite  TINYINT(1)   NOT NULL DEFAULT 0,
      created_at   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
      UNIQUE KEY uq_phone (phone_number)
    )
  `);

  return pool;
}

let poolPromise = null;

function getPool() {
  if (!poolPromise) {
    poolPromise = ensureDatabase();
  }
  return poolPromise;
}

module.exports = {
  query: async (...args) => {
    const pool = await getPool();
    return pool.query(...args);
  },
  getConnection: async () => {
    const pool = await getPool();
    return pool.getConnection();
  },
  init: getPool,
};
