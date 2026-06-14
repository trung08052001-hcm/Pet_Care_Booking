# PawSitive Care - Project Handover Documentation

> Last updated: 2026-06-14

## 1. Tong quan du an

PawSitive Care la he thong dat lich cham soc thu cung gom 3 phan chinh:

- Mobile app Flutter cho user.
- Backend REST API + WebSocket + FCM.
- Admin web ReactJS cho nhan vien/admin quan ly.

Muc tieu chinh cua he thong:

- User dang ky, dang nhap bang local, Google hoac Zalo.
- User quan ly ho so ca nhan, dia chi, thu cung.
- User dat lich dich vu cham soc thu cung.
- He thong chan trung khung gio dat lich.
- User va admin chat realtime.
- Backend gui push notification qua Firebase Cloud Messaging.
- Admin web xem booking, chat voi user, quan ly giao dien tong quan.

## 2. Tech stack

### Backend

- Runtime: Node.js CommonJS.
- Framework: Express.js.
- Database: MongoDB + Mongoose.
- Auth: JWT access token + refresh token.
- Validation: Joi.
- Realtime: Socket.IO.
- Push notification: Firebase Admin SDK / FCM.
- Security middleware: helmet, cors, express-rate-limit.
- Logger: morgan.
- Email/OTP: nodemailer.

### Mobile app

- Framework: Flutter.
- State management: BLoC / Cubit.
- Network: Dio + Retrofit.
- DI: GetIt + Injectable.
- Local storage: Hive, SharedPreferences, Flutter Secure Storage.
- Auth SDK: Google Sign-In, Zalo Flutter.
- Notification: Firebase Messaging + Flutter Local Notifications.
- Realtime chat: socket_io_client.
- Location: geolocator.
- File/Image: image_picker, file_picker.

### Admin web

- Framework: ReactJS + TypeScript.
- Build tool: Vite.
- Icons: lucide-react.
- Realtime chat: socket.io-client.
- API calls: fetch.

### DevOps

- Docker Compose services:
  - `mongo`
  - `backend`
  - `admin_web`
  - `seed_admin`

## 3. Cau truc thu muc

```text
Pet_Care_Booking/
  backend/              Backend Express API
  app/                  Flutter mobile app
  admin_web/            React admin dashboard
  docs/                 Extra documentation
  docker-compose.yml    Docker compose setup
  ai-context.md         Project handover documentation
```

### Backend structure

```text
backend/src/
  app.js
  server.js
  config/
  middlewares/
  models/
  modules/
    appReviews/
    auth/
    bookings/
    chat/
    health/
    helpCenter/
    notifications/
    pets/
    services/
  routes/
  socket/
  utils/
```

Backend duoc chia theo module. Moi module thuong co:

- `*.routes.js`: khai bao endpoint.
- `*.controller.js`: xu ly request/response.
- `*.service.js`: logic nghiep vu.
- `*.schemas.js`: Joi validation.

### Flutter structure

```text
app/lib/
  app/
  core/
    network/
    storage/
    notifications/
    presence/
    location/
  features/
    authentication/
    booking/
    chat/
    home/
    pets/
    profile/
    services/
    blog/
    shell/
```

Flutter dang di theo huong clean-ish architecture:

- `data/`: datasource, repository impl, model, mapper.
- `domain/`: entity, repository contract, usecase.
- `presentation/`: page, bloc, state, event.

### Admin web structure

```text
admin_web/src/
  app/
  features/
    chat/
  shared/
    api/
  styles/
```

## 4. API overview

Base URL local mac dinh:

```text
http://localhost:5000/api/v1
```

Flutter dev base URL hien tai:

```text
http://192.168.1.29:5000/api/v1
```

Backend hien co 36 REST endpoints dang duoc mount qua `/api/v1`.

Ngoai REST API, he thong co:

- WebSocket Socket.IO cho chat realtime va presence.
- FCM cho push notification.

## 5. REST API list

### 5.1 Health API

| Method | Endpoint | Auth | Mo ta |
|---|---|---|---|
| GET | `/health` | No | Kiem tra backend song/chay |

### 5.2 Auth API

