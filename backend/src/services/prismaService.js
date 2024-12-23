const prisma = require('../config/prismaClient');

class PrismaService {
    constructor(model) {
        this.model = prisma[model];
    }

    async create(data) {
        return await this.model.create({ data });
    }

    async findById(id) {
        return await this.model.findUnique({ where: { id } });
    }

    async findAll() {
        return await this.model.findMany();
    }

    async update(id, data) {
        return await this.model.update({ where: { id }, data });
    }

    async delete(id) {
        return await this.model.delete({ where: { id } });
    }
}

module.exports = PrismaService;