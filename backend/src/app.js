const express = require('express');
const projectRoutes = require('./routes/projects');

const app = express();

// Middleware
app.use(express.json());

// Routes
app.use('/api/projects', projectRoutes);

module.exports = app;