| Method | Endpoint | Auth | Mo ta |
|---|---|---|---|
| POST | `/auth/register` | No | Dang ky user moi |
| POST | `/auth/login` | No | Dang nhap local user |
| POST | `/auth/admin/login` | No | Dang nhap admin web, chi cho role `admin` |
| POST | `/auth/forgot-password` | No | Gui OTP quen mat khau |
| POST | `/auth/verify-reset-otp` | No | Xac thuc OTP reset password |
| POST | `/auth/reset-password` | No | Dat lai mat khau |
| POST | `/auth/refresh-token` | No | Lay access token moi |
| POST | `/auth/logout` | No | Logout, huy refresh token |
| POST | `/auth/social/google` | No | Dang nhap bang Google |
| POST | `/auth/social/zalo` | No | Dang nhap bang Zalo |
| GET | `/auth/me` | Bearer token | Lay thong tin user hien tai |
| PATCH | `/auth/me/profile` | Bearer token | Cap nhat fullName, phone, avatar |
| PATCH | `/auth/me/password` | Bearer token | Doi mat khau user |
| GET | `/auth/me/address` | Bearer token | Lay dia chi user |
| PATCH | `/auth/me/address` | Bearer token | Cap nhat dia chi user |

### 5.3 Pet API

| Method | Endpoint | Auth | Mo ta |
|---|---|---|---|
| GET | `/pets` | Bearer token | Lay danh sach thu cung cua user |
| POST | `/pets` | Bearer token | Tao thu cung moi |
| GET | `/pets/:petId` | Bearer token | Lay chi tiet thu cung |

Pet data hien luu:

- `owner`
- `name`
- `ageYears`
- `weightKg`
- `petType`: `dog`, `cat`, `rabbit`, `bird`
- `vaccinationStatus`
- `imageDataUrl`

### 5.4 Service API

| Method | Endpoint | Auth | Mo ta |
|---|---|---|---|
| GET | `/services` | No | Lay danh sach dich vu |

Ghi chu: Service hien dang la API list. Can xem lai du lieu service dang static hay seed tu DB truoc khi dua vao production.

### 5.5 Booking API

| Method | Endpoint | Auth | Mo ta |
|---|---|---|---|
| GET | `/bookings/availability` | Bearer token | Lay khung gio con trong |
| GET | `/bookings` | Bearer token | Lay lich su dat lich cua user |
| POST | `/bookings` | Bearer token | Tao booking moi |
| GET | `/bookings/:bookingId` | Bearer token | Lay chi tiet booking |
| PATCH | `/bookings/:bookingId/cancel` | Bearer token | Huy booking |

Booking co unique index:

```text
dateKey + timeSlotId
```

Index nay giup chan nhieu user dat cung mot khung gio neu status la:

- `upcoming`
- `completed`

### 5.6 Chat API

| Method | Endpoint | Auth | Mo ta |
|---|---|---|---|
| GET | `/chat/conversations` | Bearer token | Admin lay danh sach conversation, user lay conversation cua minh |
| POST | `/chat/conversations` | Bearer token | Tao hoac lay conversation cua user hien tai |
| GET | `/chat/conversations/:conversationId/messages` | Bearer token | Lay tin nhan trong conversation |
| POST | `/chat/conversations/:conversationId/messages` | Bearer token | Gui tin nhan text/image/file |
| PATCH | `/chat/conversations/:conversationId/read` | Bearer token | Danh dau da doc |

Chat message ho tro:

- Text.
- Image attachment.
- File attachment.

Ghi chu hien tai:

- File/anh dang duoc luu dang `dataUrl/base64` trong MongoDB.
- Cach nay phu hop dev/test nhanh.
- Production nen dua file sang Cloudinary, S3, Firebase Storage hoac object storage khac, MongoDB chi luu URL.

### 5.7 Notification API

| Method | Endpoint | Auth | Mo ta |
|---|---|---|---|
| POST | `/notifications/device-token` | Bearer token | Luu FCM token cua thiet bi |
| POST | `/notifications/test` | Bearer token | Gui notification test toi user hien tai |

Notification dang dung de:

- Dat lich thanh cong.
- Nhac lich truoc 1 ngay / 1 gio.
- Booking bi huy/thay doi.
- Tin nhan chat khi app o background/closed.

### 5.8 Help Center API

| Method | Endpoint | Auth | Mo ta |
|---|---|---|---|
| GET | `/help-center` | No | Lay noi dung trung tam tro giup |
| POST | `/help-center/feedback` | Bearer token | User gui yeu cau ho tro/feedback |

### 5.9 App Review API

