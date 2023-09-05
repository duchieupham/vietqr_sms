import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vietqr_sms/commons/layouts/m_app_bar.dart';
import 'package:vietqr_sms/commons/layouts/m_button_widget.dart';
import 'package:vietqr_sms/commons/utils/navigator_utils.dart';
import 'package:vietqr_sms/commons/utils/string_utils.dart';
import 'package:vietqr_sms/models/account_login_dto.dart';
import 'package:vietqr_sms/screens/register/blocs/register_bloc.dart';
import 'package:vietqr_sms/screens/register/blocs/register_provider.dart';
import 'package:vietqr_sms/screens/register/events/register_event.dart';
import 'package:vietqr_sms/screens/register/states/register_state.dart';
import 'package:vietqr_sms/screens/register/views/page/form_account.dart';
import 'package:vietqr_sms/screens/register/views/page/referral_code.dart';
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
  final focusNode = FocusNode();
  final PageController pageController = PageController();
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
            appBar: const MAppBar(
              title: 'Đăng ký',
              actions: [],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: FormAccount(
                        phoneController: _phoneNoController,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Consumer<RegisterProvider>(
                    builder: (context, provider, child) {
                      return _buildButtonSubmitFormAccount();
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

  Widget _buildButtonSubmitFormAccount() {
    return Consumer<RegisterProvider>(
      builder: (context, provider, child) {
        return MButtonWidget(
          title: 'Xác nhận',
          isEnable: provider.isEnableButton(),
          margin: EdgeInsets.zero,
          onTap: () async {
            String phone = provider.phoneNoController.text;
            String password = provider.passwordController.text;
            String confirmPassword = provider.confirmPassController.text;
            String email = provider.emailController.text;
            String name = provider.nameController.text;

            provider.updateErrs(
              phoneErr: (StringUtils.isValidatePhone(phone)!),
              passErr:
                  (!StringUtils.isNumeric(password) || (password.length != 6)),
              confirmPassErr:
                  !StringUtils.isValidConfirmText(password, confirmPassword),
            );

            if (provider.isValidValidation()) {
              String userIP = await AccountHelper.instance.getIPAddress();

              AccountLoginDTO dto = AccountLoginDTO(
                phoneNo: phone,
                password: StringUtils.encrypted(phone, password),
                userIp: userIP,
                email: email,
                fullName: name,
              );
              if (!mounted) return;
              context.read<RegisterBloc>().add(RegisterEventSubmit(dto: dto));
            }
          },
        );
      },
    );
  }

  bool isOpenOTP = false;
}
