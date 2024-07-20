import 'package:alo_do_me_to/src/core/providers/bottom_navbar_provider.dart';
import 'package:alo_do_me_to/src/core/screens/audio/audio_screen.dart';
import 'package:alo_do_me_to/src/core/screens/camera/camera_screen.dart';
import 'package:alo_do_me_to/src/core/screens/home/welcome_screen.dart';
import 'package:alo_do_me_to/src/core/screens/home/widgets/bottom_navbar.dart';
import 'package:alo_do_me_to/src/core/screens/home/widgets/custom_drawer.dart';
import 'package:alo_do_me_to/src/core/screens/home/widgets/spider_drawer.dart';
import 'package:alo_do_me_to/src/core/screens/profil/profil_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavbarProvider);
    final screens = [
      const WelcomeScreen(),
       AudioScreen(),
       CameraScreen(),
      const ProfilScreen()
    ];
    return Scaffold(
      appBar: AppBar(
        title: RichText(
            text: TextSpan(
              text: 'Alo Do ',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Aesthetic'),
              children: [
                TextSpan(
                  text: 'Me To',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Aesthetic'),
                )
              ],
            ),
          ),
          centerTitle: true,
          elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      drawer: const SpiderDrawer(),
      body: screens[selectedIndex],
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
