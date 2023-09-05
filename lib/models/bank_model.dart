import 'package:hive/hive.dart';

import 'package:vietqr_sms/commons/enum/enum_bank.dart';

part 'bank_model.g.dart';

@HiveType(typeId: 0)
class BankModel extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? bankName;
  @HiveField(2)
  String? bankSortName;
  @HiveField(3)
  String? bankAccount;
  @HiveField(4)
  DateTime? transTime;
  @HiveField(5)
  String? transMoney;
  @HiveField(6)
  String? transType;
  @HiveField(7)
  String? transferContent;

  BankModel({
    this.id,
    this.bankName,
    this.bankSortName,
    this.bankAccount,
    this.transTime,
    this.transMoney,
    this.transType,
    this.transferContent,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
        id: json["id"],
        bankName: json["bankName"],
        bankSortName: json["bankSortName"],
        bankAccount: json["bankAccount"],
        transTime: json["transTime"],
        transMoney: json["transMoney"],
        transType: json["transType"],
        transferContent: json["transferContent"],
      );
}
