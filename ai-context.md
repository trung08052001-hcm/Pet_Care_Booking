# AI Context — Pet Booking

> **Mục đích file:** Tài liệu ngữ cảnh cho Cursor, Claude, ChatGPT và các AI khác. Đọc file này **trước** khi sửa code, thêm tính năng, hoặc debug. Cập nhật file khi kiến trúc / luồng nghiệp vụ thay đổi đáng kể.

---

## 1. Tổng quan dự án

| Mục | Nội dung |
|-----|----------|
| **Tên** | Pet Booking (PawSitive Care) |
| **Mô tả** | Hệ thống đặt lịch chăm sóc, spa, thú y cho thú cưng |
| **Repo** | Monorepo tại thư mục gốc |
| **Ưu tiên phát triển** | **Flutter app** (`app/`) → **Backend** (`backend/`) → Web (`web/`) phụ |

---

## 2. Cấu trúc thư mục

```
/
├── ai-context.md          ← File này
├── app/                   ← Flutter (mobile) — TRỌNG TÂM
├── backend/               ← Node.js + Express + MongoDB
└── web/                   ← React + Vite + TanStack Query + Zustand
```

### Backend (`backend/src/`)

| Thư mục | Vai trò |
|---------|---------|
| `config/` | `env.js`, `db.js`, `firebase.js` |
| `middlewares/` | `validate` (Joi), `errorHandler`, `auth.middleware`, `asyncHandler` |
| `modules/*/` | MVC theo domain: `auth`, `pets`, `services`, `bookings`, `health` |
| `models/` | Mongoose: `user`, `refreshToken`, … |
| `validators/` | Joi helpers dùng chung |
| `utils/` | JWT (`token.js`), password hash, `apiError`, `parseSchema` |
| `services/` | `email.service.js` (Mailtrap / dev log OTP) |
| `firebase/` | `serviceAccountKey.json` (không commit secret lên git công khai) |

### Flutter (`app/lib/`)

| Layer | Đường dẫn mẫu |
|-------|----------------|
| **Presentation** | `features/<feature>/presentation/` — Bloc, Pages, Widgets |
| **Domain** | `features/<feature>/domain/` — Entities, Repository interfaces, UseCases |
| **Data** | `features/<feature>/data/` — Models, Retrofit API, Repository impl, DataSources |
| **Core** | `core/` — DI (`injection.dart`), Dio, config, storage, errors |

---

## 3. Tech stack

### Mobile — Flutter (`app/`)

- [x] **State:** `flutter_bloc` (Bloc, không dùng Cubit cho auth chính)
- [x] **Network:** `dio` + `retrofit` (`AuthApiService`, …)
- [x] **DI:** `get_it` + `injectable` (`configureDependencies` trong `core/di/injection.dart`)
- [x] **Routing:** `go_router` (`app/router/app_router.dart`)
- [x] **Storage:** `flutter_secure_storage` (token), `shared_preferences` (user cache, flags)
- [x] **Kiến trúc:** Clean Architecture — Data → Domain → Presentation
- [x] **Social login:** Firebase Auth + `google_sign_in`, Zalo qua `zalo_flutter`

**Base URL dev (mặc định):** `http://192.168.1.29:5000/api/v1` — có thể override bằng `--dart-define=DEV_BASE_URL=...`. Android emulator thường dùng `http://10.0.2.2:5000/api/v1`.

### Backend (`backend/`)

- [x] **Runtime:** Node.js (CommonJS)
- [x] **Framework:** Express
- [x] **DB:** MongoDB + Mongoose
- [x] **Kiến trúc:** MVC modular (`modules/<name>/`)
- [x] **Auth:** JWT tự implement (`utils/token.js` — HS256, crypto Node), Refresh Token lưu DB
- [x] **Validation:** **Joi** — middleware `validate(schema)` trên routes + `auth.schemas.js`
- [x] **Google:** Firebase Admin — verify `idToken`
- [x] **Email OTP:** Nodemailer + Mailtrap (dev)

### Web (`web/`) — phụ

- [x] React, Vite, TypeScript
- [x] TanStack Query, Zustand, Axios, Zod, Tailwind
- [ ] Đồng bộ 100% luồng auth recovery với app (đang lag một phần)

---

## 4. API & quy ước response

**Prefix:** `/api/v1`

### Response chuẩn

**Thành công:**

```json
{
  "success": true,
  "message": "Mô tả ngắn",
  "data": { }
}
```

**Lỗi (bắt buộc cho mọi endpoint):**

```json
{
  "success": false,
  "message": "Thông báo lỗi cho người dùng"
}
```

- Dùng class `ApiError(statusCode, message)` và `throw` trong service.
- `errorHandler` middleware chuẩn hóa Joi, Mongoose, duplicate key (`11000`).
- **Không** trả HTML/text lỗi thô cho client Flutter.
- Dev có thể kèm `stack` khi `NODE_ENV=development`.

### Auth endpoints (`/api/v1/auth`)

