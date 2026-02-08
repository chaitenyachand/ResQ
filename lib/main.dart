import 'package:flutter/material.dart';

import 'theme/app_theme.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;

  runApp(ResQApp(seenOnboarding: seenOnboarding));
}

class ResQApp extends StatelessWidget {
  final bool seenOnboarding;
  const ResQApp({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResQ',
      theme: AppTheme.darkTheme,
      home: seenOnboarding ? const LoginScreen() : const OnboardingScreen(),
    );
  }
}
