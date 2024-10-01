// controllers/allergenController.js

const { pool } = require('../config');

const getAllAllergens = async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM allergen');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
};

module.exports = {
  getAllAllergens,
};
