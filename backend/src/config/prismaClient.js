const { PrismaClient } = require('@prisma/client');
require('dotenv').config(); // Load environment variables

const prisma = new PrismaClient({
  datasources: {
    db: {
      url: process.env.DATABASE_URL, // Use the DATABASE_URL from the .env file
    },
  },
});

module.exports = prisma;