import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vietqr_sms/commons/utils/log_utils.dart';
import 'package:vietqr_sms/commons/utils/navigator_utils.dart';
import 'package:vietqr_sms/core/env/env_config.dart';
import 'package:vietqr_sms/core/pref_utils.dart';
import 'package:vietqr_sms/screens/login/login_screen.dart';
import 'package:vietqr_sms/services/shared_references/account_helper.dart';
import 'package:vietqr_sms/themes/color.dart';
import 'package:vietqr_sms/themes/theme.dart';

import 'screens/dashboard/blocs/dashboard_bloc.dart';

late SharedPreferences sharedPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs = await SharedPreferences.getInstance();

  await SharedPrefs.instance.init();
  await _initialServiceHelper();

  await Firebase.initializeApp();

  LOG.info('Config Environment: ${EnvConfig.getEnv()}');
  runApp(const VietSMSApp());
}

Future<void> _initialServiceHelper() async {
  if (!sharedPrefs.containsKey('TOKEN') ||
      sharedPrefs.getString('TOKEN') == null) {
    await AccountHelper.instance.initialAccountHelper();
  }
}

class VietSMSApp extends StatefulWidget {
  const VietSMSApp({super.key});

  @override
  State<VietSMSApp> createState() => _VietSMSAppState();
}

class _VietSMSAppState extends State<VietSMSApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
        statusBarBrightness: Brightness.light, // For iOS (dark icons)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<DashBoardBloc>(
              create: (BuildContext context) => DashBoardBloc()),
        ],
        child: MaterialApp(
          navigatorKey: NavigatorUtils.navigatorKey,
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: AppTheme.lightTheme(context),
          darkTheme: AppTheme.lightTheme(context),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            //  Locale('en'), // English
            Locale('vi'), // Vietnamese
          ],
          home: Builder(
            builder: (context) {
              return Title(
                title: 'Viet SMS',
                color: AppColor.BLACK,
                child: const Login(),
              );
            },
          ),
        ),
      ),
    );
  }
}
