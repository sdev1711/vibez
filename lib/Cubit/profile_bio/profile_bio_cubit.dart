import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBioCubit extends Cubit<bool> {
  ProfileBioCubit() : super(false);

  void setVisibility(bool visible) {
    emit(visible);
  }
}