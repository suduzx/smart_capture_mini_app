import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_capture_mobile/flavor.dart';
import 'package:smart_capture_mobile/blocs/delete_file_bloc/delete_file_event.dart';
import 'package:smart_capture_mobile/blocs/delete_file_bloc/delete_file_state.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_pdf_dto.dart';
import 'package:smart_capture_mobile/enum/file_status_enum.dart';
import 'package:smart_capture_mobile/repositories/local_capture_batch_repository.dart';
import 'package:smart_capture_mobile/services/capture_batch_service.dart';
import 'package:smart_capture_mobile/services/diod.dart';
import 'package:smart_capture_mobile/utils/file_utils.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';
import 'package:smart_capture_mobile/utils/mixin/number_util.dart';

class DeleteFileBloc extends Bloc<DeleteFileEvent, DeleteFileState>
    with NumberUtil, DatetimeUtil {
  DeleteFileBloc(super.initialState) {
    on<DeleteConfirmEvent>(_deleteConfirmEvent);
    on<DeleteEvent>(_deleteEvent);
  }

  FutureOr<void> _deleteConfirmEvent(
      DeleteConfirmEvent event, Emitter<DeleteFileState> emit) {
    emit(DeleteConfirmEventSuccess(
      isDeleteAll: event.isDeleteAll,
      title: event.isDeleteAll ? 'Xóa tất cả file' : 'Xóa file',
      message: event.fileStatus == FileStatus.deleted
          ? 'Thao tác này sẽ không thể khôi phục lại.\nBạn có chắc chắn muốn xóa file này vĩnh viễn?'
          : 'Thao tác này sẽ đưa file vào "Ảnh đã xóa".\nBạn có chắc chắn muốn xóa file này?',
    ));
  }

  FutureOr<void> _deleteEvent(
      DeleteEvent event, Emitter<DeleteFileState> emit) async {
    String rootAlbumPath = await FileUtils.getRootAlbumPath();
    CaptureBatchDto albumDto = event.albumDto;
    FileStatus fileStatus = event.fileStatus;
    List<int> selectedImages = event.imageIndexes;
    List<int> selectedPDFs = event.pdfIndexes;
    List<CaptureBatchPdfDto> currentListPDF =
        fileStatus.filterPDF(albumDto.metadata!.pdfs!);
    List<CaptureBatchImageDto> currentListImage =
        fileStatus.filter(albumDto.metadata!.images!);
    CaptureBatchService captureBatchService =
        CaptureBatchService(dio: DioD().dio, baseUrl: F.apiUrl);

    if (event.isDeleteAll) {
      selectedImages = List.generate(currentListImage.length, (index) => index);
      selectedPDFs = List.generate(currentListPDF.length, (index) => index);
    }
    bool hasSomeFailure = false;
    if (selectedPDFs.isNotEmpty) {
      List<String> deletedSuccessIds = List.empty(growable: true);
      if (fileStatus == FileStatus.deleted) {
        String captureBatchPdfIds = selectedPDFs
            .map((index) => currentListPDF[index])
            .where((pdf) => pdf.id != null)
            .map((pdf) => pdf.id!)
            .join(',');
        final result = await captureBatchService.deletePDFs(
            captureBatchPdfIds: captureBatchPdfIds);
        result.when(
            success: (success) {
              deletedSuccessIds =
                  success.data!.result!.map((e) => e.result!).toList();
            },
            failure: (failure) {
              hasSomeFailure = true;
            });
        hasSomeFailure =
            hasSomeFailure || selectedPDFs.length != deletedSuccessIds.length;
      }
      await Future.forEach(selectedPDFs, (index) async {
        CaptureBatchPdfDto pdf = currentListPDF[index];
        String absolutePathPDF = '$rootAlbumPath${pdf.metadata!.path}';
        if (fileStatus == FileStatus.deleted) {
          if ((pdf.id != null &&
                  deletedSuccessIds.indexWhere((id) => id == pdf.id!) >= 0) ||
              pdf.id == null) {
            await FileUtils.deleteFile(absolutePathPDF);
            albumDto.metadata!.pdfs!.retainWhere(
                (element) => element.metadata!.name != pdf.metadata!.name);
          }
        } else {
          int index = albumDto.metadata!.pdfs!.indexWhere(
              (element) => element.metadata!.path == pdf.metadata!.path);
          albumDto.metadata!.pdfs![index].metadata!.status = FileStatus.deleted;
        }
      });
    }

    if (selectedImages.isNotEmpty) {
      List<String> deletedSuccessIds = List.empty(growable: true);
      if (fileStatus == FileStatus.deleted) {
        String captureBatchImageIds = selectedImages
            .map((index) => currentListImage[index])
            .where((image) => image.id != null)
            .map((image) => image.id!)
            .join(',');
        final result = await captureBatchService.deleteImages(
            captureBatchImageIds: captureBatchImageIds);
        result.when(
            success: (success) {
              deletedSuccessIds =
                  success.data!.result!.map((e) => e.result!).toList();
            },
            failure: (failure) {
              hasSomeFailure = true;
            });
        // hasSomeFailure =
        //     hasSomeFailure || selectedImages.length != deletedSuccessIds.length;
      }
      await Future.forEach(selectedImages, (index) async {
        CaptureBatchImageDto image = currentListImage[index];
        String absoluteImagePath = '$rootAlbumPath${image.metadata!.path}';
        String absoluteThumbImagePath =
            '$rootAlbumPath${image.metadata!.thumbPath}';
        if (fileStatus == FileStatus.deleted) {
          if ((image.id != null &&
                  deletedSuccessIds.indexWhere((id) => id == image.id!) >= 0) ||
              image.id == null) {
            await FileUtils.deleteFile(absoluteImagePath);
            await FileUtils.deleteFile(absoluteThumbImagePath);
            albumDto.metadata!.images!.retainWhere(
                (element) => element.metadata!.name != image.metadata!.name);
          }
        } else {
          int index = albumDto.metadata!.images!.indexWhere(
              (element) => element.metadata!.path == image.metadata!.path);
          albumDto.metadata!.images![index].metadata!.status =
              FileStatus.deleted;
        }
      });
    }
    await LocalCaptureBatchRepository().sortThenUpdate(albumDto);
    String title = fileStatus == FileStatus.inUse
        ? 'File đã được xóa'
        : 'File đã được xóa vĩnh viễn';
    if (hasSomeFailure) {
      debugPrint('hasSomeFailure');
      title = 'Xóa file không thành công';
      emit(DeleteEventError(title: title));
    } else {
      emit(DeleteEventSuccess(title: title));
    }
  }
}
