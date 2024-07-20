import 'package:alo_do_me_to/src/core/themes/font_sizes.dart';
import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    shadowColor: Color(0xff625b5b),
  ),
  colorScheme: const ColorScheme.dark(
      background: Color(0xff000000),
      primary: Color(0xff3369FF),
      secondary: Color(0xffEEEEEE)),
  textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Color(0xffEEEEEE),
      ),
      titleSmall: TextStyle(
        color: Color(0xff000000),
      ),
      bodyMedium:
          TextStyle(color: Color(0xffEEEEEE), fontSize: FontSizes.small),
      bodySmall:
          TextStyle(color: Color(0xff000000), fontSize: FontSizes.small)),
);
