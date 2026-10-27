require('dotenv').config();
const bcrypt = require('bcryptjs');
const pool = require('./config/db');

async function seed() {
  try {
    const [existing] = await pool.query(
      "SELECT id FROM users WHERE email = 'admin@hotel.com'"
    );

    if (existing.length > 0) {
      console.log('Admin user already exists. Skipping seed.');
      process.exit(0);
    }

    const passwordHash = await bcrypt.hash('admin123', 10);
    await pool.query(
      'INSERT INTO users (name, email, password_hash, role) VALUES (?, ?, ?, ?)',
      ['Admin', 'admin@hotel.com', passwordHash, 'admin']
    );

    console.log('Admin user created successfully.');
    console.log('  Email:    admin@hotel.com');
    console.log('  Password: admin123');
    process.exit(0);
  } catch (err) {
    console.error('Seed failed:', err.message);
    process.exit(1);
  }
}

seed();
