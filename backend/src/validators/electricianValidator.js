const Joi = require('joi');

const electricianValidator = Joi.object({
    name: Joi.string().required(),
    contactInfo: Joi.string().optional(),
});

module.exports = electricianValidator;