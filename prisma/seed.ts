import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  const email = 'admin@gym.com';
  const plainPassword = 'Pass1234';

  const hashedPassword = await bcrypt.hash(plainPassword, 10);

  const existing = await prisma.user.findUnique({ where: { email } });

  if (existing) {
    console.log('🔁 El usuario admin ya existe. Saltando...');
    return;
  }

  await prisma.user.create({
    data: {
      name: 'Admin',
      email,
      password: hashedPassword,
      role: 'ADMIN',
      phone: '1234567890',
      address: 'Av. Ejemplo 123',
    },
  });

  console.log('✅ Admin creado correctamente!');
}

main()
  .catch(e => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => {
    prisma.$disconnect();
  });
