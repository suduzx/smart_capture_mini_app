import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:smart_capture_mobile/blocs/restore_file_bloc/restore_file_event.dart';
import 'package:smart_capture_mobile/blocs/restore_file_bloc/restore_file_state.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_pdf_dto.dart';
import 'package:smart_capture_mobile/enum/file_status_enum.dart';
import 'package:smart_capture_mobile/repositories/local_capture_batch_repository.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';
import 'package:smart_capture_mobile/utils/mixin/number_util.dart';

class RestoreFileBloc extends Bloc<RestoreFileEvent, RestoreFileState>
    with NumberUtil, DatetimeUtil {
  RestoreFileBloc(super.initialState) {
    on<RestoreConfirmEvent>(_restoreConfirmEvent);
    on<RestoreEvent>(_restoreEvent);
  }

  FutureOr<void> _restoreConfirmEvent(
      RestoreConfirmEvent event, Emitter<RestoreFileState> emit) {
    emit(const RestoreConfirmEventSuccess(
      title: 'Khôi phục ảnh',
      message:
          'Thao tác này sẽ khôi phục lại ảnh.\nBạn có chắc chắn muốn khôi phục ảnh này?',
    ));
  }

  FutureOr<void> _restoreEvent(
      RestoreEvent event, Emitter<RestoreFileState> emit) async {
    CaptureBatchDto albumDto = event.albumDto;
    List<int> selectedImages = event.imageIndexes;
    List<int> selectedPDFs = event.pdfIndexes;
    if (selectedPDFs.isNotEmpty) {
      List<String> restorePDFNames = [];
      List<CaptureBatchPdfDto> listDeletedPDF =
          FileStatus.deleted.filterPDF(albumDto.metadata!.pdfs!);
      for (var index in selectedPDFs) {
        restorePDFNames.add(listDeletedPDF[index].metadata!.name);
      }
      for (var pdf in albumDto.metadata!.pdfs!) {
        if (restorePDFNames.contains(pdf.metadata!.name)) {
          pdf.metadata!.status = FileStatus.inUse;
        }
      }
    }

    if (selectedImages.isNotEmpty) {
      List<String> restoreImageNames = [];
      List<CaptureBatchImageDto> listDeletedImage =
          FileStatus.deleted.filter(albumDto.metadata!.images!);
      for (var index in selectedImages) {
        restoreImageNames.add(listDeletedImage[index].metadata!.name);
      }
      for (var image in albumDto.metadata!.images!) {
        if (restoreImageNames.contains(image.metadata!.name)) {
          image.metadata!.status = FileStatus.inUse;
        }
      }
    }

    await LocalCaptureBatchRepository().sortThenUpdate(albumDto);

    emit(const RestoreEventSuccess(title: 'File đã được khôi phục'));
  }
}
