export const jwtConstants = {
  secret: process.env.JWT_SECRET || 'jwt_super_secret_key',
  expiresIn: '7d',
};