# Project Requirements Document

## ARCore Depth App with AI Analysis - Flutter Edition

**Project Name**: Android ARCore Depth App - Aggregate RealtimeDB  
**Version**: 2.0  
**Last Updated**: 2025-12-04  
**Status**: Flutter Architecture Established

---

## 1. Executive Summary

A cross-platform Flutter application for professional 3D room scanning using ARCore/ARKit depth sensing, with Gemini AI-powered damage analysis, offline-first Drift database, and Firebase cloud synchronization. Supports non-AR devices through WebAR fallback.

**Primary Use Case**: Water damage restoration professionals scanning rooms to:

- Capture accurate 3D measurements via AR
- Detect and document damaged areas with AI
- Generate industry-standard export formats (Xactimate .ESX, MICA XML)
- Sync data to Firebase for team collaboration
- Work offline-first with automatic cloud sync

---

## 2. Platform & Technology Stack

### 2.1 Development Platform

| Component | Technology | Version |
|-----------|------------|---------|
| **Framework** | Flutter | 3.0+ |
| **Language** | Dart | 3.0+ |
| **Platform** | Android (primary), iOS (future) | API 24+ / iOS 12+ |

### 2.2 Architecture Pattern

**Clean Architecture + MVVM** with Flutter-specific layers:

```
┌─────────────────────────────────────────┐
│     Presentation Layer (UI)             │
│  ├─ Screens (Flutter Widgets)           │
│  ├─ Riverpod Providers (State)          │
│  └─ ViewModels (Business Logic)         │
└─────────────────────────────────────────┘
                 ↓ ↑
┌─────────────────────────────────────────┐
│        Domain Layer (Core)              │
│  ├─ Entities (Business Models)          │
│  ├─ Use Cases (Business Rules)          │
│  └─ Services (AI, Export, AR)           │
└─────────────────────────────────────────┘
                 ↓ ↑
┌─────────────────────────────────────────┐
│       Data Layer (Sources)              │
│  ├─ Drift Database (Local SQLite)       │
│  ├─ Firebase (Remote Firestore/Storage) │
│  ├─ Repositories (Abstraction)          │
│  └─ Platform Channels (ARCore/ARKit)    │
└─────────────────────────────────────────┘
```

### 2.3 Core Dependencies

```yaml
# State Management & Architecture
flutter_riverpod: ^2.5.1
riverpod_annotation: ^2.3.5

# Database (Offline-First)
drift: ^2.16.0
sqlite3_flutter_libs: ^0.5.20
path_provider: ^2.1.2

# Cloud Backend
firebase_core: ^2.27.0
firebase_auth: ^4.17.8
firebase_firestore: ^4.15.8
firebase_storage: ^11.6.9

# AI Integration
google_generative_ai: ^0.2.2
flutter_dotenv: ^5.1.0

# AR & Fallback
arcore_flutter_plugin: ^0.1.0
webview_flutter: ^4.5.0

# Permissions & Utilities
permission_handler: ^11.3.0
```

---

## 3. Functional Requirements

### 3.1 AR Scanning with Fallback (FR-001)

**Priority**: High  
**Status**: Scaffold Ready

#### Requirements

- **FR-001.1**: Detect AR capability on device launch
- **FR-001.2**: Native ARCore for Android devices with ARCore support
- **FR-001.3**: Native ARKit for iOS devices (future)
- **FR-001.4**: WebAR fallback using WebView for non-AR devices
- **FR-001.5**: Capture point cloud data and room dimensions
- **FR-001.6**: Export scan data in standard formats (PLY/OBJ)
- **FR-001.7**: Seamless fallback UX (auto-detect and switch)

#### Acceptance Criteria

- App installs and runs on non-AR devices without crashing
- AR features optional (AndroidManifest: `required="false"`)
- WebAR provides basic measurement capabilities
- User notified clearly which mode is active

---

### 3.2 Gemini AI Analysis (FR-002)

**Priority**: High  
**Status**: Service Stub Ready

#### Requirements

