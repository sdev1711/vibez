import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class DocumentDownloadCubit extends Cubit<bool> {
  DocumentDownloadCubit() : super(false); // false = not downloaded

  Future<void> checkIfDownloaded(String fileName) async {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/$fileName';
    final fileExists = File(path).existsSync();
    emit(fileExists);
  }

  Future<void> downloadFile(String url, String fileName) async {
    try {
      final response = await http.get(Uri.parse(url));
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/$fileName';
      final file = File(path);
      await file.writeAsBytes(response.bodyBytes);
      emit(true); // Download complete
    } catch (e) {
      emit(false); // Optional: error handling
    }
  }
}
