// gesture_service.dart
// Touchless Gesture Recognition Service for hands-free interaction

class GestureCommand {
  final String name;
  final String banglaName;
  final String description;

  GestureCommand({
    required this.name,
    required this.banglaName,
    required this.description,
  });
}

class TouchlessGestureService {
  static final TouchlessGestureService _instance =
      TouchlessGestureService._internal();

  // Gesture commands
  static final Map<String, GestureCommand> gestureCommands = {
    'swipe_right': GestureCommand(
      name: 'swipe_right',
      banglaName: 'ডান দিকে সোয়াইপ',
      description: 'Navigate to next page',
    ),
    'swipe_left': GestureCommand(
      name: 'swipe_left',
      banglaName: 'বাম দিকে সোয়াইপ',
      description: 'Navigate to previous page',
    ),
    'swipe_up': GestureCommand(
      name: 'swipe_up',
      banglaName: 'উপরের দিকে সোয়াইপ',
      description: 'Scroll up / Refresh',
    ),
    'swipe_down': GestureCommand(
      name: 'swipe_down',
      banglaName: 'নিচের দিকে সোয়াইপ',
      description: 'Scroll down',
    ),
    'thumb_up': GestureCommand(
      name: 'thumb_up',
      banglaName: 'থাম্বস আপ',
      description: 'Approve / Yes / Confirm',
    ),
    'thumb_down': GestureCommand(
      name: 'thumb_down',
      banglaName: 'থাম্বস ডাউন',
      description: 'Reject / No / Cancel',
    ),
    'open_palm': GestureCommand(
      name: 'open_palm',
      banglaName: 'খোলা হাতের তালু',
      description: 'Stop / Pause',
    ),
    'fist': GestureCommand(
      name: 'fist',
      banglaName: 'মুষ্টি',
      description: 'Close / Back',
    ),
    'peace_sign': GestureCommand(
      name: 'peace_sign',
      banglaName: 'পিস সাইন',
      description: 'Help / Menu',
    ),
    'pointing': GestureCommand(
      name: 'pointing',
      banglaName: 'নির্দেশনা',
      description: 'Select / Tap on screen element',
    ),
  };

  Function(String)? _onGestureDetected;
  bool _isEnabled = false;

  factory TouchlessGestureService() {
    return _instance;
  }

  TouchlessGestureService._internal();

  void enableGestureDetection(Function(String) callback) {
    _onGestureDetected = callback;
    _isEnabled = true;
    print('Touchless gesture detection enabled');
  }

  void disableGestureDetection() {
    _isEnabled = false;
    print('Touchless gesture detection disabled');
  }

  bool get isEnabled => _isEnabled;

  // Simulate gesture detection (would be connected to actual gesture recognition)
  void detectedGesture(String gestureName) {
    if (_isEnabled && gestureCommands.containsKey(gestureName)) {
      _onGestureDetected?.call(gestureName);
      print('Gesture detected: $gestureName');
    }
  }

  String getBanglaGestureName(String gestureName) {
    return gestureCommands[gestureName]?.banglaName ?? 'Unknown';
  }

  String getGestureDescription(String gestureName) {
    return gestureCommands[gestureName]?.description ?? 'Unknown gesture';
  }

  // Get all available gestures
  List<GestureCommand> getAllGestures() {
    return gestureCommands.values.toList();
  }

  void dispose() {
    _isEnabled = false;
    _onGestureDetected = null;
  }
}
