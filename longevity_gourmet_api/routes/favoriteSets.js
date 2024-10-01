// routes/favoriteSets.js

const express = require('express');
const router = express.Router();
const favoriteSetController = require('../controllers/favoriteSetController');

// Routes without userId in the path (Not recommended unless you adjust your controllers)

router.get('/:setId/recipes', favoriteSetController.getFavoriteSetRecipes);
router.post('/:setId/recipes', favoriteSetController.addRecipeToFavoriteSet);
router.delete('/:setId/recipes/:recipeId', favoriteSetController.removeRecipeFromFavoriteSet);

module.exports = router;
