// weather.dart

class WeatherForecast {
  final DateTime date;
  final double temperature; // Celsius
  final double humidity; // Percentage
  final double rainProbability; // 0-100%
  final String condition; // e.g., 'scattered clouds'

  WeatherForecast({
    required this.date,
    required this.temperature,
    required this.humidity,
    required this.rainProbability,
    required this.condition,
  });
}