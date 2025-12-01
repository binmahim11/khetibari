// VOICE_INTERFACE_QUICK_REFERENCE.dart
// Quick implementation guide for developers

// ========================================
// 1. IMPORT REQUIRED SERVICES
// ========================================

// import 'package:khetibari/services/voice_service.dart';
// import 'package:khetibari/services/gesture_service.dart';
// import 'package:khetibari/screens/voice_interface_widget.dart';

// ========================================
// 2. ADD TO PUBSPEC.YAML (✓ Already Done)
// ========================================
//
// speech_to_text: ^6.4.0
// flutter_tts: ^4.2.3
// permission_handler: ^11.1.0

// ========================================
// 3. MINIMAL INTEGRATION (Copy-Paste Ready)
// ========================================
/*

class MyHomeScreen extends StatefulWidget {
  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  
  void _handleVoiceCommand(String command) {
    print('Command received: $command');
    
    switch(command) {
      case 'home':
        Navigator.pushNamed(context, '/home');
        break;
      case 'marketplace':
        Navigator.pushNamed(context, '/marketplace');
        break;
      case 'crop_batch':
        Navigator.pushNamed(context, '/crop_batch');
        break;
      case 'pest_identification':
        Navigator.pushNamed(context, '/pest_identification');
        break;
      case 'risk_map':
        Navigator.pushNamed(context, '/risk_map');
        break;
      case 'save':
        // Execute save action
        break;
      case 'submit':
        // Execute submit action
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unknown command: $command')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('আমার ড্যাশবোর্ড')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ADD THIS WIDGET
            VoiceInterfaceWidget(
              onCommandReceived: _handleVoiceCommand,
              enableGestures: true,
            ),
            
            // Your other widgets...
          ],
        ),
      ),
    );
  }
}
*/

// ========================================
// 4. VOICE SERVICE USAGE
// ========================================

/*
// Initialize
VoiceService voiceService = VoiceService();

// Start listening
await voiceService.initializeSpeechToText();
await voiceService.requestMicrophonePermission();

await voiceService.startListening(
  onResult: (recognizedText) {
    print('Heard: $recognizedText');
  },
  onError: (error) {
    print('Error: $error');
  },
);

// Stop listening
await voiceService.stopListening();

// Parse Bangla command
String command = voiceService.parseBanglaCommand('মার্কেটপ্লেস খুলুন');
// Returns: 'marketplace'

// Speak response
await voiceService.speakBangla('আপনার কমান্ড স্বীকার করা হয়েছে।');

// Cleanup
await voiceService.dispose();
*/

// ========================================
// 5. GESTURE SERVICE USAGE
// ========================================

/*
TouchlessGestureService gestureService = TouchlessGestureService();

// Enable gesture detection
gestureService.enableGestureDetection((gesture) {
  print('Gesture detected: $gesture');
  
  // Handle different gestures
  switch(gesture) {
    case 'swipe_right':
      // Go to next page
      break;
    case 'swipe_left':
      // Go to previous page
      break;
    case 'thumb_up':
      // Approve/Accept
      break;
    case 'thumb_down':
      // Reject/Decline
      break;
  }
});

// Get available gestures
List<GestureCommand> allGestures = gestureService.getAllGestures();

// Get Bangla name
String banglaName = gestureService.getBanglaGestureName('thumb_up');
// Returns: "থাম্বস আপ"

// Disable when done
gestureService.disableGestureDetection();
*/

// ========================================
// 6. SUPPORTED BANGLA COMMANDS
// ========================================

// NAVIGATION COMMANDS
const Map<String, String> BANGLA_COMMANDS = {
  'ড্যাশবোর্ড': 'home',
  'হোম': 'home',
  'বাজার': 'marketplace',
  'মার্কেটপ্লেস': 'marketplace',
  'ফসল': 'crop_batch',
  'ব্যাচ': 'crop_batch',
  'নিবন্ধন': 'crop_batch',
  'রেজিস্টার': 'crop_batch',
  'কীটপতঙ্গ': 'pest_identification',
  'সনাক্ত': 'pest_identification',
  'স্ক্যানার': 'pest_identification',
  'ঝুঁকি': 'risk_map',
  'মানচিত্র': 'risk_map',
  'ম্যাপ': 'risk_map',
  'আবহাওয়া': 'weather',
  'পূর্বাভাস': 'weather',
  'তাপমাত্রা': 'weather',
  'লগআউট': 'logout',
  'বাইরে': 'logout',
  'প্রস্থান': 'logout',

  // ACTION COMMANDS
  'সংরক্ষণ': 'save',
  'সংরক্ষণ করুন': 'save',
  'সাভ': 'save',
  'সাবমিট': 'submit',
  'প্রেরণ': 'submit',
  'বাতিল': 'cancel',
  'ফিরে যান': 'cancel',
  'মুছে': 'delete',
  'মুছে ফেলুন': 'delete',
  'শোনান': 'read_aloud',
  'পড়ুন': 'read_aloud',
  'আমাকে বলুন': 'read_aloud',
};

// ========================================
// 7. SUPPORTED GESTURES
// ========================================

const Map<String, String> GESTURES = {
  'swipe_right': 'পরবর্তী পৃষ্ঠা → সোয়াইপ ডান',
  'swipe_left': 'আগের পৃষ্ঠা ← সোয়াইপ বাম',
  'swipe_up': 'উপরে স্ক্রোল ↑ সোয়াইপ উপর',
  'swipe_down': 'নিচে স্ক্রোল ↓ সোয়াইপ নিচ',
  'thumb_up': 'অনুমোদন / হ্যাঁ 👍',
  'thumb_down': 'অস্বীকার / না 👎',
  'open_palm': 'থামান / পজ 🖐️',
  'fist': 'বন্ধ / পিছনে ✊',
  'peace_sign': 'সাহায্য / মেনু ✌️',
  'pointing': 'নির্বাচন / ট্যাপ 👆',
};

// ========================================
// 8. DEPLOYMENT CHECKLIST
// ========================================

/*
Android:
- [ ] AndroidManifest.xml has MICROPHONE permission
- [ ] compileSdkVersion >= 31
- [ ] Tested on actual device

iOS:
- [ ] Info.plist has NSMicrophoneUsageDescription
- [ ] Deployment target >= iOS 11
- [ ] Speech recognition framework linked

Both:
- [ ] All commands tested
- [ ] Error messages localized
- [ ] Performance optimized
- [ ] No memory leaks
*/
