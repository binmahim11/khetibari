// lib/providers/language_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Language provider for managing Bangla/English language toggle
class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';

  // true = Bangla, false = English
  bool _isBangla = true;

  bool get isBangla => _isBangla;
  String get currentLanguage => _isBangla ? 'Bangla' : 'English';

  late SharedPreferences _prefs;

  /// Initialize provider with saved language preference
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _isBangla = _prefs.getBool(_languageKey) ?? true;
    notifyListeners();
  }

  /// Toggle between Bangla and English
  Future<void> toggleLanguage() async {
    _isBangla = !_isBangla;
    await _prefs.setBool(_languageKey, _isBangla);
    notifyListeners();
  }

  /// Set specific language
  Future<void> setLanguage(bool bangla) async {
    _isBangla = bangla;
    await _prefs.setBool(_languageKey, _isBangla);
    notifyListeners();
  }
}

/// Translation dictionary with Bangla and English text
class Translations {
  // Auth & General
  static const Map<String, Map<String, String>> _texts = {
    // Navigation & Common
    'dashboard': {'en': 'Dashboard', 'bn': 'ড্যাশবোর্ড'},
    'marketplace': {'en': 'Marketplace', 'bn': 'বাজার'},
    'crop_batch': {'en': 'Crop Batch', 'bn': 'ফসলের ব্যাচ'},
    'pest_id': {'en': 'Pest Identification', 'bn': 'কীটপতঙ্গ চিহ্নিতকরণ'},
    'risk_map': {'en': 'Risk Map', 'bn': 'ঝুঁকি মানচিত্র'},
    'logout': {'en': 'Logout', 'bn': 'লগ আউট'},
    'settings': {'en': 'Settings', 'bn': 'সেটিংস'},

    // Language & Theme
    'language': {'en': 'Language', 'bn': 'ভাষা'},
    'english': {'en': 'English', 'bn': 'ইংরেজি'},
    'bangla': {'en': 'Bangla', 'bn': 'বাংলা'},
    'dark_mode': {'en': 'Dark Mode', 'bn': 'রাত্রিকালীন মোড'},
    'light_mode': {'en': 'Light Mode', 'bn': 'দিনের মোড'},

    // Marketplace
    'list_product': {'en': 'List New Product', 'bn': 'নতুন পণ্য যোগ করুন'},
    'sell_directly': {
      'en': 'Sell directly to consumers',
      'bn': 'সরাসরি ক্রেতাদের কাছে বিক্রয় করুন',
    },
    'view_products': {'en': 'View My Products', 'bn': 'আমার পণ্য দেখুন'},
    'my_orders': {'en': 'Orders & Transactions', 'bn': 'অর্ডার ও লেনদেন'},
    'product_name': {'en': 'Product Name', 'bn': 'পণ্যের নাম'},
    'crop_type': {'en': 'Crop Type', 'bn': 'ফসলের ধরন'},
    'quantity_kg': {'en': 'Quantity (kg)', 'bn': 'পরিমাণ (কেজি)'},
    'price_per_kg': {'en': 'Price per kg (৳)', 'bn': 'প্রতি কেজি মূল্য (৳)'},
    'location': {'en': 'Location', 'bn': 'অবস্থান'},
    'description': {'en': 'Description', 'bn': 'বিবরণ'},
    'list_now': {'en': 'List Now', 'bn': 'এখন যোগ করুন'},
    'cancel': {'en': 'Cancel', 'bn': 'বাতিল করুন'},
    'success': {
      'en': 'Product listed successfully!',
      'bn': 'পণ্য সফলভাবে যোগ করা হয়েছে!',
    },
    'error': {'en': 'Error listing product', 'bn': 'পণ্য যোগ করতে ত্রুটি'},

    // Crop Batch
    'register_crop': {
      'en': 'Register Crop Batch',
      'bn': 'ফসলের ব্যাচ নিবন্ধন করুন',
    },
    'batch_date': {'en': 'Batch Date', 'bn': 'ব্যাচ তারিখ'},
    'moisture_level': {'en': 'Moisture Level (%)', 'bn': 'আর্দ্রতা স্তর (%)'},
    'storage_type': {'en': 'Storage Type', 'bn': 'সঞ্চয়ের ধরন'},

    // Pest Identification
    'identify_pest': {'en': 'Identify Pest', 'bn': 'কীটপতঙ্গ চিহ্নিত করুন'},
    'take_photo': {'en': 'Take Photo', 'bn': 'ছবি তুলুন'},
    'upload_image': {'en': 'Upload Image', 'bn': 'ছবি আপলোড করুন'},

    // Dashboard
    'total_earnings': {'en': 'Total Earnings', 'bn': 'মোট আয়'},
    'commission_saved': {'en': 'Commission Saved', 'bn': 'সাশ্রয়কৃত কমিশন'},
    'products_listed': {'en': 'Products Listed', 'bn': 'যোগ করা পণ্য'},
    'pending_orders': {'en': 'Pending Orders', 'bn': 'অপেক্ষমান অর্ডার'},
  };

  /// Get translated text based on language
  static String get(String key, {required bool isBangla}) {
    final lang = isBangla ? 'bn' : 'en';
    return _texts[key]?[lang] ?? key;
  }
}
