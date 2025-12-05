import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// IICRC Certified Master Water Restorer AI Assistant
/// 
/// Provides expert guidance on:
/// - Water Mitigation: Categorizing water (class 1-4)
/// - Mold Remediation (S520): Advising on protocols and safety
/// - Fire Damage Restoration: Assisting with initial assessments
/// - PPE Recommendations: Ensuring safety compliance
/// - Psychrometric Analysis: Interpreting GPP, RH, and Dew Point for drying strategies
/// - Damage Assessment: Analyzing photos/videos to identify materials and extent of damage
class IICRCAssistantService {
  late final GenerativeModel _model;
  bool _initialized = false;

  // IICRC expertise context for the AI
  static const String _iicrcContext = '''
You are an IICRC Certified Master Water Restorer AI Assistant with expert knowledge in:

1. WATER DAMAGE RESTORATION (WRT - Water Damage Restoration Technician):
   - Class 1: Minimal water absorption, affects only part of a room, materials have low permeance/porosity
   - Class 2: Significant water absorption, affects entire room, carpet and cushion, may have wicked up walls 12-24 inches
   - Class 3: Greatest amount of water absorption, water comes from overhead, walls and ceilings saturated
   - Class 4: Specialty drying, materials with very low permeance (hardwood, plaster, brick, concrete, stone)
   
   Category 1: Clean water from sanitary source (broken pipe, toilet tank, rain water)
   Category 2: Grey water with contamination (washing machine overflow, toilet overflow with urine, dishwasher overflow)
   Category 3: Black water, highly contaminated (sewage, flooding from rivers, toilet overflow with feces)

2. MOLD REMEDIATION (IICRC S520 Standard):
   - Condition 1: Normal fungal ecology, routine cleaning
   - Condition 2: Small isolated areas (<10 sq ft), limited removal, source control
   - Condition 3: Large isolated areas (10-100 sq ft), full containment required
   - Condition 4: Extensive contamination (>100 sq ft), full containment with airlock
   - Requires proper PPE, containment, HEPA filtration, and post-remediation verification

3. FIRE DAMAGE RESTORATION:
   - Assess smoke damage (protein, natural, synthetic)
   - Evaluate structural integrity
   - Identify salvageable vs. non-salvageable materials
   - Recommend cleaning methods (dry cleaning, wet cleaning, abrasive, immersion)
   - Odor control strategies

4. PPE RECOMMENDATIONS (Personal Protective Equipment):
   - Level 1: Basic (gloves, safety glasses, dust mask) - routine cleaning
   - Level 2: Enhanced (N95 respirator, goggles, protective clothing) - mold, contaminated water
   - Level 3: Full protection (full-face respirator with P100 filters, Tyvek suit, boot covers) - black water, extensive mold
   - Level 4: Hazmat (SCBA, fully encapsulated suit) - chemical hazards, confined spaces

5. PSYCHROMETRIC ANALYSIS:
   - GPP (Grains Per Pound): Moisture content of air
   - RH (Relative Humidity): Percentage of saturation
   - Dew Point: Temperature at which condensation occurs
   - Target drying goals: RH 30-50%, GPP < ambient +10-20 grains
   - Calculate drying time based on class and psychrometric conditions
   - Equipment recommendations: dehumidifiers, air movers, air scrubbers

6. DAMAGE ASSESSMENT:
   - Identify affected materials (drywall, wood, carpet, tile, insulation, concrete)
   - Determine extent of damage (surface, structural, hidden)
   - Moisture mapping and moisture meter readings
   - Thermal imaging for hidden moisture
   - Documentation requirements (photos, moisture readings, scope of work)

Always provide:
- Safety-focused advice (PPE first)
- Professional, concise guidance
- Specific actionable recommendations
- Industry-standard terminology
- Compliance with IICRC standards
''';

  /// Initialize the IICRC Assistant service with API key from .env
  Future<void> initialize() async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      
      if (apiKey == null || apiKey.isEmpty || apiKey == 'your_gemini_api_key_here') {
        throw IICRCAssistantException(
          'Gemini API key not configured. Please add your key to the .env file.\n'
          'Get your API key from: https://makersuite.google.com/app/apikey'
        );
      }

      // Initialize Gemini model with extended context for IICRC expertise
      _model = GenerativeModel(
        model: 'gemini-1.5-pro',
        apiKey: apiKey,
        systemInstruction: Content.text(_iicrcContext),
      );
      
