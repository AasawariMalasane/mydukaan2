import 'package:flutter/material.dart';
import 'package:mydukaanapp2/config/app_config.dart';
import 'package:provider/provider.dart';
import '../providers/misc_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_loader.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  Future<void> _initialize() async {
    final miscProvider = Provider.of<MiscProvider>(context, listen: false);
    await Future.wait([
      miscProvider.fetchLogo(),
      miscProvider.fetchColors(),
    ]);
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MiscProvider>(
        builder: (context, miscProvider, child) {
          if (miscProvider.logo == null || miscProvider.colors == null) {
            return CustomLoader();
          } else {
            return Container(
              color: AppColors.extraColor,
              child: Center(
                child: Image.network(AppConfig.baseUrl+miscProvider.logo!.logoImage),
              ),
            );
          }
        },
      ),
    );
  }
}