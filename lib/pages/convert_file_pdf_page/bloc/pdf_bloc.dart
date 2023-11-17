import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:convert_image_to_pdf/image_to_pdf.dart';
import 'package:flutter/material.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_pdf_dto.dart';
import 'package:smart_capture_mobile/dtos/business/user_account_dto.dart';
import 'package:smart_capture_mobile/enum/file_status_enum.dart';
import 'package:smart_capture_mobile/pages/convert_file_pdf_page/bloc/pdf_event.dart';
import 'package:smart_capture_mobile/pages/convert_file_pdf_page/bloc/pdf_state.dart';
import 'package:smart_capture_mobile/repositories/local_capture_batch_repository.dart';
import 'package:smart_capture_mobile/repositories/local_user_repository.dart';
import 'package:smart_capture_mobile/utils/file_utils.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';
import 'package:smart_capture_mobile/utils/mixin/number_util.dart';

class PdfBloc extends Bloc<PdfEvent, PdfState> with DatetimeUtil, NumberUtil {
  PdfBloc(super.initialState) {
    on<CheckDisableConvertEvent>(_checkDisableConvertEvent);
    on<ConvertPdfEvent>(_convertPdfEvent);
  }

  FutureOr<void> _checkDisableConvertEvent(
      CheckDisableConvertEvent event, Emitter<PdfState> emit) {
    emit(CheckDisableConvertEventSuccess(
        isDisableConvert: event.pdfName.isEmpty));
  }

  FutureOr<void> _convertPdfEvent(
      ConvertPdfEvent event, Emitter<PdfState> emit) async {
    CaptureBatchDto albumDto = event.albumDto;
    String pdfName = '${albumDto.metadata!.captureName}_${event.pdfName}.pdf';
    if (!RegExp(r"^[a-zA-Z\d]+$").hasMatch(event.pdfName)) {
      emit(const ConvertPdfEventError(
          isDisableConvert: true,
          textError:
              'Tên file không được chứa dấu, dấu cách và ký tự đặc biệt'));
      return;
    }
    if (albumDto.metadata!.pdfs!.any(
        (pdf) => pdf.metadata!.name.toLowerCase() == pdfName.toLowerCase())) {
      emit(const ConvertPdfEventError(
        isDisableConvert: true,
        textError:
            'Album đã có tên file PDF này. Vui lòng chỉnh sửa tên file khác',
      ));
      return;
    }
    UserAccountDto? currentUser = await LocalUserRepository().getCurrentUser();
    String rootAlbumPath = await FileUtils.getRootAlbumPath();

    List<CaptureBatchImageDto> imageInUse =
        FileStatus.inUse.filter(albumDto.metadata!.images!);

    List<String> pdfPathImages = event.selectedImages
        .map((idx) =>
            '$rootAlbumPath${imageInUse.elementAt(idx).metadata!.path}')
        .toList();

    final res = await ImageToPDF().addImageToPDF(
        filePath: pdfPathImages,
        savePath: '$rootAlbumPath${albumDto.metadata!.path}',
        nameFilePdf: pdfName);

    if (!res) {
      debugPrint('convertImageToPDF: Có lỗi xảy ra khi convert');
      emit(const ConvertPdfEventError(
        isDisableConvert: true,
        textError: 'Có lỗi xảy ra khi convert. Vui lòng thử lại',
      ));
      return;
    }

    final Iterable<int> idxs =
        albumDto.metadata!.pdfs!.map((e) => e.metadata!.pageIndex);
    int maxIndex = idxs.isEmpty ? 0 : idxs.reduce(max);

    CaptureBatchPdfDto pdf = CaptureBatchPdfDto(
      metadata: MetadataPdfDto(
        dataFileIds: event.selectedImages
            .map((idx) => imageInUse.elementAt(idx).id!)
            .toList(),
        name: pdfName,
        path: '${albumDto.metadata!.path}/$pdfName',
        createdDate: DateTime.now().toUtc().toString(),
        createdByUser: currentUser?.username ?? '',
        modifiedDate: DateTime.now().toUtc().toString(),
        modifiedByUser: currentUser?.username ?? '',
        pageIndex: maxIndex + 1,
      ),
    );

    albumDto.metadata!.pdfs!.add(pdf);
    await LocalCaptureBatchRepository().sortThenUpdate(albumDto);

    emit(const ConvertPdfEventSuccess(
      isDisableConvert: true,
    ));
  }
}
