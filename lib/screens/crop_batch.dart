// crop_batch_page.dart

import 'package:flutter/material.dart';
import 'package:khetibari/models/crop_batch.dart';
import 'package:khetibari/models/weather.dart';
import 'package:khetibari/services/data_service.dart';
import 'package:khetibari/services/prediction_service.dart';
import 'package:khetibari/services/weather_service.dart';
import 'package:khetibari/utils/constants.dart';

class CropBatchPage extends StatefulWidget {
  const CropBatchPage({super.key});

  @override
  _CropBatchPageState createState() => _CropBatchPageState();
}

class _CropBatchPageState extends State<CropBatchPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedUpazila;
  double _weight = 0;
  final DateTime _harvestDate = DateTime.now();

  List<CropBatch> _batches = [];
  bool _isLoading = true;

  final DataService _dataService = DataService();
  final WeatherService _weatherService = WeatherService();
  final PredictionService _predictionService = PredictionService();

  @override
  void initState() {
    super.initState();
    _loadBatchesAndPredictions();
  }

  Future<void> _loadBatchesAndPredictions() async {
    setState(() => _isLoading = true);
    // Mock farmerId for simplicity
    List<CropBatch> activeBatches = _dataService.getActiveBatches('F-101');

    // A3/A4 Integration Logic
    for (var batch in activeBatches) {
      try {
        List<WeatherForecast> weather = await _weatherService
            .fetchWeatherForecast(batch.storageLocationUpazila);
        double etcl = _predictionService.calculateETCL(batch, weather);
        String advisory = _weatherService.generateBanglaAdvisory(weather);
        String riskSummary = _predictionService.getRiskSummaryBangla(
          etcl,
          batch.cropType,
        );

        // Temporarily attach results to the batch object for display
        (batch as dynamic).weatherAdvisory = advisory;
        (batch as dynamic).riskSummary = riskSummary;
        (batch as dynamic).etclHours = etcl;
      } catch (e) {
        print('Error integrating A3/A4: $e');
        (batch as dynamic).weatherAdvisory = 'আবহাওয়া/ঝুঁকি ডেটা পাওয়া যায়নি।';
        (batch as dynamic).riskSummary = 'ঝুঁকি গণনা ব্যর্থ হয়েছে।';
      }
    }

    setState(() {
      _batches = activeBatches;
      _isLoading = false;
    });
  }

  void _registerBatch() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newBatch = CropBatch(
        batchId: 'B-${DateTime.now().millisecondsSinceEpoch}',
        farmerId: 'F-101',
        cropType: 'Paddy (ধান)',
        estimatedWeightKg: _weight,
        harvestDate: _harvestDate,
        storageLocationUpazila: _selectedUpazila!,
        storageType: 'Jute Bags',
        loggedDate: DateTime.now(),
        currentMoistureLevel: 18.0, // Mock initial moisture
      );

      await _dataService.registerCropBatch(newBatch);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${Constants.getTranslation('register_crop_btn')} সফল হয়েছে!',
          ),
        ),
      );
      _loadBatchesAndPredictions(); // Reload list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.getTranslation('app_title')),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            onPressed: _loadBatchesAndPredictions,
            icon: Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A2: Registration Form
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Constants.getTranslation('register_crop_btn'),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'ফসলের প্রকার (Crop Type)',
                        ),
                        initialValue: 'Paddy (ধান)',
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'আনুমানিক ওজন (কেজি)',
                        ),
                        keyboardType: TextInputType.number,
                        onSaved:
                            (value) =>
                                _weight = double.tryParse(value ?? '0') ?? 0,
                        validator:
                            (value) => value!.isEmpty ? 'ওজন আবশ্যক' : null,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'সংরক্ষণের উপজেলা (Location)',
                        ),
                        value: _selectedUpazila,
                        items:
                            upazilaCoords.keys.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged:
                            (String? newValue) =>
                                setState(() => _selectedUpazila = newValue),
                        validator:
                            (value) => value == null ? 'উপজেলা আবশ্যক' : null,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _registerBatch,
                        child: Text(
                          Constants.getTranslation('register_crop_btn'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 30),
            Text(
              'আপনার নিবন্ধিত ফসলের ব্যাচ (Your Batches)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            _isLoading
                ? Center(child: CircularProgressIndicator())
                : _batches.isEmpty
                ? Text('কোনো নিবন্ধিত ব্যাচ নেই।')
                : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _batches.length,
                  itemBuilder: (context, index) {
                    final batch = _batches[index];
                    // Display A2, A3, A4 data
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      color:
                          ((batch as dynamic).etclHours ?? 999) < 72
                              ? Colors.red.shade50
                              : Colors.green.shade50,
                      child: ListTile(
                        leading: Icon(Icons.grass, color: Colors.green),
                        title: Text(
                          '${batch.cropType} (${batch.estimatedWeightKg} কেজি)',
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'স্থান: ${batch.storageLocationUpazila} | আর্দ্রতা: ${batch.currentMoistureLevel}%',
                            ),
                            // A4 Risk Summary
                            SizedBox(height: 5),
                            Text(
                              (batch as dynamic).riskSummary ?? 'Loading...',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            // A3 Weather Advisory
                            Text(
                              'আবহাওয়া পরামর্শ: ' +
                                  ((batch as dynamic).weatherAdvisory ??
                                      'Loading...'),
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
