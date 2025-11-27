// marketplace_service.dart

import 'package:hive_flutter/hive_flutter.dart';
import 'package:khetibari/models/marketplace.dart';

class MarketplaceService {
  static const String _productsBox = 'farmProducts';
  static const String _ordersBox = 'consumerOrders';
  static const String _transactionsBox = 'directTransactions';

  static Future<void> initialize() async {
    Hive.registerAdapter(FarmProductAdapter());
    Hive.registerAdapter(ConsumerOrderAdapter());
    Hive.registerAdapter(DirectDealTransactionAdapter());

    await Hive.openBox<FarmProduct>(_productsBox);
    await Hive.openBox<ConsumerOrder>(_ordersBox);
    await Hive.openBox<DirectDealTransaction>(_transactionsBox);

    // Add mock products if database is empty
    await _addMockProducts();
  }

  // Add mock products for demo
  static Future<void> _addMockProducts() async {
    final box = Hive.box<FarmProduct>(_productsBox);
    if (box.isEmpty) {
      final mockProducts = [
        FarmProduct(
          productId: 'PROD_001',
          farmerId: 'FARMER_001',
          farmerName: 'রফিকুল ফার্ম',
          productName: 'Premium Paddy',
          cropType: 'Paddy (ধান)',
          quantityKg: 500,
          basePrice: 45.0,
          location: 'Dhaka',
          description: 'High quality paddy from certified farms',
          listedDate: DateTime.now(),
          demandScore: 75,
          isAvailable: true,
        ),
        FarmProduct(
          productId: 'PROD_002',
          farmerId: 'FARMER_002',
          farmerName: 'করিম এগ্রো',
          productName: 'Organic Wheat',
          cropType: 'Wheat (গম)',
          quantityKg: 300,
          basePrice: 55.0,
          location: 'Chittagong',
          description: 'Certified organic wheat without pesticides',
          listedDate: DateTime.now(),
          demandScore: 82,
          isAvailable: true,
        ),
        FarmProduct(
          productId: 'PROD_003',
          farmerId: 'FARMER_003',
          farmerName: 'সালমান ফার্ম',
          productName: 'Fresh Maize',
          cropType: 'Maize (ভুট্টা)',
          quantityKg: 400,
          basePrice: 38.0,
          location: 'Rajshahi',
          description: 'Fresh harvested maize, perfect for grinding',
          listedDate: DateTime.now(),
          demandScore: 65,
          isAvailable: true,
        ),
        FarmProduct(
          productId: 'PROD_004',
          farmerId: 'FARMER_001',
          farmerName: 'রফিকুল ফার্ম',
          productName: 'Rice (Oryza)',
          cropType: 'Rice (চাল)',
          quantityKg: 600,
          basePrice: 52.0,
          location: 'Dhaka',
          description: 'Premium quality rice with excellent aroma',
          listedDate: DateTime.now(),
          demandScore: 88,
          isAvailable: true,
        ),
        FarmProduct(
          productId: 'PROD_005',
          farmerId: 'FARMER_004',
          farmerName: 'আমিন এগ্রি',
          productName: 'Golden Maize',
          cropType: 'Maize (ভুট্টা)',
          quantityKg: 350,
          basePrice: 40.0,
          location: 'Sylhet',
          description: 'High yielding maize variety',
          listedDate: DateTime.now(),
          demandScore: 72,
          isAvailable: true,
        ),
        FarmProduct(
          productId: 'PROD_006',
          farmerId: 'FARMER_005',
          farmerName: 'নাজমুল খামার',
          productName: 'Premium Paddy',
          cropType: 'Paddy (ধান)',
          quantityKg: 750,
          basePrice: 48.0,
          location: 'Khulna',
          description: 'Salt tolerant paddy from coastal farms',
          listedDate: DateTime.now(),
          demandScore: 78,
          isAvailable: true,
        ),
      ];

      for (var product in mockProducts) {
        await box.put(product.productId, product);
      }
      print('✅ Mock products added to marketplace');
    }

    // Add mock transactions for demo
    final transBox = Hive.box<DirectDealTransaction>(_transactionsBox);
    if (transBox.isEmpty) {
      final mockTransactions = [
        DirectDealTransaction(
          transactionId: 'TXN_001',
          farmerId: 'FARMER_001',
          farmerName: 'রফিকুল ফার্ম',
          consumerId: 'CONSUMER_001',
          consumerName: 'রহিম বাজার',
          productQuantityKg: 100,
          pricePerKg: 45.0,
          farmerEarnings: 4500.0,
          transactionDate: DateTime.now().subtract(Duration(days: 5)),
          paymentMethod: 'bKash',
          commissionSaved: 900.0, // 20% commission saved
        ),
        DirectDealTransaction(
          transactionId: 'TXN_002',
          farmerId: 'FARMER_001',
          farmerName: 'রফিকুল ফার্ম',
          consumerId: 'CONSUMER_002',
          consumerName: 'করিম সবজি দোকান',
          productQuantityKg: 150,
          pricePerKg: 52.0,
          farmerEarnings: 7800.0,
          transactionDate: DateTime.now().subtract(Duration(days: 3)),
          paymentMethod: 'Cash',
          commissionSaved: 1560.0,
        ),
        DirectDealTransaction(
          transactionId: 'TXN_003',
          farmerId: 'FARMER_001',
          farmerName: 'রফিকুল ফার্ম',
          consumerId: 'CONSUMER_003',
          consumerName: 'সালিম রেস্তোরাঁ',
          productQuantityKg: 200,
          pricePerKg: 48.0,
          farmerEarnings: 9600.0,
          transactionDate: DateTime.now().subtract(Duration(days: 1)),
          paymentMethod: 'Nagad',
          commissionSaved: 1920.0,
        ),
      ];

      for (var transaction in mockTransactions) {
        await transBox.put(transaction.transactionId, transaction);
      }
      print('✅ Mock transactions added for dashboard');
    }
  }

