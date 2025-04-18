import 'package:bloc/bloc.dart';
import 'package:story_view/story_view.dart';
import 'package:vibez/Cubit/story/story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  StoryCubit() : super(StoryState(controller: StoryController()));

  void completeStory() {
    emit(StoryState(controller: StoryController()));
  }
}
