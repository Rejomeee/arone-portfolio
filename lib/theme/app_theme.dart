import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/style.dart';

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: kMainColor,
      primary: kMainColor,
      secondary: kAccentColor,
    ),
    scaffoldBackgroundColor: kBackgroundColor,
  );

  return base.copyWith(
    textTheme: GoogleFonts.manropeTextTheme(base.textTheme),
    splashFactory: InkSparkle.splashFactory,
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: kButtonColor,
        foregroundColor: kColorWhite,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
  );
}
