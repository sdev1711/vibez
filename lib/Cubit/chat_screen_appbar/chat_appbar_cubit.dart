import 'package:flutter_bloc/flutter_bloc.dart';

class ChatAppbarCubit extends Cubit<String?> {
  ChatAppbarCubit() : super(null);

  void selectMessage(String messageId) => emit(messageId);
  void clearSelection() => emit(null);
}
