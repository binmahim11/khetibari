// crop_batch_page.dart

import 'package:flutter/material.dart';
import 'package:khetibari/models/crop_batch.dart';
import 'package:khetibari/services/data_service.dart';
import 'package:khetibari/utils/constants.dart';
import 'package:khetibari/utils/app_button_styles.dart';
import 'package:khetibari/utils/animated_farmer_graphics.dart';
import 'package:khetibari/screens/voice_interface_widget.dart';

class CropBatchPage extends StatefulWidget {
  const CropBatchPage({super.key});

  @override
  State<CropBatchPage> createState() => _CropBatchPageState();
}

class _CropBatchPageState extends State<CropBatchPage> {
  final _formKey = GlobalKey<FormState>();
  final _dataService = DataService();

  // Form fields
  late String batchId;
  late String farmerId;
  late String cropType;
  late double estimatedWeightKg;
  late DateTime harvestDate;
  late String storageLocationUpazila;
  late String storageType;
  late double currentMoistureLevel;

  // Dropdown options
  final List<String> cropTypes = [
    'Paddy (ধান)',
    'Wheat (গম)',
    'Maize (ভুট্টা)',
    'Rice (চাল)',
  ];

  final List<String> upazilas = [
    'Dhaka',
    'Chittagong',
    'Sylhet',
    'Rajshahi',
    'Khulna',
  ];

  final List<String> storageTypes = [
    'Warehouse',
    'Silo',
    'Open Field',
    'Cold Storage',
  ];

  @override
  void initState() {
    super.initState();
    batchId = DateTime.now().millisecondsSinceEpoch.toString();
    farmerId = 'FARMER_001'; // Mock farmer ID
    cropType = cropTypes[0];
    estimatedWeightKg = 1000;
    harvestDate = DateTime.now();
    storageLocationUpazila = upazilas[0];
    storageType = storageTypes[0];
    currentMoistureLevel = 15.0;
  }

  void _handleVoiceCommand(String command) {
    switch (command) {
      case 'save':
        _submitForm();
        break;
      case 'submit':
        _submitForm();
        break;
      case 'cancel':
        Navigator.pop(context);
        break;
      case 'home':
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final batch = CropBatch(
        batchId: batchId,
        farmerId: farmerId,
        cropType: cropType,
        estimatedWeightKg: estimatedWeightKg,
        harvestDate: harvestDate,
        storageLocationUpazila: storageLocationUpazila,
        storageType: storageType,
        loggedDate: DateTime.now(),
        currentMoistureLevel: currentMoistureLevel,
      );

      _dataService.registerCropBatch(batch);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ফসলের ব্যাচ সফলভাবে নিবন্ধিত হয়েছে!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.getTranslation('register_crop_btn')),
        backgroundColor: Colors.black,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 28),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Animated Farmer Graphic Header
              Center(
                child: AnimatedFarmerGraphic(
                  type: 'tractor',
                  width: 150,
                  height: 120,
                  animationType: 'slideUp',
                  duration: const Duration(milliseconds: 1200),
                ),
              ),
              const SizedBox(height: 16),

              // Voice Interface Widget
              VoiceInterfaceWidget(onCommandReceived: _handleVoiceCommand),
              SizedBox(height: 16),
              // Batch ID (Read-only)
              TextFormField(
                initialValue: batchId,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Batch ID (Auto-generated)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Crop Type Dropdown
              DropdownButtonFormField<String>(
                value: cropType,
                decoration: InputDecoration(
                  labelText: 'Crop Type',
                  border: OutlineInputBorder(),
                ),
                items:
                    cropTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    cropType = value!;
                  });
                },
              ),
              SizedBox(height: 16),

              // Estimated Weight
              TextFormField(
                initialValue: estimatedWeightKg.toString(),
                decoration: InputDecoration(
                  labelText: 'Estimated Weight (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  estimatedWeightKg = double.tryParse(value) ?? 1000;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter weight';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Harvest Date
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Harvest Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                controller: TextEditingController(
                  text: harvestDate.toIso8601String().split('T')[0],
                ),
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: harvestDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      harvestDate = pickedDate;
                    });
                  }
                },
              ),
              SizedBox(height: 16),

              // Storage Location (Upazila)
              DropdownButtonFormField<String>(
                value: storageLocationUpazila,
                decoration: InputDecoration(
                  labelText: 'Storage Location (Upazila)',
                  border: OutlineInputBorder(),
                ),
                items:
                    upazilas.map((upazila) {
                      return DropdownMenuItem(
                        value: upazila,
                        child: Text(upazila),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    storageLocationUpazila = value!;
                  });
                },
              ),
              SizedBox(height: 16),

              // Storage Type
              DropdownButtonFormField<String>(
                value: storageType,
                decoration: InputDecoration(
                  labelText: 'Storage Type',
                  border: OutlineInputBorder(),
                ),
                items:
                    storageTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    storageType = value!;
                  });
                },
              ),
              SizedBox(height: 16),

              // Current Moisture Level
              TextFormField(
                initialValue: currentMoistureLevel.toString(),
                decoration: InputDecoration(
                  labelText: 'Current Moisture Level (%)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  currentMoistureLevel = double.tryParse(value) ?? 15.0;
                },
              ),
              SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveCropBatch,
                  icon: const Icon(Icons.save),
                  label: Text(
                    Constants.getTranslation('register_crop_btn'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.3,
                    ),
                  ),
                  style: AppButtonStyles.largePrimaryBlackButton(),
                ),
              ),
              SizedBox(height: 16),

              // View Batches Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _viewBatches,
                  icon: const Icon(Icons.list),
                  label: const Text(
                    'View Saved Batches',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.3,
                    ),
                  ),
                  style: AppButtonStyles.largePrimaryBlackButton(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveCropBatch() {
    if (_formKey.currentState!.validate()) {
      final newBatch = CropBatch(
        batchId: batchId,
        farmerId: farmerId,
        cropType: cropType,
        estimatedWeightKg: estimatedWeightKg,
        harvestDate: harvestDate,
        storageLocationUpazila: storageLocationUpazila,
        storageType: storageType,
        loggedDate: DateTime.now(),
        currentMoistureLevel: currentMoistureLevel,
      );

      _dataService.registerCropBatch(newBatch);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Batch $batchId saved successfully!'),
          duration: Duration(seconds: 2),
        ),
      );

      // Reset form
      setState(() {
        batchId = DateTime.now().millisecondsSinceEpoch.toString();
        cropType = cropTypes[0];
        estimatedWeightKg = 1000;
        harvestDate = DateTime.now();
        storageLocationUpazila = upazilas[0];
        storageType = storageTypes[0];
        currentMoistureLevel = 15.0;
      });
    }
  }

  void _viewBatches() {
    final batches = _dataService.getActiveBatches(farmerId);
    final csvContent = _dataService.exportBatchesToCSV(batches);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Saved Batches (${batches.length})'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (batches.isEmpty)
                    Text('No batches saved yet.')
                  else
                    ...batches.map(
                      (batch) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Batch ID: ${batch.batchId}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Crop: ${batch.cropType}'),
                            Text('Weight: ${batch.estimatedWeightKg} kg'),
                            Text('Location: ${batch.storageLocationUpazila}'),
                            Text('Moisture: ${batch.currentMoistureLevel}%'),
                            Divider(),
                          ],
                        ),
                      ),
                    ),
                  SizedBox(height: 16),
                  Text(
                    'CSV Export:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SelectableText(csvContent),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }
}
