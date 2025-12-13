import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Screens
import 'screens/splash_screen.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('medipalBox');  // User data, vitals, etc.
  await Hive.openBox('notesBox');    // Notes storage

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
      routes: {
        '/': (context) => const SplashScreen(),
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
      },
    );
  }
}
