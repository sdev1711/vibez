import 'package:flutter/material.dart';

class ZoomState {
  final double scale;
  final Offset offset;

  ZoomState({this.scale = 1.0, this.offset = Offset.zero});

  ZoomState copyWith({double? scale, Offset? offset}) {
    return ZoomState(
      scale: scale ?? this.scale,
      offset: offset ?? this.offset,
    );
  }
}