import 'dart:io';

import 'package:flutter/material.dart';

// import 'package:flutter_sms_listener/flutter_sms_listener.dart';
import 'package:intl/intl.dart';
import 'package:telephony/telephony.dart';
import 'package:vietqr_sms/models/transaction_model.dart';

backgrounMessageHandler(SmsMessage message) async {
  print(message.address); //+977981******67, sender nubmer
  print(message.body); //sms text
  print(message.date); //1659690242000, timestamp
  Telephony.instance
      .sendSms(to: "123456789", message: "Message from background");
}

class SMSListenerScreen extends StatefulWidget {
  const SMSListenerScreen({super.key});

  @override
  State<SMSListenerScreen> createState() => _SMSListenerScreenState();
}

class _SMSListenerScreenState extends State<SMSListenerScreen> {
  // static const String LISTEN_MSG = 'Listening to sms...';
  // static const String NEW_MSG = 'Captured new message!';
  // String _status = LISTEN_MSG;
  //
  // final FlutterSmsListener _smsListener = FlutterSmsListener();
  // final List<SmsMessage> _messagesCaptured = <SmsMessage>[];

  final _dateFormat = DateFormat('E, ').add_jm();

  String sms = "";
  Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();

    if (!Platform.isAndroid) {
      return;
    }

    telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          TransactionModel data = formatVietinBank(message.body ?? '');
        },
        listenInBackground: true,
        onBackgroundMessage: backgrounMessageHandler);

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _beginListening();
    // });
  }

  formatVietinBank(String body) {
    TransactionModel data = TransactionModel();
    if (body.contains('@')) {
      List<String> splits = body.split('@');
      if (splits.isNotEmpty) {
        for (var e in splits) {
          if (e.toUpperCase().contains('VIETINBANK')) {
            List<String> values = e.split(':');
            if (values.isNotEmpty) {
              data.bankSortName = values.first;
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
            data.transType = 'C';
            for (var element in values) {
              if (element.contains('CT DI')) {
                data.transType = 'D';
              }
            }
          }
        }
      }
    }

    return data;
  }

  // void _beginListening() {
  //   _smsListener.onSmsReceived!.listen((message) {
  //     _messagesCaptured.add(message);
  //
  //     setState(() {
  //       _status = NEW_MSG;
  //     });
  //
  //     Future.delayed(const Duration(seconds: 5)).then((_) {
  //       setState(() {
  //         _status = LISTEN_MSG;
  //       });
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Listen Incoming SMS in Flutter"),
          backgroundColor: Colors.redAccent),
      body: Container(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recieved SMS Text:",
              style: TextStyle(fontSize: 30),
            ),
            const Divider(),
            Text(
              "SMS Text:" + sms,
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
