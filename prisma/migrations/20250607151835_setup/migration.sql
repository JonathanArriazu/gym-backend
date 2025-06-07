/*
  Warnings:

  - You are about to drop the column `contactoMadre` on the `Alumna` table. All the data in the column will be lost.
  - You are about to drop the column `contactoPadre` on the `Alumna` table. All the data in the column will be lost.
  - You are about to drop the column `createdAt` on the `Alumna` table. All the data in the column will be lost.
  - You are about to drop the column `nombre` on the `Alumna` table. All the data in the column will be lost.
  - You are about to drop the column `pagoSeguro` on the `Alumna` table. All the data in the column will be lost.
  - You are about to drop the column `direccion` on the `Profesor` table. All the data in the column will be lost.
  - You are about to drop the column `email` on the `Profesor` table. All the data in the column will be lost.
  - You are about to drop the column `experiencia` on the `Profesor` table. All the data in the column will be lost.
  - You are about to drop the column `nombre` on the `Profesor` table. All the data in the column will be lost.
  - You are about to drop the column `telefono` on the `Profesor` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[usuarioId]` on the table `Alumna` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[usuarioId]` on the table `Profesor` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `nivel` to the `Alumna` table without a default value. This is not possible if the table is not empty.
  - Added the required column `usuarioId` to the `Alumna` table without a default value. This is not possible if the table is not empty.
  - Added the required column `experienciaAnios` to the `Profesor` table without a default value. This is not possible if the table is not empty.
  - Added the required column `horariosDisponibles` to the `Profesor` table without a default value. This is not possible if the table is not empty.
  - Added the required column `usuarioId` to the `Profesor` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "Rol" AS ENUM ('ADMIN', 'PROFESOR', 'ALUMNA');

-- AlterTable
ALTER TABLE "Alumna" DROP COLUMN "contactoMadre",
DROP COLUMN "contactoPadre",
DROP COLUMN "createdAt",
DROP COLUMN "nombre",
DROP COLUMN "pagoSeguro",
ADD COLUMN     "nivel" TEXT NOT NULL,
ADD COLUMN     "nombreMadre" TEXT,
ADD COLUMN     "nombrePadre" TEXT,
ADD COLUMN     "seguroPagado" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "usuarioId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "Profesor" DROP COLUMN "direccion",
DROP COLUMN "email",
DROP COLUMN "experiencia",
DROP COLUMN "nombre",
DROP COLUMN "telefono",
ADD COLUMN     "experienciaAnios" INTEGER NOT NULL,
ADD COLUMN     "horariosDisponibles" TEXT NOT NULL,
ADD COLUMN     "usuarioId" INTEGER NOT NULL;

-- CreateTable
CREATE TABLE "Usuario" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "telefono" TEXT NOT NULL,
    "direccion" TEXT NOT NULL,
    "rol" "Rol" NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Usuario_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SeguroMedico" (
    "id" SERIAL NOT NULL,
    "alumnaId" INTEGER NOT NULL,
    "dni" TEXT NOT NULL,
    "fechaPago" TIMESTAMP(3) NOT NULL,
    "numeroPoliza" TEXT NOT NULL,
    "vigenciaDesde" TIMESTAMP(3) NOT NULL,
    "vigenciaHasta" TIMESTAMP(3) NOT NULL,
    "observaciones" TEXT,

    CONSTRAINT "SeguroMedico_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Competencia" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "fechaLimiteInscripcion" TIMESTAMP(3) NOT NULL,
    "fechaCompetencia" TIMESTAMP(3) NOT NULL,
    "lugar" TEXT NOT NULL,
    "direccion" TEXT NOT NULL,
    "categoria" TEXT NOT NULL,
    "nivel" TEXT NOT NULL,
    "descripcion" TEXT,

    CONSTRAINT "Competencia_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AlumnaCompetencia" (
    "id" SERIAL NOT NULL,
    "alumnaId" INTEGER NOT NULL,
    "competenciaId" INTEGER NOT NULL,
    "resultado" TEXT,

    CONSTRAINT "AlumnaCompetencia_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Usuario_email_key" ON "Usuario"("email");

-- CreateIndex
CREATE UNIQUE INDEX "SeguroMedico_alumnaId_key" ON "SeguroMedico"("alumnaId");

-- CreateIndex
CREATE UNIQUE INDEX "AlumnaCompetencia_alumnaId_competenciaId_key" ON "AlumnaCompetencia"("alumnaId", "competenciaId");

-- CreateIndex
CREATE UNIQUE INDEX "Alumna_usuarioId_key" ON "Alumna"("usuarioId");

-- CreateIndex
CREATE UNIQUE INDEX "Profesor_usuarioId_key" ON "Profesor"("usuarioId");

-- AddForeignKey
ALTER TABLE "Profesor" ADD CONSTRAINT "Profesor_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Alumna" ADD CONSTRAINT "Alumna_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "Usuario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SeguroMedico" ADD CONSTRAINT "SeguroMedico_alumnaId_fkey" FOREIGN KEY ("alumnaId") REFERENCES "Alumna"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AlumnaCompetencia" ADD CONSTRAINT "AlumnaCompetencia_alumnaId_fkey" FOREIGN KEY ("alumnaId") REFERENCES "Alumna"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AlumnaCompetencia" ADD CONSTRAINT "AlumnaCompetencia_competenciaId_fkey" FOREIGN KEY ("competenciaId") REFERENCES "Competencia"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
