import 'package:equatable/equatable.dart';
import 'package:story_view/controller/story_controller.dart';

class StoryState extends Equatable {
  final StoryController controller;

  const StoryState({required this.controller});

  @override
  List<Object> get props => [controller];
}