/*
  Warnings:

  - You are about to drop the `Alumna` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `AlumnaCompetencia` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Clase` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Competencia` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Profesor` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `SeguroMedico` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Usuario` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'PROFESSOR', 'STUDENT');

-- DropForeignKey
ALTER TABLE "Alumna" DROP CONSTRAINT "Alumna_claseId_fkey";

-- DropForeignKey
ALTER TABLE "Alumna" DROP CONSTRAINT "Alumna_profesorId_fkey";

-- DropForeignKey
ALTER TABLE "Alumna" DROP CONSTRAINT "Alumna_usuarioId_fkey";

-- DropForeignKey
ALTER TABLE "AlumnaCompetencia" DROP CONSTRAINT "AlumnaCompetencia_alumnaId_fkey";

-- DropForeignKey
ALTER TABLE "AlumnaCompetencia" DROP CONSTRAINT "AlumnaCompetencia_competenciaId_fkey";

-- DropForeignKey
ALTER TABLE "Clase" DROP CONSTRAINT "Clase_profesorId_fkey";

-- DropForeignKey
ALTER TABLE "Profesor" DROP CONSTRAINT "Profesor_usuarioId_fkey";

-- DropForeignKey
ALTER TABLE "SeguroMedico" DROP CONSTRAINT "SeguroMedico_alumnaId_fkey";

-- DropTable
DROP TABLE "Alumna";

-- DropTable
DROP TABLE "AlumnaCompetencia";

-- DropTable
DROP TABLE "Clase";

-- DropTable
DROP TABLE "Competencia";

-- DropTable
DROP TABLE "Profesor";

-- DropTable
DROP TABLE "SeguroMedico";

-- DropTable
DROP TABLE "Usuario";

-- DropEnum
DROP TYPE "Rol";

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "role" "Role" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Professor" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "specialty" TEXT NOT NULL,
    "yearsOfExperience" INTEGER NOT NULL,
    "availableSchedules" TEXT NOT NULL,

    CONSTRAINT "Professor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Class" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "level" TEXT NOT NULL,
    "minAge" INTEGER NOT NULL,
    "maxAge" INTEGER NOT NULL,
    "description" TEXT,
    "schedule" TEXT NOT NULL,
    "capacity" INTEGER NOT NULL,
    "professorId" INTEGER NOT NULL,

    CONSTRAINT "Class_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Student" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "birthDate" TIMESTAMP(3) NOT NULL,
    "level" TEXT NOT NULL,
    "medicalNotes" TEXT,
    "classId" INTEGER,
    "professorId" INTEGER,
    "insurancePaid" BOOLEAN NOT NULL DEFAULT false,
    "fatherName" TEXT,
    "fatherPhone" TEXT,
    "motherName" TEXT,
    "motherPhone" TEXT,

    CONSTRAINT "Student_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "MedicalInsurance" (
    "id" SERIAL NOT NULL,
    "studentId" INTEGER NOT NULL,
    "dni" TEXT NOT NULL,
    "paymentDate" TIMESTAMP(3) NOT NULL,
    "policyNumber" TEXT NOT NULL,
    "validFrom" TIMESTAMP(3) NOT NULL,
    "validUntil" TIMESTAMP(3) NOT NULL,
    "notes" TEXT,

    CONSTRAINT "MedicalInsurance_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Competition" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "registrationDeadline" TIMESTAMP(3) NOT NULL,
    "competitionDate" TIMESTAMP(3) NOT NULL,
    "location" TEXT NOT NULL,
    "address" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "level" TEXT NOT NULL,
    "description" TEXT,

    CONSTRAINT "Competition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StudentCompetition" (
    "id" SERIAL NOT NULL,
    "studentId" INTEGER NOT NULL,
    "competitionId" INTEGER NOT NULL,
    "result" TEXT,

    CONSTRAINT "StudentCompetition_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Professor_userId_key" ON "Professor"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Student_userId_key" ON "Student"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "MedicalInsurance_studentId_key" ON "MedicalInsurance"("studentId");

-- CreateIndex
CREATE UNIQUE INDEX "StudentCompetition_studentId_competitionId_key" ON "StudentCompetition"("studentId", "competitionId");

-- AddForeignKey
ALTER TABLE "Professor" ADD CONSTRAINT "Professor_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Class" ADD CONSTRAINT "Class_professorId_fkey" FOREIGN KEY ("professorId") REFERENCES "Professor"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Student" ADD CONSTRAINT "Student_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Student" ADD CONSTRAINT "Student_classId_fkey" FOREIGN KEY ("classId") REFERENCES "Class"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Student" ADD CONSTRAINT "Student_professorId_fkey" FOREIGN KEY ("professorId") REFERENCES "Professor"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MedicalInsurance" ADD CONSTRAINT "MedicalInsurance_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES "Student"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentCompetition" ADD CONSTRAINT "StudentCompetition_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES "Student"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StudentCompetition" ADD CONSTRAINT "StudentCompetition_competitionId_fkey" FOREIGN KEY ("competitionId") REFERENCES "Competition"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
