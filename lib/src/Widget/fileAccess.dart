// ignore_for_file: file_names
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class FileAccess {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/userinfo.json');
  }

  Future<String> readInfo() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "";
    }
  }

  Future<File> writeInfo(String content) async {
    final file = await _localFile;
    return file.writeAsString('$content');
  }

  Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/userinfo.json');
  }

  static Future<File> saveToFile(String data) async {
    final file = await getFile;
    return file.writeAsString(data);
  }

  static Future<String> readFromFile() async {
    try {
      final file = await getFile;
      String fileContents = await file.readAsString();
      return fileContents;
    } catch (e) {
      return "";
    }
  }

  static Future<File> get getFile async {
    final path = await getFilePath;
    return File('$path/userinfo.json');
  }

  static Future<String> get getFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static void removeFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      if (await checkFile()) {
        File('${directory.path}/userinfo.json').delete();
      }
    } catch (Exception) {
      // ignore: avoid_print
      print(Exception.toString());
    }
  }

  static Future<bool> checkFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return await File(await '${directory.path}/userinfo.json').exists();
  }
}
