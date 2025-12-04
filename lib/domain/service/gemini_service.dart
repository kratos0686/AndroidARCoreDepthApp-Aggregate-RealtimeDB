import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Service for integrating with Google Gemini AI API
/// Provides image analysis, damage detection, and material identification
class GeminiService {
  late final GenerativeModel _model;
  bool _initialized = false;

  /// Initialize the Gemini service with API key from .env
  /// 
  /// Must be called before using any analysis methods
  /// Throws [GeminiException] if API key is missing or invalid
  Future<void> initialize() async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      
      if (apiKey == null || apiKey.isEmpty || apiKey == 'your_gemini_api_key_here') {
        throw GeminiException(
          'Gemini API key not configured. Please add your key to the .env file.\n'
          'Get your API key from: https://makersuite.google.com/app/apikey'
        );
      }

      // Initialize Gemini model (using gemini-pro-vision for image analysis)
      _model = GenerativeModel(
        model: 'gemini-pro-vision',
        apiKey: apiKey,
      );
      
      _initialized = true;
    } catch (e) {
      throw GeminiException('Failed to initialize Gemini service: $e');
    }
  }

  /// Analyze an image for damage detection and material identification
  /// 
  /// [imageBytes] - Raw image data as bytes
  /// [prompt] - Optional custom prompt for analysis
  /// 
  /// Returns: [AnalysisResult] containing detected damage and materials
  Future<AnalysisResult> analyzeImage(
    List<int> imageBytes, {
    String? prompt,
  }) async {
    _ensureInitialized();

    try {
      final defaultPrompt = prompt ?? '''
Analyze this image for water damage restoration purposes. Identify:

1. DAMAGE TYPES: Detect any visible damage including:
   - Water stains or discoloration
   - Mold or mildew growth
   - Cracks or structural damage
   - Peeling paint or wallpaper
   - Warped or buckled materials

2. MATERIALS: Identify the materials present:
   - Drywall/Gypsum board
   - Wood (type if possible)
   - Tile (ceramic, porcelain, etc.)
   - Concrete or masonry
   - Carpet or flooring
   - Metal fixtures

3. SEVERITY: Rate damage severity as Low, Medium, or High

4. LOCATION: Describe where damage is located in the image

Provide a structured JSON response with:
{
  "damages": [{"type": "...", "severity": "...", "location": "...", "confidence": 0.0-1.0}],
  "materials": [{"name": "...", "confidence": 0.0-1.0}],
  "summary": "Brief overall assessment"
}
''';

      final content = [
        Content.multi([
          DataPart('image/jpeg', imageBytes),
          TextPart(defaultPrompt),
        ])
      ];

      final response = await _model.generateContent(content);
      
      if (response.text == null) {
        throw GeminiException('Gemini returned empty response');
      }

      return _parseAnalysisResult(response.text!);
    } catch (e) {
      throw GeminiException('Image analysis failed: $e');
    }
  }

  /// Generate a comprehensive damage report from scan data
  /// 
  /// [scanData] - Map containing room dimensions, materials, and damage areas
  /// 
  /// Returns: String containing formatted report
  Future<String> generateReport(Map<String, dynamic> scanData) async {
    _ensureInitialized();

    try {
      final prompt = '''
Generate a professional water damage restoration report based on this scan data:

Room: ${scanData['roomName']}
Dimensions: ${scanData['dimensions']}
Materials Detected: ${scanData['materials']}
Damage Areas: ${scanData['damageAreas']}

Include:
1. Executive Summary
2. Damage Assessment
3. Recommended Actions
4. Equipment Recommendations
5. Estimated Drying Time

Keep it professional and concise.
''';

      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text == null) {
        throw GeminiException('Gemini returned empty report');
      }

      return response.text!;
    } catch (e) {
      throw GeminiException('Report generation failed: $e');
    }
  }

  /// Ask a custom question about scan data or images
  /// 
  /// [question] - Natural language question
  /// [context] - Optional context data
  /// 
  /// Returns: String response from Gemini
  Future<String> askQuestion(String question, {Map<String, dynamic>? context}) async {
    _ensureInitialized();

    try {
      final fullPrompt = context != null
          ? 'Context: $context\n\nQuestion: $question'
          : question;

      final content = [Content.text(fullPrompt)];
      final response = await _model.generateContent(content);

      if (response.text == null) {
        throw GeminiException('Gemini returned empty response');
      }

      return response.text!;
    } catch (e) {
      throw GeminiException('Question processing failed: $e');
    }
  }

  /// Parse Gemini response into structured AnalysisResult
  /// 
  /// Attempts to parse JSON response, falls back to text parsing if needed
  AnalysisResult _parseAnalysisResult(String responseText) {
    try {
      // TODO: Implement robust JSON parsing from Gemini response
      // Handle cases where response might not be valid JSON
      // Extract damage types, materials, and confidence scores
      
      // For now, return a placeholder result
      return AnalysisResult(
        damages: [
          DamageDetection(
            type: 'Analysis in progress',
            severity: 'Unknown',
            location: 'See raw response',
            confidence: 0.0,
          ),
        ],
        materials: [
          MaterialDetection(
            name: 'Analysis in progress',
            confidence: 0.0,
          ),
        ],
        summary: responseText,
        rawResponse: responseText,
      );
    } catch (e) {
      throw GeminiException('Failed to parse analysis result: $e');
    }
  }

  /// Ensure service is initialized before use
  void _ensureInitialized() {
    if (!_initialized) {
      throw GeminiException(
        'GeminiService not initialized. Call initialize() first.'
      );
    }
  }
}

/// Result of image analysis containing detected damage and materials
class AnalysisResult {
  final List<DamageDetection> damages;
  final List<MaterialDetection> materials;
  final String summary;
  final String rawResponse;

  AnalysisResult({
    required this.damages,
    required this.materials,
    required this.summary,
    required this.rawResponse,
  });
}

/// Detected damage with location and severity
class DamageDetection {
  final String type;
  final String severity; // Low, Medium, High
  final String location;
  final double confidence; // 0.0 to 1.0

  DamageDetection({
    required this.type,
    required this.severity,
    required this.location,
    required this.confidence,
  });
}

/// Detected material with confidence score
class MaterialDetection {
  final String name;
  final double confidence; // 0.0 to 1.0

  MaterialDetection({
    required this.name,
    required this.confidence,
  });
}

/// Custom exception for Gemini service operations
class GeminiException implements Exception {
  final String message;

  GeminiException(this.message);

  @override
  String toString() => 'GeminiException: $message';
}