  // List product directly to consumers
  Future<void> listProduct(FarmProduct product) async {
    final box = Hive.box<FarmProduct>(_productsBox);
    await box.put(product.productId, product);
    print('Product ${product.productName} listed for direct sales');
  }

  // Get all available products
  List<FarmProduct> getAllAvailableProducts() {
    final box = Hive.box<FarmProduct>(_productsBox);
    return box.values.where((p) => p.isAvailable).toList();
  }

  // Get products by farmer
  List<FarmProduct> getProductsByFarmer(String farmerId) {
    final box = Hive.box<FarmProduct>(_productsBox);
    return box.values.where((p) => p.farmerId == farmerId).toList();
  }

  // Get products by location (for local consumer discovery)
  List<FarmProduct> getProductsByLocation(String location) {
    final box = Hive.box<FarmProduct>(_productsBox);
    return box.values
        .where((p) => p.location == location && p.isAvailable)
        .toList();
  }

  // Create direct order (consumer buys from farmer)
  Future<void> createDirectOrder(ConsumerOrder order) async {
    final box = Hive.box<ConsumerOrder>(_ordersBox);
    await box.put(order.orderId, order);

    // Update product demand score
    _updateProductDemand(order.productId);

    print(
      'Direct order created: ${order.orderId} - Farmer earns ${order.totalPrice}',
    );
  }

  // Record direct transaction (farmer-consumer deal)
  Future<void> recordDirectTransaction(
    DirectDealTransaction transaction,
  ) async {
    final box = Hive.box<DirectDealTransaction>(_transactionsBox);
    await box.put(transaction.transactionId, transaction);
    print('Direct deal recorded: Farmer saved ৳${transaction.commissionSaved}');
  }

  // Get farmer's earnings (no middleman cut)
  double getFarmerTotalEarnings(String farmerId) {
    final transactionsBox = Hive.box<DirectDealTransaction>(_transactionsBox);
    return transactionsBox.values
        .where((t) => t.farmerId == farmerId)
        .fold(0.0, (sum, t) => sum + t.farmerEarnings);
  }

  // Get commission farmer saved
  double getTotalCommissionSaved(String farmerId) {
    final transactionsBox = Hive.box<DirectDealTransaction>(_transactionsBox);
    return transactionsBox.values
        .where((t) => t.farmerId == farmerId)
        .fold(0.0, (sum, t) => sum + t.commissionSaved);
  }

  // Get consumer's order history
  List<ConsumerOrder> getConsumerOrders(String consumerId) {
    final box = Hive.box<ConsumerOrder>(_ordersBox);
    return box.values.where((o) => o.consumerId == consumerId).toList();
  }

  // Update product demand score based on interest
  void _updateProductDemand(String productId) {
    final box = Hive.box<FarmProduct>(_productsBox);
    if (box.containsKey(productId)) {
      final product = box.get(productId)!;
      final updatedProduct = FarmProduct(
        productId: product.productId,
        farmerId: product.farmerId,
        farmerName: product.farmerName,
        productName: product.productName,
        cropType: product.cropType,
        quantityKg: product.quantityKg,
        basePrice: product.basePrice,
        location: product.location,
        description: product.description,
        listedDate: product.listedDate,
        demandScore: (product.demandScore + 5).clamp(0, 100),
        isAvailable: product.isAvailable,
      );
      box.put(productId, updatedProduct);
    }
  }

  // Search products by name
  List<FarmProduct> searchProducts(String query) {
    final box = Hive.box<FarmProduct>(_productsBox);
    return box.values
        .where(
          (p) =>
              p.productName.toLowerCase().contains(query.toLowerCase()) ||
              p.cropType.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
