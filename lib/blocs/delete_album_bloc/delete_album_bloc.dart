import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_capture_mobile/flavor.dart';
import 'package:smart_capture_mobile/blocs/delete_album_bloc/delete_album_event.dart';
import 'package:smart_capture_mobile/blocs/delete_album_bloc/delete_album_state.dart';
import 'package:smart_capture_mobile/repositories/local_capture_batch_repository.dart';
import 'package:smart_capture_mobile/services/capture_batch_service.dart';
import 'package:smart_capture_mobile/services/diod.dart';
import 'package:smart_capture_mobile/utils/file_utils.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';
import 'package:smart_capture_mobile/utils/mixin/number_util.dart';

class DeleteAlbumBloc extends Bloc<DeleteAlbumEvent, DeleteAlbumState>
    with NumberUtil, DatetimeUtil {
  DeleteAlbumBloc(super.initialState) {
    on<DeleteAlbumEvent>(_deleteAlbumEvent);
  }

  Future<void> _deleteAlbumEvent(
      DeleteAlbumEvent event, Emitter<DeleteAlbumState> emit) async {
    try {
      if (event.captureBatchDto.id != null &&
          event.captureBatchDto.id!.isNotEmpty) {
        CaptureBatchService captureBatchService =
            CaptureBatchService(dio: DioD().dio, baseUrl: F.apiUrl);
        await captureBatchService.delete(
            captureBatchId: event.captureBatchDto.id!);
      }
      await FileUtils.deleteDirectory(
          '${await FileUtils.getRootAlbumPath()}${event.captureBatchDto.metadata!.path}');
      if (await LocalCaptureBatchRepository()
          .deleteAlbum(event.captureBatchDto)) {
        emit(const DeleteAlbumEventSuccess());
      } else {
        emit(const DeleteAlbumEventError());
      }
    } catch (e) {
      debugPrint('removeAlbum: ${e.toString()}');
      emit(const DeleteAlbumEventError());
    }
  }
}
