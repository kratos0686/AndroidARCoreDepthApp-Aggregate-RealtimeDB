# Project Requirements Document

## Android ARCore Depth App - Room Scanner

**Project Name**: Android ARCore Depth Room Scanner  
**Version**: 1.0  
**Last Updated**: 2025-11-21  
**Status**: Documentation Complete, Implementation Pending

---

## 1. Executive Summary

An Android application for professional 3D room scanning using ARCore depth sensing, with ML-powered damage detection, offline-first data storage, and cloud synchronization capabilities.

**Primary Use Case**: Water damage restoration professionals scanning rooms to:

- Capture accurate 3D measurements
- Detect and document damaged areas
- Generate drying plans and reports
- Sync data to cloud for team collaboration

---

## 2. Functional Requirements

### 2.1 ARCore 3D Scanning (FR-001)

**Priority**: High  
**Status**: Not Implemented

#### Requirements

- **FR-001.1**: Initialize ARCore session with depth API enabled
- **FR-001.2**: Detect horizontal planes (floors, tables)
- **FR-001.3**: Detect vertical planes (walls, doors)
- **FR-001.4**: Capture point cloud data from depth sensor
- **FR-001.5**: Calculate room dimensions (length, width, height)
- **FR-001.6**: Measure distances between user-placed anchors
- **FR-001.7**: Export point cloud data in standard format (PLY/OBJ)
- **FR-001.8**: Track AR session state and provide user feedback

#### Acceptance Criteria

- Room dimensions accurate within ±5cm
- Point cloud density sufficient for 3D reconstruction
- Real-time tracking with <100ms latency
- Graceful handling of tracking loss

---

### 2.2 Machine Learning Analysis (FR-002)

**Priority**: High  
**Status**: Not Implemented

#### Requirements

- **FR-002.1**: Integrate ML Kit Object Detection API
- **FR-002.2**: Integrate ML Kit Image Labeling API
- **FR-002.3**: Detect damage types: cracks, water stains, holes
- **FR-002.4**: Estimate material types: wood, drywall, concrete, tile
- **FR-002.5**: Provide confidence scores for all detections
- **FR-002.6**: Map detected issues to 3D spatial coordinates
- **FR-002.7**: Support custom TensorFlow Lite models
- **FR-002.8**: Run inference on-device (no cloud dependency)

#### Acceptance Criteria

- Detection confidence >70% for common damage types
- Inference time <500ms per image
- Support batch processing of images
- Graceful fallback if GPU acceleration unavailable

---

### 2.3 Offline Data Storage (FR-003)

**Priority**: High  
**Status**: Partially Implemented (Schema only)

#### Requirements

- **FR-003.1**: Implement Room Database with entities:
  - `ScanEntity`: Room scan metadata and measurements
  - `NoteEntity`: User annotations and observations
  - `ImageEntity`: Captured images with ML analysis results
- **FR-003.2**: Provide DAO interfaces with CRUD operations
- **FR-003.3**: Support reactive queries with Kotlin Flow
- **FR-003.4**: Support reactive queries with RxJava
- **FR-003.5**: Implement type converters for complex data
- **FR-003.6**: Track sync status (synced/unsynced)
- **FR-003.7**: Support database migrations
- **FR-003.8**: Enable database backup to device storage

#### Acceptance Criteria

- All data persists across app restarts
- Queries return in <100ms for typical datasets
- No data loss during migrations
- Foreign key constraints enforced

---

### 2.4 Cloud Synchronization (FR-004)

**Priority**: Medium  
**Status**: Partially Implemented (Firebase utilities only)

#### Requirements

- **FR-004.1**: Sync scan data to Firebase Firestore
- **FR-004.2**: Upload images to Firebase Storage
- **FR-004.3**: Upload point cloud files to Firebase Storage
- **FR-004.4**: Implement background sync with WorkManager
- **FR-004.5**: Handle conflict resolution (last-write-wins)
- **FR-004.6**: Retry failed uploads with exponential backoff
- **FR-004.7**: Support selective sync (WiFi-only option)
- **FR-004.8**: Implement Firebase Authentication

#### Acceptance Criteria

- Sync completes within 30s for typical scan
- No duplicate uploads
- Offline changes sync automatically when online
- User can view sync status and retry manually

---

### 2.5 User Interface (FR-005)

**Priority**: High  
**Status**: Not Implemented

#### Requirements

- **FR-005.1**: Scan List Screen (Jetpack Compose):
  - Display all scans with thumbnails
  - Show sync status indicators
  - Support pull-to-refresh
  - Search and filter functionality
