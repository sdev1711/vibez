import 'package:flutter_bloc/flutter_bloc.dart';

class EmojiCubit extends Cubit<bool> {
  EmojiCubit() : super(false);

  void toggleEmojiKeyboard() => emit(!state);

  void closeEmojiKeyboard() => emit(false);
}