- **FR-002.1**: Integration with Google Gemini API via `google_generative_ai`
- **FR-002.2**: Analyze images for damage detection (water stains, cracks, mold)
- **FR-002.3**: Material identification (drywall, wood, tile, concrete)
- **FR-002.4**: Generate damage severity reports
- **FR-002.5**: Confidence scoring for AI predictions
- **FR-002.6**: API key management via `.env` file

#### Acceptance Criteria

- Gemini API calls execute successfully with valid key
- Response parsed and stored in Drift database
- Error handling for rate limits and network issues
- No hardcoded API keys in source code

---

### 3.3 Offline-First Drift Database (FR-003)

**Priority**: High  
**Status**: Scaffold Ready

#### Requirements

- **FR-003.1**: Drift (SQLite) database for local persistence
- **FR-003.2**: Tables: Scans, Notes, Images, SyncQueue
- **FR-003.3**: Type converters for complex Dart objects (JSON, DateTime)
- **FR-003.4**: Reactive queries with Dart Streams
- **FR-003.5**: Track sync status for each record
- **FR-003.6**: Migration support for schema changes
- **FR-003.7**: Data available offline immediately

#### Acceptance Criteria

- All data persists across app restarts
- Queries execute in <100ms
- Migrations tested with no data loss
- Foreign key constraints enforced

---

### 3.4 Firebase Cloud Sync (FR-004)

**Priority**: Medium  
**Status**: Provider Scaffold Ready

#### Requirements

- **FR-004.1**: Firestore for scan metadata and notes
- **FR-004.2**: Firebase Storage for images and point clouds
- **FR-004.3**: Firebase Auth for user authentication
- **FR-004.4**: Background sync when online
- **FR-004.5**: Conflict resolution (last-write-wins or timestamp-based)
- **FR-004.6**: Exponential backoff for failed uploads
- **FR-004.7**: WiFi-only sync option

#### Acceptance Criteria

- Offline changes sync automatically when online
- No duplicate uploads
- User can view sync status in UI
- Manual retry option available

---

### 3.5 Export Service (FR-005)

**Priority**: Medium  
**Status**: Service Stub Ready

#### Requirements

- **FR-005.1**: Export scans to Xactimate format (.ESX)
- **FR-005.2**: Export scans to MICA format (XML)
- **FR-005.3**: Include room dimensions, materials, damage areas
- **FR-005.4**: Embed AI analysis results in export
- **FR-005.5**: Save exports to device storage
- **FR-005.6**: Share exports via platform share sheet

#### Acceptance Criteria

- Exported files valid for Xactimate import
- MICA XML conforms to industry standards
- Files include all relevant scan data
- Export completes in <5 seconds for typical scan

---

### 3.6 Material 3 UI (FR-006)

**Priority**: High  
**Status**: Theme Ready in main.dart

#### Requirements

- **FR-006.1**: Material Design 3 theming
- **FR-006.2**: Dynamic color support (Material You)
- **FR-006.3**: Dark mode support
- **FR-006.4**: Responsive layouts (phone, tablet)
- **FR-006.5**: Accessibility (screen reader support)
- **FR-006.6**: Loading states and error handling

#### Acceptance Criteria

- UI matches Material 3 guidelines
- Theme switches smoothly
- No visual jank (60fps)
- Accessible to users with disabilities

---

### 3.7 Permissions Management (FR-007)

**Priority**: High  
**Status**: Permission Handler Configured

#### Requirements

- **FR-007.1**: Camera permission (for AR and image capture)
- **FR-007.2**: Storage permission (for exports)
- **FR-007.3**: Internet permission (for Firebase sync)
- **FR-007.4**: Graceful handling of denied permissions
- **FR-007.5**: Request permissions at runtime (Android 6+)

#### Acceptance Criteria

- App requests permissions when needed
- Clear rationale shown to user
- App functions with limited permissions where possible
- No crashes on permission denial

---

## 4. Non-Functional Requirements

### 4.1 Performance (NFR-001)

