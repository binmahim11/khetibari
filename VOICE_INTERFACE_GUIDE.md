# Bangla Voice & Touchless Interface Implementation Guide

## Overview
This implementation provides a complete Bangla voice and touchless gesture interface for the Khetibari app, enabling farmers to interact with the application hands-free using voice commands in Bengali and gesture recognition.

## Features

### 1. **Bangla Voice Recognition (STT)**
- Real-time speech-to-text in Bangla (bn_BD)
- Automatic command parsing and execution
- Error handling and feedback

### 2. **Text-to-Speech (TTS)**
- Audio feedback in Bangla
- Command confirmation
- Status notifications

### 3. **Touchless Gesture Recognition**
- Swipe gestures (left, right, up, down)
- Hand gestures (thumbs up/down, pointing, etc.)
- Camera-based detection support

### 4. **Command Interpreter**
- 20+ predefined Bangla commands
- Smart command matching
- Contextual command execution

---

## Files Created

### Core Services

#### 1. `lib/services/voice_service.dart`
**Main voice service managing speech recognition and TTS**

```dart
VoiceService vservice = VoiceService();

// Initialize
await vservice.initializeSpeechToText();
await vservice.requestMicrophonePermission();

// Start listening
await vservice.startListening(
  onResult: (result) => print('Recognized: $result'),
  onError: (error) => print('Error: $error'),
);

// Stop listening
await vservice.stopListening();

// Parse Bangla command
String command = vservice.parseBanglaCommand('ড্যাশবোর্ড');  // Returns 'home'

// Text to speech
await vservice.speakBangla('আপনার কমান্ড স্বীকার করা হয়েছে');
```

**Supported Bangla Commands:**
- Navigation: ড্যাশবোর্ড, মার্কেটপ্লেস, ফসল, কীটপতঙ্গ, ঝুঁকি, আবহাওয়া, লগআউট
- Actions: সংরক্ষণ, সাবমিট, বাতিল, মুছে, শোনান

#### 2. `lib/services/gesture_service.dart`
**Manages touchless gesture recognition**

```dart
TouchlessGestureService gservice = TouchlessGestureService();

// Enable gesture detection
gservice.enableGestureDetection((gesture) {
  print('Detected: $gesture');
});

// Available gestures
List<GestureCommand> gestures = gservice.getAllGestures();

// Get Bangla name
String name = gservice.getBanglaGestureName('thumb_up');  // "থাম্বস আপ"
```

**Supported Gestures:**
- `swipe_right`: ডান দিকে নেভিগেট করুন
- `swipe_left`: বাম দিকে নেভিগেট করুন
- `swipe_up`: উপরে স্ক্রোল করুন
- `swipe_down`: নিচে স্ক্রোল করুন
- `thumb_up`: অনুমোদন / হ্যাঁ
- `thumb_down`: অস্বীকার / না
- `open_palm`: থামান
- `fist`: বন্ধ করুন
- `peace_sign`: সাহায্য / মেনু
- `pointing`: নির্বাচন করুন

### UI Components

#### 1. `lib/screens/voice_interface_widget.dart`
**Reusable widget for voice interface**

```dart
VoiceInterfaceWidget(
  onCommandReceived: (command) {
    print('Command: $command');
  },
  enableGestures: true,
)
```

**Features:**
- Large mic button for visibility
- Real-time text display
- Command feedback
- Gesture hint display
- Responsive design

#### 2. `lib/screens/voice_commands_page.dart`
**Reference page showing all commands and gestures**

Navigate to this page to help users learn available commands.

#### 3. `lib/screens/voice_interface_integration_example.dart`
**Complete integration example**

Shows how to integrate voice interface into existing screens with command handling.

---

## Integration Steps

### Step 1: Update pubspec.yaml
✅ Already done with these dependencies:
```yaml
speech_to_text: ^6.4.0
flutter_tts: ^4.2.3
permission_handler: ^11.1.0
```

### Step 2: Add to HomePage
```dart
import 'package:khetibari/screens/voice_interface_widget.dart';

// In your HomePage widget
Column(
  children: [
    // Your existing content
    VoiceInterfaceWidget(
      onCommandReceived: (command) => handleCommand(command),
      enableGestures: true,
    ),
  ],
)
```

### Step 3: Implement Command Handler
```dart
void handleCommand(String command) {
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
    // ... more cases
  }
}
```

### Step 4: Add to Screens (Optional)
Add to crop_batch_page.dart, pest_identification_page.dart, etc.

---

## Platform Configuration

### Android (`android/app/build.gradle`)
```gradle
android {
    compileSdkVersion 33
}
```

### Android Manifest (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.MICROPHONE" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS Info.plist
```xml
<key>NSMicrophoneUsageDescription</key>
<string>এই অ্যাপটি আপনার মাইক ব্যবহার করে ভয়েস কমান্ড স্বীকার করতে।</string>
```

---

## Usage Examples

