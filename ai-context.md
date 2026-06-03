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
| **App shell** | `app/shell/` — `MainShellPage`, bottom nav 5 tab |
| **Navigation helpers** | `app/navigation/` — ví dụ `booking_navigation.dart` |
| **Presentation** | `features/<feature>/presentation/` — Bloc, Pages, Widgets |
| **Domain** | `features/<feature>/domain/` — Entities, Repository interfaces, UseCases |
| **Data** | `features/<feature>/data/` — Models, Retrofit API, Repository impl, DataSources, Mock |
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
- [x] **Social login:** Firebase Auth + `google_sign_in`, Zalo qua `zalo_flutter` / `flutter_zalokit`
- [x] **Main shell:** 5 tab bottom nav — Trang chủ, Dịch vụ, Blog, Chat, Profile (`MainShellPage`, route `/home`)
- [x] **Booking UI:** Luồng đặt lịch 4 bước + màn chi tiết lịch hẹn (mock data, chưa nối API backend)

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

## 6. Flutter app — Main shell & features (mock-first)

### 6.1. Bottom navigation (`MainShellPage`)

| Index | Tab | Feature | Bloc |
|-------|-----|---------|------|
| 0 | Trang chủ | `features/home/` | `HomeBloc` |
| 1 | Dịch vụ | `features/services/` | `ServicesBloc` |
| 2 | Blog | `features/blog/` | `BlogBloc` |
| 3 | Chat | `features/chat/` | `ChatBloc` |
| 4 | Profile | `features/profile/` | `ProfileBloc` |

- Route: `/home` (`MainShellPage.routeName` = `main-shell`)
- `IndexedStack` giữ state từng tab; `MainShellBloc` quản lý `currentIndex`
- **Không** có tab “Đặt lịch” riêng — vào booking qua nút trên Home / Dịch vụ

### 6.2. Luồng đặt lịch (Booking flow)

**Entry points:**

- Home → “Đặt lịch ngay” → `openBookingPetSelection(context)`
- Services → “Đặt ngay” trên từng dịch vụ → `openBookingPetSelection(context, serviceId: ...)`
- Helper: `app/lib/app/navigation/booking_navigation.dart`

**Route booking:**

| Route | Name | Mô tả |
|-------|------|--------|
| `/booking/my-pets` | `booking-my-pets` | Shell 4 bước (`MyPetsPage`) |
| `/booking/detail/:bookingId` | `booking-detail` | Chi tiết lịch hẹn sau khi hoàn tất |

**4 bước (`BookingStep`):**

| Bước | Enum | UI | Bloc chính |
|------|------|-----|------------|
| 1 | `pet` | `_BookingPetStepContent` trong `my_pets_page.dart` | `BookingBloc` + `PetsBloc` |
| 2 | `service` | `BookingServiceStepContent` | `BookingServiceSelectionBloc` |
| 3 | `appointment` | `BookingAppointmentStepContent` | `BookingAppointmentBloc` |
| 4 | `confirmation` | `BookingConfirmationStepContent` | `BookingConfirmationBloc` |

**Orchestrator:** `BookingBloc` (`features/booking/presentation/bloc/`) giữ state xuyên suốt:

- `selectedPetId`, `selectedServiceIds`, `totalVnd`
- `selectedAppointmentDate`, `selectedTimeSlotId`, `selectedTimeSlotLabel`
- `bookingReference` (mã sau submit)
- `currentStep`, `serviceId` (preselect từ tab Dịch vụ)

**Stepper UI:** `booking_progress_stepper.dart` — 4 bước: Thú cưng → Dịch vụ → Lịch hẹn → Xác nhận

**Sau hoàn tất bước 4:**

1. `SubmitBookingUseCase` → mock tạo mã `PSxxxxx`
2. `BookingDetailMapper` build `BookingDetail` → lưu `BookingDetailLocalDataSource` (in-memory)
3. `openBookingDetail(context, bookingId: ...)` → `BookingDetailPage`

**Màn chi tiết lịch hẹn (`BookingDetailPage`):**

- Bloc: `BookingDetailBloc` — load detail, hủy lịch (`CancelBookingUseCase`)
- Hiển thị: mã `#PS…`, badge trạng thái (Sắp tới / Hoàn thành / Đã hủy), pet, dịch vụ + giá, ngày/giờ, địa điểm, tóm tắt thanh toán, nút Hủy lịch / Hỗ trợ
- **Lưu ý:** Dữ liệu booking hiện **chỉ trong RAM** (session app). Đóng app hoàn toàn → mất. Khi có API backend cần thay `BookingDetailLocalDataSource` bằng persist/remote.

### 6.3. Mock data booking (dev)

| Nguồn | File | Ghi chú |
|-------|------|---------|
| Thú cưng | `features/pets/data/` | Pet mẫu `pet-mochi` (Mochi), `pet-luna` |
| Dịch vụ bookable | `booking_service_mock_data_source.dart` | IDs: `booking-spa`, `booking-grooming`, `booking-boarding`, … |
| Map từ tab Dịch vụ | cùng file | VD: `grooming-cleaning` → `booking-grooming` |
| Lịch hẹn | `booking_appointment_mock_data_source.dart` | Tháng 10/2023, slot sáng/chiều, một số slot “Hết chỗ” |
| Xác nhận | `booking_confirmation_mock_data_source.dart` | Line items, ví PawSitive / MoMo trên detail |
| Chi tiết sau submit | `booking_detail_local_data_source.dart` + `booking_detail_mapper.dart` | Build từ `BookingConfirmationRequest` + content |

