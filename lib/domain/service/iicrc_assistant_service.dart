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
  /// 
  /// ⚠️ AI DISABLED: This method now throws an exception to prevent API calls.
  Future<void> initialize() async {
    throw IICRCAssistantException(
      'AI disabled in repository. IICRC Assistant AI integration has been disabled to prevent '
      'accidental credential exposure in version control.\n\n'
      'To enable AI features securely:\n'
      '1. Use a backend proxy service to handle API calls (RECOMMENDED)\n'
      '2. Inject secrets via CI/CD secret manager at build time\n'
      '3. For local dev, use .env.local (never commit this file)\n\n'
      'See .env file for detailed instructions.\n'
      'Remove this stub in iicrc_assistant_service.dart initialize() to re-enable.'
    );
  }

  /// Categorize water damage and provide mitigation guidance
  /// 
  /// ⚠️ AI DISABLED: This method now throws an exception to prevent API calls.
  /// 
  /// [description] - Description of the water damage scenario
  /// [imageBytes] - Optional image of the damage
  /// 
  /// Returns: [WaterDamageAssessment] with class, category, and recommendations
  Future<WaterDamageAssessment> assessWaterDamage({
    required String description,
    List<int>? imageBytes,
  }) async {
    throw IICRCAssistantException(
      'AI disabled in repository. To enable, provide a secure backend or secrets '
      'and remove the stub. See .env file for instructions.'
    );
  }

  /// Provide mold remediation guidance following S520 standards
  /// 
  /// ⚠️ AI DISABLED: This method now throws an exception to prevent API calls.
  /// 
  /// [description] - Description of the mold situation
  /// [imageBytes] - Optional image of the mold
  /// 
  /// Returns: [MoldRemediationAdvice] with protocol and safety measures
  Future<MoldRemediationAdvice> adviseMoldRemediation({
    required String description,
    List<int>? imageBytes,
  }) async {
    throw IICRCAssistantException(
      'AI disabled in repository. To enable, provide a secure backend or secrets '
      'and remove the stub. See .env file for instructions.'
    );
  }

  /// Assess fire damage and provide restoration guidance
  /// 
  /// ⚠️ AI DISABLED: This method now throws an exception to prevent API calls.
  /// 
  /// [description] - Description of the fire damage
  /// [imageBytes] - Optional image of the damage
  /// 
  /// Returns: [FireDamageAssessment] with restoration recommendations
  Future<FireDamageAssessment> assessFireDamage({
    required String description,
    List<int>? imageBytes,
  }) async {
    throw IICRCAssistantException(
      'AI disabled in repository. To enable, provide a secure backend or secrets '
      'and remove the stub. See .env file for instructions.'
    );
  }

  /// Recommend appropriate PPE based on scenario
  /// 
  /// ⚠️ AI DISABLED: This method now throws an exception to prevent API calls.
  /// 
  /// [scenario] - Description of the work scenario
  /// [hazards] - List of identified hazards
  /// 
  /// Returns: [PPERecommendation] with required protective equipment
  Future<PPERecommendation> recommendPPE({
    required String scenario,
    List<String>? hazards,
  }) async {
    throw IICRCAssistantException(
      'AI disabled in repository. To enable, provide a secure backend or secrets '
      'and remove the stub. See .env file for instructions.'
    );
  }

  /// Perform psychrometric analysis for drying strategy
  /// 
  /// [temperature] - Temperature in Fahrenheit
  /// [relativeHumidity] - Relative humidity percentage
  /// [grainsPerPound] - Optional GPP reading
  /// 
  /// Returns: [PsychrometricAnalysis] with drying recommendations
  /// Perform psychrometric analysis for drying strategy
  /// 
  /// ⚠️ AI DISABLED: This method now throws an exception to prevent API calls.
  /// 
  /// [temperature] - Temperature in Fahrenheit
  /// [relativeHumidity] - Relative humidity percentage
  /// [grainsPerPound] - Optional GPP reading
  /// 
  /// Returns: [PsychrometricAnalysis] with drying recommendations
  Future<PsychrometricAnalysis> analyzePsychrometrics({
    required double temperature,
    required double relativeHumidity,
    double? grainsPerPound,
  }) async {
    throw IICRCAssistantException(
      'AI disabled in repository. To enable, provide a secure backend or secrets '
      'and remove the stub. See .env file for instructions.'
    );
  }

  /// Analyze photos/videos to identify materials and damage extent
  /// 
  /// ⚠️ AI DISABLED: This method now throws an exception to prevent API calls.
  /// 
  /// [imageBytes] - Image data to analyze
  /// [additionalContext] - Optional context about the image
  /// 
  /// Returns: [DamagePhotoAnalysis] with detailed assessment
  Future<DamagePhotoAnalysis> analyzePhoto({
    required List<int> imageBytes,
    String? additionalContext,
  }) async {
    throw IICRCAssistantException(
      'AI disabled in repository. To enable, provide a secure backend or secrets '
      'and remove the stub. See .env file for instructions.'
    );
  }

  /// Ask a general question to the IICRC AI Assistant
  /// 
  /// ⚠️ AI DISABLED: This method now throws an exception to prevent API calls.
  /// 
  /// [question] - Natural language question about restoration work
  /// [context] - Optional context for the question
  /// 
  /// Returns: String response with expert guidance
  Future<String> askQuestion({
    required String question,
    String? context,
  }) async {
    throw IICRCAssistantException(
      'AI disabled in repository. To enable, provide a secure backend or secrets '
      'and remove the stub. See .env file for instructions.'
    );
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
