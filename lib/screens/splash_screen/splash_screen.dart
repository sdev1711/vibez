import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/generated/locales.g.dart';
import 'package:vibez/widgets/common_text.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    if(ApiService.auth.currentUser!=null)ApiService.getSelfInfo();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // _updateOldPosts();
    Future.delayed(Duration(seconds: 2), () {
      if(ApiService.auth.currentUser==null){
      Get.offNamed(AppRoutes.loginScreen);
      }
      else{
        Get.offNamed(AppRoutes.mainScreen);
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  // Future<void> _updateOldPosts() async {
  //   QuerySnapshot snapshot = await ApiService.firestore.collection('users').get();
  //   for (var doc in snapshot.docs) {
  //     if (!doc.data().toString().contains('lastOpenedDate')) { // Check if field is missing
  //       await ApiService.firestore.collection('users').doc(doc.id).update({'lastOpenedDate': ''});
  //     }
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.to.darkBgColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonTitle(
                  text: LocaleKeys.vibez.tr,
                  gradientColors: [AppColors.to.titleLightColor,AppColors.to.titleDarkColor],
                  textSize: 60,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
