import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibez/database/shared_preference.dart';
import 'hex_color.dart';

class AppColors extends GetxController {
  static AppColors get to => Get.find();

  RxBool isDarkMode = false.obs;
  RxInt isSelection = 0.obs;
  @override
  void onInit() {
    isDarkMode.value = SharedPrefs.getThemeMode() ?? true;
    loadThemeMode();
    super.onInit();
  }

  Color get contrastThemeColor {
    if (isSelection.value == 2) {
      final Brightness brightness =
          WidgetsBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark ? Colors.white : primaryBgColor;
    }
    return isDarkMode.value ? Colors.white : primaryBgColor;
  }

  Color get darkBgColor {
    if (isSelection.value == 2) {
      final Brightness brightness =
          WidgetsBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark
          ? Colors.grey.shade900
          : Colors.white;
    }
    return isDarkMode.value ? Colors.grey.shade900 : Colors.white;
  }

  Color get authenticationBgColor {
    if (isSelection.value == 2) {
      final Brightness brightness =
          WidgetsBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark
          ? Colors.grey.shade900
          : primaryBgColor;
    }
    return isDarkMode.value ? Colors.grey.shade900 : primaryBgColor;
  }

  Color get authenticationButtonFontColor {
    if (isSelection.value == 2) {
      final Brightness brightness =
          WidgetsBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark ? darkBgColor : primaryBgColor;
    }
    return isDarkMode.value ? darkBgColor : primaryBgColor;
  }

  Color get authCircularIndicatorColor {
    if (isSelection.value == 2) {
      final Brightness brightness =
          WidgetsBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark ? primaryBgColor : white;
    }
    return isDarkMode.value ? primaryBgColor : white;
  }

  Color get sendUserColor {
    if (isSelection.value == 2) {
      final Brightness brightness =
          WidgetsBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark ? primaryBgColor : primaryBgColor;
    }
    return isDarkMode.value ? primaryBgColor : primaryBgColor;
  }

  Color get receiveUserColor {
    if (isSelection.value == 2) {
      final Brightness brightness =
          WidgetsBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark
          ? white
          : primaryBgColor.withOpacity(0.5);
    }
    return isDarkMode.value ? white : primaryBgColor.withOpacity(0.5);
  }

  Color get sendUserFontColor {
    if (isSelection.value == 2) {
      final Brightness brightness =
          WidgetsBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark ? white : white;
    }
    return isDarkMode.value ? white : white;
  }

  Color get receiveUserFontColor {
    if (isSelection.value == 2) {
      final Brightness brightness =
          WidgetsBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark ? primaryBgColor : white;
    }
    return isDarkMode.value ? primaryBgColor : white;
  }
  // Gradient get circleBorder{
  //   if(isSelection.value==2){
  //     final Brightness brightness =
  //         WidgetsBinding.instance.window.platformBrightness;
  //     return brightness == Brightness.dark ? LinearGradient(
  //       colors: [primaryBgColor.withOpacity(0.8), white], // Border Gradient
  //       begin: Alignment.topLeft,
  //       end: Alignment.bottomRight,
  //     ) : LinearGradient(
  //       colors: [likeColor, primaryBgColor.withOpacity(0.8)], // Border Gradient
  //       begin: Alignment.topLeft,
  //       end: Alignment.bottomRight,
  //     );
  //   }
  //   return isDarkMode.value ? LinearGradient(
  //     colors: [primaryBgColor, white], // Border Gradient
  //     begin: Alignment.topLeft,
  //     end: Alignment.bottomRight,
  //   ) : LinearGradient(
  //     colors: [primaryBgColor,darkBgColor], // Border Gradient
  //     begin: Alignment.topLeft,
  //     end: Alignment.bottomRight,
  //   );
  // }

  void loadThemeMode() {
    bool? storeTheme = SharedPrefs.getThemeMode();
    if (storeTheme == null) {
      isSelection.value = 2;
    } else {
      isSelection.value = storeTheme ? 1 : 0;
    }
    isDarkMode.value = isSelection.value == 1;
  }

  void toggleTheme(int value) {
    isSelection.value = value;

    if (value == 0) {
      isDarkMode.value = false;
      Get.changeThemeMode(ThemeMode.light);
      SharedPrefs.setThemeMode(isDarkMode.value);
      log("Theme mode :-${isDarkMode.value}");
      log("sharedPref mode :- ${SharedPrefs.getThemeMode()}");
    } else if (value == 1) {
      isDarkMode.value = true;
      Get.changeThemeMode(ThemeMode.dark);
      SharedPrefs.setThemeMode(isDarkMode.value);
      log("Theme mode :-${isDarkMode.value}");
      log("sharedPref mode :- ${SharedPrefs.getThemeMode()}");
    } else if (value == 2) {
      Get.changeThemeMode(ThemeMode.system);
      SharedPrefs.removeThemeMode();
    }
    log("isDarkMode: ${isDarkMode.value}, isSelection: ${isSelection.value}");
  }

  Color primaryBgColor = HexColor('312c51');
  Color white = Colors.white;
  Color alertColor = Colors.red;
  Color defaultProfileImageBg = Colors.grey.shade300;
  Color aiLightColor = Colors.blue.shade300;
  Color aiDarkColor = Colors.blue.shade800;
  Color titleLightColor = Colors.deepPurple.shade100;
  Color titleDarkColor = Colors.deepPurple.shade600;
  // Gradient circleBorder= LinearGradient(
  //   colors: [Colors.purple, Colors.white], // Border Gradient
  //   begin: Alignment.topLeft,
  //   end: Alignment.bottomRight,
  // );
}
