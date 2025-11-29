## Local Risk Map Implementation - Complete Guide

### Overview
The Local Risk Map is a community awareness tool that visualizes the spoilage risk landscape across a farmer's district. It provides real-time visualization of anonymous, color-coded risk markers representing neighboring farms' spoilage threats.

---

## Features Implemented

### 1. **Map Setup & District Centering**
- Responsive map component using `flutter_map` package
- Auto-centers and zooms to farmer's registered district
- Supports all major Bangladesh districts (Dhaka, Chittagong, Sylhet, Rajshahi, Khulna, Laxmipur, etc.)
- District selector dropdown in top-right corner for easy navigation
- **File**: `lib/screens/risk_map` (RiskMapPage)

### 2. **Mock Neighbor Data Generation**
- **Service**: `lib/services/risk_map_service.dart`
- Generates 12-15 anonymous mock data points per district
- Data includes:
  - Coordinates (within ~50km radius of district center)
  - Risk Level: Low, Medium, or High
  - Crop Type in Bangla (ধান, গম, ভুট্টা, মসুর, শিম, সবজি, পেঁয়াজ, রসুন)
  - Last Updated timestamp (within last 24 hours)
- **100% Client-Side Storage**: No external API calls or server data

### 3. **Pin Visualization**
- **Farmer's Own Location** (Blue Pin):
  - Distinct blue location marker
  - Labeled "আমার খামার" (My Farm)
  - Slightly randomized position for privacy
  
- **Anonymous Neighbor Markers** (Color-Coded):
  - **Green** (🟢): Low Risk
  - **Yellow/Amber** (🟡): Medium Risk
  - **Red** (🔴): High Risk
  - Risk distribution: 50% Low, 30% Medium, 20% High (realistic scenario)

### 4. **Privacy Constraint**
- All neighbor data is **completely anonymous**
- No personal identifiers displayed
- No farmer names, IDs, or contact information
- Only crop type and risk level shown
- Marked as "সম্পূর্ণ গোপনীয়" (Completely Confidential) in tooltips

### 5. **Bangla Pop-up Interaction**
When tapping a neighbor pin, a bottom sheet displays:

```
মানচিত্র পৌরাণিক:
---
ফসলের ধরন: ধান (Crop Type in Bangla)
ঝুঁকির স্তর: উচ্চ (Risk Level: Low/Medium/High)
শেষ আপডেট: ৪ ঘণ্টা আগে (Last Updated: X hours ago)

সম্পূর্ণ গোপনীয় - কোন ব্যক্তিগত তথ্য প্রদর্শন করা হয় না
(Completely Confidential - No personal information displayed)
```

### 6. **Interactivity & User Experience**
- **Touch-Friendly Panning**: Drag to move around the map
- **Zooming**: Pinch to zoom in/out (min: 5x, max: 18x)
- **Dynamic Legend**: Shows map symbols (bottom-left corner)
  - Blue pin = My Farm
  - Green circle = Low Risk
  - Yellow circle = Medium Risk
  - Red circle = High Risk
- **District Selector**: Dropdown (top-right) to instantly switch districts

---

## File Structure

```
lib/
├── models/
│   └── risk_map_data.dart          # Data models for risk map
│       ├── RiskLevel (enum)
│       ├── FarmerLocation
│       ├── NeighborRiskPoint
│       ├── DistrictBoundary
│       └── Constants (districts, crops)
│
├── services/
│   └── risk_map_service.dart       # Mock data generation & management
│       ├── generateMockNeighborData()
│       ├── getMockedFarmerLocation()
│       ├── formatLastUpdateBangla()
│       └── clearCache()
│
├── screens/
│   ├── risk_map                    # Main risk map UI (RiskMapPage)
│   │   └── Features: Map, markers, tooltips, legend
│   │
│   ├── homepage.dart               # Updated with Risk Map button
│   │
│   └── farmer_dashboard_page.dart  # Updated with Risk Map button
│
└── pubspec.yaml                    # Added dependencies:
    ├── flutter_map: ^6.1.0
    └── latlong2: ^0.9.1
```

---

## Key Classes & Functions

### 1. RiskMapPage (lib/screens/risk_map)
```dart
RiskMapPage({
  required String farmerId,
  String? userDistrict,
})
```
- Main UI component for risk map visualization
- Auto-loads farmer location and neighbor data
- Manages map controller and marker rendering

### 2. RiskMapService (lib/services/risk_map_service.dart)
```dart
// Generate 12-15 mock neighbors for a district
List<NeighborRiskPoint> generateMockNeighborData({
  required String district,
  required LatLng centerCoordinates,
  int pointCount = 12,
})

// Get farmer's mocked location
FarmerLocation getMockedFarmerLocation({
  required String farmerId,
  required String district,
  required LatLng centerCoordinates,
})

// Format time in Bangla (e.g., "৪ ঘণ্টা আগে")
String formatLastUpdateBangla(DateTime lastUpdated)
```