| Method | Path | Joi schema | Mô tả |
|--------|------|------------|--------|
| POST | `/register` | `registerSchema` | Đăng ký local |
| POST | `/login` | `loginSchema` | Email hoặc SĐT + password |
| POST | `/forgot-password` | `forgotPasswordSchema` | Gửi OTP qua email |
| POST | `/verify-reset-otp` | `verifyResetOtpSchema` | Xác minh OTP 6 số |
| POST | `/reset-password` | `resetPasswordSchema` | Đổi MK (`resetToken` = OTP đã verify, cùng hash trên user) |
| POST | `/refresh-token` | `refreshTokenSchema` | Làm mới JWT |
| POST | `/logout` | `refreshTokenSchema` | Thu hồi refresh token |
| POST | `/social/google` | `googleLoginSchema` | Body: `{ "idToken": "..." }` |
| POST | `/social/zalo` | `zaloLoginSchema` | `oauthCode` và/hoặc `accessToken` |
| GET | `/me` | — | Cần header `Authorization: Bearer <accessToken>` |

**Token response (`data`):**

```json
{
  "user": { "id", "fullName", "email", "phone", "role", "authProvider", ... },
  "tokens": {
    "tokenType": "Bearer",
    "accessToken": "...",
    "refreshToken": "..."
  }
}
```

---

## 5. Authentication — hiện trạng chi tiết

### 5.1. Đăng ký / đăng nhập local

- [x] Register: lưu user MongoDB (`authProvider: "local"`)
- [x] Login: identifier = email **hoặc** phone
- [x] Password tối thiểu **8** ký tự (Joi + Mongoose)

### 5.2. Google Sign-In

- [x] Flutter: `GoogleAuthService` → Firebase credential → `idToken`
- [x] Backend: `loginWithGoogle` trong `auth.service.js`
- [x] Verify token: `google-auth.service.js` + `GOOGLE_OAUTH_CLIENT_IDS`
- [x] **Account merge:** Tìm user theo `(authProvider=google, providerId)` **hoặc** `email`; nếu tạo mới bị duplicate email (`11000`) thì **fallback** `findOne({ email })` và cập nhật — tránh 409 khi user đã đăng ký email trước đó
- [x] Sau login: cấp access + refresh JWT giống local

**File quan trọng:**

- `backend/src/modules/auth/auth.service.js` → `loginWithGoogle`
- `app/lib/features/authentication/data/services/google_auth_service.dart`
- `app/android/app/google-services.json`
- `backend/src/firebase/serviceAccountKey.json`

### 5.3. Zalo Sign-In

- [x] Flutter: `zalo_flutter` → `AuthSignInWithZaloRequested`
- [x] Backend: `zalo-oauth.service.js` + `loginWithZalo`
- [ ] Production: cần hash key / OAuth Zalo Dashboard khớp package `com.example.app`

### 5.4. Quên mật khẩu (Forgot Password) — **theo Email**

> **Đã thống nhất:** Không dùng SĐT + Zalo OTP cho forgot password. Luồng chuẩn là **email + OTP 6 số**.

**Backend flow:**

1. **`POST /forgot-password`** — body `{ "email": "user@example.com" }`
   - Luôn trả success-shaped (không lộ email có tồn tại hay không)
   - Nếu user active: sinh OTP 6 số → hash (`createTokenHash`) → lưu `user.passwordResetTokenHash` + `passwordResetExpiresAt`
   - Gửi mail qua Mailtrap; **dev:** in OTP ra terminal: `[email:dev] Password reset OTP for ...`

2. **`POST /verify-reset-otp`** — `{ "email", "otp" }`
   - So khớp hash + chưa hết hạn

3. **`POST /reset-password`** — `{ "resetToken", "password", "confirmPassword" }`
   - `resetToken` = **cùng mã OTP** (đã hash trên user)
   - Revoke refresh tokens cũ, cấp JWT mới (auto login)

**Thời hạn OTP:** cấu hình `OTP_EXPIRES_MINUTES` (mặc định **10** phút trong `.env.example`; có thể set 15).

**Flutter:**

- [x] `ForgotPasswordPage` — nhập **email**, gọi `requestPasswordResetOtp`
- [x] `ForgotPasswordOtpPage` — nhập OTP, gọi `verifyPasswordResetOtp`
- [ ] **Chưa hoàn chỉnh:** Sau verify OTP hiện `go` về **Sign In**; màn `ResetPasswordPage` còn legacy (phone) — **cần nối** `POST /reset-password` với OTP làm `resetToken` rồi vào home

**Mail dev (Mailtrap):**

```env
SMTP_HOST=sandbox.smtp.mailtrap.io
SMTP_PORT=2525
SMTP_SECURE=false
SMTP_USER=...
SMTP_PASS=...
MAIL_FROM="Pet Booking <noreply@mailtrap.io>"
OTP_EXPIRES_MINUTES=10
OTP_RESEND_COOLDOWN_SECONDS=60
```

Nếu SMTP chưa cấu hình + `NODE_ENV=development` → chỉ log OTP ra console (vẫn test được).

