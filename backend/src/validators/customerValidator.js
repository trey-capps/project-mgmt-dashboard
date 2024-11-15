const Joi = require('joi');

const customerValidator = Joi.object({
    name: Joi.string().required(),
    contactInfo: Joi.string().optional(),
});

module.exports = customerValidator;