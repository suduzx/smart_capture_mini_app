import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mp_path_provider/mp_path_provider.dart';
import 'package:mpcore/mpcore.dart';
import 'package:mpcore/utils/mp_file.dart' as MPFile;

class FileUtils {
  static Future<String?> compressThumbImage(String albumPath, String imageName,
      {int? width = 360}) async {
    try {
      // Chuẩn bị đường dẫn file
      String thumbImageName =
          '${DateTime.now().toUtc().toString()}_thumb_$imageName';
      thumbImageName = thumbImageName.replaceAll(':', '');
      thumbImageName = thumbImageName.replaceAll('/', '');
      thumbImageName = thumbImageName.replaceAll('\\', '');
      String thumbImagePath = '$albumPath/$thumbImageName.jpg';

      MPFile.File file = MPFile.File('$albumPath/$imageName.jpg');
      await file.copy(thumbImagePath);

      await ImageEditor().convertedImage(
        image: thumbImagePath,
        quality: 50,
      );
      // Uint8List imageBytes =
      //     await MPFile.File('$albumPath/$imageName.jpg').readAsBytes();
      // img.Image? image = img.decodeImage(imageBytes);
      // if (image == null) {
      //   return null;
      // }
      // // Resize ảnh & lưu lại
      // img.Image? thumbImage = img.copyResize(image, width: width);
      // final thumbBytes = img.encodeJpg(thumbImage);
      // await MPFile.File(thumbImagePath).writeAsBytes(thumbBytes);

      return thumbImageName;
    } catch (ex) {
      debugPrint('FileUtils.compressThumbImage: ${ex.toString()}');
    }
    return null;
  }

  static MPFile.File getFile(String path) {
    return MPFile.File(path);
  }

  static Future<MPFile.File> getJson(String fileName) async {
    final path = await getApplicationSupportPath();
    return MPFile.File('$path/$fileName');
  }

  static Future<MultipartFile> getMultipartFile(String absolutePath) async {
    // Uint8List fileData = absolutePath.endsWith('pdf')
    //     ? await MPFile.FileManager.getFileManager()
    //         .readAsBytesSync(MPFile.File(absolutePath))
    //     : await MPFile.FileManager.getFileManager()
    //         .readFile(MPFile.File(absolutePath));
    Uint8List fileData = await MPFile.File(absolutePath).readAsBytes();
    String filename = absolutePath
        .substring(absolutePath.lastIndexOf('/') + 1)
        .replaceAll(':', '');
    MediaType mediaType = absolutePath.endsWith('pdf')
        ? MediaType('application', 'pdf')
        : MediaType('image', 'jpeg');
    return MultipartFile.fromBytes(fileData,
        filename: filename, contentType: mediaType);
  }

  static Future<bool> deleteFile(String absolutePath,
      {bool isRelativePath = false}) async {
    try {
      if (isRelativePath) {
        final path = await getApplicationSupportPath();
        absolutePath = '$path/$absolutePath';
      }
      MPFile.File file = MPFile.File(absolutePath);
      await file.delete(recursive: true);
      return true;
    } catch (e) {
      debugPrint('FileUtils.deleteFile: ${e.toString()}');
      return false;
    }
  }

  static Future<bool> deleteDirectory(String absolutePath) async {
    try {
      MPFile.Directory dir = MPFile.Directory(absolutePath);
      await dir.delete(recursive: true);
      return true;
    } catch (e) {
      debugPrint('FileUtils.deleteDirectory: ${e.toString()}');
      return false;
    }
  }

  static Future<bool> move(
      String oldAbsolutePath, String newAbsolutePath) async {
    try {
      MPFile.File file = MPFile.File(oldAbsolutePath);
      await file.copy(newAbsolutePath);
      return await deleteFile(oldAbsolutePath);
    } catch (e) {
      debugPrint('FileUtils.move: $e');
      return false;
    }
  }

  static Future<String> getRootAlbumPath() async {
    String? dir = await getApplicationSupportPath();
    if (dir == null || dir.isEmpty) {
      return '';
    }
    dir += '/Albums'; // /storage/emulated/0/Android
    MPFile.Directory directory = MPFile.Directory(dir);
    if (!(await directory.exists())) {
      directory.create(recursive: true);
    }
    return dir;
  }

  static Future<bool> createDirectory(String absolutePath) async {
    try {
      final MPFile.Directory dir = MPFile.Directory(absolutePath);
      if (!(await dir.exists())) {
        await dir.create(recursive: true);
      }
      return true;
    } on Exception catch (e) {
      debugPrint('FileUtils.createDirectory: ${e.toString()}');
      return false;
    }
  }

  static Future<int> getFileSize(String absolutePath) async {
    Uint8List fileData = await MPFile.File(absolutePath).readAsBytes();
    return fileData.length;
  }
}
