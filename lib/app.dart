import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/misc_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/app_colors.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<MiscProvider>(
      builder: (context, miscProvider, _) {
        return Theme(
          data: ThemeData(
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: miscProvider.fontColor,
              displayColor: miscProvider.fontColor,
            ),
            primaryTextTheme: Theme.of(context).textTheme.apply(
              bodyColor: miscProvider.fontColor,
              displayColor: miscProvider.fontColor,
            ),
          ),
          child: MaterialApp(
            theme: ThemeData(
              primaryColor: miscProvider.headerColor,
                iconTheme: IconThemeData(color: miscProvider.selectedOptionColor),
                // scaffoldBackgroundColor: miscProvider.ex,
              appBarTheme: AppBarTheme(
                color: miscProvider.headerColor,
                titleTextStyle: GoogleFonts.inter(
                  color: miscProvider.fontColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                iconTheme: IconThemeData(color: miscProvider.fontColor),
              ),
              textTheme: TextTheme(
                displayLarge: GoogleFonts.inter(
                  fontSize: 18,
                  color: AppColors.lightgrey,
                  fontWeight: FontWeight.w600,
                  height: 1.19, // line height 23.87px divided by font size 20px
                  letterSpacing: 1,
                ),
                titleLarge: GoogleFonts.inter(
                  fontSize: 14,
                  color: miscProvider.fontColor,
                  fontWeight: FontWeight.w500,
                  height: 1.19, // line height 23.87px divided by font size 20px
                  letterSpacing: 1,
                ),
                titleMedium: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.lightgrey,
                  fontWeight: FontWeight.w500,
                  height: 1.19, // line height 23.87px divided by font size 20px
                  letterSpacing: 1,
                ),
                titleSmall: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: miscProvider.fontColor,
                    letterSpacing: 1
                ),
                headlineLarge: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: miscProvider.fontColor,
                  height: 1.19, // line height 23.87px divided by font size 20px
                  letterSpacing: 1,
                ),
                headlineMedium: GoogleFonts.inter(
                  fontSize: 18,
                  color: miscProvider.fontColor,
                  height: 1.19, // line height 23.87px divided by font size 20px
                  letterSpacing: 1,
                ),

              )
            ),
            home: SplashScreen(),
          ),
        );
      },
    );
  }
}