      _initialized = true;
    } catch (e) {
      throw IICRCAssistantException('Failed to initialize IICRC Assistant service: $e');
    }
  }

  /// Categorize water damage and provide mitigation guidance
  /// 
  /// [description] - Description of the water damage scenario
  /// [imageBytes] - Optional image of the damage
  /// 
  /// Returns: [WaterDamageAssessment] with class, category, and recommendations
  Future<WaterDamageAssessment> assessWaterDamage({
    required String description,
    List<int>? imageBytes,
  }) async {
    _ensureInitialized();

    try {
      final prompt = '''
Based on this water damage scenario: "$description"

Provide a comprehensive water damage assessment with:

1. WATER DAMAGE CLASS (1-4): Classify the damage extent
2. WATER CATEGORY (1-3): Identify contamination level
3. AFFECTED MATERIALS: List materials impacted
4. RECOMMENDED ACTIONS: Immediate steps to take
5. EQUIPMENT NEEDED: Specific equipment recommendations
6. ESTIMATED DRYING TIME: Based on class and conditions
7. PPE REQUIREMENTS: Required personal protective equipment
8. SAFETY CONCERNS: Any immediate safety hazards

Provide response in JSON format:
{
  "waterClass": "Class 1-4",
  "waterCategory": "Category 1-3",
  "affectedMaterials": ["material1", "material2"],
  "recommendedActions": ["action1", "action2"],
  "equipment": ["equipment1", "equipment2"],
  "estimatedDryingDays": "3-5 days",
  "ppeLevel": "Level 1-4",
  "safetyConcerns": ["concern1", "concern2"],
  "summary": "Brief professional assessment"
}
''';

      final content = imageBytes != null
          ? [
              Content.multi([
                DataPart('image/jpeg', imageBytes),
                TextPart(prompt),
              ])
            ]
          : [Content.text(prompt)];

      final response = await _model.generateContent(content);
      
      if (response.text == null) {
        throw IICRCAssistantException('Assistant returned empty response');
      }

      return WaterDamageAssessment.fromResponse(response.text!);
    } catch (e) {
      throw IICRCAssistantException('Water damage assessment failed: $e');
    }
  }

  /// Provide mold remediation guidance following S520 standards
  /// 
  /// [description] - Description of the mold situation
  /// [imageBytes] - Optional image of the mold
  /// 
  /// Returns: [MoldRemediationAdvice] with protocol and safety measures
  Future<MoldRemediationAdvice> adviseMoldRemediation({
    required String description,
    List<int>? imageBytes,
  }) async {
    _ensureInitialized();

    try {
      final prompt = '''
Based on this mold situation: "$description"

Following IICRC S520 Standard for mold remediation, provide:

1. CONDITION LEVEL (1-4): Assess mold contamination level
2. AFFECTED AREA: Estimate square footage
3. CONTAINMENT REQUIREMENTS: Specify containment needs
4. REMEDIATION PROTOCOL: Step-by-step remediation process
5. PPE REQUIREMENTS: Detailed protective equipment needed
6. AIR FILTRATION: HEPA and negative air requirements
7. DISPOSAL PROCEDURES: Safe removal and disposal methods
8. POST-REMEDIATION: Verification and clearance testing
9. SAFETY WARNINGS: Critical safety information

Provide response in JSON format:
{
  "conditionLevel": "Condition 1-4",
  "affectedAreaSqFt": "estimated square feet",
  "containmentRequired": "none/limited/full/full with airlock",
  "remediationSteps": ["step1", "step2"],
  "ppeRequired": ["item1", "item2"],
  "airFiltration": "HEPA requirements",
  "disposalMethod": "disposal instructions",
  "postRemediation": "verification requirements",
  "safetyWarnings": ["warning1", "warning2"],
  "summary": "Professional assessment"
}
''';

      final content = imageBytes != null
          ? [
              Content.multi([
                DataPart('image/jpeg', imageBytes),
                TextPart(prompt),
              ])
            ]
          : [Content.text(prompt)];

      final response = await _model.generateContent(content);
      
      if (response.text == null) {
        throw IICRCAssistantException('Assistant returned empty response');
      }

      return MoldRemediationAdvice.fromResponse(response.text!);
    } catch (e) {
      throw IICRCAssistantException('Mold remediation advice failed: $e');
    }
  }

  /// Assess fire damage and provide restoration guidance
  /// 
  /// [description] - Description of the fire damage
  /// [imageBytes] - Optional image of the damage
  /// 
  /// Returns: [FireDamageAssessment] with restoration recommendations
  Future<FireDamageAssessment> assessFireDamage({
    required String description,
    List<int>? imageBytes,
  }) async {
    _ensureInitialized();

    try {
      final prompt = '''
Based on this fire damage scenario: "$description"

Provide a comprehensive fire damage assessment with:

1. SMOKE DAMAGE TYPE: Identify smoke residue type (protein/natural/synthetic)
2. STRUCTURAL ASSESSMENT: Evaluate structural integrity
3. SALVAGEABLE MATERIALS: List items that can be restored
4. NON-SALVAGEABLE MATERIALS: List items requiring replacement
5. CLEANING METHODS: Recommend appropriate cleaning techniques
6. ODOR CONTROL: Strategies for smoke odor removal
7. RESTORATION TIMELINE: Estimated restoration duration
8. SAFETY CONCERNS: Structural or health hazards

Provide response in JSON format:
{
  "smokeDamageType": "protein/natural/synthetic/combination",
  "structuralIntegrity": "assessment",
  "salvageableItems": ["item1", "item2"],
  "nonSalvageableItems": ["item1", "item2"],
  "cleaningMethods": ["method1", "method2"],
  "odorControl": "strategies",
  "estimatedTimeline": "timeline",
  "safetyConcerns": ["concern1", "concern2"],
  "summary": "Professional assessment"
}
''';

      final content = imageBytes != null
          ? [
              Content.multi([
                DataPart('image/jpeg', imageBytes),
                TextPart(prompt),
              ])
            ]
          : [Content.text(prompt)];

      final response = await _model.generateContent(content);
      
      if (response.text == null) {
        throw IICRCAssistantException('Assistant returned empty response');
      }

      return FireDamageAssessment.fromResponse(response.text!);
    } catch (e) {
      throw IICRCAssistantException('Fire damage assessment failed: $e');
    }
  }

  /// Recommend appropriate PPE based on scenario
  /// 
  /// [scenario] - Description of the work scenario
  /// [hazards] - List of identified hazards
  /// 
  /// Returns: [PPERecommendation] with required protective equipment
  Future<PPERecommendation> recommendPPE({
    required String scenario,
    List<String>? hazards,
  }) async {
    _ensureInitialized();

    try {
      final hazardsList = hazards != null ? hazards.join(', ') : 'unknown hazards';
      final prompt = '''
For this scenario: "$scenario"
Identified hazards: $hazardsList

Provide PPE recommendations ensuring safety compliance:

1. PPE LEVEL (1-4): Overall protection level needed
2. HEAD PROTECTION: Hard hat, face shield requirements
3. EYE PROTECTION: Safety glasses, goggles, face shield
4. RESPIRATORY PROTECTION: Mask type (N95, P100, SCBA)
5. HAND PROTECTION: Glove type (nitrile, chemical resistant)
6. BODY PROTECTION: Clothing type (Tyvek, chemical suit)
7. FOOT PROTECTION: Boot requirements
8. ADDITIONAL EQUIPMENT: Other safety gear needed
9. DECONTAMINATION: Procedures for PPE removal

Provide response in JSON format:
{
  "ppeLevel": "Level 1-4",
  "headProtection": "requirements",
  "eyeProtection": "requirements",
  "respiratoryProtection": "requirements",
  "handProtection": "requirements",
  "bodyProtection": "requirements",
  "footProtection": "requirements",
  "additionalEquipment": ["item1", "item2"],
  "decontaminationProcedure": "procedure",
  "summary": "PPE compliance summary"
}
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      
      if (response.text == null) {
        throw IICRCAssistantException('Assistant returned empty response');
      }

      return PPERecommendation.fromResponse(response.text!);
    } catch (e) {
      throw IICRCAssistantException('PPE recommendation failed: $e');
    }
  }

  /// Perform psychrometric analysis for drying strategy
  /// 
  /// [temperature] - Temperature in Fahrenheit
  /// [relativeHumidity] - Relative humidity percentage
  /// [grainsPer Pound] - Optional GPP reading
  /// 
  /// Returns: [PsychrometricAnalysis] with drying recommendations
  Future<PsychrometricAnalysis> analyzePsychrometrics({
    required double temperature,
    required double relativeHumidity,
    double? grainsPerPound,
  }) async {
    _ensureInitialized();

    try {
      final prompt = '''
Perform psychrometric analysis for water damage drying:

CURRENT CONDITIONS:
- Temperature: $temperature°F
- Relative Humidity: $relativeHumidity%
${grainsPerPound != null ? '- Grains Per Pound: $grainsPerPound GPP' : ''}

Provide comprehensive analysis with:

1. DEW POINT: Calculate dew point temperature
2. GRAINS PER POUND: Calculate or validate GPP
3. VAPOR PRESSURE: Analyze vapor pressure
4. DRYING POTENTIAL: Assess current drying conditions
5. TARGET CONDITIONS: Recommended RH and GPP targets
6. EQUIPMENT RECOMMENDATIONS: Dehumidifier and air mover specs
7. ADJUSTMENT RECOMMENDATIONS: How to optimize drying
8. ESTIMATED DRYING TIME: Based on psychrometric conditions

Provide response in JSON format:
{
  "dewPoint": "temperature in °F",
  "grainsPerPound": "GPP value",
  "vaporPressure": "analysis",
  "dryingPotential": "good/fair/poor with explanation",
  "targetRH": "recommended %",
  "targetGPP": "recommended GPP",
  "equipmentRecommendations": ["equipment1", "equipment2"],
  "adjustments": ["adjustment1", "adjustment2"],
  "estimatedDryingTime": "time estimate",
  "summary": "Professional analysis"
}
''';

      final response = await _model.generateContent([Content.text(prompt)]);
      
      if (response.text == null) {
        throw IICRCAssistantException('Assistant returned empty response');
      }

      return PsychrometricAnalysis.fromResponse(response.text!);
    } catch (e) {
      throw IICRCAssistantException('Psychrometric analysis failed: $e');
    }
  }

  /// Analyze photos/videos to identify materials and damage extent
  /// 
  /// [imageBytes] - Image data to analyze
  /// [additionalContext] - Optional context about the image
  /// 
  /// Returns: [DamagePhotoAnalysis] with detailed assessment
  Future<DamagePhotoAnalysis> analyzePhoto({
    required List<int> imageBytes,
    String? additionalContext,
  }) async {
    _ensureInitialized();

    try {
      final context = additionalContext ?? 'No additional context provided';
      final prompt = '''
Analyze this image for restoration assessment purposes.
Context: $context

Provide detailed analysis including:

1. MATERIALS IDENTIFIED: List all visible materials and their condition
2. DAMAGE TYPE: Identify type of damage (water, mold, fire, structural)
3. DAMAGE EXTENT: Assess severity (minor, moderate, severe, critical)
4. AFFECTED AREAS: Describe locations and sizes of damaged areas
5. MOISTURE INDICATORS: Visible signs of water damage or moisture
6. SAFETY HAZARDS: Identify any safety concerns
7. IMMEDIATE ACTIONS: Urgent steps needed
8. DOCUMENTATION NOTES: Important observations for records

Provide response in JSON format:
{
  "materials": [{"name": "material", "condition": "good/damaged/critical"}],
  "damageType": "water/mold/fire/structural/combination",
  "damageExtent": "minor/moderate/severe/critical",
  "affectedAreas": [{"location": "location", "size": "size estimate"}],
  "moistureIndicators": ["indicator1", "indicator2"],
  "safetyHazards": ["hazard1", "hazard2"],
  "immediateActions": ["action1", "action2"],
  "documentationNotes": "detailed observations",
  "summary": "Comprehensive photo analysis"
}
''';

      final content = [
        Content.multi([
          DataPart('image/jpeg', imageBytes),
          TextPart(prompt),
        ])
      ];

      final response = await _model.generateContent(content);
      
      if (response.text == null) {
        throw IICRCAssistantException('Assistant returned empty response');
      }

      return DamagePhotoAnalysis.fromResponse(response.text!);
    } catch (e) {
      throw IICRCAssistantException('Photo analysis failed: $e');
    }
  }

  /// Ask a general question to the IICRC AI Assistant
  /// 
  /// [question] - Natural language question about restoration work
  /// [context] - Optional context for the question
  /// 
  /// Returns: String response with expert guidance
  Future<String> askQuestion({
    required String question,
    String? context,
  }) async {
    _ensureInitialized();

    try {
      final fullPrompt = context != null
          ? 'Context: $context\n\nQuestion: $question'
          : question;

      final response = await _model.generateContent([Content.text(fullPrompt)]);
      
      if (response.text == null) {
        throw IICRCAssistantException('Assistant returned empty response');
      }

      return response.text!;
    } catch (e) {
      throw IICRCAssistantException('Question processing failed: $e');
    }
  }

  /// Ensure service is initialized before use
  void _ensureInitialized() {
    if (!_initialized) {
      throw IICRCAssistantException(
        'IICRC Assistant service not initialized. Call initialize() first.'
      );
    }
  }
}

// ============================================================================
// DATA MODELS
// ============================================================================

/// Water damage assessment result
class WaterDamageAssessment {
  final String waterClass;
  final String waterCategory;
  final List<String> affectedMaterials;
  final List<String> recommendedActions;
  final List<String> equipment;
  final String estimatedDryingDays;
  final String ppeLevel;
  final List<String> safetyConcerns;
  final String summary;
  final String rawResponse;

  WaterDamageAssessment({
    required this.waterClass,
    required this.waterCategory,
    required this.affectedMaterials,
    required this.recommendedActions,
    required this.equipment,
    required this.estimatedDryingDays,
    required this.ppeLevel,
    required this.safetyConcerns,
    required this.summary,
    required this.rawResponse,
  });

  factory WaterDamageAssessment.fromResponse(String response) {
    // TODO: Parse JSON response properly
    // For now, return with raw response
    return WaterDamageAssessment(
      waterClass: 'Analysis in progress',
      waterCategory: 'Analysis in progress',
      affectedMaterials: [],
      recommendedActions: [],
      equipment: [],
      estimatedDryingDays: 'TBD',
      ppeLevel: 'TBD',
      safetyConcerns: [],
      summary: response,
      rawResponse: response,
    );
  }
}

/// Mold remediation advice
class MoldRemediationAdvice {
  final String conditionLevel;
  final String affectedAreaSqFt;
  final String containmentRequired;
  final List<String> remediationSteps;
  final List<String> ppeRequired;
  final String airFiltration;
  final String disposalMethod;
  final String postRemediation;
  final List<String> safetyWarnings;
  final String summary;
  final String rawResponse;

  MoldRemediationAdvice({
    required this.conditionLevel,
    required this.affectedAreaSqFt,
    required this.containmentRequired,
    required this.remediationSteps,
    required this.ppeRequired,
    required this.airFiltration,
    required this.disposalMethod,
    required this.postRemediation,
    required this.safetyWarnings,
    required this.summary,
    required this.rawResponse,
  });

  factory MoldRemediationAdvice.fromResponse(String response) {
    // TODO: Parse JSON response properly
    return MoldRemediationAdvice(
      conditionLevel: 'Analysis in progress',
      affectedAreaSqFt: 'TBD',
      containmentRequired: 'TBD',
      remediationSteps: [],
      ppeRequired: [],
      airFiltration: 'TBD',
      disposalMethod: 'TBD',
      postRemediation: 'TBD',
      safetyWarnings: [],
      summary: response,
      rawResponse: response,
    );
  }
}

/// Fire damage assessment
class FireDamageAssessment {
  final String smokeDamageType;
  final String structuralIntegrity;
  final List<String> salvageableItems;
  final List<String> nonSalvageableItems;
  final List<String> cleaningMethods;
  final String odorControl;
  final String estimatedTimeline;
  final List<String> safetyConcerns;
  final String summary;
  final String rawResponse;

  FireDamageAssessment({
    required this.smokeDamageType,
    required this.structuralIntegrity,
    required this.salvageableItems,
    required this.nonSalvageableItems,
    required this.cleaningMethods,
    required this.odorControl,
    required this.estimatedTimeline,
    required this.safetyConcerns,
    required this.summary,
    required this.rawResponse,
  });

  factory FireDamageAssessment.fromResponse(String response) {
    // TODO: Parse JSON response properly
    return FireDamageAssessment(
      smokeDamageType: 'Analysis in progress',
      structuralIntegrity: 'TBD',
      salvageableItems: [],
      nonSalvageableItems: [],
      cleaningMethods: [],
      odorControl: 'TBD',
      estimatedTimeline: 'TBD',
      safetyConcerns: [],
      summary: response,
      rawResponse: response,
    );
  }
}

/// PPE recommendation
class PPERecommendation {
  final String ppeLevel;
  final String headProtection;
  final String eyeProtection;
  final String respiratoryProtection;
  final String handProtection;
  final String bodyProtection;
  final String footProtection;
  final List<String> additionalEquipment;
  final String decontaminationProcedure;
  final String summary;
  final String rawResponse;

  PPERecommendation({
    required this.ppeLevel,
    required this.headProtection,
    required this.eyeProtection,
    required this.respiratoryProtection,
    required this.handProtection,
    required this.bodyProtection,
    required this.footProtection,
    required this.additionalEquipment,
    required this.decontaminationProcedure,
    required this.summary,
    required this.rawResponse,
  });

  factory PPERecommendation.fromResponse(String response) {
    // TODO: Parse JSON response properly
    return PPERecommendation(
      ppeLevel: 'Analysis in progress',
      headProtection: 'TBD',
      eyeProtection: 'TBD',
      respiratoryProtection: 'TBD',
      handProtection: 'TBD',
      bodyProtection: 'TBD',
      footProtection: 'TBD',
      additionalEquipment: [],
      decontaminationProcedure: 'TBD',
      summary: response,
      rawResponse: response,
    );
  }
}

/// Psychrometric analysis
class PsychrometricAnalysis {
  final String dewPoint;
  final String grainsPerPound;
  final String vaporPressure;
  final String dryingPotential;
  final String targetRH;
  final String targetGPP;
  final List<String> equipmentRecommendations;
  final List<String> adjustments;
  final String estimatedDryingTime;
  final String summary;
  final String rawResponse;

  PsychrometricAnalysis({
    required this.dewPoint,
    required this.grainsPerPound,
    required this.vaporPressure,
    required this.dryingPotential,
    required this.targetRH,
    required this.targetGPP,
    required this.equipmentRecommendations,
    required this.adjustments,
    required this.estimatedDryingTime,
    required this.summary,
    required this.rawResponse,
  });

  factory PsychrometricAnalysis.fromResponse(String response) {
    // TODO: Parse JSON response properly
    return PsychrometricAnalysis(
      dewPoint: 'Analysis in progress',
      grainsPerPound: 'TBD',
      vaporPressure: 'TBD',
      dryingPotential: 'TBD',
      targetRH: 'TBD',
      targetGPP: 'TBD',
      equipmentRecommendations: [],
      adjustments: [],
      estimatedDryingTime: 'TBD',
      summary: response,
      rawResponse: response,
    );
  }
}

/// Damage photo analysis
class DamagePhotoAnalysis {
  final List<MaterialCondition> materials;
  final String damageType;
  final String damageExtent;
  final List<AffectedArea> affectedAreas;
  final List<String> moistureIndicators;
  final List<String> safetyHazards;
  final List<String> immediateActions;
  final String documentationNotes;
  final String summary;
  final String rawResponse;

  DamagePhotoAnalysis({
    required this.materials,
    required this.damageType,
    required this.damageExtent,
    required this.affectedAreas,
    required this.moistureIndicators,
    required this.safetyHazards,
    required this.immediateActions,
    required this.documentationNotes,
    required this.summary,
    required this.rawResponse,
  });

  factory DamagePhotoAnalysis.fromResponse(String response) {
    // TODO: Parse JSON response properly
    return DamagePhotoAnalysis(
      materials: [],
      damageType: 'Analysis in progress',
      damageExtent: 'TBD',
      affectedAreas: [],
      moistureIndicators: [],
      safetyHazards: [],
      immediateActions: [],
      documentationNotes: '',
      summary: response,
      rawResponse: response,
    );
  }
}

/// Material condition
class MaterialCondition {
  final String name;
  final String condition;

  MaterialCondition({
    required this.name,
    required this.condition,
  });
}

/// Affected area
class AffectedArea {
  final String location;
  final String size;

  AffectedArea({
    required this.location,
    required this.size,
  });
}

/// Custom exception for IICRC Assistant operations
class IICRCAssistantException implements Exception {
  final String message;

  IICRCAssistantException(this.message);

  @override
  String toString() => 'IICRCAssistantException: $message';
}
