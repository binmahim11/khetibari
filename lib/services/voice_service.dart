// voice_service.dart
// Bangla Voice Recognition and TTS Service

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceService {
  static final VoiceService _instance = VoiceService._internal();

  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isListening = false;
  String _lastWords = '';
  Function(String)? _onResult;
  Function(String)? _onError;

  factory VoiceService() {
    return _instance;
  }

  VoiceService._internal() {
    _initializeTTS();
  }

  void _initializeTTS() {
    _flutterTts.setLanguage('bn_BD'); // Bangla (Bangladesh)
    _flutterTts.setSpeechRate(0.5);
  }

  Future<bool> initializeSpeechToText() async {
    try {
      final available = await _speechToText.initialize(
        onError: (error) {
          print('Speech recognition error: $error');
          _onError?.call(error.toString());
        },
        onStatus: (status) {
          print('Speech recognition status: $status');
        },
        debugLogging: true,
      );
      return available;
    } catch (e) {
      print('Error initializing speech to text: $e');
      return false;
    }
  }

  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> startListening({
    Function(String)? onResult,
    Function(String)? onError,
  }) async {
    if (!_speechToText.isAvailable) {
      onError?.call('Speech recognition not available');
      return;
    }

    _onResult = onResult;
    _onError = onError;

    if (!_isListening) {
      _isListening = true;
      try {
        await _speechToText.listen(
          onResult: (result) {
            _lastWords = result.recognizedWords;
            print('Recognized: $_lastWords');
            _onResult?.call(_lastWords);
          },
          localeId: 'bn_BD', // Bangla (Bangladesh)
          pauseFor: Duration(seconds: 3),
          listenMode: stt.ListenMode.confirmation,
        );
      } catch (e) {
        print('Error starting listening: $e');
        _onError?.call(e.toString());
        _isListening = false;
      }
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      _isListening = false;
    }
  }

  bool get isListening => _isListening;
  String get lastWords => _lastWords;

  // Text to Speech
  Future<void> speak(String text, {String? language}) async {
    try {
      await _flutterTts.setLanguage(language ?? 'bn_BD');
      await _flutterTts.speak(text);
    } catch (e) {
      print('Error speaking: $e');
    }
  }

  Future<void> speakBangla(String text) async {
    await speak(text, language: 'bn_BD');
  }

  // Bangla Command Interpreter
  String parseBanglaCommand(String banglaText) {
    final text = banglaText.toLowerCase();

    // Navigation commands
    if (_containsBanglaWords(text, ['ড্যাশবোর্ড', 'হোম'])) return 'home';
    if (_containsBanglaWords(text, ['বাজার', 'মার্কেটপ্লেস'])) {
      return 'marketplace';
    }
    if (_containsBanglaWords(text, ['ফসল', 'ব্যাচ', 'নিবন্ধন', 'রেজিস্টার'])) {
      return 'crop_batch';
    }
    if (_containsBanglaWords(text, ['কীটপতঙ্গ', 'সনাক্ত', 'স্ক্যানার'])) {
      return 'pest_identification';
    }
    if (_containsBanglaWords(text, ['ঝুঁকি', 'মানচিত্র', 'ম্যাপ'])) {
      return 'risk_map';
    }
    if (_containsBanglaWords(text, ['আবহাওয়া', 'পূর্বাভাস', 'তাপমাত্রা'])) {
      return 'weather';
    }
    if (_containsBanglaWords(text, ['লগআউট', 'বাইরে', 'প্রস্থান'])) {
      return 'logout';
    }

    // Action commands
    if (_containsBanglaWords(text, ['সংরক্ষণ', 'সংরক্ষণ করুন', 'সাভ'])) {
      return 'save';
    }
    if (_containsBanglaWords(text, ['বাতিল', 'ফিরে যান'])) return 'cancel';
    if (_containsBanglaWords(text, ['সাবমিট', 'প্রেরণ'])) return 'submit';
    if (_containsBanglaWords(text, ['মুছে', 'মুছে ফেলুন'])) return 'delete';
    if (_containsBanglaWords(text, ['শোনান', 'পড়ুন', 'আমাকে বলুন'])) {
      return 'read_aloud';
    }

    return 'unknown';
  }

  bool _containsBanglaWords(String text, List<String> words) {
    for (var word in words) {
      if (text.contains(word.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  // Gesture Recognition (Future enhancement)
  void enableGestureDetection(Function(String) onGestureDetected) {
    // This will be implemented with hand gesture detection
    // Triggers based on camera input
    print('Gesture detection enabled');
  }

  void disableGestureDetection() {
    print('Gesture detection disabled');
  }

  Future<void> dispose() async {
    await _speechToText.cancel();
    await _flutterTts.stop();
  }
}
