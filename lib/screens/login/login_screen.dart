// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:dudv_base/dudv_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:vietqr_sms/commons/enum/enum.dart';
import 'package:vietqr_sms/commons/layouts/m_button_widget.dart';
import 'package:vietqr_sms/commons/layouts/phone_widget.dart';
import 'package:vietqr_sms/commons/utils/navigator_utils.dart';
import 'package:vietqr_sms/commons/utils/string_utils.dart';
import 'package:vietqr_sms/models/account_login_dto.dart';
import 'package:vietqr_sms/models/info_user_dto.dart';
import 'package:vietqr_sms/screens/dashboard/dashboard_screen.dart';
import 'package:vietqr_sms/screens/login/blocs/login_bloc.dart';
import 'package:vietqr_sms/screens/login/blocs/login_provider.dart';
import 'package:vietqr_sms/screens/login/events/login_event.dart';
import 'package:vietqr_sms/screens/login/states/login_state.dart';
import 'package:vietqr_sms/screens/login/views/login_account_screen.dart';
import 'package:vietqr_sms/screens/login/views/quick_login_screen.dart';
import 'package:vietqr_sms/screens/register/register_screen.dart';
import 'package:vietqr_sms/services/shared_references/account_helper.dart';
import 'package:vietqr_sms/themes/color.dart';
import 'package:vietqr_sms/themes/route.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (BuildContext context) => LoginBloc(),
      child: ChangeNotifierProvider<LoginProvider>(
        create: (_) => LoginProvider()..init(),
        child: _Login(),
      ),
    );
  }
}

class _Login extends StatefulWidget {
  @override
  State<_Login> createState() => _LoginState();
}

class _LoginState extends State<_Login> {
  final phoneNoController = TextEditingController();
  final passController = TextEditingController();

  final passFocus = FocusNode();

  String code = '';

  Uuid uuid = const Uuid();

