// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crop_batch.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CropBatchAdapter extends TypeAdapter<CropBatch> {
  @override
  final int typeId = 0;

  @override
  CropBatch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CropBatch(
      batchId: fields[0] as String,
      farmerId: fields[1] as String,
      cropType: fields[2] as String,
      estimatedWeightKg: fields[3] as double,
      harvestDate: fields[4] as DateTime,
      storageLocationUpazila: fields[5] as String,
      storageType: fields[6] as String,
      loggedDate: fields[7] as DateTime,
      currentMoistureLevel: fields[8] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CropBatch obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.batchId)
      ..writeByte(1)
      ..write(obj.farmerId)
      ..writeByte(2)
      ..write(obj.cropType)
      ..writeByte(3)
      ..write(obj.estimatedWeightKg)
      ..writeByte(4)
      ..write(obj.harvestDate)
      ..writeByte(5)
      ..write(obj.storageLocationUpazila)
      ..writeByte(6)
      ..write(obj.storageType)
      ..writeByte(7)
      ..write(obj.loggedDate)
      ..writeByte(8)
      ..write(obj.currentMoistureLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CropBatchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
