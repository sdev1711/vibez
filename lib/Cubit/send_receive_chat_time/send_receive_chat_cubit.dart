import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeCubit extends Cubit<DateTime> {
  StreamSubscription? _timerSubscription;

  TimeCubit() : super(DateTime.now()) {
    _startUpdatingTime();
  }

  void _startUpdatingTime() {
    _timerSubscription = Stream.periodic(const Duration(seconds:20), (_) {
      return DateTime.now();
    }).listen((time) {
      emit(time);
    });
  }

  @override
  Future<void> close() {
    _timerSubscription?.cancel();
    return super.close();
  }

  /// Returns formatted time dynamically
  String formattedTime(String timestamp) {
    return timeago.format(
      DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)),
      locale: 'en_short',
    ).replaceAll("~", "");
  }
}



