import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';
import 'package:vibez/Cubit/auth/auth_cubit.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/controllers/language_controller.dart';
import 'package:vibez/generated/locales.g.dart';
import 'package:vibez/widgets/common_alert_dialog.dart';
import 'package:vibez/widgets/common_button.dart';
import 'package:vibez/widgets/common_icon_button.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:vibez/widgets/common_text_button.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({
    super.key,
    required this.context,
    required this.languageController,
  });

  final LanguageController languageController;
  final BuildContext context;

  @override
  Widget build(context) {
    int previousTheme = AppColors.to.isSelection.value;
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0),
          bottomLeft: Radius.circular(0),
        ),
      ),
      backgroundColor: AppColors.to.darkBgColor,
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          log("=====state is $state=====");
          if (state is AuthAuthenticated) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: ClipOval(
                        child: Material(
                            color: AppColors.to.contrastThemeColor,
                            child: CommonIconButton(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              iconData: Icons.arrow_back_ios_new_rounded,
                              size: 15,
                              color: AppColors.to.darkBgColor,
                            )),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CommonTextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: CommonSoraText(
                      text: LocaleKeys.profile.tr,
                      textSize: 17,
                      color: AppColors.to.contrastThemeColor,
                    ),
                  ),
                  CommonTextButton(
                    onPressed: () {
                      print("value of previous value $previousTheme");
                      showDialog<String>(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => CommonAlertDialog(
                          title: CommonSoraText(
                            text: LocaleKeys.changeTheme.tr,
                            textSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.to.contrastThemeColor,
                          ),
                          content: Obx(() {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RadioListTile(
                                  activeColor: AppColors.to.contrastThemeColor,
                                  title: CommonSoraText(
                                    text: LocaleKeys.lightTheme.tr,
                                    textSize: 17,
                                    color: AppColors.to.contrastThemeColor,
                                  ),
                                  value: 0,
                                  groupValue: AppColors.to.isSelection.value,
                                  onChanged: (value) {
                                    AppColors.to.toggleTheme(value ?? 0);
                                    // previousTheme=value??0;
                                    print("value of previous value $previousTheme");
                                    print("value of actual value ${AppColors.to.isSelection.value}");
                                    //AppColors.to.toggleTheme(0);
                                  },
                                ),
                                RadioListTile(
                                  activeColor: AppColors.to.contrastThemeColor,
                                  title: CommonSoraText(
                                    text: LocaleKeys.darkTheme.tr,
                                    textSize: 17,
                                    color: AppColors.to.contrastThemeColor,
                                  ),
                                  value: 1,
                                  groupValue: AppColors.to.isSelection.value,
                                  onChanged: (value) {
                                    AppColors.to.toggleTheme(value ?? 1);
                                    // previousTheme=value??1;
                                    print("value of previous value $previousTheme");
                                    print("value of actual value ${AppColors.to.isSelection.value}");
                                  },
                                ),
                                RadioListTile(
                                  activeColor: AppColors.to.contrastThemeColor,
                                  title: CommonSoraText(
                                    text: LocaleKeys.systemTheme.tr,
                                    textSize: 17,
                                    color: AppColors.to.contrastThemeColor,
                                  ),
                                  value: 2,
                                  groupValue: AppColors.to.isSelection.value,
                                  onChanged: (value) {
                                    AppColors.to.toggleTheme(value ?? 2);
                                    // previousTheme=value??2;
                                    log("value of previous value $previousTheme");
                                    log("value of actual value ${AppColors.to.isSelection.value}");
                                    //AppColors.to.toggleTheme(2);
                                  },
                                ),
                              ],
                            );
                          }),
                          actions: [
                            CommonTextButton(
                              onPressed: () {
                                AppColors.to.toggleTheme(previousTheme);
                                Navigator.pop(context, 'Cancel');
                                },
                              child: CommonSoraText(
                                text: LocaleKeys.cancel.tr,
                                textSize: 15,
                                color: AppColors.to.contrastThemeColor,
                              ),
                            ),
                            CommonTextButton(
                              onPressed: (){

                                Navigator.pop(context, 'OK');
                                if (previousTheme != AppColors.to.isSelection.value) {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: CommonSoraText(
                                        text: "Restart Required",
                                        textSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.to.contrastThemeColor,
                                      ),
                                      content: CommonSoraText(
                                        text: "The theme has changed. Restart the app to apply changes.",
                                        textSize: 16,
                                        color: AppColors.to.contrastThemeColor,
                                      ),
                                      actions: [
                                        CommonTextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: CommonSoraText(
                                            text: "Cancel",
                                            textSize: 15,
                                            color: AppColors.to.contrastThemeColor,
                                          ),
                                        ),
                                        CommonTextButton(
                                          onPressed: () {
                                            Restart.restartApp(
                                              notificationTitle: 'Restarting App',
                                              notificationBody: 'Please tap here to open the app again.',
                                            ); // Restart the app
                                          },
                                          child: CommonSoraText(
                                            text: "Restart Now",
                                            textSize: 15,
                                            color: AppColors.to.contrastThemeColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: CommonSoraText(
                                text: LocaleKeys.ok.tr,
                                textSize: 15,
                                color: AppColors.to.contrastThemeColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: CommonSoraText(
                      text: LocaleKeys.changeTheme.tr,
                      textSize: 17,
                      color: AppColors.to.contrastThemeColor,
                    ),
                  ),
                  CommonTextButton(
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => CommonAlertDialog(
                        title: CommonSoraText(
                          text: LocaleKeys.selectLanguage.tr,
                          textSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.to.contrastThemeColor,
                        ),
                        content: Obx(() {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              RadioListTile(
                                activeColor: AppColors.to.contrastThemeColor,
                                title: CommonSoraText(
                                  text: LocaleKeys.english.tr,
                                  textSize: 17,
                                  color: AppColors.to.contrastThemeColor,
                                ),
                                value: 0,
                                groupValue:
                                languageController.selectLanguage.value,
                                onChanged: (value) {
                                  languageController
                                      .changeLanguage(value ?? 0);
                                },
                              ),
                              RadioListTile(
                                activeColor: AppColors.to.contrastThemeColor,
                                title: CommonSoraText(
                                  text: LocaleKeys.hindi.tr,
                                  textSize: 17,
                                  color: AppColors.to.contrastThemeColor,
                                ),
                                value: 1,
                                groupValue:
                                languageController.selectLanguage.value,
                                onChanged: (value) {
                                  languageController
                                      .changeLanguage(value ?? 1);
                                },
                              ),
                              RadioListTile(
                                activeColor: AppColors.to.contrastThemeColor,
                                title: CommonSoraText(
                                  text: LocaleKeys.gujarati.tr,
                                  textSize: 17,
                                  color: AppColors.to.contrastThemeColor,
                                ),
                                value: 2,
                                groupValue:
                                languageController.selectLanguage.value,
                                onChanged: (value) {
                                  languageController
                                      .changeLanguage(value ?? 2);
                                },
                              ),
                            ],
                          );
                        }),
                        actions: [
                          CommonTextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: CommonSoraText(
                              text: LocaleKeys.cancel.tr,
                              textSize: 15,
                              color: AppColors.to.contrastThemeColor,
                            ),
                          ),
                          CommonTextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: CommonSoraText(
                              text: LocaleKeys.ok.tr,
                              textSize: 15,
                              color: AppColors.to.contrastThemeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    child: CommonSoraText(
                      text: LocaleKeys.language.tr,
                      textSize: 17,
                      color: AppColors.to.contrastThemeColor,
                    ),
                  ),
                  CommonTextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.userAccountScreen);
                    },
                    child: CommonSoraText(
                      text: LocaleKeys.account.tr,
                      textSize: 17,
                      color: AppColors.to.contrastThemeColor,
                    ),
                  ),
                  CommonTextButton(
                    onPressed: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => CommonAlertDialog(
                        title: Center(
                          child: CommonSoraText(
                            text: LocaleKeys.logOut.tr,
                            textSize: 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.to.contrastThemeColor,
                          ),
                        ),
                        content: CommonSoraText(
                          text: LocaleKeys.logOutOfYourAccount.tr,
                          color: AppColors.to.contrastThemeColor,
                          textAlign: TextAlign.center,
                          textSize: 14,
                        ),
                        actions: [
                          Row(
                            children: [
                              CommonButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                bgColor: Colors.transparent,
                                boxBorder: Border.all(
                                    width: 2,
                                    color: AppColors.to.contrastThemeColor),
                                height: 40.h,
                                width: 100.w,
                                child: CommonSoraText(
                                  text: LocaleKeys.no.tr,
                                  color: AppColors.to.contrastThemeColor,
                                  textSize: 15,
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              CommonButton(
                                onPressed: () {
                                  context.read<AuthCubit>().logout();
                                },
                                bgColor: AppColors.to.contrastThemeColor,
                                height: 40.h,
                                width: 100.w,
                                child: CommonSoraText(
                                  text: LocaleKeys.yes.tr,
                                  color: AppColors.to.darkBgColor,
                                  textSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    child: CommonSoraText(
                      text: LocaleKeys.logOut.tr,
                      textSize: 17,
                      color: AppColors.to.contrastThemeColor,
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}