import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Screens
import 'screens/choice_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/bmi_screen.dart';
import 'screens/medicaldetail_screen.dart';
import 'screens/home_page.dart';
import 'screens/note_page.dart';
import 'screens/reminder_page.dart';
import 'screens/records_page.dart';
import 'screens/settings.dart';
import 'screens/profile.dart';
import 'screens/data_security_screen.dart';
import 'screens/add_reminder_page.dart';
import 'screens/role_router.dart';
import 'screens/caregiver/link_patient_screen.dart';
import 'screens/caregiver_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).timeout(const Duration(seconds: 10));
  } catch (e) {
    debugPrint('Firebase init failed: $e');
  }

  // Configure Firestore
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('medipalBox');
  await Hive.openBox('notesBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MediPal',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEAFE63),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            return MaterialPageRoute(builder: (_) => const RoleRouter());
          } else {
            return MaterialPageRoute(builder: (_) => const ChoiceScreen());
          }
        }
        return null;
      },
      routes: {
        '/choice': (context) => const ChoiceScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/bmi': (context) => const BMIScreen(),
        '/medical': (context) => const MedicalDetailScreen(),
        '/home': (context) => const HomeScreen(),
        '/notes': (context) => const NotePage(),
        '/reminders': (context) => const ReminderPage(),
        '/records': (context) => const RecordsPage(),
        '/settings': (context) => const SettingsPage(),
        '/profile': (context) => const ProfilePage(),
        '/dataSecurity': (context) => const DataSecurityScreen(),
        '/addReminder': (context) => const AddReminderPage(),
        '/linkPatient': (context) => const LinkPatientScreen(),
        '/caregiverHome': (context) => const CaregiverHomeScreen(),
      },
    );
  }
}