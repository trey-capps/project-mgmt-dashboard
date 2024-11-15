function genericController(service, validator) {
    return {
        create: async (req, res) => {
            try {
                const validatedData = await validator.validateAsync(req.body);
                const result = await service.create(validatedData);
                res.status(201).json(result);
            } catch (error) {
                res.status(400).json({ error: error.message });
            }
        },
        readById: async (req, res) => {
            try {
                const result = await service.findById(Number(req.params.id));
                if (!result) return res.status(404).json({ error: 'Not found' });
                res.json(result);
            } catch (error) {
                res.status(500).json({ error: error.message });
            }
        },
        readAll: async (req, res) => {
            try {
                const result = await service.findAll();
                res.json(result);
            } catch (error) {
                res.status(500).json({ error: error.message });
            }
        },
        update: async (req, res) => {
            try {
                const validatedData = await validator.validateAsync(req.body);
                const result = await service.update(Number(req.params.id), validatedData);
                res.json(result);
            } catch (error) {
                res.status(400).json({ error: error.message });
            }
        },
        delete: async (req, res) => {
            try {
                const result = await service.delete(Number(req.params.id));
                res.json(result);
            } catch (error) {
                res.status(500).json({ error: error.message });
            }
        },
    };
}

module.exports = genericController;