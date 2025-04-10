import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/Cubit/auth/auth_cubit.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/generated/locales.g.dart';
import 'package:vibez/string_validation/string_validation.dart';
import 'package:vibez/widgets/common_button.dart';
import 'package:vibez/widgets/common_icon_button.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:vibez/widgets/common_text_button.dart';
import 'package:vibez/widgets/common_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool passSecured=false;
  final StringValidation stringValidation = StringValidation();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.to.authenticationBgColor,
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  spacing: 20.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100.h,
                    ),
                    Center(
                      child: CommonTitle(
                        text: LocaleKeys.vibez.tr,
                        gradientColors: [AppColors.to.titleLightColor,AppColors.to.titleDarkColor],
                        textSize: 50,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: CommonTextField(
                        key: Key('username_field'),
                        controller: userNameController,
                        hintText: LocaleKeys.userName.tr,
                        maxLines: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          if (!stringValidation.isUserNameValidate(value)) {
                            return 'Enter valid username';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: CommonTextField(
                        controller: passwordController,
                        hintText: LocaleKeys.password.tr,
                        maxLines: 1,
                        obscured: passSecured,
                        obscuredCharacter: "*",
                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        icons: CommonIconButton(
                          iconData: passSecured ? Icons.visibility_off : Icons.visibility,
                          onTap: () {
                            setState(() {
                              passSecured = !passSecured; // Toggle state
                            });
                          },
                          color: AppColors.to.contrastThemeColor,
                          size: 20.h,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (!stringValidation.isPassValidate(value)) {
                            return 'Enter valid password';
                          }
                          return null;
                        },
                      ),
                      ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.forgotPassword);
                          },
                          child: CommonSoraText(
                            text: LocaleKeys.forgotPassword.tr,
                            color: AppColors.to.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: CommonButton(
                        key: Key("login_button"),
                        onPressed: () {
                          if (formKey.currentState?.validate() ?? false) {
                            context.read<AuthCubit>().login(
                                  username: userNameController.text,
                                  password: passwordController.text,
                                );
                          }
                        },
                        bgColor: AppColors.to.white,
                        height: 50.h,
                        width: double.infinity,
                        child: state is AuthLoading
                            ? SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(
                                  color:
                                      AppColors.to.authCircularIndicatorColor,
                                ),
                              )
                            : CommonSoraText(
                                text: LocaleKeys.login.tr,
                                color:
                                    AppColors.to.authenticationButtonFontColor,
                                textSize: 17,
                              ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonSoraText(
                          text: LocaleKeys.newAccount.tr,
                          color: AppColors.to.white,
                          textSize: 15,
                        ),
                        CommonTextButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.signUpScreen);
                          },
                          child: CommonSoraText(
                            text: LocaleKeys.signUp.tr,
                            color: AppColors.to.white,
                            fontWeight: FontWeight.bold,
                            textSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