| Method | Endpoint | Auth | Mo ta |
|---|---|---|---|
| POST | `/app-reviews` | Bearer token | User gui danh gia ung dung |
| GET | `/app-reviews` | Admin token | Admin lay danh sach danh gia |

## 6. API dang khai bao o Flutter nhung backend can kiem tra

Trong Flutter co endpoint:

```text
GET /posts
```

Nhung backend hien tai chua mount route `/posts` trong `backend/src/routes/index.js`.

Neu app con dung blog/news:

- Can tao backend module `posts`.
- Hoac xoa endpoint/mock neu chua dung.

## 7. WebSocket realtime

Backend Socket.IO duoc khoi tao trong:

```text
backend/src/server.js
backend/src/socket/chatSocket.js
```

Socket auth:

- Client gui access token qua `socket.handshake.auth.token`.
- Backend verify JWT.
- Neu token sai/het han, socket bi tu choi.

### Client emit events

| Event | Payload | Mo ta |
|---|---|---|
| `presence:online` | none | Bao user/admin dang online |
| `chat:join` | `{ conversationId }` | Join room conversation |
| `chat:typing` | `{ conversationId, isTyping }` | Gui trang thai dang nhap |
| `chat:send` | `{ conversationId, text }` | Gui tin nhan qua socket |

### Server emit events

| Event | Payload | Mo ta |
|---|---|---|
| `presence:user-updated` | `{ user }` | Bao admin user online/offline |
| `chat:message` | `{ conversationId, message }` | Tin nhan moi |
| `chat:typing` | `{ conversationId, userId, isTyping }` | Trang thai dang nhap |

### Presence online/offline

User model co:

- `isOnline`
- `lastSeenAt`

Khi socket connect:

- Backend set `isOnline = true`.
- Emit `presence:user-updated` cho room `admins`.

Khi socket disconnect:

- Backend doi 1.5 giay.
- Neu user khong con socket active thi set `isOnline = false`.
- Cap nhat `lastSeenAt`.

## 8. Firebase Cloud Messaging

FCM trong he thong dung de hien notification system tren Android/iOS.

Nguyen tac nen dung:

- Neu user dang mo man hinh chat va dang xem conversation: khong can day notification system.
- Neu app background/closed: backend gui FCM.
- Khi user bam notification chat: app nen dieu huong vao tab Chat.

File lien quan:

```text
backend/src/firebase/serviceAccountKey.json
app/lib/core/notifications/push_notification_service.dart
```

Luu y bao mat:

- Khong commit `serviceAccountKey.json` len git public.
- Nen dung secret manager hoac environment mount khi deploy.

## 9. Database models

Backend hien co cac model:

| Model | File | Mo ta |
|---|---|---|
| User | `user.model.js` | Tai khoan user/admin, auth provider, profile, address, presence |
| RefreshToken | `refreshToken.model.js` | Refresh token da cap |
| Pet | `pet.model.js` | Thu cung cua user |
| Booking | `booking.model.js` | Lich hen/dat lich |
| ChatConversation | `chatConversation.model.js` | Phong chat user-admin |
| ChatMessage | `chatMessage.model.js` | Tin nhan chat text/image/file |
| DeviceToken | `deviceToken.model.js` | FCM token cua thiet bi |
| HelpFeedback | `helpFeedback.model.js` | Yeu cau ho tro cua user |
| AppReview | `appReview.model.js` | Danh gia ung dung |

## 10. Auth va role

User role hien tai:

```text
user
customer
staff
admin
```

Dang ky mac dinh:

```text
role = user
```

Admin web login:

```text
POST /auth/admin/login
```

Chi tai khoan co `role = admin` moi vao admin web.

## 11. Booking flow

Luang dat lich:

1. User dang nhap.
2. User tao/lua chon thu cung.
3. App goi `/bookings/availability` de lay khung gio.
4. Khung gio da co booking se bi khoa tren UI.
5. User chon service, ngay, gio.
6. App goi `POST /bookings`.
7. Backend check trung lich bang unique index.
8. Backend luu booking.
9. Backend co the gui FCM dat lich thanh cong.
10. App hien chi tiet lich hen.

Huy lich:

1. User bam huy.
2. App goi `PATCH /bookings/:bookingId/cancel`.
3. Backend doi status sang `cancelled`.
4. Khung gio co the duoc mo lai cho lich moi.

## 12. Chat flow

