import 'package:flutter/material.dart';
import 'package:khetibari/screens/auth_service.dart';
import 'package:khetibari/screens/crop_batch_page.dart';
import 'package:khetibari/screens/farmer_dashboard_page.dart';
import 'package:khetibari/screens/marketplace_page.dart';
import 'package:khetibari/screens/landing_page.dart';
import 'package:khetibari/services/weather_service.dart';
import 'package:khetibari/services/prediction_service.dart';
import 'package:khetibari/services/data_service.dart';
import 'package:khetibari/models/weather.dart';
import 'package:khetibari/models/crop_batch.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _weatherService = WeatherService();
  final _predictionService = PredictionService();
  final _dataService = DataService();
  final _authService = AuthService();
  
  List<WeatherForecast> _forecasts = [];
  String _advisory = '';
  bool _loadingWeather = true;
  String _selectedUpazila = 'Laxmipur Sadar'; // Default location
  
  // Crop batch risk predictions
  List<Map<String, dynamic>> _batchRisks = []; // [{batch, etcl, riskSummary}]
  bool _loadingRisks = true;

  @override
  void initState() {
    super.initState();
    _loadWeather();
    _loadCropBatchRisks();
  }

  Future<void> _loadWeather() async {
    setState(() => _loadingWeather = true);
    try {
      final forecasts = await _weatherService.fetchWeatherForecast(_selectedUpazila);
      final advisory = _weatherService.generateBanglaAdvisory(forecasts);
      setState(() {
        _forecasts = forecasts;
        _advisory = advisory;
        _loadingWeather = false;
      });
    } catch (e) {
      setState(() {
        _loadingWeather = false;
        _advisory = 'আবহাওয়া তথ্য লোড করতে সমস্যা হয়েছে।';
      });
    }
  }

  Future<void> _loadCropBatchRisks() async {
    setState(() => _loadingRisks = true);
    try {
      // Get current user ID or use default
      final userId = _authService.currentUser?.uid ?? 'FARMER_001';
      final batches = _dataService.getActiveBatches(userId);
      
      List<Map<String, dynamic>> risks = [];
      
      for (var batch in batches) {
        try {
          // Fetch weather for this batch's location
          final weather = await _weatherService.fetchWeatherForecast(
            batch.storageLocationUpazila,
          );
          
          // Calculate ETCL
          final etclHours = _predictionService.calculateETCL(batch, weather);
          final riskSummary = _predictionService.getRiskSummaryBangla(
            etclHours,
            batch.cropType,
          );
          
          risks.add({
            'batch': batch,
            'etclHours': etclHours,
            'riskSummary': riskSummary,
          });
        } catch (e) {
          // If weather fetch fails for a batch, skip it
          print('Error loading risk for batch ${batch.batchId}: $e');
        }
      }
      
      // Sort by risk (lowest ETCL = highest risk first)
      risks.sort((a, b) => (a['etclHours'] as double).compareTo(b['etclHours'] as double));
      
      setState(() {
        _batchRisks = risks;
        _loadingRisks = false;
      });
    } catch (e) {
      setState(() {
        _loadingRisks = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Home'),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
              // Navigate back to landing page after logout
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LandingPage()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome, Farmer!',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            
            // A4: Crop Batch Risk Predictions Section
            if (_batchRisks.isNotEmpty) ...[
              Card(
                elevation: 4,
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red.shade700, size: 28),
                          const SizedBox(width: 12),
                          const Text(
                            'Crop Batch Risk Alerts',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_loadingRisks)
                        const Center(child: CircularProgressIndicator())
                      else
                        ..._batchRisks.map((riskData) {
                          final batch = riskData['batch'] as CropBatch;
                          final etclHours = riskData['etclHours'] as double;
                          final riskSummary = riskData['riskSummary'] as String;
                          
                          Color riskColor;
                          if (etclHours <= 0) {
                            riskColor = Colors.red;
                          } else if (etclHours < 48) {
                            riskColor = Colors.orange;
                          } else if (etclHours < 168) {
                            riskColor = Colors.amber;
                          } else {
                            riskColor = Colors.green;
                          }
                          
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: riskColor, width: 2),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Batch: ${batch.batchId.substring(0, 8)}...',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${batch.cropType} - ${batch.estimatedWeightKg.toStringAsFixed(0)} kg',
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            'Location: ${batch.storageLocationUpazila}',
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: riskColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        etclHours <= 0
                                            ? 'CRITICAL'
                                            : etclHours < 48
                                                ? 'HIGH'
                                                : etclHours < 168
                                                    ? 'MODERATE'
                                                    : 'LOW',
                                        style: TextStyle(
                                          color: riskColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: riskColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    riskSummary,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: riskColor == Colors.green 
                                          ? Colors.green.shade900
                                          : riskColor == Colors.amber
                                              ? Colors.amber.shade900
                                              : riskColor == Colors.orange
                                                  ? Colors.orange.shade900
                                                  : Colors.red.shade900,
                                    ),
                                  ),
                                ),
                                if (etclHours > 0) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    'Estimated Time to Critical Loss: ${etclHours.toStringAsFixed(0)} hours (${(etclHours / 24).toStringAsFixed(1)} days)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ] else if (!_loadingRisks) ...[
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'No active crop batches found. Register a crop batch to see risk predictions.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            // Weather Forecast Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.wb_sunny, color: Colors.orange.shade700),
                            const SizedBox(width: 8),
                            const Text(
                              'Weather Forecast',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () {
                                _loadWeather();
                                _loadCropBatchRisks();
                              },
                              tooltip: 'Refresh All',
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Location selector
                    DropdownButton<String>(
                      value: _selectedUpazila,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'Laxmipur Sadar', child: Text('Laxmipur Sadar')),
                        DropdownMenuItem(value: 'Dinajpur Sadar', child: Text('Dinajpur Sadar')),
                        DropdownMenuItem(value: 'Bagerhat Sadar', child: Text('Bagerhat Sadar')),
                        DropdownMenuItem(value: 'Dhaka', child: Text('Dhaka')),
                        DropdownMenuItem(value: 'Chittagong', child: Text('Chittagong')),
                        DropdownMenuItem(value: 'Sylhet', child: Text('Sylhet')),
                        DropdownMenuItem(value: 'Rajshahi', child: Text('Rajshahi')),
                        DropdownMenuItem(value: 'Khulna', child: Text('Khulna')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedUpazila = value);
                          _loadWeather();
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_loadingWeather)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      // Bengali Advisory
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _advisory.contains('🚨') 
                              ? Colors.red.shade50 
                              : _advisory.contains('⚠') 
                                  ? Colors.orange.shade50 
                                  : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _advisory.contains('🚨') 
                                ? Colors.red.shade300 
                                : _advisory.contains('⚠') 
                                    ? Colors.orange.shade300 
                                    : Colors.green.shade300,
                          ),
                        ),
                        child: Text(
                          _advisory,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Weather Forecast List
                      if (_forecasts.isNotEmpty) ...[
                        const Text(
                          '5-Day Forecast:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ..._forecasts.map((forecast) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  DateFormat('MMM dd, yyyy').format(forecast.date),
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                '${forecast.temperature.toStringAsFixed(1)}°C',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                forecast.condition,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              const SizedBox(width: 12),
                              Row(
                                children: [
                                  Icon(Icons.water_drop, size: 16, color: Colors.blue.shade700),
                                  Text('${forecast.humidity.toStringAsFixed(0)}%'),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Row(
                                children: [
                                  Icon(Icons.cloud, size: 16, color: Colors.grey.shade600),
                                  Text('${forecast.rainProbability.toStringAsFixed(0)}%'),
                                ],
                              ),
                            ],
                          ),
                        )),
                      ],
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FarmerDashboardPage(
                      farmerId: 'FARMER_001',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.dashboard),
              label: const Text('Farmer Dashboard'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.purple.shade700,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CropBatchPage(),
                  ),
                );
              },
              icon: const Icon(Icons.assignment),
              label: const Text('Register Crop Batch'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MarketplacePage(),
                  ),
                );
              },
              icon: const Icon(Icons.storefront),
              label: const Text('My Marketplace'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.blue.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