- **FR-005.2**: Scan Detail Screen (Jetpack Compose):
  - Display room dimensions and volume
  - Show captured images in gallery
  - Display ML analysis results
  - List user notes with timestamps
- **FR-005.3**: AR Scanner Screen:
  - Live camera feed with AR overlay
  - Plane detection visualization
  - Measurement tools UI
  - Capture button and controls
- **FR-005.4**: Material Design 3 theming
- **FR-005.5**: Dark mode support
- **FR-005.6**: Responsive layouts for tablets
- **FR-005.7**: Loading states and error handling

#### Acceptance Criteria

- UI responds to user input in <16ms (60fps)
- No visual jank during scrolling
- Accessibility features (TalkBack compatible)
- UI matches Material Design 3 guidelines

---

### 2.6 Drying Plan Generation (FR-006)

**Priority**: Medium  
**Status**: Not Implemented

#### Requirements

- **FR-006.1**: Calculate affected area from scan data
- **FR-006.2**: Recommend equipment based on:
  - Room volume
  - Damage severity
  - Material types
- **FR-006.3**: Generate drying timeline
- **FR-006.4**: Provide priority action items
- **FR-006.5**: Export plan as PDF
- **FR-006.6**: Support customization of recommendations

#### Acceptance Criteria

- Reasonable equipment recommendations
- Timeline based on industry standards
- PDF export includes all scan data and images

---

### 2.7 Authentication & Permissions (FR-007)

**Priority**: High  
**Status**: Partially Implemented (Manifest only)

#### Requirements

- **FR-007.1**: Request camera permission at runtime
- **FR-007.2**: Request storage permission (for exports)
- **FR-007.3**: Firebase Authentication (Email/Google Sign-In)
- **FR-007.4**: User profile management
- **FR-007.5**: Check ARCore compatibility on launch
- **FR-007.6**: Prompt ARCore installation if missing

#### Acceptance Criteria

- Graceful handling of denied permissions
- Clear instructions for users
- No crashes if ARCore unavailable

---

## 3. Non-Functional Requirements

### 3.1 Performance (NFR-001)

- **NFR-001.1**: App launch time <2s on mid-range devices
- **NFR-001.2**: AR tracking initialization <1s
- **NFR-001.3**: Database queries <100ms for typical datasets
- **NFR-001.4**: ML inference <500ms per image
- **NFR-001.5**: Memory usage <200MB during normal operation
- **NFR-001.6**: Battery drain <10% per hour of active scanning

### 3.2 Reliability (NFR-002)

- **NFR-002.1**: No data loss during crashes
- **NFR-002.2**: 99.9% uptime for local features
- **NFR-002.3**: Graceful degradation if Firebase unavailable
- **NFR-002.4**: Automatic crash reporting (Firebase Crashlytics)

### 3.3 Compatibility (NFR-003)

- **NFR-003.1**: Support Android 7.0 (API 24) and above
- **NFR-003.2**: ARCore 1.40.0+ required
- **NFR-003.3**: Support devices from ~50 manufacturers
- **NFR-003.4**: Test on min 3 device form factors

### 3.4 Security (NFR-004)

- **NFR-004.1**: Encrypt sensitive data in Room Database
- **NFR-004.2**: Use Firebase Security Rules
- **NFR-004.3**: No hardcoded API keys or secrets
- **NFR-004.4**: ProGuard obfuscation in release builds
- **NFR-004.5**: HTTPS for all network traffic

### 3.5 Maintainability (NFR-005)

- **NFR-005.1**: Follow MVVM architecture pattern
- **NFR-005.2**: Minimum 80% code documentation
- **NFR-005.3**: Unit test coverage >60%
- **NFR-005.4**: Instrumented test coverage >40%
- **NFR-005.5**: CI/CD pipeline for automated testing

---

## 4. Technical Architecture

### 4.1 Technology Stack

| Component | Technology | Version |
|-----------|------------|---------|
| Language | Kotlin | 1.9.20 |
| Build Tool | Gradle | 8.2 |
| UI Framework | Jetpack Compose | BOM 2023.10.01 |
| AR SDK | ARCore | 1.40.0 |
| ML Framework | ML Kit + TensorFlow Lite | 2.14.0 |
| Database | Room | 2.6.1 |
| Async | RxJava 3 + Coroutines | 3.1.8 / 1.7.3 |
| Cloud Platform | Firebase | BOM 32.7.0 |
| Min SDK | Android 7.0 | API 24 |
| Target SDK | Android 14 | API 34 |

### 4.2 Architecture Pattern

