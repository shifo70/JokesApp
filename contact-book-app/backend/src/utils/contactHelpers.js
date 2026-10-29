const VALID_CATEGORIES = ['Family', 'Friend', 'Work'];

/** Phone must be exactly 10 digits and start with 07 */
function normalizePhone(phone) {
  return String(phone ?? '').trim().replace(/\s+/g, '');
}

function validatePhone(phone) {
  const normalized = normalizePhone(phone);
  if (!/^07\d{8}$/.test(normalized)) {
    return {
      ok: false,
      message:
        'Phone number must be exactly 10 digits and start with 07 (e.g. 0788123456).',
    };
  }
  return { ok: true, phone: normalized };
}

function validateCategory(category) {
  if (!VALID_CATEGORIES.includes(category)) {
    return {
      ok: false,
      message: 'Category must be one of: Family, Friend, Work.',
    };
  }
  return { ok: true };
}

/**
 * display_tag is NEVER stored in the database.
 * Calculated every time contacts are returned:
 *   favorite  → "* " + category   e.g. "* Family"
 *   not favorite → category       e.g. "Work"
 */
function withDisplayTag(contact) {
  const favorite = contact.is_favorite === 1 || contact.is_favorite === true;
  return {
    id: contact.id,
    full_name: contact.full_name,
    phone_number: contact.phone_number,
    category: contact.category,
    is_favorite: favorite,
    display_tag: favorite ? `* ${contact.category}` : contact.category,
  };
}

module.exports = {
  VALID_CATEGORIES,
  normalizePhone,
  validatePhone,
  validateCategory,
  withDisplayTag,
};