### 6.4. File quan trọng — booking

```
app/lib/features/booking/
├── domain/entities/          booking_step.dart, booking_detail.dart, appointment_*, …
├── domain/repositories/      booking_*_repository.dart
├── domain/usecases/          get_appointment_*, get_booking_confirmation, submit_booking,
│                             get_booking_detail, cancel_booking
├── data/datasources/         *_mock_data_source.dart, booking_detail_local_data_source.dart
├── data/repositories/        *_repository_impl.dart
├── data/mappers/             booking_detail_mapper.dart
└── presentation/
    ├── bloc/                 booking_bloc, booking_*_bloc
    ├── pages/                booking_detail_page.dart
    └── widgets/              booking_*_step_content.dart, booking_progress_stepper.dart

app/lib/features/pets/presentation/pages/my_pets_page.dart   ← shell 4 bước
app/lib/app/router/app_router.dart                           ← routes booking
app/lib/app/navigation/booking_navigation.dart               ← openBookingPetSelection, openBookingDetail
```

### 6.5. DI & codegen

- Thêm `@injectable` / `@LazySingleton` → chạy `dart run build_runner build` trong `app/`
- `AuthRepository` đăng ký **thủ công** trong `injection.dart` (`_registerAuthDependencies`) — codegen có thể cảnh báo `LogoutUseCase` / `AuthRepository` unregistered (runtime vẫn OK)

---

## 7. Tiến độ tính năng (tóm tắt)

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

### Flutter — Main tabs (mock UI + Bloc)

- [x] Home — banner, quick actions, “Đặt lịch ngay”
- [x] Services — danh sách dịch vụ, “Đặt ngay” → booking với `serviceId`
- [x] Blog — search, filter, featured/latest, weekly tip
- [x] Chat — FAQ, messages, typing, send
- [x] Profile — menu, logout (`LogoutUseCase` + `AuthRepository.logout()`)

### Flutter — Booking flow (mock, chưa API)

- [x] Bước 1: Chọn thú cưng (`MyPetsPage` + `PetsBloc`)
- [x] Bước 2: Chọn dịch vụ (multi-select, tổng tiền)
- [x] Bước 3: Chọn ngày & khung giờ (sáng/chiều, slot hết chỗ)
- [x] Bước 4: Xác nhận & thanh toán (mock submit)
- [x] Màn chi tiết lịch hẹn sau submit (`BookingDetailPage`)
- [x] Hủy lịch trên màn detail (mock, cập nhật status in-memory)
- [ ] Nối API backend `bookings` (create, get, cancel)
- [ ] Persist booking local (SharedPreferences / SQLite) hoặc fetch từ server

### Nghiệp vụ booking (backend skeleton)

- [ ] `pets`, `services`, `bookings` — có route/controller khung, chưa hoàn thiện product

### Web

- [x] Login / Register cơ bản
- [ ] Parity đầy đủ với Flutter auth recovery

---

## 8. Quy tắc viết code (Coding Conventions)

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

## 9. Biến môi trường quan trọng

Tham chiếu `backend/.env.example`. Tối thiểu để chạy local:

| Nhóm | Biến |
|------|------|
| Server | `PORT`, `NODE_ENV`, `API_PREFIX`, `MONGODB_URI`, `CLIENT_URL` |
| JWT | `ACCESS_TOKEN_SECRET`, `REFRESH_TOKEN_SECRET`, `*_EXPIRES_IN` |
| Google | `FIREBASE_SERVICE_ACCOUNT_PATH`, `GOOGLE_OAUTH_CLIENT_IDS` |
| Zalo | `ZALO_APP_ID`, `ZALO_APP_SECRET`, `ZALO_CALLBACK_URL` |
| Email OTP | `SMTP_*`, `MAIL_FROM`, `OTP_EXPIRES_MINUTES`, `OTP_RESEND_COOLDOWN_SECONDS` |

---

## 10. Lệnh chạy nhanh (dev)

```bash
# Backend
cd backend
npm install
npm run dev

# Flutter
cd app
flutter pub get
dart run build_runner build   # sau khi thêm @injectable
flutter run
```

**Health check:** `GET /api/v1/health`

---

## 11. Ghi chú cho AI khi nhận task mới

1. Xác định layer: backend / Flutter / web — **ưu tiên app** trừ khi user nói rõ khác.
2. Đọc module liên quan trong `backend/src/modules/` hoặc `app/lib/features/`.
3. Không đổi contract API đã có mà không cập nhật Flutter (Retrofit + models).
4. Forgot password: nhớ luồng **email**, không quay lại phone/Zalo OTP trừ khi user yêu cầu rõ.
5. Khi thêm endpoint: Joi schema + route `validate` + service + (nếu cần) Flutter repository/bloc.
6. **Booking:** Feature mới theo pattern `domain → data (mock trước) → presentation (Bloc)`. Orchestrator là `BookingBloc`; mỗi bước có Bloc riêng được `BlocProvider` trong `MyPetsPage`. Sau submit → `BookingDetailPage`, không về home trừ khi user back.
7. **Main shell:** 5 tab — không thêm tab “Đặt lịch” trừ khi user yêu cầu redesign nav.
8. Cập nhật **checkbox tiến độ** trong file này nếu hoàn thành hạng mục lớn.

---

*Cập nhật lần cuối: Flutter booking flow 4 bước + BookingDetailPage (mock in-memory); main shell 5 tab; auth Google/Zalo/email OTP.*
