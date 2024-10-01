// routes/allergens.js

const express = require('express');
const router = express.Router();
const allergenController = require('../controllers/allergenController');

router.get('/', allergenController.getAllAllergens);

module.exports = router;