  late LoginBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    code = uuid.v1();
  }

  @override
  void dispose() {
    phoneNoController.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, provider, child) {
        return BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state.status == BlocStatus.LOADING) {
              NavigatorUtils.openLoadingDialog();
            }
            if (state.status == BlocStatus.UNLOADING) {
              Navigator.of(context).pop();
            }

            if (state.request == LoginType.TOAST) {
              // _loginBloc.add(LoginEventGetUserInformation(userId: state.userId));
              //pop loading dialog
              //navigate to home screen

              if (provider.infoUserDTO != null) {
                List<String> list = [];
                List<InfoUserDTO> listDto =
                    AccountHelper.instance.getLoginAccount();
                List<InfoUserDTO> listCheck = [];

                if (listDto.isNotEmpty) {
                  if (listDto.length <= 3) {
                    listCheck = listDto
                        .where((element) =>
                            element.phoneNo == provider.infoUserDTO!.phoneNo)
                        .toList();

                    if (listCheck.isNotEmpty) {
                      int index = listDto.indexOf(listCheck.first);
                      listDto.removeAt(index);
                      listDto.add(provider.infoUserDTO!);
                    } else {
                      if (listDto.length == 3) {
                        listDto.sort((a, b) =>
                            a.expiryAsDateTime.compareTo(b.expiryAsDateTime));
                        listDto.removeAt(2);
                        listDto.add(provider.infoUserDTO!);
                      } else {
                        listDto.add(provider.infoUserDTO!);
                      }
                    }
                  }
                } else {
                  listDto.add(provider.infoUserDTO!);
                }

                if (listDto.length >= 2) {
                  listDto.sort((a, b) =>
                      a.expiryAsDateTime.compareTo(b.expiryAsDateTime));
                }

                for (var element in listDto) {
                  list.add(element.toSPJson().toString());
                }

                await AccountHelper.instance.setLoginAccount(list);
                provider.updateListInfoUser();
              }

              NavigatorUtils.navigatorReplace(context, const DashBoardScreen());

              if (state.isToast) {
                Fluttertoast.showToast(
                  msg: 'Đăng ký thành công',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Theme.of(context).cardColor,
                  textColor: Theme.of(context).hintColor,
                  fontSize: 15,
                );
              }
            }
            if (state.request == LoginType.CHECK_EXIST) {
              provider.updateQuickLogin(2);
              provider.updateInfoUser(state.infoUserDTO);
            }

            if (state.request == LoginType.ERROR) {
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.of(context).pop();
              //pop loading dialog
              //show msg dialog
              await NavigatorUtils.openMsgDialog(
                title: 'Không thể đăng nhập',
                msg: state.msg ?? '',
                // 'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin đăng nhập.',
              );

              passController.clear();
              passFocus.requestFocus();
            }
            if (state.request == LoginType.REGISTER) {
              final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
              if (keyboardHeight > 0.0) {
                FocusManager.instance.primaryFocus?.unfocus();
              }

              if (!mounted) return;
              final data = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Register(phoneNo: state.phone ?? ''),
                  settings: const RouteSettings(
                    name: Routes.REGISTER,
                  ),
                ),
              );

              if (data is Map) {
                AccountLoginDTO dto = AccountLoginDTO(
                  phoneNo: data['phone'],
                  password: StringUtils.encrypted(
                    data['phone'],
                    data['password'],
                  ),
                  device: '',
                  fcmToken: '',
                );
                if (!mounted) return;
                context
                    .read<LoginBloc>()
                    .add(LoginEventByPhone(dto: dto, isToast: true));
              }

              if (state.request != LoginType.NONE ||
                  state.status != BlocStatus.NONE) {
                _bloc.add(UpdateEvent());
              }
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: Stack(
                children: [
                  Visibility(
                    visible: provider.isQuickLogin == 0,
                    child: Scaffold(
                      body: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/bgr-header.png'),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: ClipRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 25, sigmaY: 25),
                                      child: Opacity(
                                        opacity: 0.6,
                                        child: Container(
                                          height: 30,
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 100,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      margin: const EdgeInsets.only(top: 50),
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/logo_vietgr_payment.png'),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Column(
                                      children: [
                                        PhoneWidget(
                                          phoneController: phoneNoController,
                                          onChanged: provider.updatePhone,
                                          autoFocus: provider.isQuickLogin == 0,
                                        ),
                                        Visibility(
                                          visible: provider.errorPhone != null,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 5, right: 30),
                                            child: Text(
                                              provider.errorPhone ?? '',
                                              textAlign: TextAlign.left,
                                              style: const TextStyle(
                                                  color: AppColor.RED_TEXT,
                                                  fontSize: 13),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: provider.isQuickLogin == 1,
                    child: LoginAccountScreen(
                      list: provider.listInfoUsers,
                      onRemoveAccount: (dto) async {
                        List<String> listString = [];
                        List<InfoUserDTO> list = provider.listInfoUsers;
                        list.removeAt(dto);
                        if (list.length >= 2) {
                          list.sort((a, b) =>
                              a.expiryAsDateTime.compareTo(b.expiryAsDateTime));
                        }

                        for (var element in list) {
                          listString.add(element.toSPJson().toString());
                        }

                        await AccountHelper.instance
                            .setLoginAccount(listString);

                        provider.updateListInfoUser();

                        if (list.isEmpty) {
                          provider.updateQuickLogin(0);
                        }
                      },
                      onQuickLogin: (dto) {
                        provider.updateQuickLogin(2);
                        provider.updateInfoUser(dto);
                      },
                      onBackLogin: () {
                        provider.updateInfoUser(null);
                        provider.updateQuickLogin(0);
                      },
                      onRegister: () async {
                        provider.updateInfoUser(null);
                        final data = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Register(phoneNo: ''),
                            settings: const RouteSettings(
                              name: Routes.REGISTER,
                            ),
                          ),
                        );

                        if (data is Map) {
                          AccountLoginDTO dto = AccountLoginDTO(
                            phoneNo: data['phone'],
                            password: StringUtils.encrypted(
                              data['phone'],
                              data['password'],
                            ),
                            device: '',
                            fcmToken: '',
                            // platform: '',
                            // sharingCode: '',
                          );
                          if (!mounted) return;
                          context
                              .read<LoginBloc>()
                              .add(LoginEventByPhone(dto: dto, isToast: true));
                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible: provider.isQuickLogin == 2,
                    child: QuickLoginScreen(
                      pinController: passController,
                      passFocus: passFocus,
                      userName: provider.infoUserDTO?.fullname ?? '',
                      phone: provider.infoUserDTO?.phoneNo ?? '',
                      onLogin: (dto) {
                        context
                            .read<LoginBloc>()
                            .add(LoginEventByPhone(dto: dto));
                      },
                      onQuickLogin: () {
                        passController.clear();
                        provider.updateQuickLogin(0);
                        provider.updateInfoUser(null);
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        if (provider.isQuickLogin == 0 ||
                            provider.isQuickLogin == 2)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Consumer<LoginProvider>(
                                builder: (context, auth, child) {
                                  if (auth.listInfoUsers.isNotEmpty) {
                                    return Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: GestureDetector(
                                        onTap: () async {
                                          provider.updateQuickLogin(1);
                                        },
                                        child: const Text(
                                          'Đăng nhập bằng tài khoản trước đó',
                                          style: TextStyle(
                                              color: AppColor.BLUE_TEXT),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                },
                              ),
                            ],
                          ),
                        const SizedBox(height: 8),
                        if (provider.isQuickLogin == 0)
                          MButtonWidget(
                            title: 'Tiếp tục',
                            isEnable: provider.isEnableButton,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            colorEnableText: provider.isEnableButton
                                ? AppColor.WHITE
                                : AppColor.GREY_TEXT,
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              _bloc.add(
                                  CheckExitsPhoneEvent(phone: provider.phone));
                            },
                          )
                        else if (provider.isQuickLogin == 2)
                          MButtonWidget(
                            title: 'Đăng nhập',
                            isEnable: passController.text.length >= 6,
                            colorEnableText: passController.text.length >= 6
                                ? AppColor.WHITE
                                : AppColor.GREY_TEXT,
                            onTap: () {
                              String phone =
                                  provider.infoUserDTO?.phoneNo ?? '';
                              AccountLoginDTO dto = AccountLoginDTO(
                                phoneNo: provider.infoUserDTO?.phoneNo ?? '',
                                password: StringUtils.encrypted(
                                  phone,
                                  passController.text,
                                ),
                              );
                              context
                                  .read<LoginBloc>()
                                  .add(LoginEventByPhone(dto: dto));
                            },
                          ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
