import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ImagePickerCubit extends Cubit<File?>{
  ImagePickerCubit():super(null);
  final ImagePicker picker= ImagePicker();
  VideoPlayerController? videoController;
  Future<void> pickImage()async{
    final pickedFile=await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if(pickedFile != null){
      emit(File(pickedFile.path));
    }
  }
  Future<void> pickImageFromCamera()async{
    final pickedFile=await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if(pickedFile != null){
      emit(File(pickedFile.path));
    }
  }
  Future<void> pickVideo() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      final videoFile = File(pickedFile.path);
      videoController = VideoPlayerController.file(videoFile)
        ..initialize().then((_) {
          emit(videoFile); // Emit the video file
        });
    } else {
      log("No video selected");
    }
  }
  Future<void> pickVideoFromCamera() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.camera);

    if (pickedFile != null) {
      final videoFile = File(pickedFile.path);
      videoController = VideoPlayerController.file(videoFile)
        ..initialize().then((_) {
          emit(videoFile); // Emit the video file
        });
    } else {
      log("No video selected");
    }
  }

  void clearVideo() {
    videoController?.dispose();
    videoController = null;
    emit(null);
  }
  void clearImage(){
    emit(null);
  }
}