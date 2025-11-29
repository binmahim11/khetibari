// lib/models/pest_identification.dart

/// Risk level enum for pest threats
enum PestRiskLevel { low, medium, high }

/// Represents identification result from Gemini AI
class PestIdentification {
  final String id;

  final String pestName; // English pest name
  
  final String pestNameBangla; // Bengali pest name (e.g., গাছের পাতার মাছি)

  final PestRiskLevel riskLevel; // High/Medium/Low

  final String description; // Detailed description in Bengali

  final String actionPlan; // Treatment/action plan in Bengali

  final List<String> symptoms; // List of symptoms observed

  final List<String> organicTreatments; // Organic/local treatment methods

  final List<String> preventiveMeasures; // Prevention methods in Bengali

  final DateTime identifiedDate;

  final String? imagePath; // Path to the uploaded image

  final String affectedCrop; // e.g., ধান, গম, ভুট্টা

  PestIdentification({
    required this.id,
    required this.pestName,
    required this.pestNameBangla,
    required this.riskLevel,
    required this.description,
    required this.actionPlan,
    required this.symptoms,
    required this.organicTreatments,
    required this.preventiveMeasures,
    required this.identifiedDate,
    this.imagePath,
    required this.affectedCrop,
  });

  /// Get Bangla text for risk level
  String getRiskLevelBangla() {
    switch (riskLevel) {
      case PestRiskLevel.low:
        return 'কম';
      case PestRiskLevel.medium:
        return 'মধ্যম';
      case PestRiskLevel.high:
        return 'উচ্চ';
    }
  }

  /// Get risk level color code for UI
  int getRiskColorValue() {
    switch (riskLevel) {
      case PestRiskLevel.low:
        return 0xFF4CAF50; // Green
      case PestRiskLevel.medium:
        return 0xFFFFC107; // Amber
      case PestRiskLevel.high:
        return 0xFFF44336; // Red
    }
  }
}

/// Represents a pest treatment history entry
class PestTreatmentHistory {
  final String id;

  final String pestIdentificationId;

  final String farmerId;

  final String treatment; // Treatment applied

  final DateTime dateApplied;

  final String? notes; // Additional notes

  final bool resolved; // Whether the issue was resolved

  PestTreatmentHistory({
    required this.id,
    required this.pestIdentificationId,
    required this.farmerId,
    required this.treatment,
    required this.dateApplied,
    this.notes,
    required this.resolved,
  });
}
