// data_service.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'package:khetibari/models/crop_batch.dart';

class DataService {
  static const String _boxName = 'cropBatches';

  // Call this once in main.dart
  static Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CropBatchAdapter());
    await Hive.openBox<CropBatch>(_boxName);
  }

  // A2: Save Batch (Offline)
  Future<void> registerCropBatch(CropBatch batch) async {
    final box = Hive.box<CropBatch>(_boxName);
    await box.put(batch.batchId, batch);
    print('A2: Crop Batch ${batch.batchId} saved locally (Offline).');

    // **Sync Online Logic (To be added for production):**
    // if (await isOnline()) {
    //   // Call Supabase/Firebase upload logic here
    // }
  }

  // A4: Fetch Active Batches
  List<CropBatch> getActiveBatches(String farmerId) {
    final box = Hive.box<CropBatch>(_boxName);
    // In a real app, filter by farmerId. Here, return all mock data.
    return box.values.toList();
  }

  // A2: CSV Export (Needs path_provider for mobile file access)
  String exportBatchesToCSV(List<CropBatch> batches) {
    StringBuffer csv = StringBuffer();
    csv.writeln(
      'Batch ID, Crop Type, Weight (kg), Upazila, Harvest Date, Moisture Level',
    );
    for (var batch in batches) {
      csv.writeln(
        '${batch.batchId}, ${batch.cropType}, ${batch.estimatedWeightKg}, ${batch.storageLocationUpazila}, ${batch.harvestDate.toIso8601String()}, ${batch.currentMoistureLevel}',
      );
    }
    // **NOTE:** For file saving on Flutter, you need to use path_provider and dart:io
    // This function returns the string content.
    return csv.toString();
  }
}
