import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:vietqr_sms/commons/enum/enum_bank.dart';
import 'package:vietqr_sms/commons/layouts/m_app_bar.dart';
import 'package:vietqr_sms/models/bank_model.dart';
import 'package:vietqr_sms/models/transaction_model.dart';
import 'package:vietqr_sms/services/local_storage/local_storage.dart';

class SMSDetailScreen extends StatefulWidget {
  final BankModel bankModel;

  const SMSDetailScreen({super.key, required this.bankModel});

  @override
  State<SMSDetailScreen> createState() => _SMSDetailScreenState();
}

class _SMSDetailScreenState extends State<SMSDetailScreen> {
  LocalStorageRepository local = LocalStorageRepository();

  List<TransactionModel> list = [];

  DateFormat dateFormat = DateFormat('dd/MM/yyyy hh:mm');

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    Box box = await local.openBox(widget.bankModel.bankSortName ?? '');
    if (local.getWishlist(box).isEmpty) {
      for (int i = 0; i < 20; i++) {
        TransactionModel data = TransactionModel(
          id: '$i',
          bankSortName: widget.bankModel.bankSortName ?? '',
          bankAccount: '101869255506',
          transTime: DateTime.now(),
          transMoney: '100000',
          transType: TransType.C.name,
          transferContent: 'CAN QUANG TRIEU chuyen tien',
        );
        local.addProductToWishlist(box, data);
      }
    }

    list = local.getWishlist(box);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(
        title: widget.bankModel.bankSortName ?? '',
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(list.length, (index) {
            TransactionModel model = list[index];
            return Container(
              width: MediaQuery.of(context).size.width / 3 * 2,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.withOpacity(0.6),
              ),
              child: Text(
                '${model.bankSortName}:${dateFormat.format(model.transTime!)}|TK:${model.bankAccount}|GD:+${model.transMoney}VND|SDC:400,559VND|ND:${model.transferContent}',
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
