import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vietqr_sms/commons/enum/enum_bank.dart';
import 'package:vietqr_sms/models/transaction_model.dart';
import 'package:vietqr_sms/themes/color.dart';

class BaoVietView extends StatelessWidget {
  final TransactionModel model;

  const BaoVietView({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3 * 2.2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.withOpacity(0.4),
      ),
      child: model.status == StatusType.BDSD.name
          ? RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 18, height: 1.5, color: AppColor.BLACK),
                children: [
                  TextSpan(text: '${model.transferContent}'),
                  if (model.getHotline is String)
                    TextSpan(
                      text: '${model.getHotline}',
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        color: AppColor.BLUE_TEXT,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launch("tel://${model.getHotline}");
                        },
                    ),
                ],
              ),
            )
          : model.status == StatusType.OTP.name
              ? RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 18, height: 1.5, color: AppColor.BLACK),
                    children: [
                      TextSpan(text: '${model.firstContent} so tien '),
                      TextSpan(
                        text: model.transMoney ?? '',
                        style: const TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            height: 1.5,
                            color: AppColor.BLUE_TEXT),
                      ),
                      TextSpan(text: '${model.transferContent}'),
                    ],
                  ),
                )
              : const SizedBox(),
    );
  }
}
