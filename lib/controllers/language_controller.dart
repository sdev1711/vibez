import 'dart:ui';
import 'package:get/get.dart';
import 'package:vibez/database/shared_preference.dart';

class LanguageController extends GetxController{

  @override
  void onInit() {
    loadLanguage();
    super.onInit();
  }
  var selectLanguage = 0.obs;
  void changeLanguage(int value){
    selectLanguage .value=value;

    if(value==0){
      Get.updateLocale(Locale('en','US'));
      SharedPrefs.saveLanguage('en');
      print(SharedPrefs.getLanguage());
    }
    else if(value==1){
      Get.updateLocale(Locale('hi','IND'));
      SharedPrefs.saveLanguage('hi');
      print(SharedPrefs.getLanguage());
    }
    else if(value==2){
      Get.updateLocale(Locale('gu','IND'));
      SharedPrefs.saveLanguage('gu');
      print(SharedPrefs.getLanguage());
    }
  }

  void loadLanguage() {
    String ? storeLanguage=SharedPrefs.getLanguage();
    if(storeLanguage == 'en'){
      selectLanguage.value=0;
    }
    else if(storeLanguage =='hi'){
      selectLanguage.value=1;
    }
    else if(storeLanguage =='gu'){
      selectLanguage.value=1;
    }
  }

}

///get generate locales assets/languages