REST + WebSocket dang duoc dung ket hop:

1. Mo man hinh chat.
2. App goi REST API lay conversation.
3. App goi REST API lay lich su tin nhan.
4. App connect WebSocket bang access token.
5. App emit `chat:join`.
6. Khi user/gui admin gui tin moi:
   - REST API luu DB.
   - Backend emit `chat:message`.
   - Ben con lai nhan realtime qua socket.
7. Neu ben nhan offline/background, backend gui FCM.

## 13. Offline strategy

App dang co Hive/local storage.

Huong dung hop ly:

- Auth token: secure storage.
- Profile cache: Hive/local DB.
- Pet cache: Hive/local DB.
- Booking cache: chi doc offline, khong cho dat/huy offline.
- Chat cache: co the cache tin gan nhat, nhung gui tin nen can online.

Quy tac nen giu:

- Pet co the tao draft offline, online lai sync sau.
- Booking bat buoc online de tranh trung khung gio.
- Address/profile co the sua offline neu co queue sync, nhung hien tai nen update online de don gian.

## 14. Environment variables backend

Backend can cac bien moi truong chinh:

```text
PORT=5000
NODE_ENV=development
API_PREFIX=/api/v1
MONGODB_URI=mongodb://127.0.0.1:27017/pet-booking
CLIENT_URL=http://localhost:3000
ACCESS_TOKEN_SECRET=...
ACCESS_TOKEN_EXPIRES_IN=15m
REFRESH_TOKEN_SECRET=...
REFRESH_TOKEN_EXPIRES_IN=7d
GOOGLE_OAUTH_CLIENT_IDS=...
ZALO_APP_ID=...
ZALO_APP_SECRET=...
ZALO_CALLBACK_URL=...
FIREBASE_SERVICE_ACCOUNT_PATH=src/firebase/serviceAccountKey.json
SMTP_HOST=...
SMTP_PORT=...
SMTP_SECURE=false
SMTP_USER=...
SMTP_PASS=...
MAIL_FROM=...
OTP_EXPIRES_MINUTES=10
OTP_RESEND_COOLDOWN_SECONDS=60
```

Docker dung:

```text
backend/.env.docker
```

Local dev dung:

```text
backend/.env
```

Can chu y:

- Neu backend chay Docker thi `MONGODB_URI` phai tro toi `mongo:27017`.
- Neu backend chay local thi `MONGODB_URI` thuong la `127.0.0.1:27017`.
- Google/Zalo login phu thuoc config app id, client id, hash key, SHA-1/SHA-256 va package name.

## 15. Cach chay du an

### Backend local

```bash
cd backend
npm install
npm run dev
```

Backend chay o:

```text
http://localhost:5000/api/v1
```

### Admin web local

```bash
cd admin_web
npm install
npm run dev
```

Admin web mac dinh chay o:

```text
http://localhost:5173
```

### Flutter app

```bash
cd app
flutter pub get
flutter run
```

Neu test tren Android emulator:

- `localhost` trong app la localhost cua emulator, khong phai may tinh.
- Nen dung IP LAN cua may, vi du `192.168.1.29`.

### Docker

```bash
docker compose up --build
```

Seed admin:

```bash
docker compose --profile tools run --rm seed_admin
```

## 16. Cach test API bang Postman

### Register

```http
POST /api/v1/auth/register
Content-Type: application/json
```

```json
{
  "fullName": "Postman Test",
  "email": "postman@example.com",
  "password": "12345678",
  "phone": "0912345678",
  "address": "123 Nguyen Trai, TP.HCM"
}
```

### Login

```http
POST /api/v1/auth/login
Content-Type: application/json
```

```json
{
  "email": "postman@example.com",
  "password": "12345678"
}
```

Lay `accessToken`, sau do them header:

```text
Authorization: Bearer <accessToken>
```

### Create pet

```http
POST /api/v1/pets
Authorization: Bearer <accessToken>
Content-Type: application/json
```

```json
{
  "name": "Milo",
  "ageYears": 2,
  "weightKg": 5.5,
  "petType": "dog",
  "vaccinationStatus": "vaccinated",
  "imageDataUrl": "data:image/png;base64,..."
}
```

### Create booking

```http
POST /api/v1/bookings
Authorization: Bearer <accessToken>
Content-Type: application/json
```

