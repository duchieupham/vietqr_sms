import 'package:hive_flutter/hive_flutter.dart';

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
  String? transTime;
  @HiveField(4)
  String? transMoney;
  @HiveField(5)
  String? oldMoney;
  @HiveField(6)
  String? transType;
  @HiveField(7)
  String? transferContent;
  @HiveField(8)
  String? firstContent;
  @HiveField(9)
  String? status;
  @HiveField(10)
  String? hotline;

  TransactionModel({
    this.id,
    this.bankSortName,
    this.bankAccount,
    this.transTime,
    this.transMoney,
    this.oldMoney,
    this.transType,
    this.transferContent,
    this.firstContent,
    this.status,
    this.hotline,
  });

  dynamic get getHotline {
    if (hotline != null) {
      if (hotline!.isNotEmpty) {
        if (hotline!.contains('/')) {
          List<String> values = hotline!.split('/');
          return values;
        } else {
          return hotline;
        }
      }
    }
    return '';
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json["id"],
        bankSortName: json["bankSortName"],
        bankAccount: json["bankAccount"],
        transTime: json["transTime"],
        transMoney: json["transMoney"],
        oldMoney: json["oldMoney"],
        transType: json["transType"],
        transferContent: json["transferContent"],
        firstContent: json["firstContent"],
        status: json["status"],
        hotline: json["hotline"],
      );
}
