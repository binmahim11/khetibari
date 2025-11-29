// weather_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:khetibari/models/weather.dart';
import 'package:khetibari/utils/constants.dart';

// Simplified location mapping for Bangladesh (Upazila to Lat/Lon)
const Map<String, Map<String, double>> upazilaCoords = {
  'Laxmipur Sadar': {'lat': 22.95, 'lon': 90.83},
  'Dinajpur Sadar': {'lat': 25.62, 'lon': 88.63},
  'Bagerhat Sadar': {'lat': 22.66, 'lon': 89.79},
  'Dhaka': {'lat': 23.8103, 'lon': 90.4125},
  'Chittagong': {'lat': 22.3569, 'lon': 91.7832},
  'Sylhet': {'lat': 24.8949, 'lon': 91.8687},
  'Rajshahi': {'lat': 24.3745, 'lon': 88.6042},
  'Khulna': {'lat': 22.8456, 'lon': 89.5403},
};

class WeatherService {
  final String _apiKey = Constants.openWeatherMapApiKey;
  final String _baseUrl = 'https://api.openweathermap.org/data/2.5/forecast';

  Future<List<WeatherForecast>> fetchWeatherForecast(String upazila) async {
    final coords = upazilaCoords[upazila];
    if (coords == null) {
       // Mock Data if location not found
       return _getMockWeather();
    }

    final response = await http.get(
      Uri.parse('$_baseUrl?lat=${coords['lat']}&lon=${coords['lon']}&units=metric&appid=$_apiKey&lang=bn')
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<WeatherForecast> forecasts = [];
      
      // Grab 5-day forecast
      for (int i = 0; i < data['list'].length && forecasts.length < 5; i += 8) {
        final item = data['list'][i];
        forecasts.add(WeatherForecast(
          date: DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000),
          temperature: item['main']['temp'].toDouble(),
          humidity: item['main']['humidity'].toDouble(),
          rainProbability: item['pop'].toDouble() * 100, 
          condition: item['weather'][0]['description'] ?? 'Clear',
        ));
      }
      return forecasts;
    } else {
      print('A3: Failed to load weather data. Status: ${response.statusCode}');
      return _getMockWeather();
    }
  }
  
  // A3: Bangla Advisory Generation
  String generateBanglaAdvisory(List<WeatherForecast> forecasts) {
    if (forecasts.isEmpty) return "আবহাওয়া সংক্রান্ত তথ্য পাওয়া যায়নি।";

    final nextDay = forecasts[0];
    if (nextDay.rainProbability > 70) {
      return "🚨 **জরুরী সতর্কতা:** আগামী ২৪ ঘণ্টায় ${nextDay.rainProbability.toStringAsFixed(0)}% বৃষ্টির সম্ভাবনা। আপনার ফসল দ্রুত ঢেকে রাখুন বা নিরাপদ স্থানে সরিয়ে নিন।";
    }
    if (nextDay.humidity > 90) {
      return "⚠ **আর্দ্রতা সতর্কতা:** আর্দ্রতা ${nextDay.humidity.toStringAsFixed(0)}% এর বেশি। ফসলের আর্দ্রতা পরীক্ষা করুন।";
    }
    return "✅ আবহাওয়া সাধারণত অনুকূলে আছে।";
  }

  List<WeatherForecast> _getMockWeather() {
    return [
      WeatherForecast(date: DateTime.now(), temperature: 28.5, humidity: 92, rainProbability: 80, condition: 'Heavy Rain'),
      WeatherForecast(date: DateTime.now().add(Duration(days: 1)), temperature: 26.0, humidity: 88, rainProbability: 60, condition: 'Cloudy'),
    ];
  }
}