- **NFR-001.1**: App launch time <3s on mid-range devices
- **NFR-001.2**: Database queries <100ms
- **NFR-001.3**: Gemini API response <3s (network dependent)
- **NFR-001.4**: Memory usage <250MB during scanning
- **NFR-001.5**: Battery drain <15% per hour of active use

### 4.2 Reliability (NFR-002)

- **NFR-002.1**: No data loss on crashes
- **NFR-002.2**: Offline-first: works without internet
- **NFR-002.3**: Graceful degradation (AR → WebAR fallback)
- **NFR-002.4**: Error logging with Firebase Crashlytics (future)

### 4.3 Compatibility (NFR-003)

- **NFR-003.1**: Android 7.0+ (API 24)
- **NFR-003.2**: ARCore optional (not required for install)
- **NFR-003.3**: iOS 12+ (future support)
- **NFR-003.4**: Tested on min 3 device types

### 4.4 Security (NFR-004)

- **NFR-004.1**: API keys stored in `.env` (not in source)
- **NFR-004.2**: Firebase Security Rules for Firestore/Storage
- **NFR-004.3**: HTTPS for all network traffic
- **NFR-004.4**: User authentication required for cloud sync
- **NFR-004.5**: No sensitive data in logs

### 4.5 Maintainability (NFR-005)

- **NFR-005.1**: Clean Architecture pattern enforced
- **NFR-005.2**: Code generation for Drift and Riverpod
- **NFR-005.3**: Documentation for all services and providers
- **NFR-005.4**: Unit tests for business logic
- **NFR-005.5**: Widget tests for UI components

---

## 5. Data Models

### 5.1 Drift Database Schema (Dart)

#### Scans Table

```dart
class Scans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get roomName => text()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get length => real()();
  RealColumn get width => real()();
  RealColumn get height => real()();
  RealColumn get area => real()();
  RealColumn get volume => real()();
  TextColumn get pointCloudPath => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  TextColumn get firebaseId => text().nullable()();
}
```

#### Notes Table

```dart
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get scanId => integer().references(Scans, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  TextColumn get content => text()();
  TextColumn get category => text()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get positionX => real().nullable()();
  RealColumn get positionY => real().nullable()();
  RealColumn get positionZ => real().nullable()();
}
```

---

## 6. Riverpod State Management

### 6.1 Provider Structure

```dart
// Database Provider
@riverpod
AppDatabase appDatabase(AppDatabaseRef ref) {
  return AppDatabase();
}

// Repository Providers
@riverpod
ScanRepository scanRepository(ScanRepositoryRef ref) {
  final db = ref.watch(appDatabaseProvider);
  return ScanRepositoryImpl(db);
}

// Firebase Providers
@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

@riverpod
FirebaseFirestore firebaseFirestore(FirebaseFirestoreRef ref) {
  return FirebaseFirestore.instance;
}

// Service Providers
@riverpod
GeminiService geminiService(GeminiServiceRef ref) {
  return GeminiService();
}

@riverpod
ExportService exportService(ExportServiceRef ref) {
  return ExportService();
}
```

---

## 7. Service Interfaces

### 7.1 GeminiService

```dart
class GeminiService {
  Future<AnalysisResult> analyzeImage(String imagePath) async {
    // Call Gemini API with image
    // Return damage analysis and material identification
  }
  
  Future<String> generateReport(ScanData scanData) async {
    // Generate text report using Gemini
  }
}
```

### 7.2 ExportService

```dart
class ExportService {
  Future<File> exportToXactimate(ScanData scanData) async {
    // Generate .ESX file format
  }
  
  Future<File> exportToMICA(ScanData scanData) async {
    // Generate MICA XML file format
  }
  
  Future<void> shareScanExport(File exportFile) async {
    // Use platform share sheet
  }
}
```

---

## 8. Implementation Status

### Phase 1: Foundation ✅

