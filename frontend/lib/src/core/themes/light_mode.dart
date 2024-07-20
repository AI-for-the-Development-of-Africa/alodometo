import 'package:alo_do_me_to/src/core/themes/font_sizes.dart';
import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    shadowColor: Colors.white,
  ),
  colorScheme: const ColorScheme.light(
      background: Color(0xffffffff),
      primary: Color(0xff98198E),
      secondary: Color(0xffEC058E)),
  inputDecorationTheme:
      const InputDecorationTheme(labelStyle: TextStyle(color: Colors.blue)),
  textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Color(0xff000000),
      ),
      titleSmall: TextStyle(
        color: Color(0xff000000),
      ),
      bodyMedium:
          TextStyle(color: Color(0xffEEEEEE), fontSize: FontSizes.small),
      bodySmall:
          TextStyle(color: Color(0xff000000), fontSize: FontSizes.small)),
);
