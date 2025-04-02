import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageInputCubit extends Cubit<bool> {
  MessageInputCubit() : super(true);

  void onTextChanged(String text) {
    emit(text.isEmpty); // Emit true if empty, false if there is text
  }
}
