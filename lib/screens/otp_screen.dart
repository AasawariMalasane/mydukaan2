import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../config/app_config.dart';
import '../providers/auth_provider.dart';
import '../providers/misc_provider.dart';
import '../utils/app_colors.dart';
import '../utils/helpers.dart';
import '../widgets/custom_button.dart';
import 'main_Screen.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNo;

  OtpScreen({Key? key, required this.mobileNo}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  String currentText = "";
  int secondsRemaining = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    startTimer();
  }

  @override
  void dispose() {
    errorController?.close();
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final miscProvider = Provider.of<MiscProvider>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 40),
              Image.network(
                AppConfig.baseUrl+miscProvider.logo!.logoImage,
                width: MediaQuery.of(context).size.width / 3,
                height: MediaQuery.of(context).size.width / 3,
              ),
              SizedBox(height: 30),
              Text(
                  "VERIFICATION",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  "Please enter the 6-digit OTP sent to your registered mobile number \n +91 ${widget.mobileNo}",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    obscureText: true,
                    obscuringCharacter: '*',
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                      activeColor: AppColors.headerColor,
                      inactiveColor: Colors.grey,
                      selectedColor: AppColors.headerColor,
                    ),
                    cursorColor: Colors.black,
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    errorAnimationController: errorController,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        currentText = value;
                      });
                    },
                    beforeTextPaste: (text) {
                      return true;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomButton(
                text: "CONFIRM OTP",
                onPressed: currentText.length < 6 ? null : _verifyOtp,
                backgroundColor: currentText.length < 6?AppColors.lightgrey:miscProvider.headerColor,
              ),
              SizedBox(height: 20),
              Text("${secondsRemaining}s", style: TextStyle(fontWeight: FontWeight.w500)),
              TextButton(
                onPressed: secondsRemaining <= 0 ? _resendOtp : null,
                child: Text(
                  "Resend OTP",
                  style: TextStyle(
                    color: secondsRemaining <= 0 ? AppColors.headerColor : Colors.grey,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _verifyOtp() async {
    if (formKey.currentState!.validate()) {
      Helpers.showLoadingDialog(context);
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.verifyOtp(widget.mobileNo, currentText);
        Helpers.hideLoadingDialog(context);
        if (authProvider.isLoggedIn) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen(),));
        } else {
          Helpers.showToast('OTP verification failed');
        }
      } catch (e) {
        Helpers.hideLoadingDialog(context);
        Helpers.showToast('Error: ${e.toString()}');
      }
    }
  }

  void _resendOtp() async {
    Helpers.showLoadingDialog(context);
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.resendOtp(widget.mobileNo);
      Helpers.hideLoadingDialog(context);
      Helpers.showToast('OTP resent successfully');
      setState(() {
        secondsRemaining = 60;
        startTimer();
      });
    } catch (e) {
      Helpers.hideLoadingDialog(context);
      Helpers.showToast('Failed to resend OTP: ${e.toString()}');
    }
  }
}