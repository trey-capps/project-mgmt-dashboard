const express = require('express');
const Joi = require('joi');
const {
  getAllProjects,
  createProject,
  updateProject,
  deleteProject,
} = require('../controllers/projectController');

const router = express.Router();

// Validation schema
const projectSchema = Joi.object({
  name: Joi.string().min(3).max(100).required(),
  description: Joi.string().max(500).optional(),
  start_date: Joi.date().required(),
  end_date: Joi.date().required(),
  budget: Joi.number().positive().required(),
});

// Routes
router.get('/', getAllProjects);

router.post('/', async (req, res, next) => {
  const { error } = projectSchema.validate(req.body);
  if (error) return res.status(400).json({ error: error.details[0].message });
  next();
}, createProject);

router.put('/:id', async (req, res, next) => {
  const { error } = projectSchema.validate(req.body);
  if (error) return res.status(400).json({ error: error.details[0].message });
  next();
}, updateProject);

router.delete('/:id', deleteProject);

module.exports = router;