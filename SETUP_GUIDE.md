# Flutter Setup Guide

## Overview

This project has been migrated to Flutter with a clean architecture setup. All platform-specific code has been replaced with cross-platform Flutter implementation.

**Security Note**: This repository has been configured with security best practices:
- AI features (Gemini API) are disabled by default
- No API keys are stored in version control
- Firebase Authentication with Google Sign-In is available for user authentication
- See "Configure Environment Variables" section for secure AI enablement

## Project Structure

```
lib/
├── domain/
│   └── service/
│       ├── auth_service.dart           # Firebase Google Sign-In
│       ├── export_service.dart         # Xactimate & MICA export
│       ├── gemini_service.dart         # AI analysis (DISABLED)
│       └── iicrc_assistant_service.dart # IICRC AI (DISABLED)
├── presentation/
│   ├── providers/
│   │   └── providers.dart              # Riverpod state management
│   └── screens/
│       └── ar_scan_screen.dart         # AR with WebAR fallback
└── main.dart                           # App entry point

android/
├── app/
│   ├── build.gradle                 # minSdkVersion 24
│   └── src/main/AndroidManifest.xml # AR optional (required="false")

.env                                    # Security guidance (NO real keys)
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

**IMPORTANT: AI features are disabled by default for security.**

The `.env` file contains security guidance. DO NOT add real API keys to this file.

To enable AI features securely, choose one of these approaches:

#### Option A: Backend Proxy (RECOMMENDED for Production)
1. Set up a secure backend service to proxy Gemini API calls
2. Store API keys in your backend's secret manager:
   - Firebase Secret Manager
   - AWS Secrets Manager
   - Google Cloud Secret Manager
3. Route AI requests through your authenticated backend
4. Modify `lib/domain/service/gemini_service.dart` and `lib/domain/service/iicrc_assistant_service.dart` to call your backend instead of Gemini directly

#### Option B: CI/CD Secret Injection (For Development/Testing)
1. Store API keys in your CI/CD platform's secret manager
2. Inject secrets at build time via environment variables
3. Never commit injected secrets to version control
4. Modify the service files to remove the exception-throwing stubs

**To disable the AI stub (after securing your secrets):**
1. Edit `lib/domain/service/gemini_service.dart`
2. Edit `lib/domain/service/iicrc_assistant_service.dart`
3. Remove the `throw` statements from `initialize()` and network methods
4. Restore the original implementation (see git history for reference)

### 4. Firebase Configuration

1. Create a Firebase project: https://console.firebase.google.com
2. Add Android app with package: `com.arscanner.android_arcore_depth_app`
3. Download `google-services.json` to `android/app/`
4. Enable the following Firebase services:
   - **Authentication**: 
     - Enable Google Sign-In provider
     - Configure OAuth consent screen
     - Add SHA-1 fingerprint for Android (get via: `keytool -list -v -keystore ~/.android/debug.keystore`)
   - **Firestore Database**: Create database in production or test mode
   - **Storage**: Enable Firebase Storage

#### Setting up Google Sign-In:

1. In Firebase Console, go to Authentication > Sign-in method
2. Enable "Google" provider
3. Configure OAuth consent screen if prompted
4. For Android: Add your app's SHA-1 certificate fingerprint:
   ```bash
   # Debug keystore (for development)
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   
   # Copy the SHA-1 fingerprint and add it in Firebase Console > Project Settings > Your apps
   ```
5. Download the updated `google-services.json` and place in `android/app/`

**Using AuthService in your app:**

The `AuthService` (located at `lib/domain/service/auth_service.dart`) provides:
- `signInWithGoogle()`: Initiate Google Sign-In flow
- `signOut()`: Sign out current user
- `currentUserStream`: Stream of authentication state changes
- `isSignedIn`: Check if user is authenticated

Example usage in IICRC Assistant screen:
```dart
final authService = AuthService();

// Listen to authentication state
authService.currentUserStream.listen((user) {
  if (user != null) {
    // User is signed in - show protected features
  } else {
    // User is signed out - show sign-in prompt
  }
});

// Sign in
try {
  await authService.signInWithGoogle();
} catch (e) {
  // Handle error
}

// Sign out
await authService.signOut();
```

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
- **GeminiService**: AI-powered image analysis (DISABLED by default for security)
- **IICRCAssistantService**: IICRC-certified AI assistant (DISABLED by default for security)
- **AuthService**: Firebase Authentication with Google Sign-In

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
**Solution**: AI features are disabled by default for security. See "Configure Environment Variables" section for secure enablement options.

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
