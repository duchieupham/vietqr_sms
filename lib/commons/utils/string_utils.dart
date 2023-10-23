import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vietqr_sms/commons/enum/enum.dart';
import 'package:vietqr_sms/commons/enum/error_type.dart';
import 'package:vietqr_sms/commons/utils/navigator_utils.dart';

class StringUtils {
  static const String _phonePattern = r'^(?:[+0]9)?[0-9]{10}$';

  static String? validatePhone(String value) {
    RegExp regExp = RegExp(_phonePattern);
    if (value.isEmpty) {
      return null;
    } else if (!regExp.hasMatch(value)) {
      return 'Số điện thoại không đúng định dạng.';
    }
    return null;
  }

  static bool isNumeric(String text) {
    return int.tryParse(text) != null;
  }

  static bool isValidConfirmText(String text, String confirmText) {
    return text.trim() == confirmText.trim();
  }

  static bool? isValidatePhone(String value) {
    RegExp regExp = RegExp(_phonePattern);
    if (value.isEmpty || value.length > 10 || value.length < 10) {
      return true;
    } else if (!regExp.hasMatch(value)) {
      return true;
    }
    return false;
  }

  static String getErrorMessage(String message) {
    String result = '';
    ErrorType errorType =
        (ErrorType.values.toString().contains('ErrorType.$message') &&
                message != '')
            ? ErrorType.values.byName(message)
            : ErrorType.E04;

    switch (errorType) {
      case ErrorType.E01:
        result = 'Mật khẩu cũ không khớp';
        break;
      case ErrorType.E02:
        result = 'Tài khoản đã tồn tại';
        break;
      case ErrorType.E03:
        result = 'Không thể tạo tài khoản';
        break;
      case ErrorType.E04:
        result = 'Không thể thực hiện thao tác này. Vui lòng thử lại sau';
        break;
      case ErrorType.E05:
        result = 'Đã có lỗi xảy ra, vui lòng thử lại sau';
        break;
      case ErrorType.E06:
        result =
            'Không thể liên kết. Tài khoản ngân hàng này đã được thêm trước đó';
        break;
      case ErrorType.E07:
        result = 'Thành viên không tồn tài trong hệ thống';
        break;
      case ErrorType.E08:
        result = 'Thành viên đã được thêm vào tài khoản trước đó';
        break;
      case ErrorType.E09:
        result = 'Không thể thêm thành viên vào tài khoản';
        break;
      case ErrorType.E10:
        result = 'Không thể thêm mẫu nội dung chuyển khoản';
        break;
      case ErrorType.E11:
        result = 'Không thể xoá mẫu nội dung chuyển khoản';
        break;
      case ErrorType.E12:
        result =
            'Không thể liên kết. Tài khoản thanh toán này đã được thêm trước đó';
        break;
      case ErrorType.E13:
        result = 'Thêm tài khoản thanh toán thất bại';
        break;
      case ErrorType.E14:
        result = 'Không thể tạo doanh nghiệp';
        break;
      case ErrorType.E15:
        result = 'CMND/CCCD không hợp lệ';
        break;
      case ErrorType.E16:
        result = 'Trạng thái TK ngân hàng không hợp lệ';
        break;
      case ErrorType.E17:
        result = 'TK ngân hàng không hợp lệ';
        break;
      case ErrorType.E18:
        result = 'Tên chủ TK không hợp lệ';
        break;
      case ErrorType.E19:
        result = 'Số điện thoại không hợp lệ';
        break;
      case ErrorType.E20:
        result = 'TK ngân hàng không tồn tại';
        break;
      case ErrorType.E21:
        result = 'Có vấn đề xảy ra khi gửi OTP. Vui lòng thử lại sau';
        break;
      case ErrorType.E22:
        result = 'Không thể đăng ký nhận BĐSD. Vui lòng thử lại sau';
        break;
      case ErrorType.E23:
        result = 'TK đã đăng ký nhận BĐSD';
        break;
      case ErrorType.E46:
        result = 'Có vấn đề xảy ra khi thực hiện yêu cầu. Vui lòng thử lại sau';
        break;
      case ErrorType.E55:
        result = 'Xác nhận mật khẩu sai.';
        break;
      case ErrorType.E56:
        result = 'Hệ thống đang xảy ra vấn đề. Vui lòng thử lại sau.';
        break;
      case ErrorType.E57:
        result =
            'Số điện thoại không đúng định dạng. Vui lòng kiểm tra lại thông tin trên và thực hiện lại.';
        break;
      case ErrorType.E58:
        result =
            'Nhà mạng không hợp lệ. Vui lòng kiểm tra lại thông tin trên và thực hiện lại.';
        break;
      case ErrorType.E59:
        result = 'Hệ thống đang xảy ra vấn đề. Vui lòng thử lại sau.';
        break;
      case ErrorType.E60:
        result = 'Hệ thống đang xảy ra vấn đề. Vui lòng thử lại sau.';
        break;
      case ErrorType.E61:
        result =
            'Số dư VQR không đủ. Vui lòng nạp thêm VQR để thực hiện nạp tiền điện thoại';
        break;
      case ErrorType.E62:
        result = 'Giao dịch thất bại.';
        break;
      case ErrorType.E63:
        result = 'Hệ thống nạp tiền đang bảo trì. Vui lòng thử lại sau';
        break;
      case ErrorType.E64:
        result = 'Hệ thống nạp tiền đang bận. Vui lòng thử lại sau';
        break;
      case ErrorType.E65:
        result = 'Xác thực thất bại. Vui lòng thử lại sau';
        break;
      case ErrorType.E70:
        result = 'Phương thức thanh toán không hợp lệ';
        break;
      case ErrorType.C03:
        result = 'Tài khoản này đã được thêm trước đó';
        break;
      default:
        result = message;
    }
    return result;
  }

