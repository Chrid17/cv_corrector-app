# CV Analyzer Pro

A professional Flutter application that analyzes, corrects, and improves CVs/Resumes. Built with clean architecture, a beautiful dark UI, and packed with career features.

---

## Features

| Feature | Description |
|---|---|
| PDF & TXT Upload | Pick and read PDF or text CV files directly |
| Paste CV Text | Paste raw CV text for instant analysis |
| ATS Score | Get an ATS compatibility score (0-100) with verdict |
| Grammar & Correction | Detailed before/after corrections with reasons |
| Keyword Analysis | See missing and present keywords for ATS |
| Skills Analysis | Technical & soft skills breakdown + recommendations |
| Cover Letter Generator | Generates a personalized cover letter from your CV |
| Cover Letter Review | Upload your existing cover letter for scoring and improvement |
| Job Description Matching | Upload a JD to get tailored CV corrections and match scores |
| Company Insights | Research-based company intel from job descriptions |
| Mock Interview Q&A | Role-specific interview questions with sample answers |
| Learning Path | Personalized skill gap analysis with resources |
| PDF Download | Download corrected CVs and cover letters as PDF |
| History | All past analyses saved locally — swipe to delete |
| Copy & Share | Copy reports and cover letters with one tap |

---

## Getting Started

### Prerequisites
- Flutter SDK 3.2.0 or later
- Dart 3.2.0 or later

### 1. Clone the project
```bash
git clone https://github.com/Chrid17/cv_corrector-app.git
cd cv_corrector-app
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
- Open the app → long-press the app title to open **Settings**
- Enter your Groq API key
- Tap **Save API Key**

---

## Supported Platforms

| Platform | Status |
|---|---|
| Web | Supported |
| Windows | Supported |
| Android | Supported |
| iOS | Supported |
| macOS | Supported |
| Linux | Supported |

---

## Tech Stack

| Category | Package |
|---|---|
| State Management | `provider` |
| HTTP | `http` |
| File Picking | `file_picker` |
| PDF Reading | `syncfusion_flutter_pdf` |
| PDF Generation | `syncfusion_flutter_pdf` |
| Animations | `flutter_animate` |
| Fonts | `google_fonts` |
| Progress Indicators | `percent_indicator` |
| Local Storage | `shared_preferences` |
| UUID | `uuid` |

---

## Privacy

- Your API key is stored **only on your device**
- CV text is processed securely — never stored on any server
- No analytics, no tracking, no third-party data collection

---

## License

Free to use for personal and educational projects.
