import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vibez/api_service/api_service.dart';

class ReadReceiptsCubit extends Cubit<bool> {
  ReadReceiptsCubit() : super(false);

  void toggleSwitch(bool value) async {
    String? userId = ApiService.user.uid;
    emit(value);
    try {
      await ApiService.firestore
          .collection('users')
          .doc(userId)
          .update({"readReceipts": value});
    } catch (e) {
      log("Error in update : $e");
    }
  }
  ///fetch initial state from firebase
  Future<void>fetchInitialState()async{
    String? userId = ApiService.user.uid;
    DocumentSnapshot userDoc=await ApiService.firestore.collection('users').doc(userId).get();
    if(userDoc.exists){
      bool lastSeen=(userDoc.data() as Map<String,dynamic>)["readReceipts"]??false;
      emit(lastSeen);
    }
  }
}