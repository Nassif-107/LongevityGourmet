// controllers/userController.js

const { pool } = require('../config');

const getUserAllergens = async (req, res) => {
  const userId = req.params.userId;

  try {
    const result = await pool.query(
      `
      SELECT Allergen.*
      FROM User_Allergen
      JOIN Allergen ON User_Allergen.allergen_id = Allergen.allergen_id
      WHERE User_Allergen.user_id = $1
      `,
      [userId]
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
};

const addUserAllergen = async (req, res) => {
  const userId = req.params.userId;
  const { allergen_id } = req.body;

  try {
    await pool.query(
      'INSERT INTO User_Allergen (user_id, allergen_id) VALUES ($1, $2) ON CONFLICT DO NOTHING',
      [userId, allergen_id]
    );
    res.sendStatus(200);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
};

const removeUserAllergen = async (req, res) => {
  const userId = req.params.userId;
  const allergenId = req.params.allergenId;

  try {
    await pool.query(
      'DELETE FROM User_Allergen WHERE user_id = $1 AND allergen_id = $2',
      [userId, allergenId]
    );
    res.sendStatus(200);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
};

module.exports = {
  getUserAllergens,
  addUserAllergen,
  removeUserAllergen,
};
