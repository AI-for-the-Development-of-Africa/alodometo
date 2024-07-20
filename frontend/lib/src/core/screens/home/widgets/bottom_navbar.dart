import 'package:alo_do_me_to/src/core/providers/bottom_navbar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavbarProvider);

    return BottomNavigationBar(
      // backgroundColor: Theme.of(context).colorScheme.primary,
      // showSelectedLabels: false,
      showUnselectedLabels: true,
      currentIndex: selectedIndex,
      unselectedItemColor: Colors.black,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      onTap: (index) => ref.read(bottomNavbarProvider.notifier).setIndex(index),
      items:  const [
        BottomNavigationBarItem(
          // backgroundColor: Theme.of(context).colorScheme.primary,
          icon: Icon(Iconsax.home, ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          // backgroundColor: Theme.of(context).colorScheme.primary,
          icon: Icon(Iconsax.microphone, ),
          label: 'Audio',
        ),
        BottomNavigationBarItem(
          // backgroundColor: Theme.of(context).colorScheme.primary,
          icon: Icon(Iconsax.camera, ),
          label: 'Camera',
        ),
        // BottomNavigationBarItem(
        //   // backgroundColor: Theme.of(context).colorScheme.primary,
        //   icon: Icon(Iconsax.people, ),
        //   label: 'Profil',
        // ),
      ],
    );
  }
}
