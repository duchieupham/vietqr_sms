import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rxdart/subjects.dart';
import 'package:vietqr_sms/commons/enum/enum.dart';
import 'package:vietqr_sms/commons/utils/log_utils.dart';
import 'package:vietqr_sms/commons/utils/string_utils.dart';
import 'package:vietqr_sms/core/base_api.dart';
import 'package:vietqr_sms/core/env/env_config.dart';
import 'package:vietqr_sms/models/account_information_dto.dart';
import 'package:vietqr_sms/models/account_login_dto.dart';
import 'package:vietqr_sms/models/code_login_dto.dart';
import 'package:vietqr_sms/models/info_user_dto.dart';
import 'package:vietqr_sms/models/response_message_dto.dart';
import 'package:vietqr_sms/services/shared_references/account_helper.dart';

class LoginRepository {
  static final codeLoginController = BehaviorSubject<CodeLoginDTO>();

  const LoginRepository();

  Future<bool> login(AccountLoginDTO dto) async {
    bool result = false;
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      String url = '${EnvConfig.getBaseUrl()}accounts-sms';
      String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
      String platform = '';
      String device = '';
      if (!StringUtils.isWeb()) {
        if (StringUtils.isIOsApp()) {
          platform = 'IOS';
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          device =
              '${iosInfo.name.toString()} ${iosInfo.systemVersion.toString()}';
        } else if (StringUtils.isAndroidApp()) {
          platform = 'ANDROID';
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          device = androidInfo.model.toString();
        }
      } else {
        platform = 'Web';
        WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
        device = webBrowserInfo.userAgent.toString();
      }
      AccountLoginDTO loginDTO = AccountLoginDTO(
        phoneNo: dto.phoneNo,
        password: dto.password,
        device: device,
        fcmToken: fcmToken,
      );
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: loginDTO.toJson(),
        type: AuthenticationType.NONE,
      );
      if (response.statusCode == 200) {
        String token = response.body;
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        AccountInformationDTO accountInformationDTO =
            AccountInformationDTO.fromJson(decodedToken);
        await AccountHelper.instance.setToken(token);
        await AccountHelper.instance
            .setAccountInformation(accountInformationDTO);
        await AccountHelper.instance.setUserId(accountInformationDTO.smsId);
        result = true;
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future checkExistPhone(String phone) async {
    try {
      String url = '${EnvConfig.getBaseUrl()}accounts-sms/search/$phone';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.NONE,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          return InfoUserDTO.fromJson(data);
        }
      } else {
        var data = jsonDecode(response.body);
        if (data != null) {
          return ResponseMessageDTO(
              status: data['status'], message: data['message']);
        }
      }
    } catch (e) {
      LOG.error(e.toString());
      return false;
    }
  }
}
