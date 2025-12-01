// marketplace_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:khetibari/models/marketplace.dart';
import 'package:khetibari/services/marketplace_service.dart';
import 'package:khetibari/utils/animations.dart';
import 'package:khetibari/screens/voice_interface_widget.dart';
import 'package:khetibari/utils/animated_farmer_graphics.dart';
import 'package:khetibari/providers/language_provider.dart';
import 'package:khetibari/providers/theme_provider.dart';

class MarketplacePage extends StatefulWidget {
  final String? selectedLocation;

  const MarketplacePage({super.key, this.selectedLocation});

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final _marketplaceService = MarketplaceService();
  final _searchController = TextEditingController();
  late List<FarmProduct> products;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    if (widget.selectedLocation != null) {
      products = _marketplaceService.getProductsByLocation(
        widget.selectedLocation!,
      );
    } else {
      products = _marketplaceService.getAllAvailableProducts();
    }
    setState(() {});
  }

  void _searchProducts(String query) {
    if (query.isEmpty) {
      _loadProducts();
    } else {
      products = _marketplaceService.searchProducts(query);
      setState(() {});
    }
  }

  /// Handle voice commands from VoiceInterfaceWidget
  void _handleVoiceCommand(String command) {
    final lowerCommand = command.toLowerCase();

    if (lowerCommand.contains('সব') || lowerCommand.contains('পণ্য')) {
      _loadProducts();
    } else if (lowerCommand.contains('খুঁজ') ||
        lowerCommand.contains('সার্চ')) {
      // Would need more speech context to search
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('পণ্য খুঁজতে কী খুঁজছেন তা বলুন')),
      );
    } else if (lowerCommand.contains('হোম') || lowerCommand.contains('বাড়ি')) {
      Navigator.pop(context);
    } else if (lowerCommand.contains('সাফল্য') ||
        lowerCommand.contains('ঠিক আছে')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('আপনার কমান্ড বোঝা হয়েছে ✓')),
      );
    } else {
      // Try to search for the command text as a product
      _searchProducts(command);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBangla = context.watch<LanguageProvider>().isBangla;
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.get('marketplace', isBangla: isBangla)),
        backgroundColor: Colors.black,
        elevation: 2,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22,
          letterSpacing: 0.5,
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 28),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: isBangla ? 'English' : 'বাংলা',
            onPressed: () async {
              await context.read<LanguageProvider>().toggleLanguage();
            },
          ),
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: isDark ? 'Light Mode' : 'Dark Mode',
            onPressed: () async {
              await context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Animated Farmer/Land Graphic
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: AnimatedFarmerGraphic(
              type: 'land_pattern',
              width: 140,
              height: 100,
              animationType: 'fadeIn',
              duration: const Duration(milliseconds: 1000),
            ),
          ),

          // Voice Interface Widget
          VoiceInterfaceWidget(onCommandReceived: _handleVoiceCommand),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchProducts,
              decoration: InputDecoration(
                hintText:
                    isBangla ? 'পণ্য খুঁজুন...' : 'Search products, crops...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _loadProducts();
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // Product List
          Expanded(
            child:
                products.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            size: 64,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No products available',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return SlideInAnimation(
                          beginOffset: Offset(
                            0,
                            0.3 * (index % 3 + 1).toDouble(),
                          ),
                          duration: Duration(
                            milliseconds: 400 + (index * 100).clamp(0, 600),
                          ),
                          child: _buildProductCard(product),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(FarmProduct product) {
    final dynamicPrice = product.calculateDynamicPrice();
    final priceIncrease =
        ((dynamicPrice - product.basePrice) / product.basePrice * 100);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showProductDetails(product),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.productName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'By: ${product.farmerName}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (priceIncrease > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '+${priceIncrease.toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                // Details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quantity',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${product.quantityKg.toStringAsFixed(1)} kg',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          product.location,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Demand',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${product.demandScore}/100',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                product.demandScore > 70
                                    ? Colors.green
                                    : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price per kg',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '৳${dynamicPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (product.basePrice != dynamicPrice)
                              Text(
                                '৳${product.basePrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey.shade500,
                                  fontSize: 12,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => _showOrderDialog(product),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                      ),
                      child: const Text('Order Now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showProductDetails(FarmProduct product) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(product.productName),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _infoRow('Farmer', product.farmerName),
                  _infoRow('Crop Type', product.cropType),
                  _infoRow('Quantity', '${product.quantityKg} kg'),
                  _infoRow('Location', product.location),
                  _infoRow('Base Price', '৳${product.basePrice}/kg'),
                  _infoRow(
                    'Current Price',
                    '৳${product.calculateDynamicPrice()}/kg',
                  ),
                  _infoRow('Demand Score', '${product.demandScore}/100'),
                  const SizedBox(height: 12),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(product.description),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showOrderDialog(product);
                },
                child: const Text('Order'),
              ),
            ],
          ),
    );
  }

  void _showOrderDialog(FarmProduct product) {
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Place Order'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Product: ${product.productName}'),
                Text('Price: ৳${product.calculateDynamicPrice()}/kg'),
                const SizedBox(height: 16),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity (kg)',
                    hintText: 'Enter quantity',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order placed successfully!')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Place Order'),
              ),
            ],
          ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}
