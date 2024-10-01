// controllers/favoriteSetController.js

const { pool } = require('../config');

const getFavoriteSets = async (req, res) => {
  const userId = req.params.userId;

  try {
    const result = await pool.query(
      'SELECT * FROM Favorite_Set WHERE user_id = $1',
      [userId]
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
};

const createFavoriteSet = async (req, res) => {
  const userId = req.params.userId;
  const { name } = req.body;

  try {
    const result = await pool.query(
      'INSERT INTO Favorite_Set (user_id, name) VALUES ($1, $2) RETURNING *',
      [userId, name]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
};

const updateFavoriteSet = async (req, res) => {
  const userId = req.params.userId;
  const setId = req.params.setId;
  const { name } = req.body;

  try {
    await pool.query(
      'UPDATE Favorite_Set SET name = $1 WHERE set_id = $2 AND user_id = $3',
      [name, setId, userId]
    );
    res.sendStatus(200);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
};

const deleteFavoriteSet = async (req, res) => {
  const userId = req.params.userId;
  const setId = req.params.setId;

  try {
    await pool.query(
      'DELETE FROM Favorite_Set WHERE set_id = $1 AND user_id = $2',
      [setId, userId]
    );
    res.sendStatus(200);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
};

const getFavoriteSetRecipes = async (req, res) => {
  const setId = req.params.setId;

  try {
    const result = await pool.query(
      `
      SELECT Recipe.*
      FROM Favorite_Set_Recipe
      JOIN Recipe ON Favorite_Set_Recipe.recipe_id = Recipe.recipe_id
      WHERE Favorite_Set_Recipe.set_id = $1
      `,
      [setId]
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
};

const addRecipeToFavoriteSet = async (req, res) => {
  const setId = req.params.setId;
  const { recipe_id } = req.body;

  try {
    await pool.query(
      'INSERT INTO Favorite_Set_Recipe (set_id, recipe_id) VALUES ($1, $2) ON CONFLICT DO NOTHING',
      [setId, recipe_id]
    );
    res.sendStatus(200);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
};

const removeRecipeFromFavoriteSet = async (req, res) => {
  const setId = req.params.setId;
  const recipeId = req.params.recipeId;

  try {
    await pool.query(
      'DELETE FROM Favorite_Set_Recipe WHERE set_id = $1 AND recipe_id = $2',
      [setId, recipeId]
    );
    res.sendStatus(200);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
};

module.exports = {
  getFavoriteSets,
  createFavoriteSet,
  updateFavoriteSet,
  deleteFavoriteSet,
  getFavoriteSetRecipes,
  addRecipeToFavoriteSet,
  removeRecipeFromFavoriteSet,
};
