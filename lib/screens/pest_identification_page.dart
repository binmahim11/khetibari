// lib/screens/pest_identification_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khetibari/models/pest_identification.dart';
import 'package:khetibari/services/pest_identification_service.dart';
import 'package:khetibari/screens/voice_interface_widget.dart';
import 'package:khetibari/utils/animated_farmer_graphics.dart';

/// Pest Identification Page using AI analysis
class PestIdentificationPage extends StatefulWidget {
  final String? farmerId;
  final String? defaultCropType;

  const PestIdentificationPage({
    super.key,
    this.farmerId,
    this.defaultCropType,
  });

  @override
  State<PestIdentificationPage> createState() => _PestIdentificationPageState();
}

class _PestIdentificationPageState extends State<PestIdentificationPage> {
  final ImagePicker _imagePicker = ImagePicker();
  final PestIdentificationService _pestService = PestIdentificationService();

  // UI State
  File? _selectedImage;
  String _selectedCropType = 'ধান'; // Default to rice
  bool _isAnalyzing = false;
  String? _errorMessage;
  PestIdentification? _identificationResult;
  bool _showVoiceInterface = false;

  // Available crop types in Bangla
  final List<String> _cropTypes = [
    'ধান',
    'গম',
    'ভুট্টা',
    'আলু',
    'পেঁয়াজ',
    'রসুন',
    'টমেটো',
    'বেগুন',
    'শাকসবজি',
    'অন্যান্য',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.defaultCropType != null) {
      _selectedCropType = widget.defaultCropType!;
    }
  }

  /// Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
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
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _errorMessage = null;
          _identificationResult = null;
        });
      }
    } catch (e) {
      _showErrorMessage('ক্যামেরা অ্যাক্সেসে ত্রুটি: $e');
    }
  }

  /// Analyze the selected image for pest identification
  Future<void> _analyzeImage() async {
    if (_selectedImage == null) {
      _showErrorMessage('অনুগ্রহ করে প্রথমে একটি ছবি নির্বাচন করুন');
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _errorMessage = null;
    });

    try {
      final result = await _pestService.identifyPestFromImage(
        imageFile: _selectedImage!,
        farmerId: widget.farmerId ?? 'default_farmer',
        cropType: _selectedCropType,
      );

      setState(() {
        _identificationResult = result;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
      _showErrorMessage('বিশ্লেষণে ত্রুটি: $e');
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
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Handle voice commands
  void _handleVoiceCommand(String command) {
    final lowerCommand = command.toLowerCase();

    if (lowerCommand.contains('ক্যামেরা') ||
        lowerCommand.contains('camera') ||
        lowerCommand.contains('ছবি তুলুন')) {
      _captureImageFromCamera();
    } else if (lowerCommand.contains('গ্যালারি') ||
        lowerCommand.contains('gallery') ||
        lowerCommand.contains('ছবি নির্বাচন')) {
      _pickImageFromGallery();
    } else if (lowerCommand.contains('বিশ্লেষণ') ||
        lowerCommand.contains('analyze') ||
        lowerCommand.contains('চেক করুন')) {
      _analyzeImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('কীটপতঙ্গ সনাক্তকরণ'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Animated Farmer Graphic
              Center(
                child: AnimatedFarmerGraphic(
                  type: 'harvest',
                  width: 120,
                  height: 120,
                  animationType: 'slideUp',
                  duration: const Duration(milliseconds: 1000),
                ),
              ),
              const SizedBox(height: 16),

              // Voice Interface Toggle
              if (_showVoiceInterface)
                VoiceInterfaceWidget(
                  onCommandReceived: _handleVoiceCommand,
                  enableGestures: true,
                )
              else
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() => _showVoiceInterface = true);
                    },
                    icon: const Icon(Icons.mic),
                    label: const Text('কণ্ঠস্বর সক্ষম করুন'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Crop Type Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ফসলের ধরন নির্বাচন করুন',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<String>(
                        value: _selectedCropType,
                        isExpanded: true,
                        items:
                            _cropTypes
                                .map(
                                  (crop) => DropdownMenuItem(
                                    value: crop,
                                    child: Text(crop),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCropType = value;
                              _identificationResult = null;
                              _errorMessage = null;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Image Preview Section
              _buildImageSection(isMobile),
              const SizedBox(height: 20),

              // Error Message
              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    border: Border.all(color: Colors.red[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[700]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Analysis Button
              ElevatedButton.icon(
                onPressed: _isAnalyzing ? null : _analyzeImage,
                icon:
                    _isAnalyzing
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                              Colors.white.withOpacity(0.7),
                            ),
                          ),
                        )
                        : const Icon(Icons.science),
                label: Text(
                  _isAnalyzing
                      ? 'বিশ্লেষণ করা হচ্ছে...'
                      : 'AI দ্বারা বিশ্লেষণ করুন',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  disabledBackgroundColor: Colors.grey[400],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 24),

              // Results Section
              if (_identificationResult != null)
                _buildResultsSection(_identificationResult!)
              else if (!_isAnalyzing && _selectedImage == null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 40,
                          color: Colors.blue[400],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'ছবি আপলোড করুন এবং বিশ্লেষণ করুন',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(bool isMobile) {
    return Card(
      child: Column(
        children: [
          if (_selectedImage != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _selectedImage!,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Icon(
                Icons.image_not_supported,
                size: 60,
                color: Colors.grey[400],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _captureImageFromCamera,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('ছবি তুলুন'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: const Icon(Icons.image),
                  label: const Text('গ্যালারি'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsSection(PestIdentification result) {
    final riskColor =
        result.riskLevel == PestRiskLevel.high
            ? Colors.red[100]
            : result.riskLevel == PestRiskLevel.medium
            ? Colors.amber[100]
            : Colors.green[100];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Pest Info Card
        Card(
          color: riskColor,
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                              color: Colors.grey[600],
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
                        color: _getRiskColor(result.riskLevel),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getRiskLevelBangla(result.riskLevel),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(result.description, style: const TextStyle(height: 1.6)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Symptoms
        if (result.symptoms.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: Colors.amber[700],
                        size: 20,
                      ),
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
                  ...result.symptoms.asMap().entries.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            '${e.key + 1}. ',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Text(
                              e.value,
                              style: const TextStyle(height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 12),

        // Treatment Plan
        Card(
          color: Colors.orange[50],
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.medical_services,
                      color: Colors.orange[700],
                      size: 20,
                    ),
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
                Text(result.actionPlan, style: const TextStyle(height: 1.6)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Organic Treatments
        if (result.organicTreatments.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.nature, color: Colors.green[700], size: 20),
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
                  ...result.organicTreatments.map(
                    (treatment) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green[600],
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              treatment,
                              style: const TextStyle(height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 12),

        // Preventive Measures
        if (result.preventiveMeasures.isNotEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shield, color: Colors.blue[700], size: 20),
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
                  ...result.preventiveMeasures.map(
                    (measure) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Text('• ', style: TextStyle(fontSize: 20)),
                          Expanded(
                            child: Text(
                              measure,
                              style: const TextStyle(height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 20),

        // Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _selectedImage = null;
                  _identificationResult = null;
                  _errorMessage = null;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('নতুন বিশ্লেষণ'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('ফলাফল সংরক্ষিত হয়েছে'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.save),
              label: const Text('সংরক্ষণ করুন'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getRiskColor(PestRiskLevel level) {
    switch (level) {
      case PestRiskLevel.high:
        return Colors.red;
      case PestRiskLevel.medium:
        return Colors.amber[700]!;
      case PestRiskLevel.low:
        return Colors.green;
    }
  }

  String _getRiskLevelBangla(PestRiskLevel level) {
    switch (level) {
      case PestRiskLevel.high:
        return 'উচ্চ ঝুঁকি';
      case PestRiskLevel.medium:
        return 'মধ্যম ঝুঁকি';
      case PestRiskLevel.low:
        return 'কম ঝুঁকি';
    }
  }
}
