// voice_interface_widget.dart
// UI Widget for Bangla Voice and Touchless Gesture Interface

import 'package:flutter/material.dart';
import 'package:khetibari/services/voice_service.dart';
import 'package:khetibari/services/gesture_service.dart';

class VoiceInterfaceWidget extends StatefulWidget {
  final Function(String) onCommandReceived;
  final bool enableGestures;

  const VoiceInterfaceWidget({
    Key? key,
    required this.onCommandReceived,
    this.enableGestures = true,
  }) : super(key: key);

  @override
  State<VoiceInterfaceWidget> createState() => _VoiceInterfaceWidgetState();
}

class _VoiceInterfaceWidgetState extends State<VoiceInterfaceWidget> {
  late VoiceService _voiceService;
  late TouchlessGestureService _gestureService;
  bool _isListening = false;
  String _recognizedText = '';
  String _lastCommand = '';

  @override
  void initState() {
    super.initState();
    _voiceService = VoiceService();
    _gestureService = TouchlessGestureService();
    _initializeVoiceService();
  }

  Future<void> _initializeVoiceService() async {
    final initialized = await _voiceService.initializeSpeechToText();
    if (initialized) {
      final permissionGranted =
          await _voiceService.requestMicrophonePermission();
      if (permissionGranted) {
        if (mounted) {
          setState(() {});
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Microphone permission required for voice commands',
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _startListening() async {
    if (!_isListening) {
      setState(() => _isListening = true);

      await _voiceService.startListening(
        onResult: (result) {
          setState(() => _recognizedText = result);
          _processCommand(result);
        },
        onError: (error) {
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: $error')));
          }
          setState(() => _isListening = false);
        },
      );
    }
  }

  Future<void> _stopListening() async {
    await _voiceService.stopListening();
    setState(() => _isListening = false);
  }

  void _processCommand(String recognizedText) {
    final command = _voiceService.parseBanglaCommand(recognizedText);

    if (command != 'unknown') {
      setState(() => _lastCommand = command);
      widget.onCommandReceived(command);

      // Provide voice feedback
      _voiceService.speakBangla('কমান্ড গ্রহণ করা হয়েছে: $command');
    }
  }

  @override
  void dispose() {
    _voiceService.dispose();
    _gestureService.disableGestureDetection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Voice Control Button
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isListening ? Colors.red.shade100 : Colors.green.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isListening ? Colors.red : Colors.green,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: _isListening ? _stopListening : _startListening,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isListening ? Colors.red : Colors.green,
                  ),
                  child: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _isListening ? 'শুনছি...' : 'কথা বলুন',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _isListening ? Colors.red : Colors.green,
                ),
              ),
              if (_recognizedText.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'আপনি বলেছেন: $_recognizedText',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
              if (_lastCommand.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'কমান্ড: $_lastCommand',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Gesture Help
        if (widget.enableGestures)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'অঙ্গভঙ্গি নিয়ন্ত্রণ (Touchless):',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildGestureInfo('👆 বাম/ডান সোয়াইপ', 'পৃষ্ঠা নেভিগেট করুন'),
                _buildGestureInfo('👆 উপর/নিচ সোয়াইপ', 'স্ক্রোল করুন'),
                _buildGestureInfo('👍 থাম্বস আপ', 'অনুমোদন করুন'),
                _buildGestureInfo('👎 থাম্বস ডাউন', 'বাতিল করুন'),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildGestureInfo(String gesture, String action) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(gesture, style: Theme.of(context).textTheme.bodySmall),
          ),
          Text(
            action,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}
