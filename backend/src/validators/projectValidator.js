const Joi = require('joi');

const projectValidator = Joi.object({
    name: Joi.string().required(),
    address: Joi.string().required(),
    wws_pm: Joi.string().optional(),
    completionDate: Joi.date().optional(),
    status: Joi.string().valid('In Progress', 'Completed', 'On Hold').required(),
    electricianId: Joi.number().integer().optional(),
    customerId: Joi.number().integer().optional(),
});

module.exports = projectValidator;