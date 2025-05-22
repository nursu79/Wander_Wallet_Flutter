# Prisma Setup Instructions

1. Generate Prisma Client:
   ```bash
   npx prisma generate
   ```
2. Run Database Migrations:
   ```bash
   npx prisma migrate dev --name init
   ```
3. (Optional) Seed the Database:
   ```bash
   npx prisma db seed
   ``` 