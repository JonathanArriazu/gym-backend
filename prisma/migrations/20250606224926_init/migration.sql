-- CreateTable
CREATE TABLE "Alumna" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "fechaNacimiento" TIMESTAMP(3) NOT NULL,
    "notasMedicas" TEXT,
    "claseId" INTEGER,
    "profesorId" INTEGER,
    "pagoSeguro" BOOLEAN NOT NULL DEFAULT false,
    "contactoPadre" TEXT,
    "telefonoPadre" TEXT,
    "contactoMadre" TEXT,
    "telefonoMadre" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Alumna_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Profesor" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "telefono" TEXT NOT NULL,
    "direccion" TEXT NOT NULL,
    "especialidad" TEXT NOT NULL,
    "experiencia" INTEGER NOT NULL,

    CONSTRAINT "Profesor_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Clase" (
    "id" SERIAL NOT NULL,
    "nombre" TEXT NOT NULL,
    "nivel" TEXT NOT NULL,
    "edadMinima" INTEGER NOT NULL,
    "edadMaxima" INTEGER NOT NULL,
    "descripcion" TEXT,
    "horario" TEXT NOT NULL,
    "capacidad" INTEGER NOT NULL,
    "profesorId" INTEGER NOT NULL,

    CONSTRAINT "Clase_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Alumna" ADD CONSTRAINT "Alumna_claseId_fkey" FOREIGN KEY ("claseId") REFERENCES "Clase"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Alumna" ADD CONSTRAINT "Alumna_profesorId_fkey" FOREIGN KEY ("profesorId") REFERENCES "Profesor"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Clase" ADD CONSTRAINT "Clase_profesorId_fkey" FOREIGN KEY ("profesorId") REFERENCES "Profesor"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