- ✅ Flutter project structure
- ✅ pubspec.yaml with all dependencies
- ✅ REQUIREMENTS.md updated
- ✅ .env file for API keys
- ✅ Android configuration (minSdkVersion 24, AR optional)
- ✅ Riverpod provider scaffolding
- ✅ Drift database scaffolding
- ✅ Firebase initialization in main.dart
- ✅ Material 3 theme setup
- ✅ Service stubs (Gemini, Export)
- ✅ AR screen stub (with fallback logic)

### Phase 2: Database Implementation 🔲

- 🔲 Complete Drift table definitions
- 🔲 Implement DAOs and repositories
- 🔲 Add type converters
- 🔲 Write database migrations
- 🔲 Create repository implementations

### Phase 3: UI Screens 🔲

- 🔲 Scan list screen
- 🔲 Scan detail screen
- 🔲 AR scan screen (full implementation)
- 🔲 Settings screen
- 🔲 Authentication screens

### Phase 4: AR & WebAR 🔲

- 🔲 Native ARCore integration
- 🔲 WebAR fallback implementation
- 🔲 Point cloud capture
- 🔲 Measurement tools

### Phase 5: AI Integration 🔲

- 🔲 Complete Gemini API implementation
- 🔲 Image analysis pipeline
- 🔲 Result parsing and storage
- 🔲 Error handling and retry logic

### Phase 6: Export Features 🔲

- 🔲 Xactimate .ESX generator
- 🔲 MICA XML generator
- 🔲 File management
- 🔲 Share functionality

### Phase 7: Testing & Polish 🔲

- 🔲 Unit tests
- 🔲 Widget tests
- 🔲 Integration tests
- 🔲 Performance optimization
- 🔲 Bug fixes

---

## 9. Setup Instructions

### 9.1 Initial Setup

After cloning the repository:

```bash
# Create platform folders (if missing)
flutter create .

# Install dependencies
flutter pub get

# Run code generation for Drift and Riverpod
dart run build_runner build --delete-conflicting-outputs

# Add your Gemini API key to .env
# Edit .env and replace placeholder with actual key
```

### 9.2 Firebase Configuration

1. Create Firebase project at console.firebase.google.com
2. Add Android app with package name: `com.example.android_arcore_depth_app_aggregate_realtimedb`
3. Download `google-services.json` → `android/app/`
4. Enable Authentication, Firestore, Storage in Firebase Console

### 9.3 Run the App

```bash
# Debug build
flutter run

# Release build
flutter build apk --release
```

---

## 10. Testing Strategy

### 10.1 Unit Tests

- Repository logic
- Service implementations (Gemini, Export)
- Data transformations
- Business logic in use cases

### 10.2 Widget Tests

- UI components
- State management (Riverpod providers)
- Navigation flows

### 10.3 Integration Tests

- Database operations
- Firebase sync
- AR functionality (on physical devices)

### 10.4 Manual Testing

- AR on multiple devices
- WebAR fallback
- Offline/online transitions
- Export file validity

---

## 11. Deployment

### 11.1 Android

- Min SDK: API 24 (Android 7.0)
- Target SDK: API 34 (Android 14)
- ARCore: Optional (required="false")
- Distribution: Google Play Store

### 11.2 iOS (Future)

- Min iOS: 12.0
- ARKit: Optional
- Distribution: App Store

---

## 12. References

### 12.1 Flutter Documentation

- [Flutter Official Docs](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [Drift (SQLite) Documentation](https://drift.simonbinder.eu)
- [Firebase for Flutter](https://firebase.flutter.dev)

### 12.2 AR & AI

- [ARCore Flutter Plugin](https://pub.dev/packages/arcore_flutter_plugin)
- [Google Generative AI Dart](https://pub.dev/packages/google_generative_ai)
- [WebAR Best Practices](https://developers.google.com/ar/develop/webxr)

### 12.3 Industry Standards

- [Xactimate File Format](https://www.xactware.com)
- [MICA Insurance Standards](https://www.mica.org)

---

**Document Control:**

- **Author**: AI Code Assistant
- **Platform**: Flutter/Dart
- **Architecture**: Clean Architecture + MVVM + Riverpod
- **Last Updated**: 2025-12-04
