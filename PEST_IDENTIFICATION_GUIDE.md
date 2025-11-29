## Pest Identification and Action Plan (Visual RAG) - Implementation Guide

### Overview
The Pest Identification feature enables farmers to upload images of pests, crop diseases, or plant damage. The system uses Google's Gemini AI with Visual RAG (Retrieval-Augmented Generation) capabilities to instantly identify threats, assess risk levels, and generate hyper-local, actionable treatment plans entirely in Bangla.

---

## Features Implemented

### 1. **Image Upload Interface**
- **Mobile-friendly UI** with dedicated buttons for:
  - Uploading from device gallery (JPEG/PNG)
  - Capturing images directly from camera
- **Live image preview** before submission
- **Crop type selector** with 10+ common Bangladesh crops in Bangla

### 2. **Gemini Visual RAG Flow**
- Sends uploaded image + context prompt to Gemini 2.0 API
- **Mandatory Google Search Grounding** ensures:
  - Verified, current treatment methods
  - Local and practical solutions for Bangladesh farming
  - Evidence-based recommendations
- Structured JSON response parsing for consistent data

### 3. **AI-Generated Output**
- **Pest Identification**: English and Bangla names
- **Risk Level Categorization**: High/Medium/Low (color-coded)
- **Symptom Description**: Visual and behavioral signs
- **Complete Treatment Plan**: Step-by-step guidance in Bangla

### 4. **Grounded Action Plan (Bangla Output)**
The response includes:
- **চিকিৎসা পরিকল্পনা** (Treatment Plan): Detailed, practical steps
- **জৈব চিকিৎসা পদ্ধতি** (Organic Treatments): 3+ local alternatives
  - Natural/biological methods
  - Traditional remedies
  - Farmer-friendly solutions
- **প্রতিরোধমূলক ব্যবস্থা** (Preventive Measures): Future-focused guidance
- **লক্ষণ সমূহ** (Symptoms): Recognition guide in Bangla

---

## File Structure

```
lib/
├── models/
│   └── pest_identification.dart
│       ├── PestRiskLevel (enum: low, medium, high)
│       ├── PestIdentification (Hive model)
│       └── PestTreatmentHistory (Hive model)
│
├── services/
│   └── pest_identification_service.dart
│       ├── identifyPestFromImage()
│       ├── Gemini API integration
│       └── Google Search grounding
│
├── screens/
│   ├── pest_identification_page.dart (UI)
│   ├── farmer_dashboard_page.dart (updated)
│   └── homepage.dart (updated)
│
└── pubspec.yaml
    └── google_generative_ai: ^0.4.2
```

---

## Key Components

### 1. **PestIdentificationService** (`lib/services/pest_identification_service.dart`)

```dart
// Main method for pest analysis
Future<PestIdentification> identifyPestFromImage({
  required File imageFile,
  required String farmerId,
  required String cropType,
}) async { ... }
```

**Features:**
- Reads image file and converts to base64
- Sends to Gemini 2.0 API with Visual RAG prompt
- Parses structured JSON response
- Returns `PestIdentification` object

**Gemini Prompt Includes:**
- Expert agricultural context
- Bangla output requirement
- Google Search grounding directive
- JSON format specification

### 2. **PestIdentificationPage** (`lib/screens/pest_identification_page.dart`)

**UI Components:**
- Header card with feature description
- Crop type dropdown (10 common crops)
- Image upload section with gallery/camera buttons
- Live image preview
- "Analyze with AI" button (red, prominent)
- Result display with formatted output

**Result Display Includes:**
- Pest name (English + Bangla)
- Risk level badge (color-coded)
- Description in Bangla
- Symptoms list
- Step-by-step treatment plan
- Organic treatment alternatives (numbered)
- Preventive measures checklist
- Save result button

### 3. **Data Models** (`lib/models/pest_identification.dart`)

