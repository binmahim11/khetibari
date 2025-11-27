// prediction_service.dart

import 'package:khetibari/models/crop_batch.dart';
import 'package:khetibari/models/weather.dart';
import 'dart:math';

class PredictionService {
  
  // A4: Calculates Estimated Time to Critical Loss (ETCL) in Hours
  double calculateETCL(CropBatch batch, List<WeatherForecast> weather) {
    const double criticalMoisture = 20.0;
    double currentMoisture = batch.currentMoistureLevel;
    
    if (currentMoisture >= criticalMoisture) {
      return 0.0; 
    }

    // 1. Determine Environmental Risk Factor (from A3 Weather)
    double avgTemp = weather.map((f) => f.temperature).fold(0.0, (a, b) => a + b) / weather.length;
    double avgHumidity = weather.map((f) => f.humidity).fold(0.0, (a, b) => a + b) / weather.length;

    // Loss Rate Logic: Higher Temp/Humidity = Faster Loss
    double dailyLossRate = 0.5; // Baseline 0.5% moisture increase per day

    if (avgTemp > 30.0 && avgHumidity > 90.0) {
      dailyLossRate = 2.5; // High Risk: Moisture increases 2.5% per day
    } else if (avgHumidity > 80.0) {
      dailyLossRate = 1.2; // Moderate Risk: Moisture increases 1.2% per day
    }
    
    // 2. Calculate ETCL
    double moistureDifference = criticalMoisture - currentMoisture;
    double etclDays = moistureDifference / dailyLossRate;
    
    double etclHours = etclDays * 24;
    return max(0.0, etclHours);
  }

  // A4: Human-Readable Risk Summary (Bangla)
  String getRiskSummaryBangla(double etclHours, String cropType) {
    if (etclHours <= 0) {
      return "🔴 **চূড়ান্ত ঝুঁকি (Critical Risk):** আর্দ্রতার মাত্রা বিপদসীমা অতিক্রম করেছে! দ্রুত সংরক্ষণের ব্যবস্থা নিন।";
    } else if (etclHours < 48) {
      return "🔥 **অতি উচ্চ ঝুঁকি (High Risk):** পরবর্তী ${etclHours.toStringAsFixed(0)} ঘণ্টার মধ্যে শস্য নষ্ট হওয়ার সম্ভাবনা। আজই শুকানোর ব্যবস্থা করুন।";
    } else if (etclHours < 168) { 
      return "⚠️ **মাঝারি ঝুঁকি (Moderate Risk):** পরবর্তী ${etclHours.toStringAsFixed(0)} ঘণ্টার মধ্যে ঝুঁকি বাড়তে পারে। ২-৩ দিনের আবহাওয়া পর্যবেক্ষণ করুন।";
    } else {
      return "🟢 **কম ঝুঁকি (Low Risk):** আপনার শস্য বর্তমানে নিরাপদ অবস্থায় আছে।";
    }
  }
}