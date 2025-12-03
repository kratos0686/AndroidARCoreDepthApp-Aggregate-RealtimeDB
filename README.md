# Room Scanner (Flutter)

## Project Overview
This project is a **Flutter-based AR Room Scanner** designed to capture room dimensions and detect damage. It employs a **hybrid AR strategy**:
1.  **Native AR**: Uses ARCore/ARKit on supported devices for high-fidelity scanning.
2.  **WebAR Fallback**: Uses a WebView-based 3D viewer for unsupported devices.

## Architecture
-   **Framework**: Flutter
-   **State Management**: Riverpod ("Riverbase")
-   **Database**: Drift (SQLite)
-   **Backend**: Firebase (Firestore, Storage)

## Setup Instructions

### 1. Initialize Flutter Project
Since this repository only contains the source code, you must first generate the platform-specific scaffolding:

```bash
# Generate android and ios folders
flutter create .
```

### 2. Configure Android
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
Ensure the file includes the Camera permission and ARCore metadata (this file should be present in the repo, but if overwritten by `flutter create`, check `android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.CAMERA" />
<meta-data android:name="com.google.ar.core" android:value="required" />
```

### 3. Configure iOS
**Update `ios/Runner/Info.plist`**:
Add the Camera usage description:
```xml
<key>NSCameraUsageDescription</key>
<string>This app requires camera access for AR room scanning.</string>
```

### 4. Install Dependencies
```bash
flutter pub get
```

### 5. Code Generation
Run the build runner to generate Riverpod and Drift code:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 6. Run the App
```bash
flutter run
```

## AR Configuration
-   **Native**: The app uses `ar_flutter_plugin`. Ensure your physical device supports ARCore (Android) or ARKit (iOS).
-   **WebAR**: If native AR is unavailable, the app redirects to a WebView. Configure the WebAR URL in `lib/features/ar/web_ar_view.dart`.

## Database
The local database uses **Drift**. Schema definitions are in `lib/data/database/database.dart`.
