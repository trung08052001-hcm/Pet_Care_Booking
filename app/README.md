# Flutter Product Base

Base project Flutter theo kiểu product team, dùng:

- `flutter_bloc` cho state management
- `dio` + `retrofit` cho networking
- `get_it` + `injectable` cho dependency injection
- `shared_preferences` + `flutter_secure_storage` cho local persistence
- `build_runner` cho code generation

## Architecture

Project đi theo `feature-first` + `full clean architecture`.

```text
lib
|- app
|  |- router
|  |- theme
|- core
|  |- common
|  |- config
|  |- di
|  |- error
|  |- network
|  |- storage
|  |- usecase
|- features
|  |- sample_posts
|     |- data
|     |- domain
|     |- presentation
```

Mỗi feature được chia thành:

- `data`: DTO, retrofit service, datasource, repository implementation
- `domain`: entity, repository contract, use case
- `presentation`: page, bloc, UI state

## Run app

Mặc định:

```bash
flutter run
```

## Generate code

```bash
dart run build_runner build
```

Nếu cần watch:

```bash
dart run build_runner watch
```

## Quality checks

```bash
flutter analyze
flutter test
```

## Add a new feature

1. Tạo thư mục mới trong `lib/features/<feature_name>/`
2. Tách đủ 3 layer `data/domain/presentation`
3. Định nghĩa `Repository` ở domain, implement ở data
4. Tạo `UseCase` cho từng action nghiệp vụ
5. Tạo `Bloc` ở presentation và inject bằng `injectable`
6. Nếu cần API mới, thêm `retrofit service` trong feature và generate lại code

## Sample feature

`sample_posts` là vertical slice mẫu:

- gọi API public `/posts`
- cache local bằng `shared_preferences`
- fallback cache khi offline
- hiển thị dữ liệu qua `Bloc`

Bạn có thể dùng feature này làm template để nhân bản cho các module thật như `auth`, `profile`, `home`, `order`, `notification`.
# app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
