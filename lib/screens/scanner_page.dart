// scanner_page.dart

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:khetibari/utils/constants.dart';
import 'dart:math';

class ScannerPage extends StatefulWidget {
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final ImagePicker _picker = ImagePicker();
  String _result = Constants.getTranslation('capture_btn');
  bool _isScanning = false;

  // A5 Mock TFLite Inference function
  Future<String> _runInference(XFile image) async {
    // In actual implementation, TFLite model inference code goes here.
    await Future.delayed(Duration(seconds: 3));
    
    if (Random().nextBool()) {
      return "ফলাফল: তাজা ফসল (Fresh Crop) - ৯২% নিশ্চিত";
    } else {
      return "ফলাফল: নষ্টের সম্ভাবনা (Possible Spoilage) - ৮৫% নিশ্চিত";
    }
  }

  Future<void> _pickImageAndScan() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _isScanning = true;
        _result = 'স্ক্যান করা হচ্ছে... অনুগ্রহ করে অপেক্ষা করুন।';
      });
      try {
        String inferenceResult = await _runInference(image);
        setState(() {
          _result = inferenceResult;
          _isScanning = false;
        });
      } catch (e) {
        setState(() {
          _result = 'স্ক্যানিং ব্যর্থ: ${e.toString()}';
          _isScanning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Constants.getTranslation('scanner_title'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 80, color: Colors.grey.shade400),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                _result,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50),
            _isScanning
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _pickImageAndScan,
                    child: Text(Constants.getTranslation('capture_btn')),
                  ),
          ],
        ),
      ),
    );
  }
}