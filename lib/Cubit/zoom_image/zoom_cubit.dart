import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:vibez/Cubit/zoom_image/zoom_state.dart';

class ZoomCubit extends Cubit<ZoomState> {
  ZoomCubit() : super(ZoomState());

  void updateScale(double scale) {
    emit(state.copyWith(scale: scale.clamp(1.0, 4.0)));
  }

  void updateOffset(Offset offset) {
    emit(state.copyWith(offset: offset));
  }

  void resetZoom() {
    emit(ZoomState());
  }
}


