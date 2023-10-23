import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:telephony/telephony.dart';
import 'package:vietqr_sms/commons/enum/enum.dart';
import 'package:vietqr_sms/commons/enum/enum_bank.dart';
import 'package:vietqr_sms/commons/layouts/m_app_bar.dart';
import 'package:vietqr_sms/commons/utils/bank_utils.dart';
import 'package:vietqr_sms/commons/utils/navigator_utils.dart';
import 'package:vietqr_sms/mixin/even_bus.dart';
import 'package:vietqr_sms/models/bank_model.dart';
import 'package:vietqr_sms/models/transaction_model.dart';
import 'package:vietqr_sms/models/user_responsion.dart';
import 'package:vietqr_sms/screens/dashboard/blocs/dashboard_bloc.dart';
import 'package:vietqr_sms/screens/dashboard/events/dashboard_event.dart';
import 'package:vietqr_sms/screens/dashboard/sms_listener.dart';
import 'package:vietqr_sms/screens/dashboard/states/dashboard_state.dart';
import 'package:vietqr_sms/screens/detail_sms/detail_sms_screen.dart';
import 'package:vietqr_sms/screens/login/login_screen.dart';
import 'package:vietqr_sms/services/local_storage/local_storage.dart';
import 'package:vietqr_sms/services/shared_references/account_helper.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  late DashBoardBloc _bloc;

  LocalStorageRepository local = LocalStorageRepository();

  UserRepository get userRes => UserRepository.instance;

  Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initData();
    });

    if (!Platform.isAndroid) {
      return;
    }

    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) async {
        TransactionModel data = TransactionModel();

        if (message.address?.toUpperCase() ==
            BankType.Vietinbank.name.toUpperCase()) {
          data = BankUtils.formatVietinBank(message.body ?? '');
        } else if (message.address?.toUpperCase() ==
            BankType.MBBank.name.toUpperCase()) {
          data = BankUtils.formatMBBank(message.body ?? '');
        } else if (message.address?.toUpperCase() ==
            BankType.Vietcombank.name.toUpperCase()) {
          data = BankUtils.formatVietComBank(message.body ?? '');
        } else if (message.address?.toUpperCase() ==
            BankType.BIDV.name.toUpperCase()) {
          data = BankUtils.formatBIDV(message.body ?? '');
        } else if (message.address?.toUpperCase() ==
                BankType.BaoVietBank.name.toUpperCase() ||
            message.address?.toUpperCase() == 'BAOVIET') {
          data = BankUtils.formatBaoVietBank(message.body ?? '');
        }

        BankModel bankModel = BankModel(
          id: '${AccountHelper.instance.getUserId()}${data.bankSortName}',
          bankSortName: data.bankSortName,
        );

        await userRes.addBankToBanks(bankModel);

        listBank = userRes.getBanks();
        setState(() {});

        Box box = await local.openBox(bankModel.bankSortName ?? '');
        await local.addProductToWishlist(box, data);
        eventBus.fire(ReloadListTrans());
      },
      listenInBackground: true,
      onBackgroundMessage: backgrounMessageHandler,
    );
  }

  int index = 0;

  List<BankModel> listBank = [];

  void initData() {
    _bloc.add(ValidTokenEvent());
    listBank = userRes.getBanks();
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<DashBoardBloc, DashBoardState>(
      listener: (context, state) async {
        if (state.request == DashBoardType.TOKEN) {
          if (state.typeToken == TokenType.Expired) {
            await NavigatorUtils.openMsgDialog(
              title: 'Phiên đăng nhập hết hạn',
              msg: state.msg ?? '',
              function: () {
                Navigator.pop(context);
                _bloc.add(TokenEventLogout());
              },
            );
          } else if (state.typeToken == TokenType.LogOut) {
            NavigatorUtils.navigatorReplace(context, const Login());
          } else if (state.typeToken == TokenType.LogOut_Failed) {
            await NavigatorUtils.openMsgDialog(
              title: 'Không thể đăng xuất',
              msg: 'Vui lòng thử lại sau.',
            );
          }
        }
      },
      child: Scaffold(
        appBar: MAppBar(
          title: 'Home',
          actions: [
            IconButton(
                onPressed: () {
                  userRes.getAtBank(index);
                  setState(() {});
                },
                icon: const Icon(Icons.add)),
          ],
        ),
        body: Column(
          children: List.generate(userRes.listBank.length, (index) {
            return _buildItem(userRes.listBank.elementAt(index));
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildItem(BankModel model) {
    return GestureDetector(
      onTap: () {
        // NavigatorUtils.navigatePage(context, const SMSListenerScreen());
        NavigatorUtils.navigatePage(context, SMSDetailScreen(bankModel: model));
      },
      child: Container(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            const Icon(
              Icons.account_circle,
              size: 50,
              color: Colors.grey,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(right: 12, bottom: 8, top: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            model.bankSortName ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                        ),
                        // Text(
                        //   '${model.transTime?.hour}:${model.transTime?.minute}',
                        //   style: const TextStyle(
                        //     color: Colors.grey,
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.w500,
                        //     height: 1.4,
                        //   ),
                        // ),
                        // const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        model.transferContent ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
