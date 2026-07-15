const express = require('express');
const pool = require('../config/db');
const {
  validatePhone,
  validateCategory,
  withDisplayTag,
} = require('../utils/contactHelpers');

const router = express.Router();

/** GET /contacts — list all (display_tag calculated, never stored) */
router.get('/', async (_req, res) => {
  try {
    const [rows] = await pool.query(
      'SELECT id, full_name, phone_number, category, is_favorite FROM contacts ORDER BY is_favorite DESC, full_name ASC'
    );
    res.json(rows.map(withDisplayTag));
  } catch (err) {
    console.error('List contacts error:', err);
    res.status(500).json({ message: 'Failed to fetch contacts.', detail: err.message });
  }
});

/**
 * GET /contacts/search?category=Family
 * Must be registered BEFORE /:id routes.
 */
router.get('/search', async (req, res) => {
  const { category } = req.query;
  const catCheck = validateCategory(category);
  if (!catCheck.ok) {
    return res.status(400).json({ message: catCheck.message });
  }

  try {
    const [rows] = await pool.query(
      'SELECT id, full_name, phone_number, category, is_favorite FROM contacts WHERE category = ? ORDER BY is_favorite DESC, full_name ASC',
      [category]
    );
    res.json(rows.map(withDisplayTag));
  } catch (err) {
    console.error('Search contacts error:', err);
    res.status(500).json({ message: 'Failed to search contacts.', detail: err.message });
  }
});

/** POST /contacts — add contact */
router.post('/', async (req, res) => {
  if (!req.body || typeof req.body !== 'object') {
    return res.status(400).json({ message: 'Request body must be JSON.' });
  }

  const { full_name, phone_number, category, is_favorite } = req.body;

  if (!full_name || !String(full_name).trim()) {
    return res.status(400).json({ message: 'Full name is required.' });
  }

  const phoneCheck = validatePhone(phone_number);
  if (!phoneCheck.ok) {
    return res.status(400).json({ message: phoneCheck.message });
  }

  const catCheck = validateCategory(category);
  if (!catCheck.ok) {
    return res.status(400).json({ message: catCheck.message });
  }

  const favorite = is_favorite === true || is_favorite === 1 || is_favorite === '1';

  try {
    const [existing] = await pool.query(
      'SELECT id FROM contacts WHERE phone_number = ?',
      [phoneCheck.phone]
    );
    if (existing.length > 0) {
      return res.status(409).json({
        message: `Phone ${phoneCheck.phone} is already saved. Use a different number.`,
      });
    }

    const [result] = await pool.query(
      'INSERT INTO contacts (full_name, phone_number, category, is_favorite) VALUES (?, ?, ?, ?)',
      [String(full_name).trim(), phoneCheck.phone, category, favorite ? 1 : 0]
    );

    const contact = withDisplayTag({
      id: result.insertId,
      full_name: String(full_name).trim(),
      phone_number: phoneCheck.phone,
      category,
      is_favorite: favorite,
    });

    console.log('Created contact:', contact);
    res.status(201).json({ message: 'Contact saved successfully.', contact });
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({
        message: `Phone ${phoneCheck.phone} is already saved. Use a different number.`,
      });
    }
    console.error('Create contact error:', err);
    res.status(500).json({
      message: 'Failed to create contact. Check MySQL connection / .env password.',
      detail: err.message,
    });
  }
});

/** PUT /contacts/:id — edit contact */
router.put('/:id', async (req, res) => {
  const { id } = req.params;
  const { full_name, phone_number, category, is_favorite } = req.body;

  if (!full_name || !String(full_name).trim()) {
    return res.status(400).json({ message: 'Full name is required.' });
  }

  const phoneCheck = validatePhone(phone_number);
  if (!phoneCheck.ok) {
    return res.status(400).json({ message: phoneCheck.message });
  }

  const catCheck = validateCategory(category);
  if (!catCheck.ok) {
    return res.status(400).json({ message: catCheck.message });
  }

  const favorite = is_favorite === true || is_favorite === 1 || is_favorite === '1';

  try {
    const [dup] = await pool.query(
      'SELECT id FROM contacts WHERE phone_number = ? AND id <> ?',
      [phoneCheck.phone, id]
    );
    if (dup.length > 0) {
      return res.status(409).json({
        message: `Phone ${phoneCheck.phone} is already saved. Use a different number.`,
      });
    }

    const [result] = await pool.query(
      'UPDATE contacts SET full_name = ?, phone_number = ?, category = ?, is_favorite = ? WHERE id = ?',
      [String(full_name).trim(), phoneCheck.phone, category, favorite ? 1 : 0, id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Contact not found.' });
    }

    const contact = withDisplayTag({
      id: parseInt(id, 10),
      full_name: String(full_name).trim(),
      phone_number: phoneCheck.phone,
      category,
      is_favorite: favorite,
    });

    res.json({ message: 'Contact updated successfully.', contact });
  } catch (err) {
    if (err.code === 'ER_DUP_ENTRY') {
      return res.status(409).json({
        message: `Phone ${phoneCheck.phone} is already saved. Use a different number.`,
      });
    }
    console.error('Update contact error:', err);
    res.status(500).json({ message: 'Failed to update contact.', detail: err.message });
  }
});

/** DELETE /contacts/:id */
router.delete('/:id', async (req, res) => {
  try {
    const [result] = await pool.query('DELETE FROM contacts WHERE id = ?', [
      req.params.id,
    ]);
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Contact not found.' });
    }
    res.json({ message: 'Contact deleted successfully.' });
  } catch (err) {
    console.error('Delete contact error:', err);
    res.status(500).json({ message: 'Failed to delete contact.', detail: err.message });
  }
});

module.exports = router;
