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
- Google Gemini API key (for AI features)
- Firebase project (for cloud sync)

## Setup

1. Install dependencies:
```bash
flutter pub get
```

2. Configure API keys in `.env`:
```
GEMINI_API_KEY=your_gemini_api_key_here
```

3. Set up Firebase (see SETUP_GUIDE.md for details)

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

The IICRC AI Assistant is accessible from the main navigation bar. It provides:

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

## Architecture

- **Clean Architecture + MVVM** pattern
- **Riverpod** for state management
- **Drift** for local SQLite database
- **Firebase** for cloud sync and authentication
- **Google Gemini AI** for intelligent analysis and IICRC expertise

## License

© 2025 AR Scan Export with IICRC AI Assistant