### 3. Data Models (lib/models/risk_map_data.dart)
```dart
class NeighborRiskPoint {
  final String pointId;
  final LatLng coordinates;
  final RiskLevel riskLevel;          // Low, Medium, High
  final String cropTypeBangla;        // ধান, গম, ভুট্টা, etc.
  final DateTime lastUpdated;
  
  int getColorValue()                 // Get color code for risk level
  String getRiskLevelBangla()         // Get Bangla text
}

class FarmerLocation {
  final String farmerId;
  final String name;                  // "আমার খামার"
  final LatLng coordinates;
  final String district;
  final String upazila;
  final String cropType;              // Bangla crop name
}
```

---

## How to Use

### 1. **Navigation**
Users can access the Risk Map from:
- **Farmer Home Page**: "Community Risk Map" button (red, with map icon)
- **Farmer Dashboard**: "Community Risk Map" button (red)

### 2. **Viewing Risks**
1. Open the Risk Map
2. See your blue pin in the center (your farm location)
3. See colored pins around you (neighbor farms)
4. Green = Safe, Yellow = Medium Risk, Red = High Risk

### 3. **Getting Details**
1. Tap any pin on the map
2. A bottom sheet opens with details:
   - Crop type (Bangla)
   - Risk level (Bangla)
   - Last update time (Bangla)
3. Close the sheet by tapping "বন্ধ করুন" (Close)

### 4. **Changing District**
1. Use the dropdown in top-right corner
2. Select a new district
3. Map automatically centers on that district
4. New mock neighbors are generated for that district

### 5. **Map Controls**
- **Drag**: Pan around the map
- **Pinch**: Zoom in/out
- **Tap**: View details of a marker

---

## Bangla Text Reference

### Risk Levels
- **কম**: Low
- **মধ্যম**: Medium
- **উচ্চ**: High

### Crop Types
- **ধান**: Rice/Paddy
- **গম**: Wheat
- **ভুট্টা**: Corn/Maize
- **মসুর**: Lentil
- **শিম**: Beans/Pulse
- **সবজি**: Vegetables
- **পেঁয়াজ**: Onion
- **রসুন**: Garlic

### Time References
- **মিনিট আগে**: X minutes ago
- **ঘণ্টা আগে**: X hours ago
- **দিন আগে**: X days ago

### UI Labels
- **আমার খামার**: My Farm
- **স্থানীয় ঝুঁকি মানচিত্র**: Local Risk Map
- **মানচিত্র পৌরাণিক**: Map Legend
- **আশপাশের ঝুঁকি তথ্য**: Nearby Risk Information
- **ফসলের ধরন**: Crop Type
- **ঝুঁকির স্তর**: Risk Level
- **শেষ আপডেট**: Last Update
- **বন্ধ করুন**: Close
- **সম্পূর্ণ গোপনীয়**: Completely Confidential

---

## Technical Details

### Dependencies Added
```yaml
flutter_map: ^6.1.0      # Map rendering
latlong2: ^0.9.1         # Latitude/Longitude handling
```

### Map Provider
- **OpenStreetMap**: Free, open-source tiles (no API key required)
- Tiles load from: `https://tile.openstreetmap.org`

### Data Persistence
- All mock data generated on-the-fly (client-side)
- Data cached for the current district
- Cache cleared when switching districts
- **No database or API required**

### District Boundaries
- 10 major Bangladesh districts with coordinates
- Each district has a default zoom level (10.0x)
- Coordinates are approximate district centers

### Color Scheme
- **Low Risk (Green)**: `Colors.green.shade600` (#4CAF50)
- **Medium Risk (Yellow)**: `Colors.amber.shade600` (#FFC107)
- **High Risk (Red)**: `Colors.red.shade600` (#F44336)
- **Farmer Location (Blue)**: `Colors.blue.shade700` (#1565C0)

---

## Testing Checklist

- [ ] Risk Map loads when navigating from home page
- [ ] Map centers on farmer's district
- [ ] Blue pin shows farmer's location
- [ ] 12-15 colored pins show neighbor locations
- [ ] Tapping neighbor pins shows Bangla tooltip
- [ ] District selector works and reloads map
- [ ] Legend displays all symbols correctly
- [ ] Panning and zooming work smoothly
- [ ] No personal identifiers visible in tooltips
- [ ] Bangla text displays correctly

---

## Future Enhancements

1. **Real Data Integration**: Replace mock data with actual farmer batch locations
2. **Risk Calculation**: Use actual ETCL values instead of random risk levels
3. **Historical Trends**: Show risk level changes over time
4. **Alerts & Notifications**: Notify farmers of high-risk areas nearby
5. **Filtering**: Allow farmers to filter by crop type or risk level
6. **Offline Maps**: Cache map tiles for offline viewing
7. **Export Reports**: Generate community risk reports in PDF

---

## Notes

- All data is **completely anonymous** - no personally identifiable information is shared
- Mock data changes each time the user switches districts
- The farmer's own location is slightly randomized for additional privacy
- Risk distribution (50% Low, 30% Medium, 20% High) reflects realistic spoilage scenarios
- The implementation is **completely offline** and requires no backend services

