import 'package:flutter/cupertino.dart';
import 'package:vietqr_sms/themes/color.dart';

class MButtonWidget extends StatelessWidget {
  final String title;
  final GestureTapCallback? onTap;
  final bool isEnable;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? colorEnableBgr;
  final Color? colorDisableBgr;
  final Color? colorEnableText;
  final Color? colorDisableText;
  final double? height;
  final Widget? child;
  final double? width;
  final double? fontSize;

  const MButtonWidget({
    super.key,
    required this.title,
    this.margin,
    this.padding,
    this.onTap,
    this.isEnable = false,
    this.colorEnableBgr,
    this.colorDisableBgr,
    this.colorEnableText,
    this.height,
    this.child,
    this.width,
    this.colorDisableText,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnable ? onTap : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            margin: margin ??
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: padding,
            height: height ?? 40,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: isEnable
                  ? colorEnableBgr ?? AppColor.BLUE_TEXT
                  : colorDisableBgr ?? AppColor.WHITE,
            ),
            child: child ??
                Text(
                  title,
                  style: TextStyle(
                    color: isEnable
                        ? colorEnableText ?? AppColor.WHITE
                        : colorDisableText,
                    fontSize: fontSize,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
