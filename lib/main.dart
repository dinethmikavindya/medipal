import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'screens/choice_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/bmi_screen.dart';
import 'screens/home_page.dart';
import 'screens/note_page.dart';
import 'screens/reminder_page.dart';
import 'screens/records_page.dart';
import 'screens/settings.dart';
import 'screens/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Hive for local storage
  await Hive.initFlutter();
  await Hive.openBox('medipalBox');
  
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
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFEAFE63),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          ThemeData.light().textTheme,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/choice': (context) => const ChoiceScreen(),
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/bmi': (context) => const BMIScreen(),
        '/home': (context) => const HomeScreen(),
        '/notes': (context) => const NotePage(),
        '/reminders': (context) => const ReminderPage(),
        '/records': (context) => const RecordsPage(),
        '/settings': (context) => const SettingsPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}