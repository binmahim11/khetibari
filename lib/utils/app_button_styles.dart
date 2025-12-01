// lib/utils/app_button_styles.dart
import 'package:flutter/material.dart';

/// Unified button styling for the Khetibari app
/// Black background, bold white text, high contrast
class AppButtonStyles {
  // Primary button: Black background with bold white text
  static ButtonStyle primaryBlackButton() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
    );
  }

  // Large primary button for important actions
  static ButtonStyle largePrimaryBlackButton() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.6),
    );
  }

  // Small button for less prominent actions
  static ButtonStyle smallBlackButton() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.4),
    );
  }

  // Icon button with black background
  static ButtonStyle iconBlackButton() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 3,
    );
  }

  // Text style for all buttons (bold white)
  static TextStyle buttonTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
      letterSpacing: 0.5,
    );
  }

  // Text style for large buttons
  static TextStyle largeButtonTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 18,
      letterSpacing: 0.5,
    );
  }

  // Text style for small buttons
  static TextStyle smallButtonTextStyle() {
    return const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
      letterSpacing: 0.3,
    );
  }

  // Dropdown menu style (black background with white text)
  static InputDecorationTheme dropdownTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.black, width: 3),
      ),
      labelStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      hintStyle: TextStyle(
        color: Colors.grey.shade600,
        fontWeight: FontWeight.w600,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  // Card theme with black border
  static BoxDecoration cardDecoration({Color backgroundColor = Colors.white}) {
    return BoxDecoration(
      color: backgroundColor,
      border: Border.all(color: Colors.black, width: 2),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // AppBar theme with black background and bold white text
  static AppBarTheme appBarTheme() {
    return AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.3),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 22,
        letterSpacing: 0.5,
      ),
      iconTheme: const IconThemeData(color: Colors.white, size: 28),
    );
  }
}

/// Extension for easy button styling on widgets
extension ButtonStyling on Text {
  Text withBlackButtonStyle({bool large = false, bool small = false}) {
    final style =
        small
            ? AppButtonStyles.smallButtonTextStyle()
            : large
            ? AppButtonStyles.largeButtonTextStyle()
            : AppButtonStyles.buttonTextStyle();
    return Text(data!, style: style);
  }
}
