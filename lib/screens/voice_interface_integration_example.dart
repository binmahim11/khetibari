// voice_interface_integration_example.dart
// Example showing how to integrate voice interface into existing screens

import 'package:flutter/material.dart';
import 'package:khetibari/screens/voice_interface_widget.dart';

class VoiceInterfaceIntegrationExample extends StatefulWidget {
  const VoiceInterfaceIntegrationExample({Key? key}) : super(key: key);

  @override
  State<VoiceInterfaceIntegrationExample> createState() =>
      _VoiceInterfaceIntegrationExampleState();
}

class _VoiceInterfaceIntegrationExampleState
    extends State<VoiceInterfaceIntegrationExample> {
  String _lastCommand = 'None';

  void _handleVoiceCommand(String command) {
    setState(() => _lastCommand = command);

    // Execute the command
    _executeCommand(command);
  }

  void _executeCommand(String command) {
    switch (command) {
      case 'home':
        _showMessage('হোম পেজে যাচ্ছি...');
        // Navigate to home
        break;
      case 'marketplace':
        _showMessage('মার্কেটপ্লেসে যাচ্ছি...');
        // Navigate to marketplace
        break;
      case 'crop_batch':
        _showMessage('ফসল নিবন্ধন পৃষ্ঠায় যাচ্ছি...');
        // Navigate to crop batch
        break;
      case 'pest_identification':
        _showMessage('কীটপতঙ্গ সনাক্তকরণে যাচ্ছি...');
        // Navigate to pest identification
        break;
      case 'risk_map':
        _showMessage('ঝুঁকি মানচিত্র খুলছি...');
        // Navigate to risk map
        break;
      case 'weather':
        _showMessage('আবহাওয়া পূর্বাভাস খুলছি...');
        // Navigate to weather
        break;
      case 'save':
        _showMessage('সংরক্ষণ করা হচ্ছে...');
        // Save action
        break;
      case 'submit':
        _showMessage('জমা দেওয়া হচ্ছে...');
        // Submit action
        break;
      case 'cancel':
        _showMessage('বাতিল করছি...');
        // Cancel action
        break;
      case 'logout':
        _showMessage('লগআউট করছি...');
        // Logout action
        break;
      default:
        _showMessage('অজানা কমান্ড: $command');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ভয়েস ইন্টারফেস ইন্টিগ্রেশন উদাহরণ'),
        backgroundColor: Colors.green.shade700,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Voice Interface Widget
            VoiceInterfaceWidget(
              onCommandReceived: _handleVoiceCommand,
              enableGestures: true,
            ),

            const SizedBox(height: 24),

            // Status Display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'সর্বশেষ কমান্ড',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _lastCommand,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'কীভাবে ব্যবহার করবেন',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInstructionStep('1', 'মাইক বাটনে ট্যাপ করুন'),
                  _buildInstructionStep(
                    '2',
                    'বাংলায় কমান্ড বলুন (যেমন "ড্যাশবোর্ড", "মার্কেটপ্লেস")',
                  ),
                  _buildInstructionStep(
                    '3',
                    'অ্যাপ কমান্ড স্বীকার করবে এবং বাস্তবায়ন করবে',
                  ),
                  _buildInstructionStep(
                    '4',
                    'জেসচার ব্যবহার করুন ট্যাচ ছাড়াই নেভিগেট করতে',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Features List
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'উপলব্ধ বৈশিষ্ট্য',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildFeature('🎤 বাংলা ভয়েস স্বীকৃতি'),
                  _buildFeature('🔊 টেক্সট-টু-স্পিচ (বাংলায় প্রতিক্রিয়া)'),
                  _buildFeature('👐 স্পর্শমুক্ত অঙ্গভঙ্গি সমর্থন'),
                  _buildFeature('📍 স্বয়ংক্রিয় কমান্ড বাস্তবায়ন'),
                  _buildFeature('♿ অ্যাক্সেসযোগ্যতার জন্য ডিজাইন করা'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade700,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Text('✓', style: TextStyle(color: Colors.green, fontSize: 18)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(feature, style: Theme.of(context).textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
