import 'package:flutter/material.dart';
import 'package:vietqr_sms/commons/utils/string_utils.dart';
import 'package:vietqr_sms/models/info_user_dto.dart';
import 'package:vietqr_sms/services/shared_references/account_helper.dart';

class LoginProvider with ChangeNotifier {
  bool isEnableButton = false;
  bool isButtonLogin = false;
  String phone = '';
  String? errorPhone;

  InfoUserDTO? infoUserDTO;
  List<InfoUserDTO> listInfoUsers = [];

  //0: trang login ban đầu
  // 1: trang login gần nhất
  //2 : quickLogin
  int isQuickLogin = 0;

  init() async {
    listInfoUsers = AccountHelper.instance.getLoginAccount();
    if (listInfoUsers.isNotEmpty) {
      isQuickLogin = 1;
    }
    notifyListeners();
  }

  void updateListInfoUser() async {
    listInfoUsers = AccountHelper.instance.getLoginAccount();
    notifyListeners();
  }

  void updateInfoUser(value) {
    infoUserDTO = value;
    notifyListeners();
  }

  void updateQuickLogin(value) {
    isQuickLogin = value;
    notifyListeners();
  }

  void updateIsEnableBT(value) {
    isEnableButton = value;
    notifyListeners();
  }

  void updateBTLogin(value) {
    isButtonLogin = value;
    notifyListeners();
  }

  void updatePhone(String value) {
    phone = value.replaceAll(" ", "");

    if (phone.length == 9) {
      if (phone[0] != '0') {
        phone = '0$phone';
      }
    }
    errorPhone = StringUtils.validatePhone(phone);
    if (errorPhone != null || value.isEmpty) {
      isEnableButton = false;
    } else {
      isEnableButton = true;
    }

    notifyListeners();
  }
}