### 5.5. User model (`authProvider`)

| Giá trị | Ý nghĩa |
|---------|---------|
| `local` | Email/password |
| `google` | Google Sign-In |
| `zalo` | Zalo OAuth |

---

## 6. Tiến độ tính năng (tóm tắt)

### Authentication

- [x] Register / Login local
- [x] JWT + Refresh token + Logout
- [x] Google Sign-In (merge email)
- [x] Zalo Sign-In (cần cấu hình dashboard)
- [x] Joi validation toàn route auth
- [x] Global error handler
- [x] Forgot password: email → OTP (Mailtrap + dev console)
- [x] Verify OTP (backend + Flutter)
- [ ] Forgot password: màn đặt mật khẩu mới trên Flutter (nối `reset-password`)

### Nghiệp vụ booking (skeleton)

- [ ] `pets`, `services`, `bookings` — có route/controller khung, chưa hoàn thiện product

### Web

- [x] Login / Register cơ bản
- [ ] Parity đầy đủ với Flutter auth recovery

---

## 7. Quy tắc viết code (Coding Conventions)

### Backend

1. **Luôn** trả lỗi JSON: `{ success: false, message: "..." }` — dùng `ApiError` + `next(error)` hoặc `asyncHandler`.
2. **Validation:** Thêm Joi schema trong `*.schemas.js`, gắn `validate(schema)` trên route — không validate thủ công rải rác trong controller.
3. **Controller mỏng:** Chỉ nhận request, gọi service, trả response.
4. **Service:** Business logic, gọi model, throw `ApiError` với status phù hợp (400, 401, 403, 409, 502).
5. **Không** commit `.env`, `serviceAccountKey.json`, secret Zalo/Google vào repo public.
6. **Password:** Hash qua `utils/password.js` (không lưu plain text).
7. **OTP / token:** Chỉ lưu **hash** (`createTokenHash`), không lưu OTP thô trong DB.

### Flutter

1. **Luồng:** UI → Bloc Event → UseCase → Repository → Retrofit/Dio.
2. **Lỗi API:** Map qua `FailureMapper` / `ApiException` — hiển thị `message` từ backend (field `message` trong JSON).
3. **Không** gọi Dio trực tiếp từ Widget; luôn qua repository.
4. **Đăng ký DI:** Thêm dependency trong `injection.dart` (hoặc module injectable tương ứng).
5. **Retrofit:** Cập nhật `auth_api_service.dart` + chạy `build_runner` hoặc sửa `.g.dart` đồng bộ.
6. **State social login:** Dùng `AuthAction.signInWithGoogle` / `signInWithZalo` riêng để loading từng nút.

### Chung

- Giữ thay đổi **nhỏ, đúng scope** — không refactor lan man khi user chỉ yêu cầu một task.
- Đồng bộ validation Flutter (form) với Joi backend (độ dài password, email, OTP 6 số).
- Message lỗi **tiếng Anh** trên API (hiện tại); UI Flutter có i18n (`AppLocalizations`).

---

## 8. Biến môi trường quan trọng

Tham chiếu `backend/.env.example`. Tối thiểu để chạy local:

| Nhóm | Biến |
|------|------|
| Server | `PORT`, `NODE_ENV`, `API_PREFIX`, `MONGODB_URI`, `CLIENT_URL` |
| JWT | `ACCESS_TOKEN_SECRET`, `REFRESH_TOKEN_SECRET`, `*_EXPIRES_IN` |
| Google | `FIREBASE_SERVICE_ACCOUNT_PATH`, `GOOGLE_OAUTH_CLIENT_IDS` |
| Zalo | `ZALO_APP_ID`, `ZALO_APP_SECRET`, `ZALO_CALLBACK_URL` |
| Email OTP | `SMTP_*`, `MAIL_FROM`, `OTP_EXPIRES_MINUTES`, `OTP_RESEND_COOLDOWN_SECONDS` |

---

## 9. Lệnh chạy nhanh (dev)

```bash
# Backend
cd backend
npm install
npm run dev

# Flutter
cd app
flutter pub get
flutter run
```

**Health check:** `GET /api/v1/health`

---

## 10. Ghi chú cho AI khi nhận task mới

1. Xác định layer: backend / Flutter / web — **ưu tiên app** trừ khi user nói rõ khác.
2. Đọc module liên quan trong `backend/src/modules/` hoặc `app/lib/features/`.
3. Không đổi contract API đã có mà không cập nhật Flutter (Retrofit + models).
4. Forgot password: nhớ luồng **email**, không quay lại phone/Zalo OTP trừ khi user yêu cầu rõ.
5. Khi thêm endpoint: Joi schema + route `validate` + service + (nếu cần) Flutter repository/bloc.
6. Cập nhật **checkbox tiến độ** trong file này nếu hoàn thành hạng mục lớn.

---

*Cập nhật lần cuối: theo codebase Pet Booking monorepo (auth: Google merge, email OTP, Joi validation).*
