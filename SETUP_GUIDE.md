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

⚠️ **AI Features Disabled**: Gemini API integration is disabled by default for security.

The `.env` file contains security guidance. **DO NOT add API keys to tracked files.**

To enable AI features securely, see the "Enabling AI Features" section below.

### 4. Firebase Configuration

#### Setup Steps:

1. Create a Firebase project: https://console.firebase.google.com
2. Add Android app with package: `com.arscanner.android_arcore_depth_app`
3. Download `google-services.json` to `android/app/`
4. Enable the following Firebase services:
   - **Authentication**: Enable Google Sign-In provider
     - Go to Authentication > Sign-in method
     - Enable Google provider
     - Add your app's SHA-1 fingerprint (required for Android)
   - **Firestore Database**: Create database in production mode
   - **Storage**: Create default storage bucket

#### Getting SHA-1 Fingerprint (Required for Google Sign-In on Android):

For debug builds:
```bash
cd android
./gradlew signingReport
```

Look for the SHA-1 under "Variant: debug" and add it to your Firebase project settings.

For release builds, use your keystore's SHA-1 fingerprint.

#### Google Sign-In Configuration:

1. In Firebase Console, go to Authentication > Sign-in method
2. Enable Google provider
3. Add support email (required)
4. For web support, add authorized domains
5. Download updated `google-services.json` if prompted

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
- **GeminiService**: AI-powered image analysis (⚠️ disabled by default)
- **IICRCAssistantService**: IICRC-certified AI assistant (⚠️ disabled by default)
- **AuthService**: Firebase Authentication with Google Sign-In

### ✅ Authentication
- Google Sign-In integration via Firebase Auth
- User session management
- Secure authentication flow

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

1. **Implement Authentication UI**
   - Add sign-in button to IICRC Assistant screen
   - Use AuthService to handle Google Sign-In flow
   - Show user profile after authentication
   - Gate AI features behind authentication

2. **Implement Drift Database**
   - Create tables in `lib/data/database/app_database.dart`
   - Run `dart run build_runner build`
   - Implement repositories

3. **Complete AR Implementation**
   - Integrate `arcore_flutter_plugin` for native AR
   - Create custom WebAR HTML for fallback mode
   - Implement measurement and capture logic

4. **Complete Export Formats**
   - Finalize Xactimate .ESX format generation
   - Complete MICA XML structure
   - Add file sharing functionality

## Enabling AI Features Securely

⚠️ **SECURITY NOTICE**: AI features are disabled by default to prevent credential exposure in version control.

### Option 1: Backend Proxy (RECOMMENDED for Production)

Create a secure backend service to handle Gemini API calls:

1. **Backend Setup**:
   - Create a backend API (Node.js, Python, Go, etc.)
   - Store Gemini API key in backend environment variables or secret manager
   - Implement endpoints that accept requests from your app
   - Backend forwards requests to Gemini API

2. **App Configuration**:
   - Update `GeminiService` and `IICRCAssistantService` to call your backend
   - Remove the AI-disabled exception stubs
   - Send authenticated requests to your backend

3. **Benefits**:
   - No API keys in app code or version control
   - Rate limiting and cost control
   - Request logging and monitoring
   - API key rotation without app updates
   - Additional security layer

### Option 2: CI/CD Secret Injection (for Testing/Staging)

Use your CI/CD platform's secret manager:

1. **GitHub Actions Example**:
   ```yaml
   # .github/workflows/build.yml
   - name: Create .env.local
     run: echo "GEMINI_API_KEY=${{ secrets.GEMINI_API_KEY }}" > .env.local
   ```

2. **App Configuration**:
   - Update app to load `.env.local` if it exists
   - Remove AI-disabled exception stubs
   - Ensure `.env.local` is in `.gitignore`

3. **GitLab CI Example**:
   ```yaml
   # .gitlab-ci.yml
   before_script:
     - echo "GEMINI_API_KEY=$GEMINI_API_KEY" > .env.local
   ```

### Option 3: Local Development Only

**⚠️ WARNING**: Only for local development, never commit API keys!

1. Create `.env.local` file:
   ```bash
   echo ".env.local" >> .gitignore
   echo "GEMINI_API_KEY=your_actual_key_here" > .env.local
   ```

2. Update `main.dart` to load `.env.local`:
   ```dart
   import 'dart:io';
   
   Future<void> main() async {
     // Load .env.local if it exists (for local dev)
     final localEnvFile = File('.env.local');
     if (await localEnvFile.exists()) {
       await dotenv.load(fileName: '.env.local');
     } else {
       await dotenv.load(fileName: '.env');
     }
     // ... rest of initialization
   }
   ```

3. Remove AI-disabled stubs in:
   - `lib/domain/service/gemini_service.dart` (initialize() method and network methods)
   - `lib/domain/service/iicrc_assistant_service.dart` (initialize() method and network methods)

4. Get your API key from: https://makersuite.google.com/app/apikey

### Re-enabling AI Code Steps

To restore AI functionality after securing your API key:

1. **In `lib/domain/service/gemini_service.dart`**:
   - Remove the exception stub in `initialize()` method
   - Restore the original API key loading and model initialization code
   - Remove exception stubs in `analyzeImage()`, `generateReport()`, and `askQuestion()`
   - Restore the original network call implementations

2. **In `lib/domain/service/iicrc_assistant_service.dart`**:
   - Remove the exception stub in `initialize()` method
   - Restore the original API key loading and model initialization code
   - Remove exception stubs in all assessment methods:
     - `assessWaterDamage()`
     - `adviseMoldRemediation()`
     - `assessFireDamage()`
     - `recommendPPE()`
     - `analyzePsychrometrics()`
     - `analyzePhoto()`
     - `askQuestion()`
   - Restore the original network call implementations

3. **Test thoroughly**:
   - Verify API calls work correctly
   - Check error handling
   - Monitor API usage and costs

4. **Security Checklist**:
   - [ ] API key is NOT in tracked files
   - [ ] `.env.local` is in `.gitignore`
   - [ ] Using backend proxy OR CI/CD secrets
   - [ ] Tested in production-like environment
   - [ ] Rate limiting implemented (if using backend)
   - [ ] Cost monitoring enabled

## Troubleshooting

### Issue: Flutter command not found
**Solution**: Install Flutter SDK: https://docs.flutter.dev/get-started/install

### Issue: Build fails with Firebase errors
**Solution**: Ensure `google-services.json` is in `android/app/` and Firebase is properly configured

### Issue: Google Sign-In not working
**Solution**: 
- Ensure Google Sign-In provider is enabled in Firebase Console
- Add SHA-1 fingerprint to Firebase project settings
- Check `google-services.json` is up to date

### Issue: AI features throw exceptions
**Solution**: AI is disabled by default. See "Enabling AI Features Securely" section above to re-enable safely

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
