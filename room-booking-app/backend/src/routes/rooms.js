const express = require('express');
const pool = require('../config/db');
const { authenticate, requireAdmin } = require('../middleware/auth');

const router = express.Router();

router.get('/', async (_req, res) => {
  try {
    const [rooms] = await pool.query(
      'SELECT id, name, price, status FROM rooms ORDER BY id ASC'
    );
    res.json(rooms);
  } catch (err) {
    console.error('Get rooms error:', err);
    res.status(500).json({ message: 'Failed to fetch rooms.' });
  }
});

router.post('/', authenticate, requireAdmin, async (req, res) => {
  const { name, price, status } = req.body;

  if (!name || price === undefined || price === null) {
    return res.status(400).json({ message: 'Room name and price are required.' });
  }

  const roomStatus = status || 'available';
  if (!['available', 'occupied'].includes(roomStatus)) {
    return res.status(400).json({ message: 'Status must be available or occupied.' });
  }

  try {
    const [result] = await pool.query(
      'INSERT INTO rooms (name, price, status) VALUES (?, ?, ?)',
      [name, price, roomStatus]
    );

    res.status(201).json({
      message: 'Room created successfully.',
      room: { id: result.insertId, name, price, status: roomStatus },
    });
  } catch (err) {
    console.error('Create room error:', err);
    res.status(500).json({ message: 'Failed to create room.' });
  }
});

router.put('/:id', authenticate, requireAdmin, async (req, res) => {
  const { id } = req.params;
  const { name, price, status } = req.body;

  if (!name || price === undefined || price === null || !status) {
    return res.status(400).json({ message: 'Name, price, and status are required.' });
  }

  if (!['available', 'occupied'].includes(status)) {
    return res.status(400).json({ message: 'Status must be available or occupied.' });
  }

  try {
    const [result] = await pool.query(
      'UPDATE rooms SET name = ?, price = ?, status = ? WHERE id = ?',
      [name, price, status, id]
    );

    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Room not found.' });
    }

    res.json({
      message: 'Room updated successfully.',
      room: { id: parseInt(id, 10), name, price, status },
    });
  } catch (err) {
    console.error('Update room error:', err);
    res.status(500).json({ message: 'Failed to update room.' });
  }
});

module.exports = router;
