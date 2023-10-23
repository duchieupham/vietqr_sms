import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:vietqr_sms/commons/enum/enum_bank.dart';
import 'package:vietqr_sms/commons/layouts/m_app_bar.dart';
import 'package:vietqr_sms/mixin/even_bus.dart';
import 'package:vietqr_sms/models/bank_model.dart';
import 'package:vietqr_sms/models/transaction_model.dart';
import 'package:vietqr_sms/services/local_storage/local_storage.dart';
import 'package:vietqr_sms/themes/color.dart';

import 'views/baoviet_view.dart';
import 'views/bidv_view.dart';
import 'views/mbbank_view.dart';
import 'views/vietcombank_view.dart';
import 'views/vietinbank_view.dart';

class SMSDetailScreen extends StatefulWidget {
  final BankModel bankModel;

  const SMSDetailScreen({super.key, required this.bankModel});

  @override
  State<SMSDetailScreen> createState() => _SMSDetailScreenState();
}

class _SMSDetailScreenState extends State<SMSDetailScreen> {
  LocalStorageRepository local = LocalStorageRepository();

  StreamSubscription? _subscription;

  List<TransactionModel> list = [];

  DateFormat dateFormat = DateFormat('dd/MM/yyyy hh:mm');

  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });

    _subscription = eventBus.on<ReloadListTrans>().listen((_) {
      initData();
    });
  }

  void initData() async {
    Box box = await local.openBox(widget.bankModel.bankSortName ?? '');
    setState(() {
      list = local.getWishlist(box);
    });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MAppBar(title: widget.bankModel.bankSortName ?? ''),
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: List.generate(list.length, (index) {
            TransactionModel model = list[index];
            if (model.bankSortName == BankType.MBBank.name) {
              return MBBankView(model: model);
            } else if (model.bankSortName == BankType.Vietcombank.name) {
              return VietComBankView(model: model);
            } else if (model.bankSortName == BankType.BIDV.name) {
              return BIDVView(model: model);
            } else if (model.bankSortName == BankType.BaoVietBank.name) {
              return BaoVietView(model: model);
            }
            return VietinBankView(model: model);
          }).toList(),
        ),
      ),
    );
  }
}
