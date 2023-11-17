import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';
import 'package:smart_capture_mobile/dtos/business/user_account_dto.dart';
import 'package:smart_capture_mobile/enum/album_customer_type_enum.dart';
import 'package:smart_capture_mobile/enum/file_status_enum.dart';
import 'package:smart_capture_mobile/repositories/local_user_repository.dart';
import 'package:smart_capture_mobile/utils/encrypt_util.dart';
import 'package:smart_capture_mobile/utils/file_utils.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';

class LocalCaptureBatchRepository with DatetimeUtil {
  final String _fileName = 'capture_batch.json';

  Future<MetadataAlbumDto> createMetadataAlbumDto(
      UserAccountDto currentUser, CaptureBatchDto album,
      {bool? createAlbumDefault = false}) async {
    MetadataAlbumDto metadataAlbumDto = album.metadata!;
    String albumPath = '';
    if (currentUser.username.isNotEmpty && createAlbumDefault == false) {
      albumPath += '/${currentUser.username}';
    }
    albumPath +=
        '/${createAlbumDefault == true ? 'default' : metadataAlbumDto.captureName!}';
    String absoluteAlbumPath =
        '${await FileUtils.getRootAlbumPath()}$albumPath';
    await FileUtils.createDirectory(absoluteAlbumPath);
    metadataAlbumDto.ownerUser =
        createAlbumDefault == true ? '' : currentUser.username;
    metadataAlbumDto.priorityDisplay = createAlbumDefault == true ? 0 : 1;
    metadataAlbumDto.path = albumPath;
    metadataAlbumDto.numberOfImage = 0;
    metadataAlbumDto.images = List.empty(growable: true);
    metadataAlbumDto.pdfs = List.empty(growable: true);
    metadataAlbumDto.isSync = album.id != null;
    metadataAlbumDto.thumbnailImage = '';
    metadataAlbumDto.createdDate = DateTime.now().toUtc().toString();
    metadataAlbumDto.createdByUser = currentUser.username;
    metadataAlbumDto.modifiedDate = DateTime.now().toUtc().toString();
    metadataAlbumDto.modifiedByUser = currentUser.username;
    metadataAlbumDto.lastImageIndex = 0;
    return metadataAlbumDto;
  }

  Future<bool> sortThenUpdate(
    CaptureBatchDto album, {
    bool? updateModified = true,
    bool? createAlbumDefault = false,
  }) async {
    try {
      album.metadata!.pdfs!.sort();
      album.metadata!.images!.sort();
      List<CaptureBatchImageDto> listImagesInUse =
          FileStatus.inUse.filter(album.metadata!.images!);
      album.metadata!.numberOfImage = listImagesInUse.length;
      album.metadata!.thumbnailImage = listImagesInUse.isEmpty
          ? ''
          : listImagesInUse.first.metadata!.thumbPath;
      if (updateModified == true) {
        album.metadata!.modifiedDate = DateTime.now().toUtc().toString();
        album.metadata!.modifiedByUser = album.metadata!.ownerUser;
      }
      album.metadata!.isSync = album.id != null &&
          FileStatus.inUse
              .filter(album.metadata!.images!)
              .every((element) => element.metadata!.isSync == true) &&
          FileStatus.inUse
              .filterPDF(album.metadata!.pdfs!)
              .every((element) => element.metadata!.isSync == true);
      List<CaptureBatchDto> albums = [];
      if (createAlbumDefault == true) {
        albums.add(album);
      } else {
        albums = await getAll(isReadOnly: false);
        final index = albums.indexWhere((a) =>
            album.metadata!.captureName!.toLowerCase() ==
                a.metadata!.captureName!.toLowerCase() &&
            album.metadata!.ownerUser!.toLowerCase() ==
                a.metadata!.ownerUser!.toLowerCase());
        if (index < 0) {
          albums.add(album);
        } else {
          albums[index] = album;
        }
        albums.sort();
      }
      String json = jsonEncode(albums);
      json = await EncryptUtil.encrypt(json);
      final file = await FileUtils.getJson(_fileName);
      await file.writeAsString(json);
      return true;
    } catch (e) {
      debugPrint('sortThenUpdate: $e');
      return false;
    }
  }

