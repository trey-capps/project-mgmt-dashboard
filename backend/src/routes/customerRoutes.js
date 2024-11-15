const express = require('express');
const PrismaService = require('../services/prismaService');
const genericController = require('../controllers/genericController');
const customerValidator = require('../validators/customerValidator');

const customerService = new PrismaService('customer'); // 'customer' matches the model in schema.prisma
const customerController = genericController(customerService, customerValidator);

const router = express.Router();

router.post('/', customerController.create);
router.get('/:id', customerController.readById);
router.get('/', customerController.readAll);
router.put('/:id', customerController.update);
router.delete('/:id', customerController.delete);

module.exports = router;