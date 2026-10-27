const express = require('express');
const pool = require('../config/db');
const { authenticate, requireCustomer } = require('../middleware/auth');

const router = express.Router();

/**
 * Book a room — the critical concurrency-safe logic:
 * Uses a transaction + SELECT ... FOR UPDATE to lock the room row,
 * so two simultaneous booking requests cannot both succeed.
 */
router.post('/', authenticate, requireCustomer, async (req, res) => {
  const { room_id } = req.body;
  const customerId = req.user.id;

  if (!room_id) {
    return res.status(400).json({ message: 'room_id is required.' });
  }

  const connection = await pool.getConnection();

  try {
    await connection.beginTransaction();

    const [rooms] = await connection.query(
      'SELECT id, name, status FROM rooms WHERE id = ? FOR UPDATE',
      [room_id]
    );

    if (rooms.length === 0) {
      await connection.rollback();
      return res.status(404).json({ message: 'Room not found.' });
    }

    const room = rooms[0];

    if (room.status !== 'available') {
      await connection.rollback();
      return res.status(400).json({
        message: `Room "${room.name}" is already occupied. Booking rejected.`,
      });
    }

    await connection.query(
      'UPDATE rooms SET status = ? WHERE id = ?',
      ['occupied', room_id]
    );

    const [bookingResult] = await connection.query(
      'INSERT INTO bookings (room_id, customer_id) VALUES (?, ?)',
      [room_id, customerId]
    );

    await connection.commit();

    res.status(201).json({
      message: `Room "${room.name}" booked successfully!`,
      booking: {
        id: bookingResult.insertId,
        room_id: parseInt(room_id, 10),
        customer_id: customerId,
        room_name: room.name,
      },
    });
  } catch (err) {
    await connection.rollback();
    console.error('Booking error:', err);
    res.status(500).json({ message: 'Failed to process booking.' });
  } finally {
    connection.release();
  }
});

module.exports = router;
