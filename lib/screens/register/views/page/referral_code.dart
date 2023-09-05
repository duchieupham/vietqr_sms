import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_sms/commons/enum/enum.dart';
import 'package:vietqr_sms/commons/layouts/textfield_custom.dart';
import 'package:vietqr_sms/screens/register/blocs/register_provider.dart';

class ReferralCode extends StatelessWidget {
  const ReferralCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        return TextFieldCustom(
          isObscureText: false,
          maxLines: 1,
          autoFocus: true,
          textFieldType: TextFieldType.LABEL,
          title: 'Thông tin người giới thiệu',
          hintText: 'Mã giới thiệu của bạn bè đã chia sẻ cho bạn trước đó',
          fontSize: 12,
          // subTitle: '(Tuỳ chọn nếu có)',
          controller: provider.introduceController,
          inputType: TextInputType.text,
          keyboardAction: TextInputAction.next,
          onChange: provider.updateIntroduce,
        );
      },
    );
  }
}
