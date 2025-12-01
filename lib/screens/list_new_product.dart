// lib/screens/list_new_product.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:khetibari/models/marketplace.dart';
import 'package:khetibari/services/marketplace_service.dart';
import 'package:khetibari/providers/language_provider.dart';
import 'package:khetibari/providers/theme_provider.dart';
import 'package:uuid/uuid.dart';

class ListNewProductPage extends StatefulWidget {
  final String farmerId;
  final String farmerName;
  final String? selectedLocation;

  const ListNewProductPage({
    super.key,
    required this.farmerId,
    required this.farmerName,
    this.selectedLocation,
  });

  @override
  State<ListNewProductPage> createState() => _ListNewProductPageState();
}

class _ListNewProductPageState extends State<ListNewProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _marketplaceService = MarketplaceService();
  bool _isLoading = false;

  late final TextEditingController _productNameController;
  late final TextEditingController _cropTypeController;
  late final TextEditingController _quantityController;
  late final TextEditingController _priceController;
  late final TextEditingController _locationController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _productNameController = TextEditingController();
    _cropTypeController = TextEditingController();
    _quantityController = TextEditingController();
    _priceController = TextEditingController();
    _locationController = TextEditingController(
      text: widget.selectedLocation ?? '',
    );
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _cropTypeController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _listProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final product = FarmProduct(
        productId: const Uuid().v4(),
        farmerId: widget.farmerId,
        farmerName: widget.farmerName,
        productName: _productNameController.text,
        cropType: _cropTypeController.text,
        quantityKg: double.parse(_quantityController.text),
        basePrice: double.parse(_priceController.text),
        location: _locationController.text,
        description: _descriptionController.text,
        listedDate: DateTime.now(),
        demandScore: 50, // Start with neutral demand
        isAvailable: true,
      );

      await _marketplaceService.listProduct(product);

      if (mounted) {
        final isBangla = context.read<LanguageProvider>().isBangla;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Translations.get('success', isBangla: isBangla)),
            backgroundColor: Colors.green.shade600,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        final isBangla = context.read<LanguageProvider>().isBangla;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Translations.get('error', isBangla: isBangla)),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBangla = context.watch<LanguageProvider>().isBangla;
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.get('list_product', isBangla: isBangla)),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(
                  labelText: Translations.get(
                    'product_name',
                    isBangla: isBangla,
                  ),
                  hintText:
                      isBangla
                          ? 'যেমন: আম, ধান, গম'
                          : 'e.g., Mango, Rice, Wheat',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.label),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return isBangla
                        ? 'পণ্যের নাম প্রয়োজন'
                        : 'Product name required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Crop Type
              TextFormField(
                controller: _cropTypeController,
                decoration: InputDecoration(
                  labelText: Translations.get('crop_type', isBangla: isBangla),
                  hintText:
                      isBangla
                          ? 'যেমন: ধান, গম, ভুট্টা'
                          : 'e.g., Paddy, Wheat, Maize',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.grain),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return isBangla
                        ? 'ফসলের ধরন প্রয়োজন'
                        : 'Crop type required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Quantity
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: Translations.get(
                    'quantity_kg',
                    isBangla: isBangla,
                  ),
                  hintText: isBangla ? '100 - 1000' : '100 - 1000',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.scale),
                  suffixText: 'kg',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return isBangla ? 'পরিমাণ প্রয়োজন' : 'Quantity required';
                  }
                  if (double.tryParse(value!) == null) {
                    return isBangla
                        ? 'বৈধ সংখ্যা প্রবেশ করুন'
                        : 'Enter valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price per kg
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: Translations.get(
                    'price_per_kg',
                    isBangla: isBangla,
                  ),
                  hintText: '40 - 100',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                  prefixText: '৳ ',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return isBangla ? 'মূল্য প্রয়োজন' : 'Price required';
                  }
                  if (double.tryParse(value!) == null) {
                    return isBangla
                        ? 'বৈধ মূল্য প্রবেশ করুন'
                        : 'Enter valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: Translations.get('location', isBangla: isBangla),
                  hintText:
                      isBangla
                          ? 'যেমন: ঢাকা, চট্টগ্রাম'
                          : 'e.g., Dhaka, Chittagong',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return isBangla ? 'অবস্থান প্রয়োজন' : 'Location required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: Translations.get(
                    'description',
                    isBangla: isBangla,
                  ),
                  hintText:
                      isBangla
                          ? 'আপনার পণ্য সম্পর্কে বিস্তারিত লিখুন'
                          : 'Write details about your product',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return isBangla ? 'বিবরণ প্রয়োজন' : 'Description required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed:
                          _isLoading ? null : () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: Text(
                        Translations.get('cancel', isBangla: isBangla),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                        foregroundColor: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _listProduct,
                      icon:
                          _isLoading
                              ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : const Icon(Icons.check),
                      label: Text(
                        Translations.get('list_now', isBangla: isBangla),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