  Future<List<CaptureBatchDto>> getAll({required bool isReadOnly}) async {
    List<CaptureBatchDto> albums = [];
    UserAccountDto? currentUser = await LocalUserRepository().getCurrentUser();
    try {
      final file = await FileUtils.getJson(_fileName);
      String content = await file.readAsString();
      content = await EncryptUtil.decrypt(content);
      List<dynamic> list = jsonDecode(content);
      albums = List<CaptureBatchDto>.from(
          list.map<CaptureBatchDto>((e) => CaptureBatchDto.fromJson(e)));
      if (albums.isNotEmpty && isReadOnly) {
        albums = albums
            .where((album) =>
                album.metadata!.ownerUser!.isEmpty ||
                album.metadata!.ownerUser == currentUser?.username)
            .toList();
      }
    } catch (e) {
      debugPrint('listAlbums: $e');
      albums = [];
    }
    if (albums.isEmpty) {
      CaptureBatchDto captureBatchDto = CaptureBatchDto();
      captureBatchDto.metadata = MetadataAlbumDto(
          nationalId: null,
          customerType: CustomerType.khcn.name,
          customerName: null,
          captureName: 'Album mặc định');
      captureBatchDto.metadata = await createMetadataAlbumDto(
          currentUser!, captureBatchDto,
          createAlbumDefault: true);
      await sortThenUpdate(captureBatchDto, createAlbumDefault: true);
      albums.add(captureBatchDto);
    }
    return albums;
  }

  Future<CaptureBatchImageDto> updateValueImage(
      CaptureBatchImageDto imageDto) async {
    UserAccountDto? currentUser = await LocalUserRepository().getCurrentUser();
    imageDto.metadata!.modifiedDate = DateTime.now().toUtc().toString();
    imageDto.metadata!.modifiedByUser = currentUser?.username ?? '';
    imageDto.metadata!.isSync = imageDto.id != null;
    return imageDto;
  }

  Future<bool> deleteAlbum(CaptureBatchDto albumDto) async {
    try {
      List<CaptureBatchDto> albums = await getAll(isReadOnly: false);
      albums.removeWhere((element) =>
          element.metadata!.captureName!.toLowerCase() ==
              albumDto.metadata!.captureName!.toLowerCase() &&
          element.metadata!.ownerUser!.toLowerCase() ==
              albumDto.metadata!.ownerUser!.toLowerCase());
      albums.sort();
      final file = await FileUtils.getJson(_fileName);
      String json = jsonEncode(albums);
      json = await EncryptUtil.encrypt(json);
      await file.writeAsString(json);
      return true;
    } catch (e) {
      debugPrint('deleteAlbum: $e');
      return false;
    }
  }

  Future<void> cleanUpAlbumOver(Duration duration) async {
    debugPrint('cleanUpOver: START');
    try {
      String rootAlbumPath = await FileUtils.getRootAlbumPath();
      DateTime now = DateTime.now();
      List<CaptureBatchDto> albums = await getAll(isReadOnly: false);
      await Future.forEach(albums, (album) async {
        /// Image
        List<String> deletedImageNames = [];
        await Future.forEach(album.metadata!.images!, (image) async {
          DateTime createdDate = string2Datetime(image.metadata!.createdDate);
          if (createdDate.isBefore(now.subtract(duration))) {
            await FileUtils.deleteFile('$rootAlbumPath${image.metadata!.path}');
            await FileUtils.deleteFile(
                '$rootAlbumPath${image.metadata!.thumbPath}');
            deletedImageNames.add(image.metadata!.name);
          }
        });
        if (deletedImageNames.isNotEmpty) {
          album.metadata!.images!.retainWhere(
              (image) => !deletedImageNames.contains(image.metadata!.name));
        }

        /// PDF
        List<String> deletedPDFNames = [];
        await Future.forEach(album.metadata!.pdfs!, (pdf) async {
          DateTime createdDate = string2Datetime(pdf.metadata!.createdDate);
          if (createdDate.isBefore(now.subtract(duration))) {
            await FileUtils.deleteFile('$rootAlbumPath${pdf.metadata!.path}');
            deletedPDFNames.add(pdf.metadata!.name);
          }
        });
        if (deletedPDFNames.isNotEmpty) {
          album.metadata!.pdfs!.retainWhere(
              (pdf) => !deletedPDFNames.contains(pdf.metadata!.name));
        }
        await LocalCaptureBatchRepository().sortThenUpdate(
          album,
          updateModified: false,
        );
      });
      debugPrint('cleanUpOver: END');
    } catch (e) {
      debugPrint('cleanUpOver: $e');
    }
  }
}
