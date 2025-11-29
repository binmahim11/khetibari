// lib/models/risk_map_data.dart

import 'package:latlong2/latlong.dart';

/// Risk level enum for color coding
enum RiskLevel { low, medium, high }

/// Represents a farmer's location on the risk map
class FarmerLocation {
  final String farmerId;
  final String name;
  final LatLng coordinates;
  final String district;
  final String upazila;
  final String cropType; // মোবাইল ফসলের ধরন (e.g., ধান, গম, ভুট্টা)
  final String cropTypeBangla; // Bangla crop type for display

  FarmerLocation({
    required this.farmerId,
    required this.name,
    required this.coordinates,
    required this.district,
    required this.upazila,
    required this.cropType,
    this.cropTypeBangla = 'ধান',
  });
}

/// Represents anonymous neighbor risk data point
class NeighborRiskPoint {
  final String pointId; // Unique ID for the risk point
  final LatLng coordinates;
  final RiskLevel riskLevel;
  final String cropTypeBangla; // e.g., 'ধান', 'গম', 'ভুট্টা'
  final DateTime lastUpdated;

  NeighborRiskPoint({
    required this.pointId,
    required this.coordinates,
    required this.riskLevel,
    required this.cropTypeBangla,
    required this.lastUpdated,
  });

  /// Get color for this risk level
  int getColorValue() {
    switch (riskLevel) {
      case RiskLevel.low:
        return 0xFF4CAF50; // Green
      case RiskLevel.medium:
        return 0xFFFFC107; // Amber/Yellow
      case RiskLevel.high:
        return 0xFFF44336; // Red
    }
  }

  /// Get Bangla text for risk level
  String getRiskLevelBangla() {
    switch (riskLevel) {
      case RiskLevel.low:
        return 'কম'; // Low
      case RiskLevel.medium:
        return 'মধ্যম'; // Medium
      case RiskLevel.high:
        return 'উচ্চ'; // High
    }
  }
}

/// District boundary data for map centering and zooming
class DistrictBoundary {
  final String name;
  final LatLng center;
  final double defaultZoom;

  const DistrictBoundary({
    required this.name,
    required this.center,
    required this.defaultZoom,
  });
}

/// Mapping of Bangladesh districts to coordinates and boundaries
final Map<String, DistrictBoundary> bangladeshDistricts = {
  'ঢাকা': DistrictBoundary(
    name: 'Dhaka',
    center: const LatLng(23.8103, 90.4125),
    defaultZoom: 10.0,
  ),
  'চট্টগ্রাম': DistrictBoundary(
    name: 'Chittagong',
    center: const LatLng(22.3569, 91.7832),
    defaultZoom: 10.0,
  ),
  'সিলেট': DistrictBoundary(
    name: 'Sylhet',
    center: const LatLng(24.8917, 91.8832),
    defaultZoom: 10.0,
  ),
  'রাজশাহী': DistrictBoundary(
    name: 'Rajshahi',
    center: const LatLng(24.3745, 88.6042),
    defaultZoom: 10.0,
  ),
  'খুলনা': DistrictBoundary(
    name: 'Khulna',
    center: const LatLng(22.8456, 89.5403),
    defaultZoom: 10.0,
  ),
  'লক্ষ্মীপুর': DistrictBoundary(
    name: 'Laxmipur',
    center: const LatLng(22.9424, 91.1691),
    defaultZoom: 10.0,
  ),
  'নোয়াখালী': DistrictBoundary(
    name: 'Noakhali',
    center: const LatLng(23.1727, 91.0988),
    defaultZoom: 10.0,
  ),
  'পটুয়াখালী': DistrictBoundary(
    name: 'Patuakhali',
    center: const LatLng(22.3569, 90.3319),
    defaultZoom: 10.0,
  ),
  'বরিশাল': DistrictBoundary(
    name: 'Barisal',
    center: const LatLng(22.7010, 90.3535),
    defaultZoom: 10.0,
  ),
  'ময়মনসিংহ': DistrictBoundary(
    name: 'Mymensingh',
    center: const LatLng(24.7465, 90.4060),
    defaultZoom: 10.0,
  ),
};

/// Bangla text for crop types commonly affected by spoilage
const Map<String, String> cropTypesBangla = {
  'Paddy': 'ধান',
  'Wheat': 'গম',
  'Corn': 'ভুট্টা',
  'Lentil': 'মসুর',
  'Pulse': 'শিম',
  'Vegetables': 'সবজি',
  'Fruits': 'ফল',
  'Spices': 'মশলা',
};
