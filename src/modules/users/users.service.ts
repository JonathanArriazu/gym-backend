import { ConflictException, Injectable } from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { PrismaService } from 'src/common/prisma/prisma.service';

@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async create(data: CreateUserDto) {
    const existingUser = await this.prisma.user.findFirst({
    where: {
      email: data.email,
      isDeleted: false,
    },
  });

   if (existingUser) {
    throw new ConflictException('Ya existe un usuario con ese email');
  }

    return this.prisma.user.create({ data });
  }

  async findAll(search?: string) {
    return this.prisma.user.findMany({
      where: {
        isDeleted: false,
        OR: search
          ? [
              { email: { contains: search, mode: 'insensitive' } },
              { name: { contains: search, mode: 'insensitive' } },
            ]
          : undefined,
      },
    });
  }

  async findOne(id: number) {
    const user = await this.prisma.user.findUnique({ where: { id } });
    return user?.isDeleted ? null : user;
  }

  update(id: number, data: UpdateUserDto) {
    return this.prisma.user.update({ where: { id }, data });
  }

  async remove(id: number) {
  return this.prisma.user.update({
    where: { id },
    data: { isDeleted: true },
  });
}
}
