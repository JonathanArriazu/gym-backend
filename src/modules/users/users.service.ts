import { BadRequestException, ConflictException, Injectable } from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { PrismaService } from 'src/common/prisma/prisma.service';
import { PaginationArgs } from 'src/common/dto/pagination.dto';
import { paginate } from 'src/common/pagination/pagination.utils';
import { Prisma } from '@prisma/client';
import * as bcrypt from 'bcrypt';

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

    const hashedPassword = await bcrypt.hash(data.password, 10);

    return this.prisma.user.create({
      data: {
        ...data,
        password: hashedPassword,
      },
    });
  }

  async findAll({ search, page = 1, limit = 10 }: PaginationArgs) {
  
  const where: Prisma.UserWhereInput = {
    isDeleted: false,
    OR: search
      ? [
          { email: { contains: search, mode: Prisma.QueryMode.insensitive } },
          { name: { contains: search, mode: Prisma.QueryMode.insensitive } },
        ]
      : undefined,
  };

  return paginate(this.prisma.user, page, limit, where, { createdAt: 'desc' });
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
