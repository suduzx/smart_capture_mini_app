import 'package:flutter/material.dart';
import 'package:smart_capture_mobile/blocs/sync_bloc/sync_data.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_pdf_dto.dart';
import 'package:smart_capture_mobile/dtos/result_sync.dart';
import 'package:smart_capture_mobile/enum/file_status_enum.dart';
import 'package:smart_capture_mobile/repositories/local_capture_batch_repository.dart';
import 'package:smart_capture_mobile/services/capture_batch_service.dart';
import 'package:smart_capture_mobile/utils/file_utils.dart';

class SyncUtil {
  Future<CaptureBatchImageDto> syncImage(
    CaptureBatchService captureBatchService,
    LocalCaptureBatchRepository localCaptureBatchRepository,
    CaptureBatchDto album,
    CaptureBatchImageDto image,
    String rootAlbumPath,
  ) async {
    try {
      final uploadResult = await captureBatchService.uploadImage(
          captureBatchId: album.id!,
          rootAlbumPath: rootAlbumPath,
          image: image);
      if (uploadResult.isFailure) {
        image.metadata!.isSync = false;
        return image;
      }
      CaptureBatchImageDto dto = uploadResult.success!.data!.result![0];
      image.id = dto.id;
      image.captureId = dto.captureId;
      image.name = dto.name;
      image.pageIndex = dto.pageIndex;
      image.bucketName = dto.bucketName;
      image.s3Url = dto.s3Url;
      image.s3UrlThumbnail = dto.s3UrlThumbnail;
      image.metadata!.isSync = dto.id != null;
      return image;
    } catch (e) {
      debugPrint(e.toString());
      return image;
    }
  }

  Future<ResultSync> syncAlbum(
    String? imagePath,
    String? albumPath,
    CaptureBatchService captureBatchService,
    LocalCaptureBatchRepository localCaptureBatchRepository,
  ) async {
    debugPrint('SyncUtil.syncAlbum: START');
    ResultSync resultSync = ResultSync();
    try {
      String rootAlbumPath = await FileUtils.getRootAlbumPath();
      while (SyncData.datas.isNotEmpty) {
        List<CaptureBatchDto> albums =
            await localCaptureBatchRepository.getAll(isReadOnly: true);
        String path = SyncData.datas.first;
        CaptureBatchDto album;
        if (path.startsWith(SyncData.prefixUpdateT24)) {
          path = path.replaceAll(SyncData.prefixUpdateT24, '');
          album = albums.firstWhere((album) => album.metadata!.path == path);
          album = await _syncUpdateT24(
            captureBatchService,
            album,
            rootAlbumPath,
          );
          if (albumPath != null) {
            albumPath = album.metadata!.path;
            resultSync.albumName = album.metadata!.captureName;
          }
        } else {
          album = albums
              .firstWhere((album) => path.contains(album.metadata!.path!));
          if (path.startsWith(SyncData.prefixImage)) {
            await _syncImages(
              captureBatchService,
              localCaptureBatchRepository,
              path,
              album,
              rootAlbumPath,
            );
          } else {
            await _syncPdfs(
              captureBatchService,
              localCaptureBatchRepository,
              path,
              album,
              rootAlbumPath,
            );
          }
        }
        SyncData.datas.removeAt(0);
        await Future.delayed(const Duration(milliseconds: 333));
      }
      debugPrint('SyncUtil.syncAlbum: COMPLETED');
      List<CaptureBatchDto> albums =
          await localCaptureBatchRepository.getAll(isReadOnly: true);
      if (imagePath != null) {
        resultSync.result = albums
                .firstWhere(
                    (album) => imagePath.startsWith(album.metadata!.path!))
                .metadata!
                .images!
                .firstWhere((img) => img.metadata!.path == imagePath)
                .metadata!
                .isSync ==
            true;
      } else if (albumPath != null) {
        resultSync.result = albums
            .where((album) => album.metadata!.path == albumPath)
            .every((album) => album.metadata!.isSync == true);
      } else {
        resultSync.result = albums
            .where((album) => album.metadata!.priorityDisplay == 1)
            .every((album) => album.metadata!.isSync == true);
      }
      return resultSync;
    } catch (e) {
      debugPrint('SyncUtil.syncAlbum: ERROR - ${e.toString()}');
      return resultSync;
    }
  }

