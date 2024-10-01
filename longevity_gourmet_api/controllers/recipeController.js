// controllers/recipeController.js

const { pool } = require('../config');

const getRecipes = async (req, res) => {
  const searchQuery = req.query.search || '';
  const userId = req.query.userId || 0;

  try {
    // Get user's allergens
    const userAllergensResult = await pool.query(
      'SELECT allergen_id FROM User_Allergen WHERE user_id = $1',
      [userId]
    );
    const userAllergenIds = userAllergensResult.rows.map(row => row.allergen_id);

    // Get ingredients that contain user's allergens
    let allergenIngredientIds = [];
    if (userAllergenIds.length > 0) {
      const allergenIngredientsResult = await pool.query(
        'SELECT DISTINCT ingredient_id FROM Allergen_Ingredient WHERE allergen_id = ANY($1::int[])',
        [userAllergenIds]
      );
      allergenIngredientIds = allergenIngredientsResult.rows.map(row => row.ingredient_id);
    }

    // Get recipes that do not contain ingredients with allergens
    let query = `
      SELECT DISTINCT Recipe.*
      FROM Recipe
      JOIN Recipe_Ingredient ON Recipe.recipe_id = Recipe_Ingredient.recipe_id
      WHERE Recipe.title ILIKE $1
    `;

    let values = [`%${searchQuery}%`];

    if (allergenIngredientIds.length > 0) {
      query += `
        AND Recipe.recipe_id NOT IN (
          SELECT recipe_id FROM Recipe_Ingredient WHERE ingredient_id = ANY($2::int[])
        )
      `;
      values.push(allergenIngredientIds);
    }

    const recipesResult = await pool.query(query, values);
    res.json(recipesResult.rows);
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
};

const getRecipeById = async (req, res) => {
  const recipeId = req.params.id;

  try {
    // Get recipe details
    const recipeResult = await pool.query('SELECT * FROM Recipe WHERE recipe_id = $1', [recipeId]);
    const recipe = recipeResult.rows[0];

    if (!recipe) {
      return res.status(404).send('Recipe not found');
    }

    // Get recipe steps
    const stepsResult = await pool.query(
      'SELECT * FROM Recipe_Step WHERE recipe_id = $1 ORDER BY step_number',
      [recipeId]
    );

    // Get recipe ingredients
    const ingredientsResult = await pool.query(
      `
      SELECT Ingredient.*, Recipe_Ingredient.quantity, Recipe_Ingredient.unit
      FROM Recipe_Ingredient
      JOIN Ingredient ON Recipe_Ingredient.ingredient_id = Ingredient.ingredient_id
      WHERE Recipe_Ingredient.recipe_id = $1
      `,
      [recipeId]
    );

    res.json({
      ...recipe,
      steps: stepsResult.rows,
      ingredients: ingredientsResult.rows,
    });
  } catch (err) {
    console.error(err);
    res.status(500).send('Server error');
  }
};

module.exports = {
  getRecipes,
  getRecipeById,
};
