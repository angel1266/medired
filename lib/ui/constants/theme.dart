import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';

class AppTheme {
  ThemeData get themeData => ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Outfit',
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.greenBackground,
          onPrimary: Colors.white,
          secondary: AppColors.blueBackground,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            labelStyle: const TextStyle(
              color: AppColors.blueBackground,
              fontWeight: FontWeight.bold,
            ),
            floatingLabelStyle: const TextStyle(
              color: AppColors.blueBackground,
              fontWeight: FontWeight.bold,
            ),
            helperStyle: const TextStyle(
              color: AppColors.blueBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(8),
          hintStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(33, 57, 118, 0.4),
          ),
          filled: true,
          fillColor: const Color.fromRGBO(255, 255, 255, 0.7),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 1.0),
            borderRadius: BorderRadius.circular(20),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
}
