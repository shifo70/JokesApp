// Registration Number: YOUR_REGISTRATION_NUMBER
// ← Replace YOUR_REGISTRATION_NUMBER with your real student registration number.

require('dotenv').config();
const express = require('express');
const cors = require('cors');
const contactRoutes = require('./routes/contacts');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/', (_req, res) => {
  res.json({ message: 'Contact Book API is running.' });
});

app.use('/contacts', contactRoutes);

app.use((_req, res) => {
  res.status(404).json({ message: 'Endpoint not found.' });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
