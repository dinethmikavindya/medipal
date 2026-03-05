# 🏥 MediPal – Digital Health Management Mobile Application

MediPal is a Flutter-based mobile health management application designed to help users manage personal health records, medications, reminders, and appointments efficiently.

This project is currently under development.

---

# 🚀 Technologies Used

- **Flutter** (Frontend Mobile Framework)
- **Dart**
- **Firebase Authentication**
- **Cloud Firestore**
- **Android Studio Emulator (Pixel 5)**
- **VS Code**
- **macOS (Apple Silicon)**

---

# 📦 Project Setup Instructions

Follow these steps to run the project on your emulator.

---

## ✅ 1. Prerequisites

Make sure the following are installed:

- Flutter SDK (Stable Version)
- Android Studio
- Android SDK
- Android Emulator (Pixel device recommended)
- VS Code (with Flutter & Dart extensions)
- Firebase project configured

To verify Flutter installation:

```bash
flutter doctor
All major sections should show ✓.
✅ 2. Clone the Repository
git clone <your-repository-link>
cd medipal1
Or open the project folder directly in VS Code.
✅ 3. Install Dependencies
Inside the project root folder:
flutter pub get
✅ 4. Firebase Configuration
Ensure:
google-services.json is inside:
android/app/
Firebase Authentication is enabled.
Firestore Database is created.
If you update Firebase settings:
flutter clean
flutter pub get
✅ 5. Start Android Emulator
Option A – From Android Studio
Open Android Studio
Go to Device Manager
Start your emulator (Recommended: Pixel 5)
Option B – From Terminal
List emulators:
flutter emulators
Launch emulator:
flutter emulators --launch Pixel_5
If emulator fails:
Open Android Studio once
Cold boot the emulator
Ensure virtualization is enabled
✅ 6. Run the Application
Once emulator is running:
flutter run
Or press F5 in VS Code.
🔐 Current Features Implemented
Firebase Authentication (Login / Register)
User session handling (User stays logged in)
Basic navigation structure
Firebase connection setup
Emulator testing configured
🧭 Project Structure Overview
lib/
│
├── main.dart
├── login.dart
├── register.dart
├── home.dart
├── services/
│   └── auth_service.dart
└── widgets/
🔄 Session Handling
Firebase automatically keeps users logged in.
main.dart checks:

FirebaseAuth.instance.currentUser
If user exists → Navigate to Home
If not → Navigate to Login
🛠️ Common Issues & Fixes
❌ Emulator exited with code 1
Open Android Studio once
Cold boot the emulator
Ensure Android SDK is updated
❌ Gradle Build Failed
flutter clean
flutter pub get
flutter run
❌ Firebase not connecting
Check google-services.json
Make sure SHA-1 key is added in Firebase Console
📌 Development Status
UI is basic for now.
Current focus: Functional implementation first.
UI/UX improvements will be done after completing core features.

📖 Useful Commands
flutter doctor
flutter clean
flutter pub get
flutter run
flutter devices
flutter emulators

flutter emulators
flutter emulators --launch Pixel_5

flutter clean
flutter pub get
flutter run


git add .
git commit -m "Your commit message"
git push