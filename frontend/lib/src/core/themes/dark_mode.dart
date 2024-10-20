import 'package:alo_do_me_to/src/core/themes/font_sizes.dart';
import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    shadowColor: Colors.white,
  ),
  colorScheme: const ColorScheme.dark(
      surface: Color(0xffffffff),
      primary: Color(0xff181145),
      secondary: Color(0xff133889)),
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
