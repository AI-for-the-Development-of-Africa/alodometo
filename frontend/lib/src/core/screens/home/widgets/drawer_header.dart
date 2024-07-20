import 'package:alo_do_me_to/src/core/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Header extends ConsumerStatefulWidget {
  const Header({
    super.key,
  });

  @override
  ConsumerState<Header> createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<Header> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeProvider);

    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: AssetImage("assets/images/drawer/chatbg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage("assets/images/drawer/me.jpg"),
              ),
              GestureDetector(
                child: (currentTheme == ThemeMode.dark)
                    ? Icon(
                        Icons.light_mode,
                        color: Theme.of(context).colorScheme.secondary,
                      )
                    : Icon(
                        Icons.dark_mode,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                onTap: () {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              )
            ],
          ),
          const SizedBox(height: 10),
          const Text("Hospice",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Row(
            children: [
              Icon(
                Icons.call,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
             Text("+229 66723308",
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
