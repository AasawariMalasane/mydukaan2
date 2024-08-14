import 'package:flutter/foundation.dart';
import '../repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../utils/auth_storage.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;

  UserModel? _user;
  bool _isLoading = false;
  String? _error;
  String? _verificationId;

  AuthProvider(this._authRepository) {
    _initializeAuthState();
  }

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  Future<void> _initializeAuthState() async {
    final isLoggedIn = await AuthStorage.isLoggedIn();
    if (isLoggedIn) {
      final userId = await AuthStorage.getUserId();
      final authToken = await AuthStorage.getAuthToken();
      if (userId != null && authToken != null) {
        _user = UserModel(userId: userId, authenticationToken: authToken);
        notifyListeners();
      }
    }
  }


  Future<void> sendOtp(String phoneNumber) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // _verificationId = await _authRepository.sendOtp(phoneNumber);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // final fireBaseToken = await _authRepository.verifyOtp(_verificationId!, otp);
      // String fcmToken = await _authRepository.getFcmToken();
      await login(phoneNumber, "true", "abc");
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String phoneNumber, String otpVerification, String fireBaseToken) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _user = await _authRepository.login(phoneNumber, otpVerification, fireBaseToken);
      await AuthStorage.setLoggedIn(true);
      await AuthStorage.setUserId(_user!.userId);
      await AuthStorage.setAuthToken(_user!.authenticationToken);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resendOtp(String phoneNumber) async {
    await sendOtp(phoneNumber);
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.signOut(_user!.userId, _user!.authenticationToken);
      await AuthStorage.clearAuthData();
      _user = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _authRepository.editProfile(_user!.userId, profileData);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}