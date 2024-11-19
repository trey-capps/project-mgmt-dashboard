const express = require('express');
const PrismaService = require('../services/prismaService');
const genericController = require('../controllers/genericController');
const projectValidator = require('../validators/projectValidator');

const projectService = new PrismaService('project');
const projectController = genericController(projectService, projectValidator);

const router = express.Router();

router.post('/', projectController.create);
router.get('/:id', projectController.readById);
router.get('/', projectController.readAll);
router.put('/:id', projectController.update);
router.delete('/:id', projectController.delete);

module.exports = router;