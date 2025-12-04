# Flutter Setup Guide

## Overview

This project has been migrated to Flutter with a clean architecture setup. All platform-specific code has been replaced with cross-platform Flutter implementation.

## Project Structure

```
lib/
├── domain/
│   └── service/
│       ├── export_service.dart      # Xactimate & MICA export
│       └── gemini_service.dart      # AI analysis
├── presentation/
│   ├── providers/
│   │   └── providers.dart           # Riverpod state management
│   └── screens/
│       └── ar_scan_screen.dart      # AR with WebAR fallback
└── main.dart                        # App entry point

android/
├── app/
│   ├── build.gradle                 # minSdkVersion 24
│   └── src/main/AndroidManifest.xml # AR optional (required="false")

.env                                 # API keys (not in git with real keys)
```

## Initial Setup

### 1. Install Flutter Dependencies

```bash
flutter pub get
```

### 2. Create Platform Folders (if needed)

If the `android`, `ios`, `web`, etc. folders are missing:

```bash
flutter create .
```

This will create all platform folders without overwriting existing files.

### 3. Configure Environment Variables

Edit `.env` file and add your Gemini API key:

```
GEMINI_API_KEY=your_actual_key_here
```

Get your key from: https://makersuite.google.com/app/apikey

### 4. Firebase Configuration

1. Create a Firebase project: https://console.firebase.google.com
2. Add Android app with package: `com.arscanner.android_arcore_depth_app`
3. Download `google-services.json` to `android/app/`
4. Enable:
   - Authentication (Email/Google)
   - Firestore Database
   - Storage

### 5. Run Code Generation

For Drift database and Riverpod providers:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Re-run this whenever you modify database tables or add new Riverpod providers with `@riverpod` annotation.

## Running the App

### Debug Mode

```bash
flutter run
```

### Release Mode

```bash
flutter run --release
```

Or build APK:

```bash
flutter build apk --release
```

## Key Features Implemented

### ✅ Configuration
- Project renamed to match repository
- All dependencies added (Riverpod, Drift, Firebase, Gemini, ARCore, WebView)
- Android minSdkVersion set to 24
- AR features marked as optional (works on non-AR devices)

### ✅ Services
- **ExportService**: Export scans to Xactimate (.ESX) and MICA (XML)
- **GeminiService**: AI-powered image analysis and damage detection

### ✅ State Management
- Riverpod providers for Firebase, services, and UI state
- Scaffolding for database and repository providers

### ✅ UI
- Material Design 3 with dark mode
- AR scan screen with automatic fallback (native → WebAR)
- Navigation and bottom navigation bar

## Architecture

**Clean Architecture + MVVM**

- **Presentation Layer**: UI (Screens), State (Riverpod Providers)
- **Domain Layer**: Business Logic (Services, Use Cases, Entities)
- **Data Layer**: Data Sources (Drift DB, Firebase, Repositories)

## Next Steps

1. **Implement Drift Database**
   - Create tables in `lib/data/database/app_database.dart`
   - Run `dart run build_runner build`
   - Implement repositories

2. **Complete AR Implementation**
   - Integrate `arcore_flutter_plugin` for native AR
   - Create custom WebAR HTML for fallback mode
   - Implement measurement and capture logic

3. **Enhance AI Analysis**
   - Parse Gemini responses into structured data
   - Add custom prompts for different damage types
   - Store analysis results in database

4. **Complete Export Formats**
   - Finalize Xactimate .ESX format generation
   - Complete MICA XML structure
   - Add file sharing functionality

## Troubleshooting

### Issue: Flutter command not found
**Solution**: Install Flutter SDK: https://docs.flutter.dev/get-started/install

### Issue: Build fails with Firebase errors
**Solution**: Ensure `google-services.json` is in `android/app/`

### Issue: Gemini API errors
**Solution**: Check `.env` file has valid API key

### Issue: AR not working
**Solution**: AR features are optional - app will fallback to WebAR automatically

## Testing

```bash
# Run unit tests
flutter test

# Run with coverage
flutter test --coverage
```

## Documentation

- **REQUIREMENTS.md**: Full feature and architecture documentation
- **README.md**: Project overview
- **This file (SETUP_GUIDE.md)**: Setup instructions

## Support

For issues or questions, refer to:
- Flutter docs: https://flutter.dev/docs
- Riverpod docs: https://riverpod.dev
- Drift docs: https://drift.simonbinder.eu
- Firebase Flutter: https://firebase.flutter.dev
