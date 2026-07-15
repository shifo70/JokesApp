const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'room_booking_secret_key_change_in_production';

function authenticate(req, res, next) {
  const authHeader = req.headers.authorization;
  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'Access denied. No token provided.' });
  }

  const token = authHeader.split(' ')[1];
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded;
    next();
  } catch {
    return res.status(401).json({ message: 'Invalid or expired token.' });
  }
}

function requireAdmin(req, res, next) {
  if (req.user.role !== 'admin') {
    return res.status(403).json({ message: 'Admin access required.' });
  }
  next();
}

function requireCustomer(req, res, next) {
  if (req.user.role !== 'customer') {
    return res.status(403).json({ message: 'Customer access required.' });
  }
  next();
}

module.exports = { authenticate, requireAdmin, requireCustomer, JWT_SECRET };
