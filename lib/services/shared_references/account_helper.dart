import 'dart:io';

import 'package:vietqr_sms/commons/utils/log_utils.dart';
import 'package:vietqr_sms/main.dart';
import 'package:vietqr_sms/models/account_information_dto.dart';
import 'package:vietqr_sms/models/info_user_dto.dart';

class AccountHelper {
  const AccountHelper._privateConstructor();

  static const AccountHelper _instance = AccountHelper._privateConstructor();

  static AccountHelper get instance => _instance;

  Future<void> initialAccountHelper() async {
    await sharedPrefs.setString('TOKEN', '');
    await sharedPrefs.setString('FCM_TOKEN', '');
  }

  Future<void> setToken(String value) async {
    await sharedPrefs.setString('TOKEN', value);
  }

  String getToken() {
    return sharedPrefs.getString('TOKEN')!;
  }

  Future<void> setFcmToken(String token) async {
    await sharedPrefs.setString('FCM_TOKEN', token);
  }

  String getFcmToken() {
    return sharedPrefs.getString('FCM_TOKEN')!;
  }

  Future<void> setLoginAccount(List<String> list) async {
    await sharedPrefs.setStringList('LOGIN_ACCOUNT', list);
  }

  List<InfoUserDTO> getLoginAccount() {
    return ListLoginAccountDTO.fromJson(
            sharedPrefs.getStringList('LOGIN_ACCOUNT'))
        .list;
  }

  Future<void> setAccountInformation(AccountInformationDTO dto) async {
    await sharedPrefs.setString(
        'ACCOUNT_INFORMATION', dto.toSPJson().toString());
  }

  //get user device IP address
  Future<String> getIPAddress() async {
    String result = '';
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          // kiểm tra xem địa chỉ IP có phải là IPv4 hay không
          if (addr.type == InternetAddressType.IPv4 && !addr.isLinkLocal) {
            result = addr.address;
          }
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