### Example 1: Basic Integration
```dart
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _handleCommand(String command) {
    switch(command) {
      case 'marketplace':
        Navigator.pushNamed(context, '/marketplace');
        break;
      case 'crop_batch':
        Navigator.pushNamed(context, '/crop_batch');
        break;
      // ... more commands
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('কৃষি সহায়ক')),
      body: Column(
        children: [
          VoiceInterfaceWidget(
            onCommandReceived: _handleCommand,
            enableGestures: true,
          ),
          // Rest of your content
        ],
      ),
    );
  }
}
```

### Example 2: Custom Command Processing
```dart
VoiceInterfaceWidget(
  onCommandReceived: (command) {
    if (command == 'read_aloud') {
      VoiceService().speakBangla('এখন আমি আপনাকে তথ্য পড়ে শুনাচ্ছি...');
    } else if (command == 'save') {
      _saveData();
      VoiceService().speakBangla('ডেটা সংরক্ষণ করা হয়েছে।');
    }
  },
)
```

### Example 3: Form Submission with Voice
```dart
// In a form widget
ElevatedButton(
  onPressed: () => _submitForm(),
  child: Text('জমা দিন'),
),

// Also listen to voice commands
void _submitForm() {
  // Form submission logic
  VoiceService().speakBangla('আপনার ফর্ম জমা দেওয়া হয়েছে।');
}
```

---

## Bangla Voice Commands Reference

### Navigation Commands
| Bangla | English | Action |
|--------|---------|--------|
| ড্যাশবোর্ড | Dashboard | Go to home page |
| মার্কেটপ্লেস | Marketplace | Open marketplace |
| ফসল নিবন্ধন | Crop Registration | Register new crop |
| কীটপতঙ্গ সনাক্ত | Pest Identification | Open pest scanner |
| ঝুঁকি মানচিত্র | Risk Map | View risk map |
| আবহাওয়া | Weather | Check weather forecast |

### Action Commands
| Bangla | English | Action |
|--------|---------|--------|
| সংরক্ষণ | Save | Save current form |
| সাবমিট | Submit | Submit form |
| বাতিল | Cancel | Cancel operation |
| মুছে ফেলুন | Delete | Delete item |
| শোনান | Read Aloud | Read text aloud |

---

## Accessibility Features

✅ **For visually impaired farmers:**
- Audio-only interface
- Voice feedback on every action
- Large touch targets
- High contrast display

✅ **For illiterate farmers:**
- Voice commands (no reading required)
- Audio instructions
- Visual icons with symbols
- Simple gesture interactions

✅ **For physically challenged:**
- Touchless gesture control
- No need to tap screen
- Hands-free operation
- Camera-based detection

---

## Testing

### Test Voice Recognition
```dart
void testVoiceRecognition() async {
  VoiceService service = VoiceService();
  await service.initializeSpeechToText();
  
  // Test with Bangla text
  String command = service.parseBanglaCommand('ড্যাশবোর্ড যান');
  assert(command == 'home');
  
  String command2 = service.parseBanglaCommand('মার্কেটপ্লেস খুলুন');
  assert(command2 == 'marketplace');
}
```

### Test TTS
```dart
void testTextToSpeech() async {
  VoiceService service = VoiceService();
  await service.speakBangla('আপনার কমান্ড স্বীকার করা হয়েছে।');
}
```

---

## Troubleshooting

### Issue: Microphone not working
**Solution:**
1. Check AndroidManifest.xml has permission
2. Request runtime permission
3. Check microphone is enabled on device

### Issue: Bangla text not recognized
**Solution:**
1. Ensure microphone picks up clear audio
2. Reduce background noise
3. Speak clearly and slowly
4. Check internet connection (for cloud-based recognition)

### Issue: TTS voice not playing
**Solution:**
1. Check device volume
2. Verify Bangla language pack is installed
3. Check device speaker settings

---

## Performance Optimization

1. **Voice Recognition:**
   - Cache initialized instance
   - Reuse VoiceService singleton
   - Minimize network calls

2. **TTS:**
   - Pre-buffer common phrases
   - Use shorter messages
   - Cache compiled speech

3. **Gestures:**
   - Implement debouncing
   - Use efficient detection algorithms
   - Limit recognition frequency

---

## Future Enhancements

- [ ] Hand gesture recognition via camera
- [ ] Advanced NLP for complex commands
- [ ] Multi-language support
- [ ] Custom voice profiles
- [ ] Offline speech recognition
- [ ] Real-time translation
- [ ] Advanced gesture library
- [ ] Contextual command suggestions

---

## References

- [speech_to_text Documentation](https://pub.dev/packages/speech_to_text)
- [flutter_tts Documentation](https://pub.dev/packages/flutter_tts)
- [permission_handler Documentation](https://pub.dev/packages/permission_handler)

---

## Support

For issues or questions about the voice interface implementation, refer to:
1. Voice Command Reference Page (in-app)
2. Integration Example Screen
3. Service documentation in code comments