```json
{
  "petId": "<petId>",
  "serviceIds": ["grooming"],
  "dateKey": "2026-06-14",
  "timeSlotId": "10:00",
  "timeSlotLabel": "10:00"
}
```

### Send chat message

```http
POST /api/v1/chat/conversations/<conversationId>/messages
Authorization: Bearer <accessToken>
Content-Type: application/json
```

```json
{
  "text": "Xin chao admin",
  "attachments": []
}
```

## 17. Danh gia source hien tai

### Diem tot

- Backend da chia module ro rang theo domain.
- Da co validation Joi cho nhieu API quan trong.
- Auth co access token va refresh token.
- Booking co unique index de chan trung lich.
- Chat da co REST API ket hop WebSocket.
- Da co FCM device token va notification test.
- Flutter co BLoC, repository, datasource, mapper, DI.
- Admin web da co base UI va ket noi chat realtime.
- Docker Compose da co MongoDB, backend, admin web.

### Rủi ro / technical debt

- Upload anh/file dang luu base64 trong MongoDB, se nang DB neu dung that.
- Chua co phan quyen chi tiet cho staff/admin ngoai role basic.
- Mot so API admin quan ly service/customer/pet/report/notification chua day du, admin web hien nhieu phan van la UI/static.
- Backend chua co test tu dong cho service/controller.
- Flutter test con it, moi co smoke/sample test.
- Chua co CI/CD.
- Chua co centralized logging/monitoring.
- Chua co API documentation OpenAPI/Swagger.
- Chua co migration/seed data chuan cho service, help center, posts.
- Refresh token va auto retry tren app can duoc audit ky vi da tung co loi 401.
- Google/Zalo login phu thuoc config ngoai source, de loi neu doi `google-services.json`, SHA key, Zalo hash key.
- Chat attachment nen co limit/scan file chat hon khi production.
- FCM lifecycle can test tren real device voi background/terminated state.

## 18. Nhung phan con thieu nen lam tiep

### Backend

- Tao Swagger/OpenAPI cho toan bo REST API.
- Tao API admin:
  - Quan ly booking.
  - Quan ly service.
  - Quan ly customer.
  - Quan ly pet.
  - Quan ly report.
  - Quan ly notification.
  - Quan ly feedback/app review.
- Them unit/integration test.
- Them upload service dung Cloudinary/S3/Firebase Storage.
- Them audit log cho admin action.
- Them pagination/filter/sort chuan cho list API.
- Them error code chuan thay vi chi message text.

### Flutter app

- Hoan thien offline cache strategy bang Hive.
- Them queue sync cho pet draft.
- Audit refresh token interceptor.
- Them test cho AuthBloc, BookingBloc, ChatBloc, PetBloc.
- Chuan hoa da ngon ngu en/vi cho tat ca man hinh.
- Toi uu image cache va loading state.

### Admin web

- Ket noi tat ca page voi API that.
- Them route guard theo admin token.
- Them refresh token flow.
- Them empty/loading/error state cho tung page.
- Them UI quan ly feedback/review.
- Them upload service image neu co.

### DevOps

- Them `.env.example` day du va khong chua secret that.
- Them GitHub Actions build/test.
- Them Docker healthcheck cho backend.
- Them production deployment guide.
- Them backup MongoDB.

## 19. Quyen han va bao mat can chu y

- Khong commit secret:
  - Firebase service account.
  - JWT secret.
  - Zalo app secret.
  - SMTP password.
- Admin role hien co the sua truc tiep trong MongoDB.
- Nen them API quan ly role chi cho super admin neu du an lon hon.
- Nen them rate limit rieng cho login/register/forgot password.
- Nen validate kich thuoc base64 upload tu client va server.

## 20. Ket luan ban giao

Du an da co nen tang kha day du cho mot san pham pet care booking:

- Mobile app co auth, booking, pet, profile, chat, notification.
- Backend co REST API, WebSocket, MongoDB, FCM.
- Admin web co UI dashboard va chat.

Trang thai hien tai phu hop de tiep tuc phat trien MVP.

Truoc khi dua len production, nen uu tien:

1. Chuyen upload anh/file sang object storage.
2. Hoan thien admin API va noi du lieu that vao admin web.
3. Viet Swagger/OpenAPI.
4. Them test backend va Flutter BLoC.
5. Kiem tra lai auth refresh token, Google/Zalo login, FCM lifecycle tren real device.
6. Them logging, monitoring, backup va CI/CD.
