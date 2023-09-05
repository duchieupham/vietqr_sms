import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vietqr_sms/commons/enum/enum.dart';
import 'package:vietqr_sms/commons/utils/log_utils.dart';
import 'package:vietqr_sms/commons/utils/navigator_utils.dart';
import 'package:vietqr_sms/core/base_api.dart';
import 'package:vietqr_sms/core/env/env_config.dart';
import 'package:vietqr_sms/models/response_message_dto.dart';
import 'package:vietqr_sms/services/shared_references/account_helper.dart';

class DashboardApi {
  const DashboardApi();

  Future<ResponseMessageDTO> checkValidToken() async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      String url = '${EnvConfig.getBaseUrl()}token-sms';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );

      if (response.statusCode == 403) {
        result =
            const ResponseMessageDTO(status: 'TOKEN_EXPIRED', message: 'E05');
      } else {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return result;
  }

  Future<bool> logout() async {
    bool result = false;
    try {
      final String url = '${EnvConfig.getBaseUrl()}accounts-sms/logout';
      String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: {'fcmToken': fcmToken},
        type: AuthenticationType.NONE,
      );
      if (response.statusCode == 200) {
        await _resetServices().then((value) => result = true);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<void> _resetServices() async {
    await AccountHelper.instance.initialAccountHelper();
  }
}
