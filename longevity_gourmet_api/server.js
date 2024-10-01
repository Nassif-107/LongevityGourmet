// server.js

const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');

// Import routes
const recipeRoutes = require('./routes/recipes');
const allergenRoutes = require('./routes/allergens');
const userRoutes = require('./routes/users');
const favoriteSetRoutes = require('./routes/favoriteSets');

const app = express();
const port = 3000;

app.use(bodyParser.json());
app.use(cors());

// Use routes
app.use('/recipes', recipeRoutes);
app.use('/allergens', allergenRoutes);
app.use('/users', userRoutes);
app.use('/favoritesets', favoriteSetRoutes);

// Default route
app.get('/', (req, res) => {
  res.send('Longevity Gourmet API Server');
});

app.listen(port, '0.0.0.0', () => {
  console.log(`Server is running on http://localhost:${port}`);
});
