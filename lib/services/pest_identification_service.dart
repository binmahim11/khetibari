// lib/services/pest_identification_service.dart

import 'dart:io';
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:khetibari/models/pest_identification.dart';

/// Service for pest identification using Gemini's Visual RAG capabilities
class PestIdentificationService {
  static final PestIdentificationService _instance =
      PestIdentificationService._internal();

  late GenerativeModel _model;
  static String? _apiKey;
  bool _isInitialized = false;

  factory PestIdentificationService() {
    return _instance;
  }

  PestIdentificationService._internal();

  /// Sets the Gemini API key (call this during app initialization)
  static void setApiKey(String apiKey) {
    _apiKey = apiKey;
  }

  /// Initialize the Gemini model with Visual RAG capabilities
  void _ensureInitialized() {
    if (_isInitialized && _apiKey != null) {
      return;
    }

    if (_apiKey == null || _apiKey!.isEmpty) {
      throw Exception(
        'Gemini API key not set. Call PestIdentificationService.setApiKey() during app initialization.',
      );
    }

    _model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: _apiKey!);
    _isInitialized = true;
  }

  /// Identifies pest from an image using Gemini's Visual RAG
  /// Returns a PestIdentification object with AI-generated analysis
  Future<PestIdentification> identifyPestFromImage({
    required File imageFile,
    required String farmerId,
    required String cropType,
  }) async {
    try {
      // Check if API key is valid before trying to initialize
      if (_apiKey == null || _apiKey!.isEmpty) {
        return _getMockPestIdentification(cropType);
      }

      // Ensure model is initialized with valid API key
      _ensureInitialized();

      // Read image and convert to bytes
      final imageBytes = await imageFile.readAsBytes();

      // Determine image type
      final imageMimeType = _getImageMimeType(imageFile.path);

      // Create the prompt with image in Bangla
      final prompt = '''
      একটি ফসলের পোকা বা রোগের ছবি বিশ্লেষণ করুন। এটি $cropType ফসলের সম্ভবত ক্ষতিগ্রস্ত এলাকা থেকে নেওয়া হয়েছে।
      
      অনুগ্রহ করে নিম্নলিখিত তথ্য JSON ফর্ম্যাটে প্রদান করুন:
      {
        "pestName": "পোকা/রোগের ইংরেজি নাম",
        "pestNameBangla": "পোকা/রোগের বাংলা নাম",
        "riskLevel": "কম/মধ্যম/উচ্চ",
        "description": "বাংলায় সম্পূর্ণ বর্ণনা",
        "symptoms": ["লক্ষণ ১", "লক্ষণ ২"],
        "actionPlan": "বাংলায় চিকিৎসা পরিকল্পনা",
        "organicTreatments": ["জৈব পদ্ধতি ১", "জৈব পদ্ধতি ২"],
        "preventiveMeasures": ["প্রতিরোধ ১", "প্রতিরোধ ২"]
      }
      ''';

      // Make API call with image
      final response = await _model.generateContent([
        Content.multi([TextPart(prompt), DataPart(imageMimeType, imageBytes)]),
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
      final riskLevelStr =
          jsonData['riskLevel']?.toString().toLowerCase() ?? 'medium';
      final riskLevel = _parseRiskLevel(riskLevelStr);

      // Create PestIdentification object
      final identification = PestIdentification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        pestName: jsonData['pestName']?.toString() ?? 'Unknown Pest',
        pestNameBangla:
            jsonData['pestNameBangla']?.toString() ?? 'অজানা পোকা/রোগ',
        riskLevel: riskLevel,
        description: jsonData['description']?.toString() ?? 'বর্ণনা উপলব্ধ নেই',
        actionPlan:
            jsonData['actionPlan']?.toString() ??
            'চিকিৎসা পরিকল্পনা উপলব্ধ নেই',
        symptoms: List<String>.from(jsonData['symptoms'] as List? ?? []),
        organicTreatments: List<String>.from(
          jsonData['organicTreatments'] as List? ?? [],
        ),
        preventiveMeasures: List<String>.from(
          jsonData['preventiveMeasures'] as List? ?? [],
        ),
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

  /// Mock pest identification - returns sample data based on crop type
  PestIdentification _getMockPestIdentification(String cropType) {
    if (cropType == 'ধান' || cropType == 'Rice') {
      return PestIdentification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        pestName: 'Brown Plant Hopper',
        pestNameBangla: 'বাদামী গাছ ফড়িং (BPH)',
        riskLevel: PestRiskLevel.high,
        description:
            'ধান ফসলের জন্য এটি একটি গুরুতর পোকা, যা গাছের গোড়া থেকে রস শুষে নেয়। গুরুতর আক্রমণে পুরো ক্ষেত শুকিয়ে যেতে পারে।',
        symptoms: [
          'ধান গাছের গোড়ার দিকে বাদামী রঙের ছোট পোকা দেখা যায়',
          'আক্রমণের ফলে ধান গাছ পুড়ে যাওয়া বা "হপার বার্ন" হয়',
          'গাছের বৃদ্ধি কমে যায়',
        ],
        actionPlan:
            'ডিনোটেফুরান বা ইমিডাক্লোপ্রিড গ্রুপের কীটনাশক গাছের গোড়ায় প্রয়োগ করুন।',
        organicTreatments: [
          'সঠিক ঘনত্বে রোপণ করে বায়ু চলাচল নিশ্চিত করুন',
          'আলোক ফাঁদ ব্যবহার করুন',
        ],
        preventiveMeasures: [
          'সহনশীল জাতের চারা ব্যবহার করুন',
          'জমির আশেপাশ পরিষ্কার রাখুন',
          'নিয়মিত পর্যবেক্ষণ করুন',
        ],
        identifiedDate: DateTime.now(),
        imagePath: '',
        affectedCrop: cropType,
      );
    } else if (cropType == 'গম' || cropType == 'Wheat') {
      return PestIdentification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        pestName: 'Aphid',
        pestNameBangla: 'গমের শুঁড়পোকা',
        riskLevel: PestRiskLevel.medium,
        description:
            'গমের শুঁড়পোকা ছোট সবুজ বা বাদামী রঙের পোকা যা গাছের রস শুষে খায়।',
        symptoms: [
          'ছোট সবুজ বা বাদামী পোকা দেখা যায়',
          'পাতা কুঁকড়ে যায় এবং হলুদ হয়ে যায়',
          'গাছের বৃদ্ধি মন্থর হয়',
        ],
        actionPlan: 'ম্যালাথিয়ন বা ইমিডাক্লোপ্রিড কীটনাশক স্প্রে করুন।',
        organicTreatments: [
          'নিম তেল (Neem Oil) স্প্রে করুন',
          'সাবানের পানি স্প্রে করুন',
        ],
        preventiveMeasures: [
          'ফসলের পরিচর্যা নিয়মিত করুন',
          'স্বাস্থ্যকর বীজ ব্যবহার করুন',
          'আগাছা পরিষ্কার করুন',
        ],
        identifiedDate: DateTime.now(),
        imagePath: '',
        affectedCrop: cropType,
      );
    } else if (cropType == 'ভুট্টা' || cropType == 'Corn') {
      return PestIdentification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        pestName: 'Fall Armyworm',
        pestNameBangla: 'ভুট্টার কম্বল কীট',
        riskLevel: PestRiskLevel.high,
        description:
            'ভুট্টার কম্বল কীট ভুট্টার পাতা ও দানা খায় এবং ফসলের ব্যাপক ক্ষতি করে।',
        symptoms: [
          'পাতায় ছোট গোল ছিদ্র দেখা যায়',
          'পাতা ঝাঁঝরা হয়ে যায়',
          'ভুট্টার দানায় সুরঙ্গ দেখা যায়',
        ],
        actionPlan:
            'স্পিনোসাড বা ক্লোরান্ট্রানিলিপ্রোল জাতীয় কীটনাশক প্রয়োগ করুন।',
        organicTreatments: [
          'বেসিলাস থুরিনজিয়েনসিস (Bt) স্প্রে ব্যবহার করুন',
          'হাতে তুলে কীট দূর করুন',
        ],
        preventiveMeasures: [
          'ফেরোমোন ফাঁদ ব্যবহার করুন',
          'আক্রান্ত পাতা সরিয়ে ফেলুন',
          'সময়মত পরবর্তী বপন করুন',
        ],
        identifiedDate: DateTime.now(),
        imagePath: '',
        affectedCrop: cropType,
      );
    } else if (cropType == 'আলু' || cropType == 'Potato') {
      return PestIdentification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        pestName: 'Late Blight',
        pestNameBangla: 'আলুর মড়ক রোগ',
        riskLevel: PestRiskLevel.high,
        description:
            'ফাইটোপথোরা ইনফেস্ট্যান্স ছত্রাক দ্বারা সৃষ্ট এই রোগ আলুর পাতা ও কাণ্ড দ্রুত নষ্ট করে।',
        symptoms: [
          'পাতার কিনারায় কালো বা বাদামী দাগ হয়',
          'পাতার নিচে সাদা ছত্রাক দেখা যায়',
          'আক্রান্ত আলু পচে যায়',
        ],
        actionPlan:
            'মেটাল্যাক্সিল ও ম্যানকোজেব মিশ্রিত ছত্রাকনাশক স্প্রে করুন প্রতি ৫-৭ দিনে।',
        organicTreatments: [
          'নিম তেল নিয়মিত স্প্রে করুন',
          '১% বোর্দো মিশ্রণ ব্যবহার করুন',
        ],
        preventiveMeasures: [
          'রোগমুক্ত বীজ ব্যবহার করুন',
          'সঠিক দূরত্বে রোপণ করুন',
          'মাটির জল নিকাশ নিশ্চিত করুন',
        ],
        identifiedDate: DateTime.now(),
        imagePath: '',
        affectedCrop: cropType,
      );
    } else {
      // Default response for unknown crops
      return PestIdentification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        pestName: 'Unknown Pest',
        pestNameBangla: 'অজানা পোকা/রোগ',
        riskLevel: PestRiskLevel.medium,
        description:
            'অজানা পোকা বা রোগ সনাক্ত হয়েছে। কৃষি বিশেষজ্ঞের সাথে যোগাযোগ করুন।',
        symptoms: ['ফসলে অস্বাভাবিক পরিবর্তন লক্ষ্য করা যাচ্ছে'],
        actionPlan: 'স্থানীয় কৃষি অফিসে সাহায্যের জন্য যোগাযোগ করুন।',
        organicTreatments: ['সুপারিশের জন্য কৃষি বিশেষজ্ঞের সাথে পরামর্শ করুন'],
        preventiveMeasures: ['ফসলের স্বাস্থ্য পর্যবেক্ষণ অব্যাহত রাখুন'],
        identifiedDate: DateTime.now(),
        imagePath: '',
        affectedCrop: cropType,
      );
    }
  }
}
