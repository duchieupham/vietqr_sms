import 'package:vietqr_sms/commons/enum/enum_bank.dart';
import 'package:vietqr_sms/models/transaction_model.dart';

import 'string_utils.dart';

class BankUtils {
  static TransactionModel formatBaoVietBank(String body) {
    TransactionModel data = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bankSortName: BankType.BaoVietBank.name,
    );

    data.status = StatusType.BDSD.name;
    List<String> splits = body.split(' ');
    if (StringUtils.validateMobile(splits.last)) {
      data.hotline = splits.last;
      data.transferContent = body.replaceAll(splits.last, '');
    } else {
      data.transferContent = body;
    }

    return data;
  }

  static TransactionModel formatBIDV(String body) {
    TransactionModel data = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bankSortName: BankType.BIDV.name,
    );

    data.status = StatusType.BDSD.name;
    List<String> splits = body.split(' ');
    if (StringUtils.validateMobile(splits.last)) {
      data.hotline = splits.last;
      data.transferContent = body.replaceAll(splits.last, '');
    } else {
      data.transferContent = body;
    }

    return data;
  }

  static TransactionModel formatVietComBank(String body) {
    TransactionModel data = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bankSortName: BankType.Vietcombank.name,
    );
    if (body.contains('OTP') && body.contains('so tien')) {
      data.status = StatusType.OTP.name;
      List<String> splits = body.split('so tien');
      if (splits.isNotEmpty) {
        data.firstContent = splits.first;
        List<String> values = splits.last.trim().split(' ');
        if (values.isNotEmpty) {
          String otp = values.first;
          data.transMoney = otp;
          String content = splits.last.replaceAll(otp, '');
          data.transferContent = content;
        }
      }
    } else {
      data.status = StatusType.BDSD.name;
      List<String> splits = body.split(' ');
      if (StringUtils.validateMobile(splits.last)) {
        data.hotline = splits.last;
        data.transferContent = body.replaceAll(splits.last, '');
      } else {
        data.transferContent = body;
      }
    }

    return data;
  }

  static TransactionModel formatMBBank(String body) {
    TransactionModel data = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bankSortName: BankType.MBBank.name,
    );
    if (body.contains('OTP')) {
      data.status = StatusType.OTP.name;
      List<String> splits = body.split(':');
      if (splits.isNotEmpty) {
        data.firstContent = splits.first;
        List<String> values = splits.last.split('.');
        if (values.isNotEmpty) {
          String otp = values.first;
          data.transMoney = otp;
          String content = splits.last.replaceAll(otp, '');
          data.transferContent = content;
        }
      }
    } else {
      data.status = StatusType.BDSD.name;
      List<String> splits = body.split(' ');
      if (StringUtils.validateMobile(splits.last)) {
        data.hotline = splits.last;
        data.transferContent = body.replaceAll(splits.last, '');
      } else {
        data.transferContent = body;
      }
    }

    return data;
  }

  static TransactionModel formatVietinBank(String body) {
    TransactionModel data = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bankSortName: BankType.Vietinbank.name,
    );
    if (body.contains('@')) {
      data.status = StatusType.BDSD.name;

      List<String> splits = body.split('@');
      if (splits.isNotEmpty) {
        for (var e in splits) {
          if (e
              .toUpperCase()
              .contains(BankType.Vietinbank.name.toUpperCase())) {
            List<String> values = e.split(':');
            if (values.isNotEmpty) {
              data.transTime = '${values[1]}:${values.last}';
            }
          }

          if (e.contains('TK')) {
            List<String> values = e.split(':');
            if (values.isNotEmpty) {
              data.bankAccount = values.last;
            }
          }

          if (e.contains('GD')) {
            List<String> values = e.split(':');
            if (values.isNotEmpty) {
              data.transMoney = values.last;
            }
          }

          if (e.contains('SDC')) {
            List<String> values = e.split(':');
            if (values.isNotEmpty) {
              data.oldMoney = values.last;
            }
          }

          if (e.contains('ND')) {
            List<String> values = e.split(':');
            data.transferContent = values.last;
            data.transType = TransType.C.name;
            for (var element in values) {
              if (element.contains('CT DI')) {
                data.transType = TransType.D.name;
              }
            }
          }
        }
      }
    } else if (body.contains('OTP') && !body.contains('Hotline')) {
      data.status = StatusType.OTP.name;
      List<String> splits = body.split('OTP:');
      if (splits.isNotEmpty) {
        data.firstContent = splits.first;
        List<String> values = splits.last.split(' ');
        if (values.isNotEmpty) {
          String otp = values.first;
          data.transMoney = otp;
          String content = splits.last.replaceAll(otp, '');
          data.transferContent = content;
        }
      }
    } else if (body.contains('OTP') && body.contains('Hotline')) {
      data.status = StatusType.HOTLINE.name;
      List<String> splits = body.split('Hotline:');
      if (splits.isNotEmpty) {
        data.firstContent = splits.first;
        data.transferContent = 'Hotline:';
        String hotline = splits.last;
        data.hotline = hotline;
      }
    }

    return data;
  }
}
