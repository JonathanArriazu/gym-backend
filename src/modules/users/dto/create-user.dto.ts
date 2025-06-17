import { IsEmail, IsEnum, IsNotEmpty, IsString, MinLength } from 'class-validator';

enum Role {
  ADMIN = 'ADMIN',
  PROFESSOR = 'PROFESSOR',
  STUDENT = 'STUDENT',
}

export class CreateUserDto {
	@IsString()
  @IsNotEmpty()
  name: string;

  @IsEmail()
	@IsNotEmpty()
  email: string;

  @IsString()
  @MinLength(6)
  password: string;

  @IsString()
  @IsNotEmpty()
  phone: string;

  @IsString()
  @IsNotEmpty()
  address: string;

  @IsEnum(Role)
  role: Role;
}
