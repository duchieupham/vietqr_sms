import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_sms/commons/enum/enum.dart';
import 'package:vietqr_sms/commons/layouts/m_app_bar.dart';
import 'package:vietqr_sms/commons/layouts/m_button_widget.dart';
import 'package:vietqr_sms/commons/layouts/phone_widget.dart';
import 'package:vietqr_sms/commons/layouts/pin_code_input.dart';
import 'package:vietqr_sms/commons/layouts/textfield_custom.dart';
import 'package:vietqr_sms/commons/utils/navigator_utils.dart';
import 'package:vietqr_sms/commons/utils/string_utils.dart';
import 'package:vietqr_sms/models/account_login_dto.dart';
import 'package:vietqr_sms/screens/register/blocs/register_bloc.dart';
import 'package:vietqr_sms/screens/register/blocs/register_provider.dart';
import 'package:vietqr_sms/screens/register/events/register_event.dart';
import 'package:vietqr_sms/screens/register/states/register_state.dart';
import 'package:vietqr_sms/screens/register/views/dialog_register.dart';
import 'package:vietqr_sms/services/shared_references/account_helper.dart';
import 'package:vietqr_sms/themes/color.dart';

class Register extends StatelessWidget {
  final String phoneNo;

  const Register({super.key, required this.phoneNo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (BuildContext context) => RegisterBloc(),
      child: ChangeNotifierProvider<RegisterProvider>(
        create: (_) => RegisterProvider(),
        child: RegisterScreen(phoneNo: phoneNo),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  final String phoneNo;

  const RegisterScreen({super.key, required this.phoneNo});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _phoneNoController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();

  final focusNode = FocusNode();

  final controller = ScrollController();

  // final auth = FirebaseAuth.instance;

  void initialServices(BuildContext context) {
    if (StringUtils.isNumeric(widget.phoneNo)) {
      Provider.of<RegisterProvider>(context, listen: false)
          .updatePhone(widget.phoneNo);
      _phoneNoController.value =
          _phoneNoController.value.copyWith(text: widget.phoneNo);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialServices(context);
    });
  }

  double heights = 0.0;

  @override
  Widget build(BuildContext context) {
    final viewInsets = EdgeInsets.fromWindowPadding(
        WidgetsBinding.instance.window.viewInsets,
        WidgetsBinding.instance.window.devicePixelRatio);

    if (heights < viewInsets.bottom) {
      heights = viewInsets.bottom;
    }

    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) async {
        if (state is RegisterLoadingState) {
          NavigatorUtils.openLoadingDialog();
        }
        if (state is RegisterFailedState) {
          //pop loading dialog
          Navigator.pop(context);
          //
          NavigatorUtils.openMsgDialog(
            title: 'Không thể đăng ký',
            msg: state.msg,
          );
        }
        if (state is RegisterSuccessState) {
          //pop loading dialog
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          //pop to login page
          backToPreviousPage(context, true);
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: const MAppBar(title: 'Đăng ký'),
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Consumer<RegisterProvider>(
                    builder: (context, provider, child) {
                      return Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              PhoneWidget(
                                onChanged: provider.updatePhone,
                                phoneController: _phoneNoController,
                              ),
                              Visibility(
                                visible: provider.phoneErr,
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                      left: 5, top: 5, right: 30),
                                  child: Text(
                                    'Số điện thoại không đúng định dạng.',
                                    style: TextStyle(
                                        color: AppColor.RED_TEXT, fontSize: 13),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Mật khẩu ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.BLACK,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '*',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.RED_EC1010,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' (Bao gồm 6 số)',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: AppColor.BLACK,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 40,
                                child: PinCodeInput(
                                  autoFocus: true,
                                  obscureText: true,
                                  onChanged: (value) {
                                    provider.updatePassword(value);
                                  },
                                ),
                              ),
                              Visibility(
                                visible: provider.passwordErr,
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                      left: 5, top: 5, right: 30),
                                  child: Text(
                                    'Mật khẩu bao gồm 6 số.',
                                    style: TextStyle(
                                        color: AppColor.RED_TEXT, fontSize: 13),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                              TextFieldCustom(
                                isObscureText: false,
                                maxLines: 1,
                                textFieldType: TextFieldType.LABEL,
                                title: 'Mã giới thiệu',
                                hintText: 'Nhập mã giới thiệu của bạn bè',
                                controller: provider.introduceController,
                                inputType: TextInputType.text,
                                keyboardAction: TextInputAction.next,
                                onChange: provider.updateIntroduce,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Consumer<RegisterProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildButtonSubmit(context, heights),
                          if (!provider.isShowButton)
                            SizedBox(height: viewInsets.bottom),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void backToPreviousPage(BuildContext context, bool isRegisterSuccess) {
    Navigator.pop(
        context,
        isRegisterSuccess
            ? {
                'phone': Provider.of<RegisterProvider>(context, listen: false)
                    .phoneNoController
                    .text,
                'password':
                    Provider.of<RegisterProvider>(context, listen: false)
                        .passwordController
                        .text,
              }
            : null);
  }

  Widget _buildButtonSubmit(BuildContext context, double height) {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        return MButtonWidget(
          title: 'Đăng ký',
          isEnable: provider.isEnableButton(),
          margin: EdgeInsets.zero,
          onTap: () async {
            provider.updateHeight(height, true);

            String phone = provider.phoneNoController.text;

            String password = provider.passwordController.text;
            String confirmPassword = provider.confirmPassController.text;

            provider.updateErrs(
              phoneErr: (StringUtils.isValidatePhone(phone)!),
              passErr:
                  (!StringUtils.isNumeric(password) || (password.length != 6)),
              confirmPassErr:
                  !StringUtils.isValidConfirmText(password, confirmPassword),
            );

            if (provider.isValid()) {
              await showGeneralDialog(
                context: context,
                barrierLabel: "Barrier",
                barrierDismissible: true,
                barrierColor: Colors.black.withOpacity(0.5),
                transitionDuration: const Duration(milliseconds: 700),
                pageBuilder: (_, __, ___) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DialogRegister(
                        passController: provider.passwordController,
                        onChanged: (value) {
                          provider.updateRePass(value);
                        },
                        onTap: () async {
                          if (provider.isValidValidation()) {
                            String userIP =
                                await AccountHelper.instance.getIPAddress();

                            AccountLoginDTO dto = AccountLoginDTO(
                              phoneNo: phone,
                              password: StringUtils.encrypted(phone, password),
                              userIp: userIP,
                              email: _emailController.text,
                              fullName: _nameController.text,
                            );
                            if (!mounted) return;
                            context
                                .read<RegisterBloc>()
                                .add(RegisterEventSubmit(dto: dto));
                          }
                        },
                      ),
                      SizedBox(height: provider.height - kToolbarHeight),
                    ],
                  );
                },
              );
              provider.updateHeight(0.0, false);
            }
          },
        );
      },
    );
  }

  bool isOpenOTP = false;
}
