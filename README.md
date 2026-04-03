# tripwise

TripWise is a Flutter app scaffold with a modern baseline:

- Material 3 theming
- Riverpod (`flutter_riverpod`) for state management
- `go_router` for navigation
- Feature-first folder structure under `lib/`

## Getting Started

Install Flutter on Windows (stable) and ensure `flutter` is on your PATH:
- `https://docs.flutter.dev/get-started/install/windows`

Then:

```bash
flutter pub get
flutter run
```

## Structure

- `lib/app/`: app shell (router, theme, top-level widgets)
- `lib/features/`: feature modules (screens + feature-level UI)
- `lib/shared/`: shared UI and utilities
