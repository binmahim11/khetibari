// marketplace.dart

import 'package:hive/hive.dart';

part 'marketplace.g.dart'; // Run: flutter packages pub run build_runner build

@HiveType(typeId: 1)
class FarmProduct {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String farmerId;

  @HiveField(2)
  final String farmerName;

  @HiveField(3)
  final String productName;

  @HiveField(4)
  final String cropType; // e.g., 'Paddy (ধান)'

  @HiveField(5)
  final double quantityKg;

  @HiveField(6)
  final double basePrice; // Price per kg set by farmer

  @HiveField(7)
  final double dynamicPrice; // Adjusted by demand

  @HiveField(8)
  final String location; // Upazila

  @HiveField(9)
  final String description;

  @HiveField(10)
  final DateTime listedDate;

  @HiveField(11)
  final int demandScore; // 0-100 based on interested buyers

  @HiveField(12)
  final bool isAvailable;

  FarmProduct({
    required this.productId,
    required this.farmerId,
    required this.farmerName,
    required this.productName,
    required this.cropType,
    required this.quantityKg,
    required this.basePrice,
    this.dynamicPrice = 0,
    required this.location,
    required this.description,
    required this.listedDate,
    this.demandScore = 0,
    this.isAvailable = true,
  });

  // Calculate dynamic price based on demand
  double calculateDynamicPrice() {
    double priceMultiplier =
        1.0 + (demandScore / 100) * 0.3; // Up to 30% increase
    return basePrice * priceMultiplier;
  }

  // Profit for farmer (no middleman)
  double getFarmerProfit(double soldQuantity) {
    return calculateDynamicPrice() * soldQuantity;
  }
}

@HiveType(typeId: 2)
class ConsumerOrder {
  @HiveField(0)
  final String orderId;

  @HiveField(1)
  final String consumerId;

  @HiveField(2)
  final String consumerName;

  @HiveField(3)
  final String productId;

  @HiveField(4)
  final String farmerId;

  @HiveField(5)
  final String farmerName;

  @HiveField(6)
  final double quantityKg;

  @HiveField(7)
  final double pricePerKg;

  @HiveField(8)
  final double totalPrice;

  @HiveField(9)
  final DateTime orderDate;

  @HiveField(10)
  final String status; // 'pending', 'confirmed', 'delivered'

  @HiveField(11)
  final String deliveryLocation;

  @HiveField(12)
  final DateTime? estimatedDelivery;

  ConsumerOrder({
    required this.orderId,
    required this.consumerId,
    required this.consumerName,
    required this.productId,
    required this.farmerId,
    required this.farmerName,
    required this.quantityKg,
    required this.pricePerKg,
    required this.totalPrice,
    required this.orderDate,
    required this.status,
    required this.deliveryLocation,
    this.estimatedDelivery,
  });
}

@HiveType(typeId: 3)
class DirectDealTransaction {
  @HiveField(0)
  final String transactionId;

  @HiveField(1)
  final String farmerId;

  @HiveField(2)
  final String farmerName;

  @HiveField(3)
  final String consumerId;

  @HiveField(4)
  final String consumerName;

  @HiveField(5)
  final double productQuantityKg;

  @HiveField(6)
  final double pricePerKg;

  @HiveField(7)
  final double farmerEarnings; // 100% goes to farmer, no commission

  @HiveField(8)
  final DateTime transactionDate;

  @HiveField(9)
  final String paymentMethod; // 'cash', 'bkash', 'nagad', etc.

  @HiveField(10)
  final double commissionSaved; // Middleman commission farmer avoided

  DirectDealTransaction({
    required this.transactionId,
    required this.farmerId,
    required this.farmerName,
    required this.consumerId,
    required this.consumerName,
    required this.productQuantityKg,
    required this.pricePerKg,
    required this.farmerEarnings,
    required this.transactionDate,
    required this.paymentMethod,
    required this.commissionSaved,
  });
}
