import 'package:flutter/material.dart';
import 'package:mydukaanapp2/screens/main_Screen.dart';
import 'package:provider/provider.dart';
import '../config/app_config.dart';
import '../providers/misc_provider.dart';
import '../utils/app_colors.dart';
import '../utils/validators.dart';
import '../utils/helpers.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_loader.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _phoneError="";

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MiscProvider>(
        builder: (context, miscProvider, child) {
      if (miscProvider.logo == null || miscProvider.colors == null) {
        return CustomLoader();
      }
      else {
        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 40),
                       Image.network(
                           AppConfig.baseUrl+miscProvider.logo!.logoImage,
                          width: MediaQuery.of(context).size.width / 3,
                          height: MediaQuery.of(context).size.width / 3,
                        ),
                        SizedBox(height: 30),
                        Text(
                          "Enter your Mobile Number",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge
                        ),
                        SizedBox(height: 20),
                        Text(
                          "We will send SMS with a verification\n code on this number",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                        ),
                        SizedBox(height: 15),
                        Form(
                          key: _formKey,
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.lightTextColor
                                  ),
                                  color:AppColors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    "+91  ",
                                    style: Theme.of(context).textTheme.displayLarge
                                  ),
                                ),
                              ),
                              SizedBox(width: 5,),
                              Expanded(
                                child: TextFormField(
                                  controller: _phoneController,
                                  style: Theme.of(context).textTheme.titleLarge,
                                  decoration: InputDecoration(
                                      hintText: 'Phone Number',
                                      hintStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.lightTextColor),
                                      border: OutlineInputBorder(borderRadius:BorderRadius.circular(7),borderSide: BorderSide(color: AppColors.lightTextColor)),
                                      enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(7),borderSide: BorderSide(color: AppColors.lightTextColor)),
                                      focusedBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(7),borderSide: BorderSide(color: AppColors.lightTextColor)),
                                      disabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(7),borderSide: BorderSide(color: AppColors.lightTextColor)),
                                      filled: true,
                                      fillColor: AppColors.white,
                                     //contentPadding: EdgeInsets.all(8)
                                    ),
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    final error = Validators.validatePhone(value);
                                    setState(() => _phoneError = error!);
                                    // return error;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_phoneError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              _phoneError!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        SizedBox(height: 20),
                        Expanded(
                          child: Container(), // This acts as a spacer
                        ),
                        CustomButton(
                          text: "SEND OTP",
                          onPressed: _handleLogin,
                          backgroundColor: miscProvider.headerColor,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Continue as a guest",
                              style: Theme.of(context).textTheme.titleMedium
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    })
    );
  }

  void _handleLogin() async {
    print(_formKey.currentState!.validate());
    print("_phoneError==$_phoneError");
    if (_formKey.currentState!.validate()&&_phoneError =="") {
      // Helpers.showLoadingDialog(context);
      try {
        // final authProvider = Provider.of<AuthProvider>(context, listen: false);
        // await authProvider.sendOtp(_phoneController.text);
        // Helpers.hideLoadingDialog(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(mobileNo: _phoneController.text),
          ),
        );
      } catch (e) {
        Helpers.hideLoadingDialog(context);
        Helpers.showToast('Failed to send OTP: ${e.toString()}');
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}