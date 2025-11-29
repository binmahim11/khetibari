// lib/services/risk_map_service.dart

import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'package:khetibari/models/risk_map_data.dart';

/// Service for managing risk map data, including mock neighbor generation
class RiskMapService {
  static final RiskMapService _instance = RiskMapService._internal();
  
  late List<NeighborRiskPoint> _cachedNeighbors = [];
  late String _cachedDistrict = '';
  final Random _random = Random();

  factory RiskMapService() {
    return _instance;
  }

  RiskMapService._internal();

  /// Bangladeshi crop types in Bangla for variety
  static const List<String> cropTypesBangla = [
    'ধান',      // Paddy/Rice
    'গম',       // Wheat
    'ভুট্টা',    // Corn/Maize
    'মসুর',      // Lentil
    'শিম',      // Beans/Pulse
    'সবজি',     // Vegetables
    'পেঁয়াজ',    // Onion
    'রসুন',     // Garlic
  ];

  /// Generates 12-15 mock neighbor risk points within a district
  /// All data is completely anonymous (no names or personal identifiers)
  List<NeighborRiskPoint> generateMockNeighborData({
    required String district,
    required LatLng centerCoordinates,
    int pointCount = 12,
  }) {
    // Return cached data if it's for the same district
    if (_cachedDistrict == district && _cachedNeighbors.isNotEmpty) {
      return _cachedNeighbors;
    }

    List<NeighborRiskPoint> neighbors = [];
    
    // Generate 12-15 random points within approximately 50km radius of district center
    // Rough conversion: 1 degree latitude ≈ 111 km, 1 degree longitude varies with latitude
    final latRange = 0.45;  // ~50 km
    final lonRange = 0.45;  // ~50 km (approximate for Bangladesh latitude)
    
    for (int i = 0; i < pointCount; i++) {
      // Generate random offset from center
      final latOffset = (random.nextDouble() - 0.5) * latRange;
      final lonOffset = (random.nextDouble() - 0.5) * lonRange;
      
      final lat = centerCoordinates.latitude + latOffset;
      final lon = centerCoordinates.longitude + lonOffset;
      
      // Randomly assign risk levels (distribution: 50% Low, 30% Medium, 20% High)
      final riskValue = random.nextDouble();
      final riskLevel = riskValue < 0.50
          ? RiskLevel.low
          : riskValue < 0.80
              ? RiskLevel.medium
              : RiskLevel.high;
      
      // Randomly select crop type
      final cropType = cropTypesBangla[random.nextInt(cropTypesBangla.length)];
      
      // Mock last update time (within last 24 hours)
      final hoursAgo = random.nextInt(24);
      final lastUpdated = DateTime.now().subtract(Duration(hours: hoursAgo));
      
      neighbors.add(
        NeighborRiskPoint(
          pointId: 'neighbor_${i + 1}',
          coordinates: LatLng(lat, lon),
          riskLevel: riskLevel,
          cropTypeBangla: cropType,
          lastUpdated: lastUpdated,
        ),
      );
    }
    
    // Cache the generated data
    _cachedNeighbors = neighbors;
    _cachedDistrict = district;
    
    return neighbors;
  }

  /// Gets the farmer's own location (mocked)
  FarmerLocation getMockedFarmerLocation({
    required String farmerId,
    required String district,
    required LatLng centerCoordinates,
  }) {
    // Generate a mocked location slightly offset from district center
    final latOffset = (random.nextDouble() - 0.5) * 0.1; // ~5-10 km offset
    final lonOffset = (random.nextDouble() - 0.5) * 0.1;
    
    return FarmerLocation(
      farmerId: farmerId,
      name: 'আমার খামার', // "My Farm" in Bangla
      coordinates: LatLng(
        centerCoordinates.latitude + latOffset,
        centerCoordinates.longitude + lonOffset,
      ),
      district: district,
      upazila: 'Sadar', // Default upazila
      cropType: 'ধান', // Default to paddy
    );
  }

  /// Clears cached data to regenerate on next call
  void clearCache() {
    _cachedNeighbors = [];
    _cachedDistrict = '';
  }

  /// Formats last updated time in Bangla
  String formatLastUpdateBangla(DateTime lastUpdated) {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} মিনিট আগে'; // X minutes ago
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ঘণ্টা আগে'; // X hours ago
    } else {
      return '${difference.inDays} দিন আগে'; // X days ago
    }
  }

  /// Gets a random instance
  Random get random => _random;
}
