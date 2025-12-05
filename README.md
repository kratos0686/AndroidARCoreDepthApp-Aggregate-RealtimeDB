# Room Scanner (Flutter)

## Project Overview
This project is a **Flutter-based AR Room Scanner** designed to capture room dimensions, detect damage, and integrate with professional restoration workflows.

### Key Features
1.  **Hybrid AR**: Auto-detects native AR (ARCore/ARKit) or falls back to WebAR.
2.  **Gemini AI**:
    *   **Visual Analysis**: Detects damage type (water, mold, cracks) from images.
    *   **Smart Notes**: Refines rough user notes into professional claim language.
    *   **Validation**: Sanity checks measurements for realism.
3.  **Professional Export**:
    *   **Xactimate**: Exports scan data to `.ESX` (XML) format.
    *   **MICA**: Exports data to MICA-compatible XML.
4.  **Offline First**: Uses Drift (SQLite) for robust local storage.

## Architecture
-   **Framework**: Flutter
-   **State Management**: Riverpod ("Riverbase")
-   **AI**: Google Gemini (via `google_generative_ai`)
-   **Database**: Drift

## Setup Instructions

### 1. Initialize Flutter Project
Since this repository only contains the source code, you must first generate the platform-specific scaffolding:

```bash
# Generate android and ios folders
flutter create .
```

### 2. Configure Environment (Gemini)
1.  Get an API Key from [Google AI Studio](https://makersuite.google.com/app/apikey).
2.  Copy `.env.example` to `.env`:
    ```bash
    cp .env.example .env
    ```
3.  Edit `.env` and add your API key:
    ```
    GEMINI_API_KEY=your_api_key_here
    ```

### 3. Configure Android
**Update `android/app/build.gradle`**:
Change the `minSdkVersion` to 24 (required for ARCore):
```gradle
defaultConfig {
    // ...
    minSdkVersion 24
    // ...
}
```

**Verify `android/app/src/main/AndroidManifest.xml`**:
Ensure the file includes Camera/AR permissions (see repository source).

### 4. Configure iOS
**Update `ios/Runner/Info.plist`**:
Add the Camera usage description:
```xml
<key>NSCameraUsageDescription</key>
<string>This app requires camera access for AR room scanning.</string>
```

### 5. Install Dependencies & Generate Code
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

### 6. Run the App
```bash
flutter run
```

## Exporting Data
To export data for **Xactimate** or **MICA**:
1.  Complete a room scan.
2.  Tap the **Share/Export** icon in the top right.
3.  Select **Xactimate (.ESX)** or **MICA (.XML)**.
4.  Share the generated file via email or drive.
