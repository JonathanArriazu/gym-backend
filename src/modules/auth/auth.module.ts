import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { JwtModule } from '@nestjs/jwt';
import { jwtConstants } from 'src/config/jwt';
import { AuthService } from './auth.service';
import { UsersModule } from '../users/users.module';
import { PrismaModule } from 'src/common/prisma/prisma.module';

@Module({
  imports: [
    JwtModule.register({
      secret: jwtConstants.secret,
      signOptions: { expiresIn: jwtConstants.expiresIn },
    }),
    UsersModule,
    PrismaModule,
  ],
  providers: [AuthService],
  controllers: [AuthController],
})
export class AuthModule {}
