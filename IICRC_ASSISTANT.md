# IICRC Certified Master Water Restorer AI Assistant

## Overview

This Flutter application integrates a comprehensive **IICRC Certified Master Water Restorer AI Assistant** powered by Google Gemini AI. The assistant is designed to support field technicians in the assessment and execution of restoration projects with professional, safety-focused, and concise advice.

## Features

### 1. Water Mitigation

Categorize and assess water damage according to IICRC standards:

#### Water Damage Classes
- **Class 1**: Minimal water absorption, affects only part of a room, materials have low permeance/porosity
- **Class 2**: Significant water absorption, affects entire room, carpet and cushion, may have wicked up walls 12-24 inches
- **Class 3**: Greatest amount of water absorption, water comes from overhead, walls and ceilings saturated
- **Class 4**: Specialty drying, materials with very low permeance (hardwood, plaster, brick, concrete, stone)

#### Water Categories
- **Category 1**: Clean water from sanitary source (broken pipe, toilet tank, rain water)
- **Category 2**: Grey water with contamination (washing machine overflow, toilet overflow with urine, dishwasher overflow)
- **Category 3**: Black water, highly contaminated (sewage, flooding from rivers, toilet overflow with feces)

#### Guidance Provided
- Affected materials identification
- Recommended immediate actions
- Equipment needed (dehumidifiers, air movers, etc.)
- Estimated drying time
- Required PPE level
- Safety concerns

**Usage**: Navigate to IICRC AI → Water Mitigation, describe the damage scenario, and receive instant classification and guidance.

---

### 2. Mold Remediation (S520 Standard)

Advise on mold remediation protocols following IICRC S520 standards:

#### Condition Levels
- **Condition 1**: Normal fungal ecology, routine cleaning
- **Condition 2**: Small isolated areas (<10 sq ft), limited removal, source control
- **Condition 3**: Large isolated areas (10-100 sq ft), full containment required
- **Condition 4**: Extensive contamination (>100 sq ft), full containment with airlock

#### Guidance Provided
- Condition level assessment
- Affected area estimation
- Containment requirements (none/limited/full/full with airlock)
- Step-by-step remediation protocol
- Required PPE specifications
- Air filtration (HEPA and negative air requirements)
- Safe disposal procedures
- Post-remediation verification requirements
- Critical safety warnings

**Usage**: Navigate to IICRC AI → Mold Remediation, describe the mold situation (optionally with photos), and receive S520-compliant remediation guidance.

---

### 3. Fire Damage Restoration

Assist with initial fire damage assessments:

#### Assessment Areas
- Smoke damage type identification (protein, natural, synthetic)
- Structural integrity evaluation
- Salvageable vs. non-salvageable material determination
- Appropriate cleaning methods (dry cleaning, wet cleaning, abrasive, immersion)
- Odor control strategies

#### Guidance Provided
- Smoke damage type classification
- Structural assessment
- List of salvageable items
- List of items requiring replacement
- Recommended cleaning methods
- Odor control strategies
- Estimated restoration timeline
- Safety concerns and hazards

**Usage**: Navigate to IICRC AI → Fire Damage, describe the fire damage scenario, and receive comprehensive restoration guidance.

---

### 4. PPE Recommendations

Ensure safety compliance with appropriate personal protective equipment:

#### PPE Levels
- **Level 1**: Basic (gloves, safety glasses, dust mask) - routine cleaning
- **Level 2**: Enhanced (N95 respirator, goggles, protective clothing) - mold, contaminated water
- **Level 3**: Full protection (full-face respirator with P100 filters, Tyvek suit, boot covers) - black water, extensive mold
- **Level 4**: Hazmat (SCBA, fully encapsulated suit) - chemical hazards, confined spaces

#### Guidance Provided
- Overall PPE level recommendation
- Head protection requirements (hard hat, face shield)
- Eye protection specifications (safety glasses, goggles)
- Respiratory protection (mask type: N95, P100, SCBA)
- Hand protection (glove type: nitrile, chemical resistant)
- Body protection (clothing type: Tyvek, chemical suit)
- Foot protection requirements
- Additional safety equipment
- Decontamination procedures

