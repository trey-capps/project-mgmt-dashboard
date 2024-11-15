const express = require('express');
const projectRoutes = require('./routes/projects');
const cors = require('cors')


const app = express();
app.use(cors());

// Middleware
app.use(express.json());

// Routes
app.use('/api/projects', projectRoutes);

module.exports = app;