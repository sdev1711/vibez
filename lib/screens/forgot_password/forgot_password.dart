import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/string_validation/string_validation.dart';
import 'package:vibez/widgets/common_appBar.dart';
import 'package:vibez/widgets/common_icon_button.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:vibez/widgets/common_textfield.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final StringValidation stringValidation = StringValidation();
  Future<void> resetPassword() async {
    String email = emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      Get.snackbar("Invalid Email", "Please enter a valid email address.",
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar("Email Sent", "Check your email to reset your password.",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.to.darkBgColor,
      appBar: CommonAppBar(
        title: CommonSoraText(
          text: "Forgot password",
          color: AppColors.to.contrastThemeColor,
          textSize: 20,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: CommonIconButton(
              onTap: () {
                if (formKey.currentState?.validate() ?? false) {
                  resetPassword();
                }
              },
              iconData: Icons.done_rounded,
              size: 30,
              color: AppColors.to.contrastThemeColor,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30.h,
            ),
            CommonSoraText(
              text: "Enter email",
              color: AppColors.to.contrastThemeColor,
              textSize: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: CommonSoraText(
                text: "Enter email address associated\nwith your account.",
                color: AppColors.to.contrastThemeColor,
                textSize: 15,
              ),
            ),
            Form(
              key: formKey,
              child: CommonTextField(
                controller: emailController,
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
          ],
        ),
      ),
    );
  }
}