```dart
@HiveType(typeId: 7)
class PestIdentification {
  final String id;
  final String pestName;                // English
  final String pestNameBangla;          // Bengali
  final PestRiskLevel riskLevel;        // High/Medium/Low
  final String description;             // Bangla
  final String actionPlan;              // Bangla
  final List<String> symptoms;          // Bangla
  final List<String> organicTreatments; // Bangla
  final List<String> preventiveMeasures; // Bangla
  final DateTime identifiedDate;
  final String? imagePath;
  final String affectedCrop;
}
```

---

## Supported Crop Types (Bangla)

1. **ধান** - Paddy/Rice
2. **গম** - Wheat
3. **ভুট্টা** - Corn/Maize
4. **মসুর** - Lentil
5. **শিম** - Beans/Pulse
6. **সবজি** - Vegetables
7. **পেঁয়াজ** - Onion
8. **আলু** - Potato
9. **টমেটো** - Tomato
10. **বেগুন** - Eggplant

---

## API Integration

### Gemini 2.0 Flash Model
- **Model**: `gemini-2.0-flash`
- **Capabilities**: Vision understanding + Search grounding
- **Response Format**: Structured JSON (enforced)

### Environment Setup
```dart
// In pest_identification_service.dart
final String _apiKey = 'YOUR_GEMINI_API_KEY';

// TODO: Replace with actual API key from Firebase Config or Secure Storage
```

**To Configure API Key:**
```dart
// During app initialization
PestIdentificationService().setApiKey(apiKeyFromSecureStorage);
```

---

## Response Format (JSON)

The Gemini API returns structured JSON:

```json
{
  "pestName": "Leaf Folder",
  "pestNameBangla": "পাতা ভাঁজকারী পোকা",
  "riskLevel": "high",
  "description": "এই পোকা ফসলের পাতা ভাঁজ করে এবং ভিতরে লুকিয়ে থাকে...",
  "symptoms": [
    "পাতায় লম্বালম্বি সাদা দাগ",
    "পাতা মোটা হয়ে যায়",
    "পাতার ভেতর থেকে খাওয়া শুরু হয়"
  ],
  "actionPlan": "১. আক্রান্ত পাতা সংগ্রহ করে ধ্বংস করুন... ২. জৈব কীটনাশক ব্যবহার করুন...",
  "organicTreatments": [
    "নিম পাতার নির্যাস ১০% দ্রবণ স্প্রে করুন",
    "ট্রাইকোডার্মা ছত্রাক ব্যবহার করুন",
    "আলোর ফাঁদ স্থাপন করুন"
  ],
  "preventiveMeasures": [
    "ক্ষেতের আশপাশ পরিষ্কার রাখুন",
    "সঠিক সময়ে বীজ বপন করুন",
    "প্রতিরোধী জাত ব্যবহার করুন"
  ],
  "affectedCrop": "ধান"
}
```

---

## Bangla Text Examples

### Common Terminology

| English | Bengali |
|---------|---------|
| Pest | পোকা |
| Disease | রোগ |
| Symptom | লক্ষণ |
| Treatment | চিকিৎসা |
| Organic | জৈব |
| Prevention | প্রতিরোধ |
| Risk Level | ঝুঁকির স্তর |
| Low Risk | কম ঝুঁকি |
| Medium Risk | মধ্যম ঝুঁকি |
| High Risk | উচ্চ ঝুঁকি |
| Spray | স্প্রে করুন |
| Dose | মাত্রা |
| Days | দিন |

### Example Organic Treatment Methods (Bangla)

- **নিম পাতার নির্যাস** - Neem leaf extract
- **ট্রাইকোডার্মা** - Trichoderma fungus
- **বোর্ডো মিশ্রণ** - Bordeaux mixture
- **ছাই মিশ্রণ** - Ash mixture
- **সাবান পানি** - Soapy water
- **আলোর ফাঁদ** - Light trap
- **হাতে সংগ্রহ** - Hand picking

---

## Integration Points

### 1. **Farmer Dashboard** (`lib/screens/farmer_dashboard_page.dart`)
- Added "পোকা চিহ্নিতকরণ" button to Quick Actions
- Orange color for pest-related actions
- Navigates to `PestIdentificationPage`

### 2. **Home Page** (`lib/screens/homepage.dart`)
- Added pest identification button to navigation
- Easy access from main farmer interface
- Positioned with other crop management tools

