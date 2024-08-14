
class Validators {
  // static String? validateEmail(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Email is required';
  //   }
  //   if (!AppConstants.emailRegex.hasMatch(value)) {
  //     return 'Enter a valid email address';
  //   }
  //   return null;
  // }

  // static String? validatePassword(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Password is required';
  //   }
  //   if (value.length < 6) {
  //     return 'Password must be at least 6 characters long';
  //   }
  //   return null;
  // }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Enter a valid 10-digit phone number';
    }
    return "";
  }

  // static String? validateName(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Name is required';
  //   }
  //   if (value.length < 2) {
  //     return 'Name must be at least 2 characters long';
  //   }
  //   return null;
  // }

  // static String? validateNotEmpty(String? value, String fieldName) {
  //   if (value == null || value.isEmpty) {
  //     return '$fieldName is required';
  //   }
  //   return null;
  // }

  // static String? validatePincode(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Pincode is required';
  //   }
  //   if (value.length != 6 || int.tryParse(value) == null) {
  //     return 'Enter a valid 6-digit pincode';
  //   }
  //   return null;
  // }

  // static String? validateOTP(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'OTP is required';
  //   }
  //   if (value.length != 6 || int.tryParse(value) == null) {
  //     return 'Enter a valid 6-digit OTP';
  //   }
  //   return null;
  // }
}