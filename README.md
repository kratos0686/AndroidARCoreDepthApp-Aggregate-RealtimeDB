# Room Scanner

A Flutter application for professional 3D room scanning with integrated **IICRC Certified Master Water Restorer AI Assistant** for water damage restoration professionals.

## Key Features

### AR Scanning
- ARCore/ARKit depth sensing for accurate 3D measurements
- WebAR fallback for non-AR devices
- Offline-first data storage with Firebase cloud sync
- Export to industry-standard formats (Xactimate .ESX, MICA XML)

### IICRC AI Assistant
The app includes a comprehensive AI assistant certified in water restoration expertise:

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

**Note:** AI features are disabled by default for security. See Setup section for details.

## Setup

1. Install dependencies:
```bash
flutter pub get
```

2. Set up Firebase (see SETUP_GUIDE.md for details):
   - Create a Firebase project
   - Enable Firebase Authentication with Google Sign-In provider
   - Add your app to Firebase and download configuration files
   - Enable Firestore Database and Storage

3. **AI Features (Disabled by Default)**:
   - AI features using Gemini API are **disabled** in this repository for security
   - To enable AI securely, use one of these approaches:
     - **Recommended for Production**: Set up a secure backend proxy to handle Gemini API calls
     - **For Development**: Use CI/CD secret injection (never commit API keys)
   - See `.env` file and SETUP_GUIDE.md for detailed instructions on secure AI enablement

4. **Authentication**:
   - The app includes Firebase Google Sign-In authentication
   - Users can authenticate using their Google account
   - IICRC Assistant features can be gated by authentication

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

**Note:** AI features are currently disabled in the repository for security. To use the IICRC AI Assistant:

1. Set up secure AI backend or configure secret injection (see Setup section)
2. Authenticate using Google Sign-In (powered by Firebase Authentication)
3. Access the assistant from the main navigation bar

The IICRC AI Assistant provides:

- **Professional Guidance**: IICRC-certified restoration expertise
- **Safety-Focused**: PPE and safety recommendations prioritized
- **Concise Advice**: Quick, actionable recommendations
- **Industry Standards**: Compliant with IICRC standards and best practices

Once enabled, you can use the assistant to:
1. Assess water damage severity and get mitigation plans
2. Get mold remediation protocols following S520 standards
3. Evaluate fire damage and restoration strategies
4. Determine appropriate PPE for various scenarios
5. Analyze psychrometric conditions for optimal drying
6. Upload photos for AI-powered damage assessment
7. Ask any restoration-related questions for expert guidance

## Architecture

- **Clean Architecture + MVVM** pattern
- **Riverpod** for state management
- **Drift** for local SQLite database
- **Firebase** for cloud sync and authentication
- **Firebase Authentication** with Google Sign-In for user authentication
- **Google Gemini AI** for intelligent analysis (disabled by default; requires secure backend)

## License

© 2025 AR Scan Export with IICRC AI Assistant