**MVVM (Model-View-ViewModel)** with clean architecture layers:

```
┌─────────────────────────────────────────┐
│        Presentation Layer               │
│  ├─ Compose UI (View)                   │
│  └─ ViewModel (State Management)        │
└─────────────────────────────────────────┘
                 ↓ ↑
┌─────────────────────────────────────────┐
│         Domain Layer                    │
│  └─ Use Cases (Business Logic)          │
└─────────────────────────────────────────┘
                 ↓ ↑
┌─────────────────────────────────────────┐
│          Data Layer                     │
│  ├─ Repository (Abstraction)            │
│  ├─ Room Database (Local)               │
│  ├─ Firebase (Remote)                   │
│  ├─ ARCore Manager (Hardware)           │
│  └─ ML Kit Analyzer (ML)                │
└─────────────────────────────────────────┘
```

### 4.3 Data Flow

**Reactive Data Flow with RxJava & Flow:**

1. **User Action** → UI Event
2. **ViewModel** → Call Use Case
3. **Use Case** → Execute business logic
4. **Repository** → Coordinate data sources
5. **Data Sources** → Fetch/Store data
6. **Observable/Flow** → Emit updates
7. **ViewModel** → Update UI state
8. **Compose UI** → Recompose with new state

---

## 5. Dependencies

### 5.1 Core Dependencies

```gradle
// Core Android
androidx.core:core-ktx:1.12.0
androidx.appcompat:appcompat:1.6.1
androidx.lifecycle:lifecycle-runtime-ktx:2.6.2

// Jetpack Compose
androidx.compose:compose-bom:2023.10.01
androidx.compose.material3:material3
androidx.lifecycle:lifecycle-viewmodel-compose:2.6.2

// ARCore
com.google.ar:core:1.40.0
com.google.ar.sceneform:core:1.17.1

// ML Kit & TensorFlow Lite
org.tensorflow:tensorflow-lite:2.14.0
org.tensorflow:tensorflow-lite-support:0.4.4

// Room Database
androidx.room:room-runtime:2.6.1
androidx.room:room-ktx:2.6.1

// RxJava
io.reactivex.rxjava3:rxjava:3.1.8
io.reactivex.rxjava3:rxandroid:3.0.2

// Firebase (using BoM)
com.google.firebase:firebase-bom:32.7.0
com.google.firebase:firebase-firestore
com.google.firebase:firebase-storage
com.google.firebase:firebase-auth
```

---

## 6. Data Models

### 6.1 Room Database Schema

#### ScanEntity

```kotlin
@Entity(tableName = "scans")
data class ScanEntity(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val roomName: String,
    val timestamp: Long,
    val length: Float,
    val width: Float,
    val height: Float,
    val area: Float,
    val volume: Float,
    val pointCloudPath: String?,
    val isSynced: Boolean = false,
    val firebaseId: String? = null
)
```

#### NoteEntity

```kotlin
@Entity(
    tableName = "notes",
    foreignKeys = [ForeignKey(
        entity = ScanEntity::class,
        parentColumns = ["id"],
        childColumns = ["scanId"],
        onDelete = ForeignKey.CASCADE
    )]
)
data class NoteEntity(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val scanId: Long,
    val title: String,
    val content: String,
    val category: String,
    val timestamp: Long,
    val positionX: Float?,
    val positionY: Float?,
    val positionZ: Float?
)
```

---

## 7. API Contracts

### 7.1 Repository Interface

```kotlin
interface RoomScanRepository {
    // Scans
    fun getAllScans(): Flow<List<RoomScan>>
    fun getScanById(id: Long): Flow<RoomScan?>
    suspend fun insertScan(scan: RoomScan): Long
    suspend fun updateScan(scan: RoomScan)
    suspend fun deleteScan(id: Long)
    
    // Notes
    fun getNotesForScan(scanId: Long): Flow<List<Note>>
    suspend fun insertNote(note: Note): Long
    
    // Sync
    fun syncToFirebase(): Completable
    fun getUnsyncedScans(): Flow<List<RoomScan>>
}
```

---

## 8. Implementation Phases

### Phase 1: Foundation (Weeks 1-2)

- ✅ Project setup and dependencies
- ✅ Documentation
- 🔲 Room Database implementation
- 🔲 Basic UI screens (Compose)
- 🔲 Navigation setup

### Phase 2: ARCore Integration (Weeks 3-4)

- 🔲 ARCore session management
- 🔲 Plane detection
- 🔲 Point cloud capture
- 🔲 Measurement tools
- 🔲 3D visualization

