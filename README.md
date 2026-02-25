# 🤖 CV.AI — AI-Powered CV Corrector & Analyzer

A fully functional Flutter app that uses Claude AI (Anthropic) to analyze, correct, and improve CVs/Resumes. Built with clean architecture, beautiful dark UI, and packed with career features.

---

## ✨ Features

| Feature | Description |
|---|---|
| 📄 **PDF & TXT Upload** | Pick and read PDF or text CV files directly |
| ✏️ **Paste CV Text** | Paste raw CV text for instant analysis |
| 🎯 **ATS Score** | Get an ATS compatibility score (0–100) with verdict |
| 🔍 **Grammar & Correction** | Detailed before/after corrections with reasons |
| 🏷️ **Keyword Analysis** | See missing and present keywords for ATS |
| ⚙️ **Skills Analysis** | Technical & soft skills breakdown + recommendations |
| 📬 **Cover Letter Generator** | AI writes a personalized cover letter from your CV |
| 🔗 **LinkedIn Summary** | Ready-to-use LinkedIn "About" section |
| 🎤 **Elevator Pitch** | 30-second pitch for networking events |
| 🧠 **Interview Prep** | Role-specific interview questions + STAR tips |
| 💰 **Salary Estimation** | Estimated salary range based on experience |
| 📊 **Multi-Score Dashboard** | ATS, Impact, Readability & Completeness scores |
| 📁 **History** | All past analyses saved locally — swipe to delete |
| 📤 **Share & Copy** | Share reports, copy cover letters with one tap |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.2.0 or later
- Dart 3.2.0 or later
- An **Anthropic API key** from [console.anthropic.com](https://console.anthropic.com)

### 1. Clone or unzip the project
```bash
cd cv_corrector
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Run the app
```bash
flutter run
```

### 4. Add your API key
- Open the app → tap the **Settings (⚙️)** icon in the top right
- Enter your Anthropic API key (`sk-ant-api03-...`)
- Tap **Save API Key**

---

## 🗂️ Project Structure

```
lib/
├── main.dart                          # App entry point
├── core/
│   ├── constants/
│   │   └── app_constants.dart         # Colors, text styles, theme, strings
│   ├── services/
│   │   ├── app_provider.dart          # Global state (ChangeNotifier)
│   │   ├── claude_service.dart        # Anthropic API integration
│   │   ├── history_service.dart       # SharedPreferences storage
│   │   └── pdf_service.dart           # File picking & PDF text extraction
│   └── widgets/
│       └── common_widgets.dart        # Reusable UI components
├── data/
│   └── models/
│       └── cv_analysis_model.dart     # CV analysis data model
└── presentation/
    ├── home/
    │   └── home_screen.dart           # Main screen with upload & analyze
    ├── result/
    │   ├── result_screen.dart         # Tabbed result dashboard
    │   └── tabs/
    │       ├── overview_tab.dart      # Scores, summary, strengths, wins
    │       ├── corrections_tab.dart   # Filterable corrections list
    │       ├── keywords_tab.dart      # Keyword match analysis
    │       ├── skills_tab.dart        # Skills breakdown
    │       ├── cover_letter_tab.dart  # Cover letter + LinkedIn + pitch
    │       └── interview_tab.dart     # Interview questions + tips
    ├── history/
    │   └── history_screen.dart        # Past analyses with swipe-to-delete
    └── settings/
        └── settings_screen.dart       # API key management + info
```

---

## 🛠️ Tech Stack

| Category | Package |
|---|---|
| State Management | `provider ^6.1.2` |
| HTTP | `http ^1.2.2` |
| File Picking | `file_picker ^8.1.2` |
| PDF Reading | `syncfusion_flutter_pdf ^27.1.48` |
| Animations | `flutter_animate ^4.5.0` |
| Fonts | `google_fonts ^6.2.1` |
| Charts | `fl_chart ^0.69.0` |
| Progress Indicators | `percent_indicator ^4.2.3` |
| Markdown | `flutter_markdown ^0.7.4` |
| Local Storage | `shared_preferences ^2.3.3` |
| Sharing | `share_plus ^10.0.2` |
| Date Formatting | `intl ^0.19.0` |
| UUID | `uuid ^4.5.1` |

---

## 📱 Screens Overview

### Home Screen
- Upload PDF/TXT or paste CV text
- Feature chips overview
- Loading animation with cycling messages

### Result Dashboard (6 Tabs)
1. **Overview** — ATS hero score, 4 score rings, career level, salary, strengths & issues, quick wins
2. **Corrections** — Filterable list with expandable before/after cards, priority badges
3. **Keywords** — Match rate bar, present/missing keyword chips with copy
4. **Skills** — Technical, soft, missing skills with chips
5. **Cover Letter** — AI cover letter, LinkedIn summary, elevator pitch — all copyable
6. **Interview** — Role-specific questions with expandable STAR tips

### History Screen
- All past analyses sorted by date
- ATS score badge per entry
- Swipe to delete / Clear all

### Settings Screen
- API key input with show/hide toggle
- How-to instructions modal
- Privacy & security info

---

## 🔧 Platform-Specific Setup

### Android
Add to `android/app/src/main/AndroidManifest.xml` inside `<manifest>`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

### iOS
Add to `ios/Runner/Info.plist`:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Required to pick CV files</string>
```

### macOS (Desktop)
Add to `macos/Runner/DebugProfile.entitlements` AND `Release.entitlements`:
```xml
<key>com.apple.security.network.client</key>
<true/>
<key>com.apple.security.files.user-selected.read-only</key>
<true/>
```

---

## 💡 How It Works

1. User uploads a PDF or pastes CV text
2. Text is extracted from the PDF using Syncfusion
3. Text is sent to Claude claude-opus-4-6 via the Anthropic API
4. Claude returns a structured JSON analysis
5. The app parses and displays results across 6 feature tabs
6. Results are saved locally using SharedPreferences

---

## 🔐 Privacy

- Your API key is stored **only on your device** via SharedPreferences
- CV text is sent **directly to Anthropic's API** — not stored by this app
- No analytics, no tracking, no third-party servers

---

## 🎨 Design

- **Theme:** Dark, professional, teal & purple accent
- **Fonts:** Space Grotesk (headings) + Inter (body) + JetBrains Mono (code)
- **Colors:** `#0D1117` background, `#00D4A8` primary, `#7C3AED` accent
- **Animations:** `flutter_animate` for staggered reveals, counters, shimmer

---

## 📄 License

Free to use for personal and educational projects.
