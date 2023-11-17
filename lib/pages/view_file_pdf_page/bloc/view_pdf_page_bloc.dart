import 'dart:async';
import 'dart:io';

import 'package:smart_capture_mobile/pages/view_file_pdf_page/bloc/view_pdf_page_event.dart';
import 'package:smart_capture_mobile/pages/view_file_pdf_page/bloc/view_pdf_page_state.dart';
import 'package:smart_capture_mobile/utils/file_utils.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';
import 'package:smart_capture_mobile/utils/mixin/number_util.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class ViewPdfPageBloc extends Bloc<ViewPdfPageEvent, ViewPdfPageState>
    with DatetimeUtil, NumberUtil {
  ViewPdfPageBloc(super.initialState) {
    on<LoadPdfFileEvent>(_loadPdfFileEvent);
  }

  FutureOr<void> _loadPdfFileEvent(
      LoadPdfFileEvent event, Emitter<ViewPdfPageState> emit) async {
    try {
      String rootAlbumPath = await FileUtils.getRootAlbumPath();
      String absolutePath = '$rootAlbumPath${event.pdf.metadata!.path}';
      File file = File(absolutePath);
      emit(LoadPdfFileEventSuccess(
        rootAlbumPath: rootAlbumPath,
        albumDto: event.album,
        pdf: event.pdf,
        file: file,
      ));
    } catch (e) {
      debugPrint('_loadPdfFileEvent: $e');
      emit(LoadPdfFileEventError(
        title: 'Có lỗi xảy ra',
        message:
            'Hiện không thể mở tệp PDF này do không tìm thấy đường dẫn file. Vui lòng kiểm tra và thử lại',
        titleButton: 'OK',
        albumDto: event.album,
        pdf: event.pdf,
      ));
    }
  }
}
