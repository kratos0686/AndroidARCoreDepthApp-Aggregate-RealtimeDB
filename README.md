# Room Scanner

A Flutter application for professional 3D room scanning with integrated **IICRC Certified Master Water Restorer AI Assistant** for water damage restoration professionals.

## Key Features

### AR Scanning
- ARCore/ARKit depth sensing for accurate 3D measurements
- WebAR fallback for non-AR devices
- Offline-first data storage with Firebase cloud sync
- Export to industry-standard formats (Xactimate .ESX, MICA XML)

### IICRC AI Assistant

⚠️ **AI Features Currently Disabled**: The Gemini API integration has been disabled by default to prevent accidental exposure of API keys in version control.

The app includes a comprehensive AI assistant framework with IICRC-certified water restoration expertise:

#### Water Mitigation
- Categorize water damage (Class 1-4)
- Identify water category (Category 1-3: clean, grey, black water)
- Assess affected materials and extent
- Recommend drying equipment and timeline

#### Mold Remediation (S520)
- Condition level assessment (1-4)
- Containment requirements
- HEPA filtration and negative air specifications
- Safety protocols and PPE requirements

#### Fire Damage Restoration
- Smoke damage type identification
- Structural integrity assessment
- Material salvageability evaluation
- Cleaning method recommendations

#### PPE Recommendations
- Level-based protection guidance (1-4)
- Respiratory, hand, body, and eye protection specs
- Decontamination procedures
- Safety compliance ensuring

#### Psychrometric Analysis
- GPP (Grains Per Pound) interpretation
- RH (Relative Humidity) analysis
- Dew Point calculations
- Drying strategy optimization
- Equipment recommendations

#### Damage Assessment
- Photo/video analysis
- Material identification
- Damage extent evaluation
- Moisture indicators detection
- Safety hazard identification

## Getting Started

This project was initialized with basic scaffolding. To generate the platform-specific code (Android, iOS, Web, etc.), run the following command in this directory:

```bash
flutter create .
```

This will create the necessary `android/`, `ios/`, `web/`, `linux/`, `macos/`, and `windows/` directories based on your environment configuration.

## Requirements

- Flutter SDK
- Android Studio / Xcode (for mobile development)
- Firebase project (for cloud sync and authentication)

## Setup

1. Install dependencies:
```bash
flutter pub get
```

2. Set up Firebase:
   - Create a Firebase project at https://console.firebase.google.com
   - Add your app to the Firebase project
   - Download and configure Firebase config files
   - Enable Firebase Authentication with Google Sign-In provider
   - See SETUP_GUIDE.md for detailed Firebase setup instructions

3. Configure Google Sign-In (see SETUP_GUIDE.md for details)

## Running the App

After generating the platform code:

```bash
flutter run
```

## Documentation

- **REQUIREMENTS.md**: Complete technical specifications
- **SETUP_GUIDE.md**: Detailed setup instructions
- **README.md**: This file - project overview

## IICRC AI Assistant Usage

⚠️ **AI is currently disabled by default.** See "Enabling AI Features Securely" below.

The IICRC AI Assistant is accessible from the main navigation bar. When enabled, it provides:

- **Professional Guidance**: IICRC-certified restoration expertise
- **Safety-Focused**: PPE and safety recommendations prioritized
- **Concise Advice**: Quick, actionable recommendations
- **Industry Standards**: Compliant with IICRC standards and best practices

Access the assistant to:
1. Assess water damage severity and get mitigation plans
2. Get mold remediation protocols following S520 standards
3. Evaluate fire damage and restoration strategies
4. Determine appropriate PPE for various scenarios
5. Analyze psychrometric conditions for optimal drying
6. Upload photos for AI-powered damage assessment
7. Ask any restoration-related questions for expert guidance

## Authentication

The app uses Firebase Authentication with Google Sign-In to secure access:

- **Sign in with Google**: Users authenticate using their Google account
- **Secure session management**: Firebase handles token management and session persistence
- **User profile access**: Display name, email, and photo URL available after sign-in

To implement the sign-in UI in your screens:

```dart
// Example usage in IICRC Assistant screen
final authService = AuthService();

// Check authentication state
authService.authStateChanges.listen((user) {
  if (user != null) {
    print('User is signed in: ${user.displayName}');
  } else {
    print('User is signed out');
  }
});

// Sign in
try {
  await authService.signInWithGoogle();
} catch (e) {
  print('Sign-in error: $e');
}

// Sign out
await authService.signOut();
```

## Enabling AI Features Securely

⚠️ **SECURITY NOTICE**: AI features (Gemini API) are disabled by default to prevent credential exposure.

### Option 1: Backend Proxy (RECOMMENDED for Production)
1. Create a secure backend service (Node.js, Python, Go, etc.)
2. Store Gemini API key in backend environment variables or secret manager
3. Your app sends requests to your backend endpoint
4. Backend forwards requests to Gemini API and returns responses
5. Benefits:
   - No API keys in app code or version control
   - Rate limiting and cost control
   - Request logging and monitoring
   - API key rotation without app updates

### Option 2: CI/CD Secret Injection (for Testing/Staging)
1. Store API key in CI/CD secret manager (GitHub Secrets, GitLab Variables)
2. Inject secret at build time via environment variables
3. Load secret in app from environment (not from tracked files)
4. Ensure secrets are never committed to version control

### Option 3: Local Development Only
1. Create `.env.local` file (add to .gitignore)
2. Add: `GEMINI_API_KEY=your_actual_key_here`
3. Update app to load `.env.local` instead of `.env`
4. **NEVER commit `.env.local` to version control**
5. Remove AI-disabled stubs in `lib/domain/service/gemini_service.dart` and `lib/domain/service/iicrc_assistant_service.dart`

### Re-enabling AI Code
To re-enable AI features after securing your API key:

1. Remove the exception stubs in:
   - `lib/domain/service/gemini_service.dart` (initialize() and network methods)
   - `lib/domain/service/iicrc_assistant_service.dart` (initialize() and network methods)
2. Restore the original API call implementation
3. Ensure your secure key management solution is in place
4. Test thoroughly before deploying

See `.env` file for detailed instructions and security guidance.

## Architecture

- **Clean Architecture + MVVM** pattern
- **Riverpod** for state management
- **Drift** for local SQLite database
- **Firebase** for cloud sync and authentication
- **Google Gemini AI** for intelligent analysis and IICRC expertise

## License

© 2025 AR Scan Export with IICRC AI Assistant

