import 'package:bloc/bloc.dart';

class VideoVisibilityCubit extends Cubit<bool> {
  VideoVisibilityCubit() : super(false);

  void setVisibility(bool visible) {
    emit(visible);
  }
}
