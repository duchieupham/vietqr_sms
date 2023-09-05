import 'package:hive_flutter/hive_flutter.dart';
import 'package:vietqr_sms/commons/enum/enum_bank.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 1)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? bankSortName;
  @HiveField(2)
  String? bankAccount;
  @HiveField(3)
  DateTime? transTime;
  @HiveField(4)
  String? transMoney;
  @HiveField(5)
  String? transType;
  @HiveField(6)
  String? transferContent;

  TransactionModel({
    this.id,
    this.bankSortName,
    this.bankAccount,
    this.transTime,
    this.transMoney,
    this.transType,
    this.transferContent,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json["id"],
        bankSortName: json["bankSortName"],
        bankAccount: json["bankAccount"],
        transTime: json["transTime"],
        transMoney: json["transMoney"],
        transType: json["transType"],
        transferContent: json["transferContent"],
      );
}
