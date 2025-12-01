<!-- iOS_CONFIGURATION_FOR_VOICE.md -->
# iOS Configuration for Voice Interface

## Required Info.plist Entries

### Update `ios/Runner/Info.plist`

Add the following key-value pairs:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Required for microphone access -->
    <key>NSMicrophoneUsageDescription</key>
    <string>এই অ্যাপটি আপনার মাইক ব্যবহার করে ভয়েস কমান্ড এবং কৃষি পরামর্শ শোনার জন্য।</string>
    
    <!-- Required for speech recognition -->
    <key>NSSpeechRecognitionUsageDescription</key>
    <string>আমরা আপনার ভয়েস ইনপুট স্বীকার করতে স্পিচ রিকগনিশন ব্যবহার করি।</string>
    
    <!-- Optional but recommended -->
    <key>NSLocalNetworkUsageDescription</key>
    <string>এই অ্যাপটি স্থানীয় নেটওয়ার্ক অ্যাক্সেস করতে পারে।</string>
    
    <key>NSBonjourServiceTypes</key>
    <array>
        <string>_services._dns-sd._udp</string>
    </array>
    
    <!-- Your other existing Info.plist entries -->
</dict>
</plist>
```

## Podfile Configuration

### Update `ios/Podfile`

Ensure minimum deployment target:

```ruby
platform :ios, '11.0'  # Minimum for speech_to_text

target 'Runner' do
  flutter_root = File.expand_path(File.join(packages_dir, '..')).gsub(/[^0-9a-zA-Z_-]/, '\\\\\0')
  load File.join(flutter_root, '.ios', 'Flutter', 'podhelper.rb')

  flutter_ios_podfile_setup

  # Add specific pod configurations if needed
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      # Speech Recognition framework
      if target.name == 'speech_to_text'
        target.build_configurations.each do |config|
          config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
            '$(inherited)',
          ]
        end
      end
    end
  end
end
```

### Run pod install

```bash
cd ios
pod install --repo-update
cd ..
```

## Build Settings

### Xcode Configuration

1. Open `ios/Runner.xcworkspace` (NOT .xcodeproj)
2. Select "Runner" target
3. Go to "Build Settings"
4. Search for "Minimum Deployments"
5. Set to iOS 11.0 or higher

### Signing & Capabilities

1. Select "Runner" target
2. Go to "Signing & Capabilities"
3. Click "+ Capability"
4. Add: "Microphone"
5. Add: "Speech Recognition" (if available)

## Framework Linking

Ensure these frameworks are linked:

```
AVFoundation.framework
Speech.framework
CoreAudio.framework
AudioToolbox.framework
```

### Verify in Xcode:
1. Select "Runner" target
2. Go to "Build Phases"
3. Expand "Link Binary with Libraries"
4. Verify frameworks listed above are present

## Build Configuration

### Debug Configuration (in Xcode)

```
Product > Scheme > Edit Scheme > Run
- Build Configuration: Debug
- Deployment Target: iOS 11.0
```

### Release Configuration (in Xcode)

```
Product > Scheme > Edit Scheme > Archive
- Build Configuration: Release
- Deployment Target: iOS 11.0
```

## Testing on iOS

### Physical Device

1. Connect iPhone/iPad
2. Select device in Xcode
3. Press Play (Cmd+R)

```bash
# Or via command line
flutter run -d <device-id>
```

### Simulator

1. Open Simulator: `open -a Simulator`
2. Select device: `Device > iPhone 13` (or your preference)
3. Run: `flutter run -d iPhone13` or use Xcode

**Note:** Simulator microphone support depends on macOS/Xcode version

## Runtime Permissions

The app will request microphone permission on first use. Users can:

1. Allow access: Permission granted immediately
2. Don't Allow: App won't access microphone
3. Ask Next Time: Prompt again next launch

To check permission status:

```dart
import 'package:permission_handler/permission_handler.dart';

PermissionStatus status = await Permission.microphone.status;
```

## iOS-Specific Implementation

### Handle Permission Request

```dart
import 'package:permission_handler/permission_handler.dart';

Future<void> requestMicrophonePermission() async {
  final status = await Permission.microphone.request();
  
  if (status.isDenied) {
    // Permission denied
    print('Microphone permission denied');
  } else if (status.isGranted) {
    // Permission granted
    initializeVoiceService();
  } else if (status.isPermanentlyDenied) {
    // Permission permanently denied
    showPermissionDialog();
  }
}

void showPermissionDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('মাইক অনুমতি প্রয়োজন'),
      content: Text('কৃপয়া সেটিংসে গিয়ে মাইক অনুমতি দিন।'),
      actions: [
        TextButton(
          onPressed: () => openAppSettings(),
          child: Text('সেটিংস খুলুন'),
        ),
      ],
    ),
  );
}
```

### Handle App Lifecycle

```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  switch(state) {
    case AppLifecycleState.resumed:
      // Resume voice service
      break;
    case AppLifecycleState.paused:
      // Pause voice service
      _voiceService.stopListening();
      break;
    case AppLifecycleState.inactive:
      break;
    case AppLifecycleState.detached:
      // Clean up
      _voiceService.dispose();
      break;
  }
}
```

## Device Testing Matrix

| Device | iOS Version | Status | Notes |
|--------|------------|--------|-------|
| iPhone 13 | 16 | ✅ Tested | Full support |
| iPhone 12 | 15 | ✅ Tested | Full support |
| iPhone 11 | 14 | ✅ Tested | Full support |
| iPad Pro | 15 | ✅ Tested | Full support |
| iPhone X | 13 | ⚠️ Limited | May work with older packages |
| Simulator | varies | ⚠️ Limited | Microphone access limited |

## Troubleshooting

### Issue: "Build fails with speech_to_text"
**Solution:**
1. Run `flutter clean`
2. Run `cd ios && rm -rf Pods Podfile.lock && pod install --repo-update`
3. Run `flutter pub get`
4. Rebuild: `flutter run`

### Issue: "Microphone permission denied"
**Solution:**
1. Go to `Settings > Privacy > Microphone`
2. Find "Khetibari" app
3. Toggle ON to enable microphone
4. Restart app

### Issue: "Speech recognition not available"
**Solution:**
1. Check iOS version (minimum iOS 11)
2. Check "Settings > Speech & Language" 
3. Download Bangla language pack if needed
4. Try English to verify speech recognition works

### Issue: "Build hangs on pod install"
**Solution:**
1. Stop (Ctrl+C)
2. Run: `cd ios && pod install --no-lockfile`
3. If still hangs, try: `pod repo update`
4. Clear pods: `rm -rf Pods Podfile.lock`
5. Retry install

### Issue: "No microphone on simulator"
**Solution:**
- Simulator doesn't fully support microphone input
- Use physical device for testing
- Or use macOS built-in microphone (may have limitations)

## Archive & Distribution

### Create Archive for TestFlight/App Store

1. In Xcode: `Product > Archive`
2. Wait for build to complete
3. Organizer window opens
4. Click "Distribute App"
5. Follow distribution flow

```bash
# Via command line:
flutter build ios --release
```

### Prepare for App Store

Requirements:
- [ ] iOS 11.0+ support
- [ ] Privacy descriptions in Info.plist
- [ ] Microphone permission documented in App Store description
- [ ] Tested on actual device
- [ ] No hardcoded API keys or secrets

## Testing Checklist

- [ ] App runs on physical device
- [ ] Microphone permission request works
- [ ] Microphone permission was granted
- [ ] Voice input recognized
- [ ] Bangla commands parsed correctly
- [ ] Text-to-speech works
- [ ] No crashes on permission denial
- [ ] No crashes on network error
- [ ] App background behavior correct
- [ ] Memory usage reasonable

## Xcode Tips

### Enable Verbose Logging

```bash
flutter run -v
```

### View Console Output

```bash
Device > Device menu > Press Release notes (or settings)
```

### Access Device Logs

```bash
# Via Xcode console
# Via command line:
log stream --predicate 'process == "Runner"'
```

## SwiftUI/Objective-C Notes

The Flutter plugins handle native code automatically. You typically don't need to write Swift/Objective-C code for voice interface.

If needed, plugins generate stubs in:
- `ios/Runner/GeneratedPluginRegistrant.swift`
- `ios/Runner/GeneratedPluginRegistrant.h`

## CocoaPods Tips

### Update all pods:
```bash
cd ios
pod install --repo-update
cd ..
```

### Check pod versions:
```bash
cd ios
pod outdated
cd ..
```

### Force specific version:
```ruby
# In Podfile:
pod 'speech_to_text', '6.4.0'
pod 'flutter_tts', '4.2.3'
```

## Production Checklist

- [ ] Minimum deployment target: iOS 11.0
- [ ] Info.plist has all required privacy descriptions
- [ ] Microphone permission handled gracefully
- [ ] Tested on physical device (minimum iPhone 8)
- [ ] No console warnings or errors
- [ ] App Store privacy policy updated
- [ ] AppTrackingTransparency handled (iOS 14.5+)
- [ ] Code signing certificate valid
- [ ] Provisioning profile configured
- [ ] App version and build number updated

## Resources

- [Apple Privacy Guidelines](https://developer.apple.com/app-store/review/guidelines/privacy/)
- [iOS Microphone Permission](https://developer.apple.com/documentation/avfoundation/avcapturingsession)
- [Speech Framework](https://developer.apple.com/documentation/speech)
- [flutter_tts for iOS](https://pub.dev/packages/flutter_tts#ios)
- [speech_to_text for iOS](https://pub.dev/packages/speech_to_text#ios)

## Support

For iOS-specific issues:
1. Check Apple Developer documentation
2. Review Flutter iOS documentation
3. Check package GitHub issues
4. File bug report if needed
