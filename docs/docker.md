# Docker Setup

Run the local stack with MongoDB, backend, and admin web:

```powershell
docker-compose up --build
```

Services:

- Backend API: `http://localhost:5000/api/v1`
- Admin web: `http://localhost:5174`
- MongoDB: `mongodb://localhost:27017/pet-booking`

The backend container reads environment variables from `backend/.env.docker`.
The admin web receives its API URL at build time from `VITE_API_BASE_URL`.

For LAN testing, build with your machine IP:

```powershell
$env:VITE_API_BASE_URL="http://192.168.1.29:5000/api/v1"
docker-compose up --build
```

Seed an admin account into the Docker MongoDB:

```powershell
docker-compose --profile tools run --rm seed_admin
```

Default admin credentials:

```text
email: admin@pawcare.local
password: Admin@123456
```

Override the seed credentials:

```powershell
$env:ADMIN_EMAIL="trung@admin.com"
$env:ADMIN_PASSWORD="Admin@123456"
docker-compose --profile tools run --rm seed_admin
```

Notes:

- Mongo data is persisted in the `mongo_data` Docker volume.
- Firebase service account files are not committed. If notification features need Firebase inside Docker, place `serviceAccountKey.json` in `backend/src/firebase/`.
- This machine currently supports the legacy `docker-compose` command. If your Docker Desktop supports the newer plugin, `docker compose ...` works with the same arguments.
- Stop the stack with `docker-compose down`.
- Stop and delete Mongo data with `docker-compose down -v`.
