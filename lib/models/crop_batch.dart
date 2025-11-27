// crop_batch.dart

import 'package:hive/hive.dart';

part 'crop_batch.g.dart'; // Run: flutter packages pub run build_runner build

@HiveType(typeId: 0)
class CropBatch {
  @HiveField(0)
  final String batchId;

  @HiveField(1)
  final String farmerId; // Mocked for simplicity

  @HiveField(2)
  final String cropType; // e.g., 'Paddy (ধান)'

  @HiveField(3)
  final double estimatedWeightKg;

  @HiveField(4)
  final DateTime harvestDate;

  @HiveField(5)
  final String storageLocationUpazila; // CRUCIAL for A3/A4

  @HiveField(6)
  final String storageType;

  @HiveField(7)
  final DateTime loggedDate;

  @HiveField(8)
  double currentMoistureLevel;

  CropBatch({
    required this.batchId,
    required this.farmerId,
    required this.cropType,
    required this.estimatedWeightKg,
    required this.harvestDate,
    required this.storageLocationUpazila,
    required this.storageType,
    required this.loggedDate,
    this.currentMoistureLevel = 15.0,
  });
}
