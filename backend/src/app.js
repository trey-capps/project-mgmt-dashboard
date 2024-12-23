const express = require('express');
const cors = require('cors');

// const projectRoutes = require('./routes/projectRoutes');
// const electricianRoutes = require('./routes/electricianRoutes');
// const customerRoutes = require('./routes/customerRoutes');

const app = express();

app.use(cors());

// Middleware
app.use(express.json());

// Routes
app.get('/b', (req, res) => {
    res.send({ message: 'B success!' });
});

app.get('/', (req, res) => {
    res.send({ message: 'Test Success!' });
});

// app.use('/projects', projectRoutes);
// app.use('/electricians', electricianRoutes);
// app.use('/customers', customerRoutes);

module.exports = app;