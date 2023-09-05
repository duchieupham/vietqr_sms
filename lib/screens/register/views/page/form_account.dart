import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_sms/commons/enum/enum.dart';
import 'package:vietqr_sms/commons/layouts/phone_widget.dart';
import 'package:vietqr_sms/commons/layouts/pin_code_input.dart';
import 'package:vietqr_sms/commons/layouts/textfield_custom.dart';
import 'package:vietqr_sms/screens/register/blocs/register_provider.dart';
import 'package:vietqr_sms/themes/color.dart';

class FormAccount extends StatelessWidget {
  final TextEditingController phoneController;

  const FormAccount({Key? key, required this.phoneController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Số điện thoại*',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.BLACK,
                  ),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Số điện thoại được dùng để đăng nhập vào hệ thống VietQR Vn',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColor.BLACK,
                  ),
                ),
              ),
              PhoneWidget(
                onChanged: provider.updatePhone,
                phoneController: phoneController,
              ),
              Visibility(
                visible: provider.phoneErr,
                child: const Padding(
                  padding: EdgeInsets.only(left: 5, top: 5, right: 30),
                  child: Text(
                    'Số điện thoại không đúng định dạng.',
                    style: TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFieldCustom(
                isObscureText: false,
                maxLines: 1,
                autoFocus: true,
                textFieldType: TextFieldType.LABEL,
                title: 'Email',
                hintText: 'your_email@gmail.com',
                fontSize: 12,
                controller: provider.emailController,
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onChange: provider.updateEmail,
              ),
              const SizedBox(height: 30),
              TextFieldCustom(
                isObscureText: false,
                maxLines: 1,
                autoFocus: true,
                textFieldType: TextFieldType.LABEL,
                title: 'Họ tên',
                hintText: 'Nguyễn Văn A',
                fontSize: 12,
                controller: provider.nameController,
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onChange: provider.updateName,
              ),
              const SizedBox(height: 30),
              const Text(
                'Đặt mật khẩu*',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.BLACK,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                'Mật khẩu có độ dài 6 ký tự số, không bao gồm chữ và ký tự đặc biệt',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.BLACK,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: PinCodeInput(
                    autoFocus: true,
                    obscureText: true,
                    onChanged: (value) {
                      provider.updatePassword(value);
                    },
                  ),
                ),
              ),
              Visibility(
                visible: provider.passwordErr,
                child: const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    'Mật khẩu bao gồm 6 số.',
                    style: TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Xác nhận lại mật khẩu*',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColor.BLACK,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                'Nhập lại mật khẩu ở trên để xác nhận',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColor.BLACK,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: PinCodeInput(
                    autoFocus: true,
                    obscureText: true,
                    onChanged: (value) {
                      provider.updateConfirmPassword(value);
                    },
                  ),
                ),
              ),
              Visibility(
                visible: provider.confirmPassErr,
                child: const Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text(
                    'Mật khẩu không trùng nhau',
                    style: TextStyle(color: AppColor.RED_TEXT, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
