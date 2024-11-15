-- CreateTable
CREATE TABLE "Project" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "wws_pm" TEXT,
    "completionDate" TIMESTAMP(3),
    "status" TEXT NOT NULL,
    "electricianId" INTEGER,
    "customerId" INTEGER,

    CONSTRAINT "Project_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Electrician" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "contactInfo" TEXT,

    CONSTRAINT "Electrician_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Customer" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "contactInfo" TEXT,

    CONSTRAINT "Customer_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Project" ADD CONSTRAINT "Project_electricianId_fkey" FOREIGN KEY ("electricianId") REFERENCES "Electrician"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Project" ADD CONSTRAINT "Project_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customer"("id") ON DELETE SET NULL ON UPDATE CASCADE;
