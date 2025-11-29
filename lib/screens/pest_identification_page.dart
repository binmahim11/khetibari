// lib/screens/pest_identification_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khetibari/models/pest_identification.dart';
import 'package:khetibari/services/pest_identification_service.dart';

/// Pest Identification Page using Gemini's Visual RAG
/// Allows farmers to upload pest/disease images and get AI-generated treatment plans in Bangla
class PestIdentificationPage extends StatefulWidget {
  final String farmerId;
  final String? defaultCropType;

  const PestIdentificationPage({
    super.key,
    required this.farmerId,
    this.defaultCropType,
  });

  @override
  State<PestIdentificationPage> createState() => _PestIdentificationPageState();
}

class _PestIdentificationPageState extends State<PestIdentificationPage> {
  final _pestService = PestIdentificationService();
  final _imagePicker = ImagePicker();
  
  File? _selectedImage;
  String _selectedCropType = 'ধান'; // Default to Paddy
  bool _isAnalyzing = false;
  PestIdentification? _identificationResult;
  String? _errorMessage;

  /// List of common crops in Bangladesh (in Bangla)
  static const List<String> cropTypes = [
    'ধান',        // Paddy/Rice
    'গম',         // Wheat
    'ভুট্টা',      // Corn/Maize
    'মসুর',        // Lentil
    'শিম',        // Beans/Pulse
    'সবজি',       // Vegetables
    'পেঁয়াজ',      // Onion
    'আলু',        // Potato
    'টমেটো',      // Tomato
    'বেগুন',      // Eggplant
  ];

  /// Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _errorMessage = null;
          _identificationResult = null;
        });
      }
    } catch (e) {
      _showErrorMessage('ছবি নির্বাচনে ত্রুটি: $e');
    }
  }

  /// Capture image from camera
  Future<void> _captureImageFromCamera() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _errorMessage = null;
          _identificationResult = null;
        });
      }
    } catch (e) {
      _showErrorMessage('ক্যামেরা থেকে ছবি নিতে ত্রুটি: $e');
    }
  }

  /// Analyze the selected image using Gemini
  Future<void> _analyzeImage() async {
    if (_selectedImage == null) {
      _showErrorMessage('অনুগ্রহ করে একটি ছবি নির্বাচন করুন');
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
    });

    try {
      final result = await _pestService.identifyPestFromImage(
        imageFile: _selectedImage!,
        farmerId: widget.farmerId,
        cropType: _selectedCropType,
      );

      setState(() {
        _identificationResult = result;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
        _errorMessage = 'পোকা চিহ্নিত করতে ব্যর্থ: $e';
      });
    }
  }

  /// Show error message
  void _showErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('পোকা চিহ্নিতকরণ'),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bug_report, color: Colors.green.shade700, size: 28),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'পোকা ও রোগ সনাক্তকরণ সেবা',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'আপনার ফসলের পোকা বা রোগের ছবি তুলুন এবং কৃত্রিম বুদ্ধিমত্তা দ্বারা চিকিৎসা পরামর্শ পান।',
                      style: TextStyle(color: Colors.black54, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Crop Type Selector
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ফসলের ধরন নির্বাচন করুন',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedCropType,
                      items: cropTypes
                          .map((crop) => DropdownMenuItem(
                            value: crop,
                            child: Text(crop),
                          ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedCropType = value);
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Image Upload Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'পোকা বা ক্ষতির ছবি আপলোড করুন',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Image Preview
                    if (_selectedImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_not_supported,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'কোন ছবি নির্বাচিত নেই',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Image Selection Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isAnalyzing ? null : _pickImageFromGallery,
                            icon: const Icon(Icons.photo_library),
                            label: const Text('গ্যালারি থেকে'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              disabledBackgroundColor: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isAnalyzing ? null : _captureImageFromCamera,
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('ক্যামেরা দিয়ে'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              disabledBackgroundColor: Colors.grey.shade400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Analyze Button
            ElevatedButton.icon(
              onPressed: _isAnalyzing ? null : _analyzeImage,
              icon: _isAnalyzing
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
                  : const Icon(Icons.science),
              label: Text(
                _isAnalyzing ? 'বিশ্লেষণ করা হচ্ছে...' : 'AI দ্বারা বিশ্লেষণ করুন',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                disabledBackgroundColor: Colors.grey.shade400,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 24),

            // Error Message
            if (_errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error, color: Colors.red.shade600),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red.shade600),
                      ),
                    ),
                  ],
                ),
              )
            else if (_identificationResult != null)
              _buildIdentificationResult(_identificationResult!)
            else if (!_isAnalyzing && _selectedImage == null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'শুরু করতে: একটি ফসলের ধরন নির্বাচন করুন এবং একটি ছবি আপলোড করুন, তারপর "বিশ্লেষণ করুন" বোতাম টিপুন।',
                  style: TextStyle(color: Colors.black54, height: 1.6),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build the result display widget
  Widget _buildIdentificationResult(PestIdentification result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Pest Info Card
        Card(
          elevation: 4,
          color: Color(result.riskLevel == PestRiskLevel.high
              ? 0xFFFEEAE6
              : result.riskLevel == PestRiskLevel.medium
                  ? 0xFFFFF8E1
                  : 0xFFF1F8E9),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result.pestNameBangla,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '(${result.pestName})',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Color(result.getRiskColorValue()),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'ঝুঁকি: ${result.getRiskLevelBangla()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  result.description,
                  style: const TextStyle(height: 1.6),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Symptoms
        if (result.symptoms.isNotEmpty) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue.shade600),
                      const SizedBox(width: 8),
                      const Text(
                        'লক্ষণ সমূহ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...result.symptoms.map((symptom) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(fontSize: 18, color: Colors.blue.shade600),
                        ),
                        Expanded(child: Text(symptom)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Action Plan
        Card(
          elevation: 2,
          color: Colors.amber.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.task_alt, color: Colors.amber.shade700),
                    const SizedBox(width: 8),
                    const Text(
                      'চিকিৎসা পরিকল্পনা',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  result.actionPlan,
                  style: const TextStyle(height: 1.7, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Organic Treatments
        if (result.organicTreatments.isNotEmpty) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.eco, color: Colors.green.shade600),
                      const SizedBox(width: 8),
                      const Text(
                        'জৈব চিকিৎসা পদ্ধতি',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...result.organicTreatments.asMap().entries.map((entry) {
                    int idx = entry.key + 1;
                    String treatment = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.green.shade600,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$idx',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(treatment, style: const TextStyle(height: 1.5))),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Preventive Measures
        if (result.preventiveMeasures.isNotEmpty) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shield, color: Colors.purple.shade600),
                      const SizedBox(width: 8),
                      const Text(
                        'প্রতিরোধমূলক ব্যবস্থা',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...result.preventiveMeasures.map((measure) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '✓ ',
                          style: TextStyle(fontSize: 18, color: Colors.purple.shade600),
                        ),
                        Expanded(child: Text(measure)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Save Button
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('ফলাফল সংরক্ষিত হয়েছে')),
            );
          },
          icon: const Icon(Icons.save),
          label: const Text('ফলাফল সংরক্ষণ করুন'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }
}
