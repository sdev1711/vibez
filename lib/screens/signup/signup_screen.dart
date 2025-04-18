import 'package:intl/intl.dart';
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

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final StringValidation stringValidation = StringValidation();
  String formattedDate =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  bool passSecured = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.to.authenticationBgColor,
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Get.offAllNamed(AppRoutes.mainScreen);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: CommonSoraText(
                  text: state.message,
                  color: AppColors.to.contrastThemeColor,
                ),
                backgroundColor: AppColors.to.darkBgColor,
              ));
            }
          },
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
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CommonTextField(
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CommonTextField(
                          controller: nameController,
                          hintText: LocaleKeys.enterName.tr,
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a name';
                            }
                            if (!stringValidation.isNameValidate(value)) {
                              return 'Name must only contain letters';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CommonTextField(
                          controller: emailController,
                          hintText: LocaleKeys.email.tr,
                          maxLines: 1,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a email';
                            }
                            if (!stringValidation.isEmailValidate(value)) {
                              return 'Enter valid e-mail';
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                          icons: CommonIconButton(
                            iconData: passSecured
                                ? Icons.visibility_off
                                : Icons.visibility,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CommonTextField(
                          controller: confirmPasswordController,
                          hintText: LocaleKeys.confirmPassword.tr,
                          maxLines: 1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value != passwordController.text) {
                              return 'Password not matched';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: CommonButton(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              context.read<AuthCubit>().signUp(
                                    username: userNameController.text,
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    createdAt: formattedDate,
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
                                  text: LocaleKeys.signUp.tr,
                                  color: AppColors
                                      .to.authenticationButtonFontColor,
                                  textSize: 17,
                                ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonSoraText(
                            text: LocaleKeys.oldAccount.tr,
                            color: AppColors.to.white,
                            textSize: 15,
                          ),
                          CommonTextButton(
                            onPressed: () {
                              Get.offAllNamed(AppRoutes.loginScreen);
                            },
                            child: CommonSoraText(
                              text: LocaleKeys.login.tr,
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
