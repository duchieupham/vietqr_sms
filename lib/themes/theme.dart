import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vietqr_sms/themes/color.dart';

class AppTheme {
  //use
  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColor.GREY_BG,
      canvasColor: AppColor.GREY_BG,
      primaryColor: AppColor.WHITE,
      hoverColor: AppColor.TRANSPARENT,
      focusColor: AppColor.BLUE_MB,
      cardColor: AppColor.WHITE,
      shadowColor: AppColor.BLACK_LIGHT,
      indicatorColor: AppColor.DARK_PINK,
      hintColor: AppColor.BLACK,
      splashColor: AppColor.TRANSPARENT,
      highlightColor: AppColor.TRANSPARENT,
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: AppColor.BLACK,
          ),
      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        elevation: 0,
        backgroundColor: AppColor.TRANSPARENT,
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
        ),
        fillColor: AppColor.WHITE,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return AppColor.WHITE;
          }
          return null;
        }),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return AppColor.WHITE;
          }
          return null;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return AppColor.WHITE;
          }
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return AppColor.WHITE;
          }
          return null;
        }),
      ),
      colorScheme: const ColorScheme.light(primary: AppColor.BLUE_TEXT)
          .copyWith(secondary: AppColor.GREY_TEXT),
    );
  }
}
