// Mock language management
bool isBangla = true; // Set this based on user preference

class Constants {
  // A3: Weather API Key
  static const String openWeatherMapApiKey =
      '2e441b618a9df728a58f7e3de1284e9f';

  static const Map<String, Map<String, String>> localizedStrings = {
    'en': {
      'app_title': 'Khetibari: HarvestGuard',
      'scanner_title': 'Crop Health Scanner (A5)',
      'problem_heading': 'The \$1.5 Billion Problem',
      'loss_statistic':
          'Bangladesh loses 4.5 million metric tonnes of food grains annually.',
      'food_loss_today': 'Visualizing Annual Food Loss:',
      'loss_percent': '34% Lost',
      'solution_heading': 'Introducing HarvestGuard',
      'harvest_guard_pitch':
          'A mobile-first system providing hyper-local risk prediction and advisory to save your crops.',
      'get_started_btn': 'Get Started',
      'capture_btn': 'Capture Photo & Scan',
      'register_crop_btn': 'Register Crop Batch',
    },
    'bn': {
      'app_title': 'খেতিবাড়ি: হার্ভেস্টগার্ড',
      'scanner_title': 'ফসলের স্বাস্থ্য স্ক্যানার (A5)',
      'problem_heading': '১.৫ বিলিয়ন ডলারের ক্ষতি',
      'loss_statistic':
          'প্রতি বছর ৪.৫ মিলিয়ন মেট্রিক টন খাদ্যশস্য নষ্ট হয় বাংলাদেশে।',
      'food_loss_today': 'বার্ষিক খাদ্য নষ্টের চিত্র:',
      'loss_percent': '৩৪% নষ্ট',
      'solution_heading': 'হার্ভেস্টগার্ডের সূচনা',
      'harvest_guard_pitch':
          'আপনার ফসল রক্ষা করতে হাইপার-লোকাল ঝুঁকি পূর্বাভাস এবং পরামর্শ প্রদানকারী একটি মোবাইল-ফার্স্ট সিস্টেম।',
      'get_started_btn': 'শুরু করুন',
      'capture_btn': 'ছবি তুলুন ও স্ক্যান করুন',
      'register_crop_btn': 'ফসলের ব্যাচ নিবন্ধন করুন',
    },
  };

  static String getTranslation(String key) {
    final lang = isBangla ? 'bn' : 'en';
    return localizedStrings[lang]![key] ?? localizedStrings['en']![key]!;
  }
}
