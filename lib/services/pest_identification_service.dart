// lib/services/pest_identification_service.dart

import 'dart:io';
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:khetibari/models/pest_identification.dart';

/// Service for pest identification using Gemini's Visual RAG capabilities
class PestIdentificationService {
  static final PestIdentificationService _instance = PestIdentificationService._internal();
  
  late GenerativeModel _model;
  final String _apiKey = 'YOUR_GEMINI_API_KEY'; // Replace with actual API key

  factory PestIdentificationService() {
    return _instance;
  }

  PestIdentificationService._internal() {
    _initializeModel();
  }

  /// Initialize the Gemini model with Visual RAG capabilities
  void _initializeModel() {
    _model = GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: _apiKey,
    );
  }

  /// Identifies pest from an image using Gemini's Visual RAG
  /// Returns a PestIdentification object with AI-generated analysis
  Future<PestIdentification> identifyPestFromImage({
    required File imageFile,
    required String farmerId,
    required String cropType,
  }) async {
    try {
      // Read image and convert to bytes
      final imageBytes = await imageFile.readAsBytes();
      
      // Determine image type
      final imageMimeType = _getImageMimeType(imageFile.path);

      // Create the prompt with image
      final prompt = '''
      একটি ফসলের পোকা বা রোগের ছবি বিশ্লেষণ করুন। এটি ${cropType} ফসলের সম্ভবত ক্ষতিগ্রস্ত এলাকা থেকে নেওয়া হয়েছে।
      
      অনুগ্রহ করে নিম্নলিখিত তথ্য প্রদান করুন:
      1. পোকা/রোগের নাম (বাংলা)
      2. ঝুঁকির স্তর (কম/মধ্যম/উচ্চ)
      3. লক্ষণ সমূহ (বাংলায়)
      4. ব্যাপক চিকিৎসা পরিকল্পনা (বাংলায়)
      5. জৈব চিকিৎসা পদ্ধতি (বাংলায়)
      6. প্রতিরোধমূলক ব্যবস্থা (বাংলায়)
      
      Google Search ব্যবহার করে সর্বশেষ এবং যাচাইকৃত পদ্ধতি প্রদান করুন।
      
      প্রতিক্রিয়া অবশ্যই JSON ফর্ম্যাটে হতে হবে।
      ''';

      // Make API call with image
      final response = await _model.generateContent([
        Content.multi([
          TextPart(prompt),
          DataPart(imageMimeType, imageBytes),
        ])
      ]);

      // Parse the response
      final responseText = response.text;
      if (responseText == null || responseText.isEmpty) {
        throw Exception('Empty response from Gemini API');
      }

      // Extract JSON from response
      final jsonString = _extractJSON(responseText);
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

      // Parse risk level
      final riskLevelStr = jsonData['riskLevel']?.toString().toLowerCase() ?? 'medium';
      final riskLevel = _parseRiskLevel(riskLevelStr);

      // Create PestIdentification object
      final identification = PestIdentification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        pestName: jsonData['pestName']?.toString() ?? 'Unknown Pest',
        pestNameBangla: jsonData['pestNameBangla']?.toString() ?? 'অজানা পোকা/রোগ',
        riskLevel: riskLevel,
        description: jsonData['description']?.toString() ?? 'বর্ণনা উপলব্ধ নেই',
        actionPlan: jsonData['actionPlan']?.toString() ?? 'চিকিৎসা পরিকল্পনা উপলব্ধ নেই',
        symptoms: List<String>.from(jsonData['symptoms'] as List? ?? []),
        organicTreatments: List<String>.from(jsonData['organicTreatments'] as List? ?? []),
        preventiveMeasures: List<String>.from(jsonData['preventiveMeasures'] as List? ?? []),
        identifiedDate: DateTime.now(),
        imagePath: imageFile.path,
        affectedCrop: cropType,
      );

      return identification;
    } on SocketException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Invalid response format: ${e.message}');
    } catch (e) {
      throw Exception('Failed to identify pest: $e');
    }
  }

  /// Extracts JSON from response text
  String _extractJSON(String text) {
    // Try to find JSON object in the response
    final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
    if (jsonMatch != null) {
      return jsonMatch.group(0)!;
    }
    throw Exception('No JSON found in response');
  }

  /// Parses risk level string to enum
  PestRiskLevel _parseRiskLevel(String riskStr) {
    final lower = riskStr.toLowerCase();
    if (lower.contains('high') || lower.contains('উচ্চ')) {
      return PestRiskLevel.high;
    } else if (lower.contains('medium') || lower.contains('মধ্যম')) {
      return PestRiskLevel.medium;
    } else {
      return PestRiskLevel.low;
    }
  }

  /// Determines MIME type based on file extension
  String _getImageMimeType(String filePath) {
    final lower = filePath.toLowerCase();
    if (lower.endsWith('.png')) {
      return 'image/png';
    } else if (lower.endsWith('.gif')) {
      return 'image/gif';
    } else if (lower.endsWith('.webp')) {
      return 'image/webp';
    } else {
      return 'image/jpeg'; // Default to JPEG
    }
  }

  /// Sets the API key (should be called during app initialization)
  void setApiKey(String apiKey) {
    // Note: In production, get this from secure storage or environment
    // This is a placeholder for the actual implementation
  }
}
