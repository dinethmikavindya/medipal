import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'splash_screen.dart';
import 'choice_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('medipalBox'); // local storage for vitals, settings, etc.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediPal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/choice': (context) => const ChoiceScreen(),
        '/signup': (context) => const Placeholder(), // replace with SignUpScreen
        '/signin': (context) => const Placeholder(), // replace with SignInScreen
      },
    );
  }
}