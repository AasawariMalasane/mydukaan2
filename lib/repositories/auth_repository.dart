import 'package:firebase_messaging/firebase_messaging.dart';

import '../config/app_config.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';
import '../config/api_endpoints.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiService _apiService;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  AuthRepository(this._apiService);


  // Future<String> sendOtp(String phoneNumber) async {
  //   try {
  //     Completer<String> completer = Completer<String>();
  //
  //     await _auth.verifyPhoneNumber(
  //       phoneNumber: '+91$phoneNumber',
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         // Auto-retrieval or instant verification
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         completer.completeError(e);
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         completer.complete(verificationId);
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         // Auto-retrieval timeout
  //       },
  //     );
  //     return completer.future;
  //   } catch (e) {
  //     throw Exception("Failed to send OTP: ${e.toString()}");
  //   }
  // }
  //
  // Future<String> verifyOtp(String verificationId, String otp) async {
  //   try {
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: verificationId,
  //       smsCode: otp,
  //     );
  //
  //     UserCredential userCredential = await _auth.signInWithCredential(credential);
  //     return await userCredential.user!.getIdToken();
  //   } catch (e) {
  //     throw Exception("Failed to verify OTP: ${e.toString()}");
  //   }
  // }

  // Future<String> getFcmToken() async {
  //   try {
  //     String? token = await _firebaseMessaging.getToken();
  //     if (token == null) {
  //       throw Exception("Failed to get FCM token");
  //     }
  //     return token;
  //   } catch (e) {
  //     throw Exception("Error getting FCM token: ${e.toString()}");
  //   }
  // }

  Future<UserModel> login(String phoneNumber, String otpVerification, String fireBaseToken) async {
    final response = await _apiService.post(
      ApiEndpoints.login,
      body: {
        "phoneNumber": phoneNumber,
        "otpVerification": otpVerification,
        "fireBaseToken": fireBaseToken,
        "vendorId": AppConfig.vendorId
      },
    );
    return UserModel.fromJson(response['data'][0]);
  }

  Future<UserModel> editProfile(String id, Map<String, dynamic> profileData) async {
    final response = await _apiService.patch(
      ApiEndpoints.editProfile(id),
      body: profileData,
    );
    return UserModel.fromJson(response['data'][0]);
  }

  Future<UserModel> getProfile(String id) async {
    final response = await _apiService.get(ApiEndpoints.getProfile(id));
    return UserModel.fromJson(response['data'][0]);
  }

  Future<void> signOut(String id, String fireBaseToken) async {
    await _apiService.patch(
      ApiEndpoints.signOut(id),
      body: {"fireBaseToken": fireBaseToken},
    );
  }
}