  static String getCheckMessage(String message) {
    String result = '';
    CheckType checkType =
        (CheckType.values.toString().contains('CheckType.$message') &&
                message != '')
            ? CheckType.values.byName(message)
            : CheckType.C02;
    switch (checkType) {
      case CheckType.C01:
        result = 'Tài khoản không tồn tại trong hệ thống';
        break;
      case CheckType.C02:
        result = 'Lỗi không xác định. Vui lòng thử lại sau';
        break;
      case CheckType.C03:
        result = 'TK ngân hàng này đã được liên kết trước đó';
        break;
      case CheckType.C04:
        result =
            'Không thể xoá TK. Tính năng đang bảo trì cho TK ngân hàng đã liên kết.';
        break;
      default:
        result = message;
    }
    return result;
  }

  static String formatPhoneNumberVN(String phoneNumber) {
    String numericString = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (numericString.length >= 10) {
      return phoneNumber.replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d+)'),
          (Match m) => "${m[1]} ${m[2]} ${m[3]}");
    } else {
      if (numericString.length == 8) {
        return '${numericString.substring(0, 4)} ${numericString.substring(4, 8)}';
      }
      return numericString;
    }
  }

  static String encrypted(String prefix, String textEncrypt) {
    String result = '';
    List<int> key = utf8.encode(prefix);
    List<int> data = utf8.encode(textEncrypt);
    Hmac hSHA256 = Hmac(sha256, key);
    Digest digest = hSHA256.convert(data);
    result = digest.toString();
    return result;
  }

  static bool isWeb() {
    return kIsWeb;
  }

  static bool isIOsApp() {
    BuildContext context = NavigatorUtils.navigatorKey.currentContext!;
    final platform = Theme.of(context).platform;
    return (!isWeb() && platform == TargetPlatform.iOS);
  }

  //check android Platform
  static bool isAndroidApp() {
    BuildContext context = NavigatorUtils.navigatorKey.currentContext!;
    final platform = Theme.of(context).platform;
    return (!isWeb() && platform == TargetPlatform.android);
  }

  static bool validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }
}