  Future<CaptureBatchDto> _syncUpdateT24(
    CaptureBatchService captureBatchService,
    CaptureBatchDto album,
    String rootAlbumPath,
  ) async {
    try {
      debugPrint('SyncUtil._syncUpdateT24.path: ${album.metadata!.path}');
      final result = await captureBatchService.updateInfoT24(
        captureBatchId: album.id!,
      );
      if (result.isFailure) {
        return album;
      }
      CaptureBatchDto captureBatch = result.success!.data!.result![0];
      String oldName = album.metadata!.captureName!;
      String newName = captureBatch.metadata!.captureName!;
      if (oldName == newName) {
        return album;
      }
      String albumPath = album.metadata!.path!.replaceAll(oldName, newName);

      await FileUtils.createDirectory('$rootAlbumPath/$albumPath');
      if (album.metadata!.images != null) {
        await Future.forEach(album.metadata!.images!, (img) async {
          SyncData.datas
              .retainWhere((element) => !element.contains(img.metadata!.path));
          await FileUtils.move('$rootAlbumPath${img.metadata!.path}',
              '$rootAlbumPath${img.metadata!.path.replaceAll(oldName, newName)}');
          await FileUtils.move('$rootAlbumPath${img.metadata!.thumbPath}',
              '$rootAlbumPath${img.metadata!.thumbPath.replaceAll(oldName, newName)}');
          img.metadata!.name = img.metadata!.name.replaceAll(oldName, newName);
          img.metadata!.path = img.metadata!.path.replaceAll(oldName, newName);
          img.metadata!.thumbPath =
              img.metadata!.thumbPath.replaceAll(oldName, newName);
          if (img.metadata!.isSync == false &&
              img.metadata!.status == FileStatus.inUse &&
              !SyncData.datas
                  .contains('${SyncData.prefixImage}${img.metadata!.path}')) {
            SyncData.datas.add('${SyncData.prefixImage}${img.metadata!.path}');
          }
        });
      }
      if (album.metadata!.pdfs != null) {
        await Future.forEach(album.metadata!.pdfs!, (pdf) async {
          SyncData.datas
              .retainWhere((element) => !element.contains(pdf.metadata!.path));
          await FileUtils.move('$rootAlbumPath${pdf.metadata!.path}',
              '$rootAlbumPath${pdf.metadata!.path.replaceAll(oldName, newName)}');
          pdf.metadata!.name = pdf.metadata!.name.replaceAll(oldName, newName);
          pdf.metadata!.path = pdf.metadata!.path.replaceAll(oldName, newName);
          if (pdf.metadata!.isSync == false &&
              pdf.metadata!.status == FileStatus.inUse &&
              !SyncData.datas
                  .contains('${SyncData.prefixPdf}${pdf.metadata!.path}')) {
            SyncData.datas.add('${SyncData.prefixPdf}${pdf.metadata!.path}');
          }
        });
      }
      await FileUtils.deleteDirectory('$rootAlbumPath/${album.metadata!.path}');

      album.metadata!.path = albumPath;
      album.metadata!.nationalId = captureBatch.metadata!.nationalId;
      album.metadata!.captureName = captureBatch.metadata!.captureName;
      album.metadata!.customerName = captureBatch.metadata!.customerName;
      album.metadata!.customerId = captureBatch.metadata!.customerId;

      await LocalCaptureBatchRepository().sortThenUpdate(
        album,
        updateModified: false,
      );

      return album;
    } catch (e) {
      debugPrint(e.toString());
      return album;
    }
  }

  Future<void> _syncImages(
    CaptureBatchService captureBatchService,
    LocalCaptureBatchRepository localCaptureBatchRepository,
    String path,
    CaptureBatchDto album,
    String rootAlbumPath,
  ) async {
    try {
      debugPrint('SyncUtil._syncImages.path: $path');
      path = path.replaceAll(SyncData.prefixImage, '');
      CaptureBatchImageDto image = album.metadata!.images!
          .firstWhere((img) => img.metadata!.path == path);
      image = await syncImage(captureBatchService, localCaptureBatchRepository,
          album, image, rootAlbumPath);
      List<CaptureBatchDto> albums =
          await localCaptureBatchRepository.getAll(isReadOnly: true);
      album =
          albums.firstWhere((album) => path.startsWith(album.metadata!.path!));
      int index = album.metadata!.images!
          .indexWhere((img) => img.metadata!.path == path);
      album.metadata!.images![index] = image;
      await localCaptureBatchRepository.sortThenUpdate(
        album,
        updateModified: false,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _syncPdfs(
    CaptureBatchService captureBatchService,
    LocalCaptureBatchRepository localCaptureBatchRepository,
    String path,
    CaptureBatchDto album,
    String rootAlbumPath,
  ) async {
    try {
      debugPrint('SyncUtil._syncPdfs.path: $path');
      path = path.replaceAll(SyncData.prefixPdf, '');
      CaptureBatchPdfDto pdf =
          album.metadata!.pdfs!.firstWhere((p) => p.metadata!.path == path);
      final uploadResult = await captureBatchService.uploadPdf(
        captureBatchId: album.id!,
        rootAlbumPath: rootAlbumPath,
        metadataPdfDto: pdf.metadata!,
        pageIndex: pdf.metadata!.pageIndex,
      );
      if (uploadResult.isSuccess) {
        CaptureBatchPdfDto dto = uploadResult.success!.data!.result![0];
        pdf.id = dto.id;
        pdf.captureId = dto.captureId;
        pdf.fileType = dto.captureId;
        pdf.name = dto.name;
        pdf.pageIndex = dto.pageIndex;
        pdf.bucketName = dto.bucketName;
        pdf.s3Url = dto.s3Url;
        pdf.s3UrlThumbnail = dto.s3UrlThumbnail;
        pdf.metadata!.isSync = dto.id != null;
      }
      List<CaptureBatchDto> albums =
          await localCaptureBatchRepository.getAll(isReadOnly: true);
      album =
          albums.firstWhere((album) => path.startsWith(album.metadata!.path!));
      int index =
          album.metadata!.pdfs!.indexWhere((p) => p.metadata!.path == path);
      album.metadata!.pdfs![index] = pdf;
      await localCaptureBatchRepository.sortThenUpdate(
        album,
        updateModified: false,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
