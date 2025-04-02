import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:story_view/story_view.dart';

class StoryState extends Equatable {
  final StoryController controller;

  const StoryState({required this.controller});

  @override
  List<Object> get props => [controller];
}

class StoryCubit extends Cubit<StoryState> {
  StoryCubit() : super(StoryState(controller: StoryController()));

  void completeStory() {
    emit(StoryState(controller: StoryController())); // Reset controller
  }
}
