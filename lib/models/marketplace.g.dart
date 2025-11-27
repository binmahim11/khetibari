// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FarmProductAdapter extends TypeAdapter<FarmProduct> {
  @override
  final int typeId = 1;

  @override
  FarmProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FarmProduct(
      productId: fields[0] as String,
      farmerId: fields[1] as String,
      farmerName: fields[2] as String,
      productName: fields[3] as String,
      cropType: fields[4] as String,
      quantityKg: fields[5] as double,
      basePrice: fields[6] as double,
      dynamicPrice: fields[7] as double,
      location: fields[8] as String,
      description: fields[9] as String,
      listedDate: fields[10] as DateTime,
      demandScore: fields[11] as int,
      isAvailable: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FarmProduct obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.farmerId)
      ..writeByte(2)
      ..write(obj.farmerName)
      ..writeByte(3)
      ..write(obj.productName)
      ..writeByte(4)
      ..write(obj.cropType)
      ..writeByte(5)
      ..write(obj.quantityKg)
      ..writeByte(6)
      ..write(obj.basePrice)
      ..writeByte(7)
      ..write(obj.dynamicPrice)
      ..writeByte(8)
      ..write(obj.location)
      ..writeByte(9)
      ..write(obj.description)
      ..writeByte(10)
      ..write(obj.listedDate)
      ..writeByte(11)
      ..write(obj.demandScore)
      ..writeByte(12)
      ..write(obj.isAvailable);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FarmProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConsumerOrderAdapter extends TypeAdapter<ConsumerOrder> {
  @override
  final int typeId = 2;

  @override
  ConsumerOrder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConsumerOrder(
      orderId: fields[0] as String,
      consumerId: fields[1] as String,
      consumerName: fields[2] as String,
      productId: fields[3] as String,
      farmerId: fields[4] as String,
      farmerName: fields[5] as String,
      quantityKg: fields[6] as double,
      pricePerKg: fields[7] as double,
      totalPrice: fields[8] as double,
      orderDate: fields[9] as DateTime,
      status: fields[10] as String,
      deliveryLocation: fields[11] as String,
      estimatedDelivery: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, ConsumerOrder obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.orderId)
      ..writeByte(1)
      ..write(obj.consumerId)
      ..writeByte(2)
      ..write(obj.consumerName)
      ..writeByte(3)
      ..write(obj.productId)
      ..writeByte(4)
      ..write(obj.farmerId)
      ..writeByte(5)
      ..write(obj.farmerName)
      ..writeByte(6)
      ..write(obj.quantityKg)
      ..writeByte(7)
      ..write(obj.pricePerKg)
      ..writeByte(8)
      ..write(obj.totalPrice)
      ..writeByte(9)
      ..write(obj.orderDate)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.deliveryLocation)
      ..writeByte(12)
      ..write(obj.estimatedDelivery);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConsumerOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DirectDealTransactionAdapter extends TypeAdapter<DirectDealTransaction> {
  @override
  final int typeId = 3;

  @override
  DirectDealTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DirectDealTransaction(
      transactionId: fields[0] as String,
      farmerId: fields[1] as String,
      farmerName: fields[2] as String,
      consumerId: fields[3] as String,
      consumerName: fields[4] as String,
      productQuantityKg: fields[5] as double,
      pricePerKg: fields[6] as double,
      farmerEarnings: fields[7] as double,
      transactionDate: fields[8] as DateTime,
      paymentMethod: fields[9] as String,
      commissionSaved: fields[10] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DirectDealTransaction obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.transactionId)
      ..writeByte(1)
      ..write(obj.farmerId)
      ..writeByte(2)
      ..write(obj.farmerName)
      ..writeByte(3)
      ..write(obj.consumerId)
      ..writeByte(4)
      ..write(obj.consumerName)
      ..writeByte(5)
      ..write(obj.productQuantityKg)
      ..writeByte(6)
      ..write(obj.pricePerKg)
      ..writeByte(7)
      ..write(obj.farmerEarnings)
      ..writeByte(8)
      ..write(obj.transactionDate)
      ..writeByte(9)
      ..write(obj.paymentMethod)
      ..writeByte(10)
      ..write(obj.commissionSaved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DirectDealTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
