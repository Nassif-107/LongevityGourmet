// routes/users.js

const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const favoriteSetController = require('../controllers/favoriteSetController');

// User Allergens
router.get('/:userId/allergens', userController.getUserAllergens);
router.post('/:userId/allergens', userController.addUserAllergen);
router.delete('/:userId/allergens/:allergenId', userController.removeUserAllergen);

// Favorite Sets
router.get('/:userId/favoritesets', favoriteSetController.getFavoriteSets);
router.post('/:userId/favoritesets', favoriteSetController.createFavoriteSet);
router.put('/:userId/favoritesets/:setId', favoriteSetController.updateFavoriteSet);
router.delete('/:userId/favoritesets/:setId', favoriteSetController.deleteFavoriteSet);

// Favorite Set Recipes
router.get('/:userId/favoritesets/:setId/recipes', favoriteSetController.getFavoriteSetRecipes);
router.post('/:userId/favoritesets/:setId/recipes', favoriteSetController.addRecipeToFavoriteSet);
router.delete('/:userId/favoritesets/:setId/recipes/:recipeId', favoriteSetController.removeRecipeFromFavoriteSet);

module.exports = router;
