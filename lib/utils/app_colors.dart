import 'package:flutter/material.dart';

class AppColors {
  // Static colors
  static const Color primaryColor = Color(0xFF4CAF50);  // Green
  static const Color accentColor = Color(0xFFFFA000);   // Orange
  static const Color backgroundColor = Color(0xFFEBEFEA);
  static const Color lightgrey = Color(0xFF8F9593);
  static const Color textColor = Color(0xFF333333);  // Dark Grey
  static const Color lightTextColor = Color(0xFFD4DFDB);  // Medium Grey
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Dynamic colors (will be updated from backend)
  static Color headerColor = Color(0xFF10A1EA);
  static Color footerColor = Color(0xFFA59F5F);
  static Color sidebarColor = Color(0xFFC2B8F4);
  static Color extraColor = Color(0xFFA3629D);
  static Color wishListColor = Color(0xFFAD18AF);
  static Color fontColor = Color(0xFFC73333);
  static Color selectedOptionColor = Color(0xFF6A4375);

  static void updateDynamicColors({
    required Color header,
    required Color footer,
    required Color sidebar,
    required Color extra,
    required Color wishList,
    required Color font,
    required Color selectedOption,
  }) {
    headerColor = header;
    footerColor = footer;
    sidebarColor = sidebar;
    extraColor = extra;
    wishListColor = wishList;
    fontColor = font;
    selectedOptionColor = selectedOption;
  }
}