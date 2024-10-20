import 'package:alo_do_me_to/src/core/providers/theme_provider.dart';
import 'package:alo_do_me_to/src/core/screens/onboarding_screen.dart';
import 'package:alo_do_me_to/src/core/themes/dark_mode.dart';
import 'package:alo_do_me_to/src/core/themes/light_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',  
      theme: lightMode,
      darkTheme: darkMode,
      themeMode: themeMode,
      home: const OnboardingScreen(),
    );
  }
}