**Usage**: Navigate to IICRC AI → PPE Recommendations, describe the work scenario and identified hazards, and receive specific PPE guidance.

---

### 5. Psychrometric Analysis

Interpret environmental conditions for optimal drying strategies:

#### Key Metrics
- **GPP (Grains Per Pound)**: Moisture content of air
- **RH (Relative Humidity)**: Percentage of saturation
- **Dew Point**: Temperature at which condensation occurs

#### Target Conditions
- RH: 30-50%
- GPP: < ambient +10-20 grains

#### Guidance Provided
- Dew point calculation
- Grains per pound analysis
- Vapor pressure evaluation
- Drying potential assessment (good/fair/poor)
- Target RH and GPP recommendations
- Equipment recommendations (dehumidifier and air mover specifications)
- Adjustment recommendations to optimize drying
- Estimated drying time based on conditions

**Usage**: Navigate to IICRC AI → Psychrometric Analysis, input temperature and relative humidity readings, and receive comprehensive drying strategy guidance.

---

### 6. Damage Assessment

Analyze photos and videos to identify materials and assess damage extent:

#### Analysis Capabilities
- Material identification (drywall, wood, carpet, tile, insulation, concrete, etc.)
- Damage type classification (water, mold, fire, structural)
- Damage extent evaluation (minor, moderate, severe, critical)
- Affected area mapping with size estimates
- Moisture indicator detection
- Safety hazard identification
- Immediate action recommendations
- Documentation notes for records

#### Guidance Provided
- List of identified materials and their condition
- Damage type classification
- Severity assessment
- Detailed description of affected areas
- Visible moisture indicators
- Safety hazards present
- Immediate actions required
- Comprehensive documentation notes

**Usage**: Navigate to IICRC AI → Damage Assessment, upload a photo or video, optionally add context, and receive detailed AI-powered analysis.

---

### 7. Ask a Question

General restoration guidance through natural language conversation:

#### Capabilities
- Answer any restoration-related questions
- Provide IICRC-certified expertise
- Offer equipment recommendations
- Explain restoration procedures
- Clarify industry standards
- Give safety advice

#### Example Questions
- "What dehumidifier capacity do I need for a 500 sq ft room?"
- "How do I handle asbestos discovered during water damage restoration?"
- "What's the difference between structural and non-structural drying?"
- "When should I call for mold testing?"
- "How do I document water damage for insurance claims?"

**Usage**: Navigate to IICRC AI → Ask a Question, type your question in natural language, and receive expert guidance in real-time.

---

## Technical Implementation

### Architecture

The IICRC AI Assistant is implemented as a Flutter service using:

- **Google Gemini 1.5 Pro**: Advanced language model with extended context
- **System Instructions**: Pre-loaded with comprehensive IICRC knowledge base
- **Structured Prompts**: Specific prompts for each assessment type
- **JSON Responses**: Structured data for easy parsing and display

### Service Class

`IICRCAssistantService` (lib/domain/service/iicrc_assistant_service.dart)

Main methods:
- `initialize()`: Initialize the Gemini model with IICRC context
- `assessWaterDamage()`: Water damage classification and guidance
- `adviseMoldRemediation()`: S520-compliant mold advice
- `assessFireDamage()`: Fire damage evaluation
- `recommendPPE()`: Safety equipment recommendations
- `analyzePsychrometrics()`: Environmental condition analysis
- `analyzePhoto()`: Image-based damage assessment
- `askQuestion()`: General restoration questions

### Data Models

Structured response models for each assessment type:
- `WaterDamageAssessment`
- `MoldRemediationAdvice`
- `FireDamageAssessment`
- `PPERecommendation`
- `PsychrometricAnalysis`
- `DamagePhotoAnalysis`

### UI Implementation