### Phase 3: ML Integration (Weeks 5-6)

- 🔲 ML Kit object detection
- 🔲 Image labeling
- 🔲 Custom TFLite model integration
- 🔲 Damage detection logic
- 🔲 Material type estimation

### Phase 4: Firebase Sync (Week 7)

- 🔲 Firestore integration
- 🔲 Storage integration
- 🔲 Background sync
- 🔲 Authentication

### Phase 5: Advanced Features (Week 8)

- 🔲 Drying plan generation
- 🔲 PDF export
- 🔲 Report generation

### Phase 6: Testing & Polish (Weeks 9-10)

- 🔲 Unit tests
- 🔲 Instrumented tests
- 🔲 UI/UX improvements
- 🔲 Performance optimization
- 🔲 Bug fixes

---

## 9. Testing Strategy

### 9.1 Unit Tests

- Repository logic
- Use case business logic
- Data transformations
- ViewModel state management

### 9.2 Instrumented Tests

- Database operations
- UI components (Compose tests)
- Navigation flows

### 9.3 Manual Testing

- ARCore tracking on real devices
- ML model accuracy
- Offline/online transitions
- Cross-device compatibility

---

## 10. Deployment

### 10.1 Build Variants

- **Debug**: Development builds with logging
- **Release**: Production builds with ProGuard

### 10.2 Distribution

- Google Play Store (internal testing → beta → production)
- Enterprise distribution (if applicable)

### 10.3 Release Checklist

- [ ] Firebase configuration complete
- [ ] Security rules configured
- [ ] ProGuard rules tested
- [ ] Signed APK/AAB generated
- [ ] Tested on min 5 real devices
- [ ] Crashlytics integrated
- [ ] Privacy policy published
- [ ] Play Store listing complete

---

## 11. Risks & Mitigation

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| ARCore compatibility issues | High | Medium | Extensive device testing, fallback modes |
| ML model accuracy low | Medium | Medium | Custom model training, user feedback loop |
| Firebase quota exceeded | High | Low | Implement caching, optimize uploads |
| Performance on low-end devices | Medium | High | Profiling, optimization, min spec requirements |
| Data loss during sync | High | Low | Robust conflict resolution, local backups |

---

## 12. Success Metrics

### 12.1 Technical Metrics

- App crash rate <1%
- ANR rate <0.1%
- Scan completion rate >90%
- Sync success rate >95%

### 12.2 User Metrics

- Average scan time <5 minutes
- User retention (Day 7) >40%
- User satisfaction >4.0/5.0
- Feature adoption rate >60%

---

## 13. Future Enhancements

### 13.1 Roadmap (Post-MVP)

- Multi-room project management
- Team collaboration features
- Real-time co-editing
- Voice notes and annotations
- Integration with insurance APIs
- AR repair instruction overlay
- Cost estimation engine
- CAD format export
- iOS version (ARKit)

---

## 14. Compliance & Legal

### 14.1 Privacy

- GDPR compliance (EU users)
- CCPA compliance (California users)
- Privacy policy required
- User consent for data collection

### 14.2 Licensing

- Open source libraries: Comply with licenses
- ARCore: Google Terms of Service
- Firebase: Google Cloud Terms
- TensorFlow: Apache 2.0 License

---

## 15. References

### 15.1 Documentation

- [ARCore Developer Guide](https://developers.google.com/ar/develop)
- [ML Kit Documentation](https://developers.google.com/ml-kit)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Jetpack Compose Guide](https://developer.android.com/jetpack/compose)
- [Room Database](https://developer.android.com/training/data-storage/room)

### 15.2 Project Documentation

- [ARCHITECTURE.md](app/Android2.0roomscanner/ARCHITECTURE.md)
- [README.md](app/Android2.0roomscanner/README.md)
- [IMPLEMENTATION_SUMMARY.md](app/Android2.0roomscanner/IMPLEMENTATION_SUMMARY.md)

---

## Appendix A: Glossary

- **ARCore**: Google's augmented reality platform for Android
- **Point Cloud**: 3D representation of scanned environment as points
- **Plane Detection**: ARCore feature to identify flat surfaces
- **ML Kit**: Google's mobile ML SDK
- **TFLite**: TensorFlow Lite for mobile ML inference
- **Room**: Android's SQLite abstraction library
- **RxJava**: Reactive extensions for JVM
- **Jetpack Compose**: Android's modern UI toolkit

---

**Document Control:**

- **Author**: AI Code Assistant
- **Reviewers**: TBD
- **Approval**: TBD
- **Next Review Date**: TBD
