// ignore_for_file: void_checks

import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/material.dart';
import 'package:vietqr_sms/commons/layouts/button_widget.dart';
import 'package:vietqr_sms/themes/color.dart';

class NavigatorUtils {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? context() => navigatorKey.currentContext;

  static bool isPopLoading = false;

  static Future navigatorReplace(BuildContext context, Widget child) async {
    navigateToRoot(context);
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => child));
  }

  static Future navigatePage(BuildContext context, Widget widget) async {
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => widget,
    ));
  }

  static void navigateToRoot(BuildContext context) {
    return Navigator.of(context).popUntil((route) => route.isFirst);
  }

  static void handleNavigationForMessage(
      {required String type,
      required Map<String, dynamic> messageData,
      bool isNavi = false}) {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    if (isNavi) {
      Navigator.of(context).pop();
    }

    return;
  }

  static void openLoadingDialog({String msg = ''}) async {
    if (!isPopLoading) {
      isPopLoading = true;
      return await showDialog(
          barrierDismissible: false,
          context: navigatorKey.currentContext!,
          builder: (BuildContext context) {
            return Material(
              color: AppColor.TRANSPARENT,
              child: Center(
                child: (Utils.isWeb)
                    ? Container(
                        width: 200,
                        height: 200,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(
                              color: AppColor.BLUE_TEXT,
                            ),
                            Padding(padding: EdgeInsets.only(top: 30)),
                            Text(
                              'Đang tải',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        width: 250,
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: AppColor.BLUE_TEXT,
                            ),
                            if (msg.isNotEmpty) ...[
                              Padding(padding: EdgeInsets.only(top: 30)),
                              Text(
                                msg,
                                textAlign: TextAlign.center,
                              ),
                            ]
                          ],
                        ),
                      ),
              ),
            );
          }).then((value) => isPopLoading = false);
    }
  }

  static Future openMsgDialog({
    required String title,
    String? buttonExit,
    String? buttonConfirm,
    required String msg,
    VoidCallback? function,
    VoidCallback? functionConfirm,
    bool isSecondBT = false,
    bool showImageWarning = true,
    double width = 300,
    double height = 300,
    BuildContext? context,
  }) {
    return showDialog(
        barrierDismissible: false,
        context: context ?? navigatorKey.currentContext!,
        builder: (BuildContext context) {
          return Material(
            color: AppColor.TRANSPARENT,
            child: Center(
              child: Container(
                width: width,
                height: height,
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (showImageWarning)
                      Image.asset(
                        'assets/images/ic-warning.png',
                        width: 80,
                        height: 80,
                      ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    SizedBox(
                      width: 250,
                      height: 60,
                      child: Text(
                        msg,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ButtonWidget(
                              height: 40,
                              text: buttonExit ?? 'Đóng',
                              textColor:
                                  isSecondBT ? AppColor.BLACK : AppColor.WHITE,
                              bgColor: isSecondBT
                                  ? AppColor.GREY_EBEBEB
                                  : AppColor.BLUE_TEXT,
                              borderRadius: 5,
                              function: (function != null)
                                  ? function
                                  : () {
                                      Navigator.pop(context);
                                    },
                            ),
                          ),
                          if (isSecondBT) ...[
                            const SizedBox(width: 10),
                            Expanded(
                              child: ButtonWidget(
                                height: 40,
                                text: buttonConfirm ?? 'Xác nhận',
                                textColor: AppColor.WHITE,
                                bgColor: AppColor.BLUE_TEXT,
                                borderRadius: 5,
                                function: functionConfirm!,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // const Padding(padding: EdgeInsets.only(top: 10)),
                  ],
                ),
              ),
              // : Container(
              //     width: 300,
              //     height: 250,
              //     alignment: Alignment.center,
              //     padding: const EdgeInsets.symmetric(horizontal: 40),
              //     decoration: BoxDecoration(
              //       color: Theme.of(context).cardColor,
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         const Spacer(),
              //         Text(
              //           msg,
              //           textAlign: TextAlign.center,
              //           style: const TextStyle(
              //             fontSize: 16,
              //           ),
              //         ),
              //         const Spacer(),
              //         ButtonWidget(
              //           width: 230,
              //           text: 'OK',
              //           textColor: DefaultTheme.WHITE,
              //           bgColor: DefaultTheme.GREEN,
              //           function: (function != null)
              //               ? function
              //               : () {
              //                   Navigator.pop(context);
              //                 },
              //         ),
              //         const Padding(padding: EdgeInsets.only(bottom: 20)),
              //       ],
              //     ),
              //   ),
            ),
          );
        });
  }
}