`IICRCAssistantScreen` (lib/presentation/screens/iicrc_assistant_screen.dart)

Features:
- Category-based navigation
- Form-based input for assessments
- Chat interface for questions
- Real-time AI responses
- Professional Material 3 design
- Certification badge display

---

## Configuration

### API Key Setup

1. Obtain a Gemini API key from: https://makersuite.google.com/app/apikey

2. Add to `.env` file:
```
GEMINI_API_KEY=your_actual_api_key_here
```

3. The app will initialize the IICRC Assistant on startup

### Error Handling

If the API key is missing or invalid:
- The app will start normally
- AI Assistant features will show an error message
- Other app features remain functional
- User can configure the API key and restart

---

## Best Practices

### For Field Technicians

1. **Start with Water Mitigation**: Always classify water damage first
2. **Check PPE Requirements**: Review safety equipment before entering
3. **Document Everything**: Use Damage Assessment to analyze photos
4. **Ask Questions**: Use the Q&A feature for clarifications
5. **Verify Readings**: Use Psychrometric Analysis to confirm drying progress

### Safety First

- The assistant always prioritizes safety recommendations
- PPE guidance is provided for all scenarios
- Safety concerns are highlighted in all assessments
- Follow IICRC standards and local regulations
- Consult with supervisors for complex situations

### Documentation

- Save AI assessments for records
- Include in insurance claims
- Reference IICRC standards cited
- Photograph all damage areas
- Track drying progress with psychrometric readings

---

## IICRC Standards Covered

The AI Assistant is trained on the following IICRC standards:

- **WRT**: Water Damage Restoration Technician
- **S500**: Standard and Reference Guide for Professional Water Damage Restoration
- **S520**: Standard and Reference Guide for Professional Mold Remediation
- **FSRT**: Fire and Smoke Restoration Technician
- **AMRT**: Applied Microbial Remediation Technician

---

## Limitations

### What the AI Assistant CAN Do

✅ Provide expert guidance based on IICRC standards  
✅ Classify damage according to industry standards  
✅ Recommend appropriate equipment and procedures  
✅ Identify safety hazards and PPE requirements  
✅ Analyze photos for damage assessment  
✅ Calculate psychrometric conditions  
✅ Answer restoration-related questions  

### What the AI Assistant CANNOT Do

❌ Replace on-site professional judgment  
❌ Provide final approval for insurance claims  
❌ Detect hidden damage not visible in photos  
❌ Replace moisture meters or thermal imaging  
❌ Make decisions about structural integrity  
❌ Substitute for licensed contractors  
❌ Guarantee specific outcomes  

### Important Notes

- The AI Assistant provides guidance, not decisions
- Always follow company protocols and local regulations
- Verify AI recommendations with supervisors when needed
- Use professional testing equipment for measurements
- Document all findings independently of AI assessments

---

## Support & Feedback

For issues or questions about the IICRC AI Assistant:

1. Check that your Gemini API key is configured correctly
2. Ensure you have an active internet connection
3. Review error messages for specific guidance
4. Contact your system administrator for API access issues

---

## Future Enhancements

Planned improvements:

- [ ] Voice input for hands-free operation
- [ ] Offline mode with cached responses
- [ ] Integration with equipment manufacturers' specs
- [ ] Real-time moisture reading integration
- [ ] Thermal image analysis
- [ ] Multi-language support
- [ ] Report generation in PDF format
- [ ] Integration with industry software (Xactimate, MICA)

---

## Version History

### Version 1.0.0 (Current)
- Initial release with all core IICRC AI Assistant features
- Water mitigation categorization
- Mold remediation (S520) protocols
- Fire damage assessment
- PPE recommendations
- Psychrometric analysis
- Damage photo analysis
- Q&A chat interface

---

**Document Control:**
- **Created**: 2025-12-05
- **Version**: 1.0.0
- **Author**: IICRC AI Assistant Development Team
- **Last Updated**: 2025-12-05
