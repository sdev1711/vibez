import 'dart:io';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class DocumentDownloadCubit extends Cubit<bool> {
  DocumentDownloadCubit() : super(false); // false = not downloaded

  Future<void> checkIfDownloaded(String fileName) async {
    final downloadsDir = Directory('/storage/emulated/0/Download');
    final path = '${downloadsDir.path}/$fileName';
    final fileExists = File(path).existsSync();
    emit(fileExists);
  }

  Future<void> downloadFile(String url, String fileName) async {
    try {

      final response = await http.get(Uri.parse(url));


      final downloadsDir = Directory('/storage/emulated/0/Download');
      final path = '${downloadsDir.path}/$fileName';
      final file = File(path);
      await file.writeAsBytes(response.bodyBytes);
      final result = await FileSaver.instance.saveFile(
        name: fileName.split('.').first,
        bytes: response.bodyBytes,
        ext: fileName.split('.').last,
        mimeType: MimeType.other,
      );
      debugPrint("File saved at: $path");
      emit(true);
    } catch (e) {
      debugPrint("Download failed: $e");
      emit(false);
    }
  }

}