### 3. **Dependencies** (`pubspec.yaml`)
- Added: `google_generative_ai: ^0.4.2`
- Already has: `image_picker` for image selection

---

## Usage Flow

1. **Open Page**: Tap "পোকা চিহ্নিতকরণ" from dashboard/home
2. **Select Crop**: Choose affected crop type from dropdown
3. **Upload Image**:
   - Tap "গ্যালারি থেকে" (Gallery) or
   - Tap "ক্যামেরা দিয়ে" (Camera)
4. **Review Image**: See preview of selected image
5. **Analyze**: Tap "AI দ্বারা বিশ্লেষণ করুন" (Analyze with AI)
6. **Wait**: Loading indicator shows processing
7. **View Results**:
   - Pest identification
   - Risk level
   - Description
   - Symptoms
   - Treatment plan
   - Organic alternatives
   - Preventive measures
8. **Save**: Tap "ফলাফল সংরক্ষণ করুন" (Save Result)

---

## Error Handling

The service handles:
- **Network errors**: SocketException
- **API errors**: Exception with descriptive message
- **Format errors**: FormatException
- **File errors**: File reading issues

**User-Friendly Error Messages** (in Bangla):
- "ছবি নির্বাচনে ত্রুটি" (Error selecting image)
- "পোকা চিহ্নিত করতে ব্যর্থ" (Failed to identify pest)
- "অনুগ্রহ করে একটি ছবি নির্বাচন করুন" (Please select an image)

---

## Technical Details

### Image Processing
- **Formats Supported**: JPEG, PNG, GIF, WebP
- **Quality**: 80% compression for faster upload
- **MIME Types**:
  - image/jpeg (default)
  - image/png
  - image/gif
  - image/webp

### Gemini API Features
- **Vision Understanding**: Image recognition and analysis
- **Google Search Grounding**: Real-time verified information
- **JSON Parsing**: Structured response extraction
- **Bangla Language**: Full Bengali language support

### Data Storage (Hive)
```dart
@HiveType(typeId: 7)
class PestIdentification { ... }

@HiveType(typeId: 8)
class PestTreatmentHistory { ... }
```

---

## Configuration

### API Key Setup
1. Get Gemini API key from Google Cloud Console
2. Store securely (not in code)
3. Initialize during app startup:

```dart
final service = PestIdentificationService();
service.setApiKey(secureApiKey);
```

### Recommended: Use Environment Variables
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
```

---

## Future Enhancements

1. **Local Storage**: Save identification history to Hive
2. **Treatment Tracking**: Log treatments applied and outcomes
3. **Photo Gallery**: View identification history with images
4. **Alerts**: Notify when specific pests detected
5. **Offline Mode**: Cache common pest patterns
6. **Multi-language**: Support regional Indian languages
7. **Community Sharing**: Share findings with other farmers
8. **Expert Review**: Submit for agricultural expert verification

---

## Testing Checklist

- [ ] Image upload from gallery works
- [ ] Camera capture works
- [ ] Image preview displays correctly
- [ ] Crop type selection works
- [ ] Analyze button triggers API call
- [ ] Loading indicator shows during processing
- [ ] Results display all sections
- [ ] Bangla text renders correctly
- [ ] Risk level color coding works
- [ ] Treatment plan formatting is readable
- [ ] Organic treatments numbered correctly
- [ ] Preventive measures marked with checkmarks
- [ ] Error messages display in Bangla
- [ ] Navigation back works properly

---

## Dependencies

```yaml
google_generative_ai: ^0.4.2   # Gemini API
image_picker: ^1.0.7            # Image selection
intl: ^0.18.1                   # Internationalization
hive: ^2.2.3                    # Local storage
flutter:                        # Flutter framework
```

---

## Notes

- All responses MUST be in Bengali for user-facing content
- Google Search grounding is mandatory for accuracy
- Organic methods prioritized for sustainable farming
- Risk assessment based on crop damage severity
- Treatment plans consider local availability
- All data is farmer-specific and can be saved locally

