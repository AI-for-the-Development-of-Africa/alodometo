import 'package:alo_do_me_to/src/core/screens/home/widgets/drawer_header.dart';
import 'package:alo_do_me_to/src/core/screens/profil/profil_screen.dart';
import 'package:flutter/material.dart';

class SpiderDrawer extends StatelessWidget {
  const SpiderDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const Header(),
          // ListTile(
          //   leading: const Icon(Icons.person_2_outlined),
          //   title: const Text("Mon profil"),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const ProfilScreen(),
          //         ),
          //       );
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Langues"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: const Text("Mon abonnement"),
            onTap: () {},
          ),
          // ListTile(
          //   leading: const Icon(Icons.bookmark_border),
          //   title: const Text("Ma sauvegarde"),
          //   onTap: () {},
          // ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text("Paramètres"),
            onTap: () {},
          ),
          const Divider(color: Colors.black),
          // ListTile(
          //   leading: const Icon(Icons.person_add_outlined),
          //   title: const Text("Inviter des amis"),
          //   onTap: () {},
          // ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("Fonctionnalités"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}