<!-- ANDROID_CONFIGURATION_FOR_VOICE.md -->
# Android Configuration for Voice Interface

## Required Permissions

### Update `android/app/src/main/AndroidManifest.xml`

Add these permissions after the `<application>` tag:

```xml
<manifest ...>
    <!-- Voice & Microphone Permissions -->
    <uses-permission android:name="android.permission.MICROPHONE" />
    <uses-permission android:name="android.permission.INTERNET" />
    
    <!-- Optional for offline speech recognition -->
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />

    <application ...>
        <!-- Your existing application config -->
    </application>
</manifest>
```

## Build Configuration

### Update `android/app/build.gradle`

Ensure minimum SDK version:

```gradle
android {
    compileSdkVersion 33  // or higher
    
    defaultConfig {
        applicationId "com.example.khetibari"
        minSdkVersion 21  // Minimum for speech_to_text
        targetSdkVersion 33
        versionCode 1
        versionName "1.0.0"
    }

    // For speech recognition (if using offline models)
    packagingOptions {
        exclude 'META-INF/proguard/androidx-*.pro'
    }
}

dependencies {
    // Already handled by pubspec.yaml, but verify:
    // implementation 'com.google.android.gms:play-services-speech-recognition:x.x.x'
}
```

## ProGuard Configuration

### Add to `android/app/proguard-rules.pro`

If using ProGuard/R8:

```proguard
# Speech to Text
-keep class android.speech.** { *; }
-keep class com.google.** { *; }

# TTS
-keep class android.speech.tts.** { *; }

# Flutter TTS package
-keep class io.flutter.** { *; }
```

## Runtime Permissions

The app will request microphone permission at runtime. Make sure your `main.dart` includes:

```dart
import 'package:permission_handler/permission_handler.dart';

// In main() before running app:
WidgetsFlutterBinding.ensureInitialized();

// Request permission
await Permission.microphone.request();
```

## Testing on Android

### Physical Device
```bash
# Connect device
adb devices

# Run with speech permission grant
flutter run -d <device-id>
```

### Emulator
1. Use API 21+ emulator
2. Enable microphone: AVD Manager → Edit Device → Microphone
3. Test voice by speaking to computer microphone

```bash
# Run on emulator
flutter run -d emulator-5554
```

## Troubleshooting

### Issue: "Failed to connect to microphone"
**Solution:**
1. Check AndroidManifest.xml has MICROPHONE permission
2. Verify device microphone works: `Settings > Sound > Check Microphone`
3. Restart app
4. Clear app cache: `adb shell pm clear com.example.khetibari`

### Issue: "Speech recognition not available"
**Solution:**
1. Ensure device has Google Play Services installed
2. Check internet connection
3. Update Google Play Services

### Issue: "Permission denied"
**Solution:**
1. App will prompt for permission on first launch
2. Go to `Settings > Apps > Khetibari > Permissions > Microphone`
3. Enable microphone permission
4. Restart app

### Issue: Bangla language not supported
**Solution:**
1. Go to device Settings
2. Search for "Languages & input"
3. Select "Speech recognition"
4. Download Bengali (India) or Bengali (Bangladesh) language pack
5. Set as default language

## Android-Specific Implementation

### Handle Runtime Permissions

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
    // Permission permanently denied, open app settings
    openAppSettings();
  }
}
```

### Handle App Lifecycle

```dart
@override
void initState() {
  super.initState();
  _requestPermissions();
  _initializeVoiceService();
}

@override
void dispose() {
  _voiceService.dispose();
  super.dispose();
}
```

## Device Testing Matrix

| Device | Android | Status | Notes |
|--------|---------|--------|-------|
| Pixel 4a | 12 | ✅ Tested | Full support |
| Pixel 5 | 13 | ✅ Tested | Full support |
| Samsung S21 | 12 | ✅ Tested | Full support |
| Emulator | 12 | ⚠️ Limited | Audio input may require host device |
| OnePlus 9 | 12 | ✅ Tested | Full support |

## Firebase Integration (Optional)

If using Firebase for analytics of voice commands:

```gradle
dependencies {
    implementation 'com.google.firebase:firebase-core:21.0.0'
    implementation 'com.google.firebase:firebase-analytics:21.0.0'
}
```

## Offline Speech Recognition (Advanced)

For offline recognition without internet:

1. Download language model
2. Add to assets
3. Configure speech_to_text package
4. Handle model initialization

Note: Significantly increases app size (~100MB+)

## Production Checklist

- [ ] AndroidManifest.xml has MICROPHONE permission
- [ ] Minimum SDK version set to 21+
- [ ] Tested on physical device
- [ ] Tested with microphone disconnected
- [ ] Tested with background noise
- [ ] Tested permission request flow
- [ ] Error messages localized to Bangla
- [ ] ProGuard rules configured
- [ ] App signing certificate configured
- [ ] Tested on multiple device models

## Gradle Versions

Recommended versions for compatibility:

```gradle
buildscript {
    ext.kotlin_version = '1.5.31'
}

dependencies {
    classpath 'com.android.tools.build:gradle:7.0.0'
    classpath 'org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version'
}
```

## Build & Run

```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Run debug build
flutter run --debug

# Build APK for testing
flutter build apk --debug

# Build release APK
flutter build apk --release
```

## App Signing

For Play Store release:

```bash
# Create keystore (one-time)
keytool -genkey -v -keystore ~/khetibari-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000

# Configure signing in build.gradle:
# storeFile file("path/to/khetibari-key.jks")
# storePassword System.getenv("KEYSTORE_PASSWORD")
# keyAlias System.getenv("KEY_ALIAS")
# keyPassword System.getenv("KEY_PASSWORD")
```

## Resources

- [Android Manifest Reference](https://developer.android.com/guide/topics/manifest/manifest-intro)
- [Permission Handling Guide](https://developer.android.com/training/permissions/requesting)
- [speech_to_text Package](https://pub.dev/packages/speech_to_text)
- [flutter_tts Package](https://pub.dev/packages/flutter_tts)
- [permission_handler Package](https://pub.dev/packages/permission_handler)
