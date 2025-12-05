# IICRC AI Assistant - Architecture Overview

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Application                       │
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │         Presentation Layer (UI)                     │    │
│  │                                                      │    │
│  │  ┌──────────────────────────────────────────────┐  │    │
│  │  │  Main Navigation (Bottom Nav Bar)            │  │    │
│  │  │  - Home                                       │  │    │
│  │  │  - Scans                                      │  │    │
│  │  │  - IICRC AI ← NEW                            │  │    │
│  │  │  - Settings                                   │  │    │
│  │  └──────────────────────────────────────────────┘  │    │
│  │                                                      │    │
│  │  ┌──────────────────────────────────────────────┐  │    │
│  │  │  IICRC Assistant Screen                      │  │    │
│  │  │  ┌────────────────────────────────────────┐  │  │    │
│  │  │  │ 1. Water Mitigation                    │  │  │    │
│  │  │  │ 2. Mold Remediation (S520)            │  │  │    │
│  │  │  │ 3. Fire Damage                        │  │  │    │
│  │  │  │ 4. PPE Recommendations                │  │  │    │
│  │  │  │ 5. Psychrometric Analysis             │  │  │    │
│  │  │  │ 6. Damage Assessment                  │  │  │    │
│  │  │  │ 7. Ask a Question                     │  │  │    │
│  │  │  └────────────────────────────────────────┘  │  │    │
│  │  └──────────────────────────────────────────────┘  │    │
│  │                                                      │    │
│  │  Riverpod State Management                          │    │
│  │  - iicrcAssistantProvider                          │    │
│  └────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │         Domain Layer (Business Logic)               │    │
│  │                                                      │    │
│  │  ┌──────────────────────────────────────────────┐  │    │
│  │  │  IICRCAssistantService                       │  │    │
│  │  │                                               │  │    │
│  │  │  - assessWaterDamage()                       │  │    │
│  │  │  - adviseMoldRemediation()                   │  │    │
│  │  │  - assessFireDamage()                        │  │    │
│  │  │  - recommendPPE()                            │  │    │
│  │  │  - analyzePsychrometrics()                   │  │    │
│  │  │  - analyzePhoto()                            │  │    │
│  │  │  - askQuestion()                             │  │    │
│  │  └──────────────────────────────────────────────┘  │    │
│  │                                                      │    │
│  │  Data Models:                                        │    │
│  │  - WaterDamageAssessment                            │    │
│  │  - MoldRemediationAdvice                            │    │
│  │  - FireDamageAssessment                             │    │
│  │  - PPERecommendation                                │    │
│  │  - PsychrometricAnalysis                            │    │
│  │  - DamagePhotoAnalysis                              │    │
│  └────────────────────────────────────────────────────┘    │
│                          ↓↑                                  │
│  ┌────────────────────────────────────────────────────┐    │
│  │         External Services                           │    │
│  │                                                      │    │
│  │  ┌──────────────────────────────────────────────┐  │    │
│  │  │  Google Gemini 1.5 Pro API                   │  │    │
│  │  │                                               │  │    │
│  │  │  System Instruction:                         │  │    │
│  │  │  ┌────────────────────────────────────────┐  │  │    │
│  │  │  │  IICRC Certified Knowledge Base        │  │  │    │
│  │  │  │  - WRT Standards                       │  │  │    │
│  │  │  │  - S500 (Water Damage)                 │  │  │    │
│  │  │  │  - S520 (Mold Remediation)            │  │  │    │
│  │  │  │  - FSRT (Fire & Smoke)                │  │  │    │
│  │  │  │  - AMRT (Microbial)                   │  │  │    │
│  │  │  │  - PPE Protocols                       │  │  │    │
│  │  │  │  - Psychrometric Calculations          │  │  │    │
│  │  │  └────────────────────────────────────────┘  │  │    │
│  │  └──────────────────────────────────────────────┘  │    │
│  └────────────────────────────────────────────────────┘    │
│                                                              │
│  Configuration:                                              │
│  .env file → GEMINI_API_KEY                                 │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

### Water Mitigation Assessment Flow

```
User Input
    ↓
┌─────────────────────┐
│ Water Mitigation    │
│ Screen              │
│ (Form)              │
└─────────────────────┘
    ↓
    Description: "Burst pipe in kitchen..."
    ↓
┌──────────────────────────────────────┐
│ IICRCAssistantService                │
│ .assessWaterDamage()                 │
└──────────────────────────────────────┘
    ↓
┌──────────────────────────────────────┐
│ Google Gemini API                    │
│ + IICRC System Instructions          │
└──────────────────────────────────────┘
    ↓
    Structured Analysis
    ↓
┌──────────────────────────────────────┐
│ WaterDamageAssessment                │
│ - waterClass: "Class 2"              │
│ - waterCategory: "Category 1"        │
│ - equipment: [...]                   │
│ - estimatedDryingDays: "3-5 days"   │
│ - ppeLevel: "Level 2"                │
└──────────────────────────────────────┘
    ↓
┌──────────────────────────────────────┐
│ Display Results                      │
│ (UI Card with formatted data)        │
└──────────────────────────────────────┘
```

### Photo Analysis Flow

