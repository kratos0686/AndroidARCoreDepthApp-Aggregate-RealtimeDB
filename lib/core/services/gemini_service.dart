import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gemini_service.g.dart';

class GeminiService {
  late final GenerativeModel _visionModel;
  late final GenerativeModel _textModel;

  GeminiService() {
    final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

    // Model for images (damage detection)
    _visionModel = GenerativeModel(
      model: 'gemini-1.5-flash', // Using flash for lower latency
      apiKey: apiKey,
    );

    // Model for text (notes, reports)
    _textModel = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  /// Analyzes an image to detect damage (water, mold, cracks).
  Future<String> analyzeImage(String imagePath) async {
    if (dotenv.env['GEMINI_API_KEY']?.isEmpty ?? true) {
      return "Error: Gemini API Key not configured.";
    }

    try {
      final imageFile = File(imagePath);
      if (!imageFile.existsSync()) return "Error: Image file not found.";

      final imageBytes = await imageFile.readAsBytes();
      final content = [
        Content.multi([
          TextPart("Analyze this image for a water damage restoration professional. Identify specific damages (water stains, cracks, mold), material types (drywall, wood), and estimate severity. Format the response as a bulleted list."),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      final response = await _visionModel.generateContent(content);
      return response.text ?? "No analysis generated.";
    } catch (e) {
      return "Error analyzing image: $e";
    }
  }

  /// Refines raw user notes into professional documentation.
  /// Example: "big crack on north wall" -> "Significant structural crack observed on the North elevation."
  Future<String> refineNote(String rawText) async {
    if (dotenv.env['GEMINI_API_KEY']?.isEmpty ?? true) {
      return "Mock: Key missing. Refined: $rawText";
    }

    try {
      final content = [
        Content.text(
          "You are an assistant for a restoration professional. "
          "Rewrite the following rough note into a clear, professional observation suitable for an insurance claim report. "
          "Keep it concise.\n\nRaw Note: \"$rawText\""
        )
      ];

      final response = await _textModel.generateContent(content);
      return response.text ?? rawText;
    } catch (e) {
      return "Error refining note: $e";
    }
  }

  /// Generates a drying plan based on room metrics.
  Future<String> generateDryingPlan(Map<String, dynamic> roomData) async {
     if (dotenv.env['GEMINI_API_KEY']?.isEmpty ?? true) {
      return "Mock Plan: Install 2 dehumidifiers and 4 air movers.";
    }

    try {
      final prompt = "Generate a drying plan for a room with the following data: $roomData. "
          "Include equipment recommendations (dehumidifiers, air movers) and a 3-day timeline.";

      final content = [Content.text(prompt)];
      final response = await _textModel.generateContent(content);
      return response.text ?? "Unable to generate plan.";
    } catch (e) {
      return "Error generating plan: $e";
    }
  }

  /// Sanity checks measurements for realism.
  Future<String> validateMeasurements(Map<String, double> dimensions) async {
   if (dotenv.env['GEMINI_API_KEY']?.isEmpty ?? true) {
      return "Measurements appear valid (Mock).";
    }

    try {
      final prompt = "Analyze these room dimensions for a residential house: $dimensions. "
          "Are any of these measurements unrealistic or flagged as potential errors? (e.g., a 50ft ceiling). "
          "Reply with 'Valid' or an explanation of the anomaly.";

      final content = [Content.text(prompt)];
      final response = await _textModel.generateContent(content);
      return response.text ?? "Validation failed.";
    } catch (e) {
      return "Error validating: $e";
    }
  }
}

@riverpod
GeminiService geminiService(GeminiServiceRef ref) {
  return GeminiService();
}
