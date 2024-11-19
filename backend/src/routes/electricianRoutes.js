const express = require('express');
const PrismaService = require('../services/prismaService');
const genericController = require('../controllers/genericController');
const electricianValidator = require('../validators/electricianValidator');

const electricianService = new PrismaService('electrician'); // 'electrician' matches the model in schema.prisma
const electricianController = genericController(electricianService, electricianValidator);

const router = express.Router();

router.post('/', electricianController.create);
router.get('/:id', electricianController.readById);
router.get('/', electricianController.readAll);
router.put('/:id', electricianController.update);
router.delete('/:id', electricianController.delete);

module.exports = router;