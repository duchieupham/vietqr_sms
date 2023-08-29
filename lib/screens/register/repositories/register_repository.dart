import 'dart:convert';

import 'package:vietqr_sms/commons/enum/enum.dart';
import 'package:vietqr_sms/commons/utils/log_utils.dart';
import 'package:vietqr_sms/core/base_api.dart';
import 'package:vietqr_sms/core/env/env_config.dart';
import 'package:vietqr_sms/models/account_login_dto.dart';
import 'package:vietqr_sms/models/response_message_dto.dart';

class RegisterRepository {
  const RegisterRepository();

  Future<ResponseMessageDTO> register(AccountLoginDTO dto) async {
    ResponseMessageDTO result =
        const ResponseMessageDTO(status: '', message: '');
    try {
      final String url = '${EnvConfig.getBaseUrl()}accounts-sms/register';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: dto.toJson(),
        type: AuthenticationType.NONE,
      );
      if (response.statusCode == 200 || response.statusCode == 400) {
        var data = jsonDecode(response.body);
        result = ResponseMessageDTO.fromJson(data);
      } else {
        result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
      }
    } catch (e) {
      LOG.error(e.toString());
      result = const ResponseMessageDTO(status: 'FAILED', message: 'E05');
    }
    return result;
  }
}
