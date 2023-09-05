import 'package:flutter/material.dart';

class RegisterProvider with ChangeNotifier {
  //error handler
  bool _isPhoneErr = false;
  bool _isPasswordErr = false;

  bool _isConfirmPassErr = false;

  final phoneNoController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPassController = TextEditingController();

  final introduceController = TextEditingController();

  final emailController = TextEditingController();

  final nameController = TextEditingController();

  get phoneErr => _isPhoneErr;

  get passwordErr => _isPasswordErr;

  get confirmPassErr => _isConfirmPassErr;

  String _verificationId = '';

  get verificationId => _verificationId;

  int? _resendToken;

  get resendToken => _resendToken;

  // final auth = FirebaseAuth.instance;

  static const String countryCode = '+84';

  int _page = 0;

  int get page => _page;

  void updateVerifyId(value) {
    _verificationId = value;
    notifyListeners();
  }

  void updateResendToken(value) {
    _resendToken = value;
    notifyListeners();
  }

  void updatePhone(String value) {
    String phone = value.replaceAll(" ", "");

    if (phone.isNotEmpty) {
      phoneNoController.value = phoneNoController.value.copyWith(text: phone);
      _isPhoneErr = false;
    } else {
      _isPhoneErr = true;
    }
    notifyListeners();
  }

  void updatePassword(String value) {
    if (value.isNotEmpty) {
      passwordController.value = passwordController.value.copyWith(text: value);
      _isPasswordErr = false;
    } else {
      _isPasswordErr = true;
    }
    notifyListeners();
  }

  void updateConfirmPassword(String value) {
    if (value == passwordController.text) {
      confirmPassController.value =
          confirmPassController.value.copyWith(text: value);
      _isConfirmPassErr = false;
    } else {
      _isConfirmPassErr = true;
    }
    notifyListeners();
  }

  void updateErrs({
    required bool phoneErr,
    required bool passErr,
    required bool confirmPassErr,
  }) {
    _isPhoneErr = phoneErr;
    _isPasswordErr = passErr;
    _isConfirmPassErr = confirmPassErr;
    notifyListeners();
  }

  bool isValidValidation() {
    return !_isPhoneErr && !_isPasswordErr && !_isConfirmPassErr;
  }

  bool isValid() {
    return !_isPhoneErr && !_isPasswordErr;
  }

  bool isEnableButton() {
    if (phoneNoController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPassController.text.isNotEmpty) {
      if (isValidValidation()) {
        return true;
      }
    }
    return false;
  }

  void reset() {
    _isPhoneErr = false;
    _isPasswordErr = false;
    _isConfirmPassErr = false;
    notifyListeners();
  }

  void updateIntroduce(String value) {
    introduceController.value = introduceController.value.copyWith(text: value);
    notifyListeners();
  }

  updatePage(int page) {
    _page = page;
    notifyListeners();
  }

  void updateEmail(String value) {
    if (value.isNotEmpty) {
      emailController.value = emailController.value.copyWith(text: value);
    } else {}
    notifyListeners();
  }

  void updateName(String value) {
    if (value.isNotEmpty) {
      nameController.value = nameController.value.copyWith(text: value);
    } else {}
    notifyListeners();
  }
}