```
User Action
    ↓
┌─────────────────────┐
│ Upload Photo        │
│ + Context           │
└─────────────────────┘
    ↓
    Image bytes + description
    ↓
┌──────────────────────────────────────┐
│ IICRCAssistantService                │
│ .analyzePhoto()                      │
└──────────────────────────────────────┘
    ↓
┌──────────────────────────────────────┐
│ Gemini Vision API                    │
│ + IICRC Damage Assessment Context    │
└──────────────────────────────────────┘
    ↓
    AI Vision Analysis
    ↓
┌──────────────────────────────────────┐
│ DamagePhotoAnalysis                  │
│ - materials: [...]                   │
│ - damageType: "water"                │
│ - damageExtent: "moderate"           │
│ - moistureIndicators: [...]          │
│ - safetyHazards: [...]               │
└──────────────────────────────────────┘
    ↓
    Display comprehensive analysis
```

## Component Interaction

```
┌────────────────┐         ┌──────────────────┐
│ User Interface │ ←────→  │ IICRC Assistant  │
│ (Screens)      │         │ Screen           │
└────────────────┘         └──────────────────┘
         ↓                          ↓
         ↓                          ↓
┌─────────────────────────────────────────────┐
│         Riverpod Provider                   │
│         iicrcAssistantProvider              │
└─────────────────────────────────────────────┘
                    ↓
                    ↓
┌─────────────────────────────────────────────┐
│      IICRCAssistantService Instance         │
│      (Singleton via Provider)               │
└─────────────────────────────────────────────┘
                    ↓
                    ↓
┌─────────────────────────────────────────────┐
│      Google Gemini GenerativeModel          │
│      (Initialized with System Context)      │
└─────────────────────────────────────────────┘
```

## IICRC Knowledge Base Structure

The AI is pre-loaded with comprehensive IICRC expertise:

```
IICRC Context (System Instruction)
├── Water Damage Restoration (WRT)
│   ├── Classes (1-4): Extent of damage
│   │   ├── Class 1: Minimal absorption
│   │   ├── Class 2: Significant absorption
│   │   ├── Class 3: Maximum absorption
│   │   └── Class 4: Specialty materials
│   └── Categories (1-3): Contamination level
│       ├── Category 1: Clean water
│       ├── Category 2: Grey water
│       └── Category 3: Black water
│
├── Mold Remediation (S520)
│   ├── Condition 1: Normal ecology
│   ├── Condition 2: <10 sq ft
│   ├── Condition 3: 10-100 sq ft
│   └── Condition 4: >100 sq ft
│
├── Fire & Smoke Restoration (FSRT)
│   ├── Smoke types (protein/natural/synthetic)
│   ├── Cleaning methods
│   └── Odor control
│
├── PPE Protocols
│   ├── Level 1: Basic protection
│   ├── Level 2: Enhanced protection
│   ├── Level 3: Full protection
│   └── Level 4: Hazmat
│
├── Psychrometric Science
│   ├── GPP calculations
│   ├── RH interpretation
│   ├── Dew point formulas
│   └── Drying strategies
│
└── Damage Assessment
    ├── Material identification
    ├── Severity evaluation
    ├── Moisture detection
    └── Safety hazards
```

## Key Design Principles

1. **Safety First**: All recommendations prioritize technician safety
2. **IICRC Compliance**: All guidance follows certified standards
3. **Minimal Changes**: Integration doesn't disrupt existing AR features
4. **User-Friendly**: Intuitive navigation and clear results
5. **Professional**: Industry-standard terminology and formatting
6. **Comprehensive**: 7 categories covering all restoration needs
7. **Contextual**: AI understands restoration scenarios
8. **Actionable**: Provides specific, implementable guidance

## Technology Stack

- **Frontend**: Flutter 3.0+ (Dart)
- **State Management**: Riverpod 2.5+
- **AI Engine**: Google Gemini 1.5 Pro
- **Architecture**: Clean Architecture + MVVM
- **Design**: Material Design 3
- **Platform**: Android (API 24+), iOS future

## File Organization

```
lib/
├── domain/
│   └── service/
│       ├── gemini_service.dart
│       ├── export_service.dart
│       └── iicrc_assistant_service.dart ← NEW (808 lines)
│
├── presentation/
│   ├── providers/
│   │   └── providers.dart (includes iicrcAssistantProvider)
│   └── screens/
│       ├── ar_scan_screen.dart
│       └── iicrc_assistant_screen.dart ← NEW (940 lines)
│
└── main.dart (updated with IICRC initialization)

Documentation/
├── IICRC_ASSISTANT.md (Technical documentation)
├── IICRC_QUICK_START.md (User guide)
├── README.md (Updated overview)
├── REQUIREMENTS.md (Updated with FR-002a)
└── ARCHITECTURE.md (This file)
```

## Future Enhancements

### Phase 1 (Current) ✅
- Core service implementation
- 7 assessment categories
- UI integration
- Documentation

### Phase 2 (Planned)
- [ ] Complete all category screens (currently placeholders)
- [ ] Image upload functionality for Damage Assessment
- [ ] Camera integration for real-time analysis
- [ ] JSON response parsing for structured data

### Phase 3 (Future)
- [ ] Offline mode with cached responses
- [ ] Voice input/output
- [ ] Report PDF generation
- [ ] Integration with Xactimate/MICA
- [ ] Multi-language support
- [ ] Thermal image analysis

## Performance Considerations

- **API Calls**: Average 2-5 seconds per request
- **Image Analysis**: 5-10 seconds with photos
- **Caching**: Not implemented yet
- **Network**: Requires internet connection
- **Rate Limits**: Subject to Gemini API limits

## Security

- ✅ API key stored in `.env` (not in source control)
- ✅ No hardcoded secrets
- ✅ HTTPS for all API communication
- ✅ No sensitive data in logs
- ⚠️ Requires valid Gemini API key

---

**Version**: 1.0.0  
**Created**: 2025-12-05  
**Last Updated**: 2025-12-05  
**Author**: IICRC AI Assistant Development Team
