import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:smart_capture_mobile/blocs/sync_bloc/sync_data.dart';
import 'package:smart_capture_mobile/blocs/sync_bloc/sync_event.dart';
import 'package:smart_capture_mobile/blocs/sync_bloc/sync_state.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/result_sync.dart';
import 'package:smart_capture_mobile/enum/file_status_enum.dart';
import 'package:smart_capture_mobile/flavor.dart';
import 'package:smart_capture_mobile/repositories/local_capture_batch_repository.dart';
import 'package:smart_capture_mobile/repositories/local_capture_business_repository.dart';
import 'package:smart_capture_mobile/services/capture_batch_service.dart';
import 'package:smart_capture_mobile/services/diod.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';
import 'package:smart_capture_mobile/utils/mixin/number_util.dart';
import 'package:smart_capture_mobile/utils/sync_util.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState>
    with DatetimeUtil, NumberUtil {
  SyncBloc(super.initialState) {
    on<AddSyncDataEvent>(_addSyncDataEvent);
    on<SyncAlbumEvent>(_syncAlbumEvent);
  }

  FutureOr<void> _addSyncDataEvent(
      AddSyncDataEvent event, Emitter<SyncState> emit) async {
    try {
      int? remainTime = await LocalCaptureBusinessRepository().getRemainTime();
      await LocalCaptureBatchRepository()
          .cleanUpAlbumOver(Duration(days: remainTime!));
      List<CaptureBatchDto> albums =
          await LocalCaptureBatchRepository().getAll(isReadOnly: true);
      if (event.albumPath != null) {
        albums.retainWhere((album) => album.metadata!.path == event.albumPath);
      } else {
        albums.retainWhere((album) => album.metadata!.priorityDisplay == 1);
      }
      if (event.imagePath != null &&
          !SyncData.datas
              .contains('${SyncData.prefixImage}${event.imagePath}')) {
        SyncData.datas.add('${SyncData.prefixImage}${event.imagePath}');
      } else {
        for (var album in albums) {
          if (album.metadata!.customerId == null &&
              !SyncData.datas.contains(
                  '${SyncData.prefixUpdateT24}${album.metadata!.path!}')) {
            SyncData.datas
                .add('${SyncData.prefixUpdateT24}${album.metadata!.path!}');
          }
          if (album.metadata!.isSync == true) {
            continue;
          }
          for (var image in (album.metadata!.images ?? [])) {
            if (image.metadata!.isSync == false &&
                image.metadata!.status == FileStatus.inUse &&
                !SyncData.datas.contains(
                    '${SyncData.prefixImage}${image.metadata!.path}')) {
              SyncData.datas
                  .add('${SyncData.prefixImage}${image.metadata!.path}');
            }
          }
          for (var pdf in (album.metadata!.pdfs ?? [])) {
            if (pdf.metadata!.isSync == false &&
                pdf.metadata!.status == FileStatus.inUse &&
                !SyncData.datas
                    .contains('${SyncData.prefixPdf}${pdf.metadata!.path}')) {
              SyncData.datas.add('${SyncData.prefixPdf}${pdf.metadata!.path}');
            }
          }
        }
      }
      emit(AddSyncDataEventSuccess(
        imagePath: event.imagePath,
        albumPath: event.albumPath,
        showAlert: event.showAlert,
      ));
    } catch (e) {
      emit(AddSyncDataEventError(showAlert: event.showAlert));
    }
  }

  FutureOr<void> _syncAlbumEvent(
      SyncAlbumEvent event, Emitter<SyncState> emit) async {
    try {
      if (event.isSyncCompleted == false) {
        emit(SyncAlbumEventError(
          showAlert: event.showAlert,
          title: 'Hiện chưa thể thao tác',
          message:
              'Hiện tại đang tiến hành đồng bộ tự động ảnh lên hệ thống. Vui lòng thử lại sau!',
          titleButton: 'OK',
        ));
        return;
      }
      SyncUtil syncUtil = SyncUtil();
      ResultSync resultSync = await syncUtil.syncAlbum(
        event.imagePath,
        event.albumPath,
        CaptureBatchService(dio: DioD().dio, baseUrl: F.apiUrl),
        LocalCaptureBatchRepository(),
      );
      if (resultSync.result) {
        emit(SyncAlbumEventCompleted(
          showAlert: event.showAlert,
          albumName: resultSync.albumName,
          isSuccess: true,
        ));
      } else {
        emit(SyncAlbumEventCompleted(
          showAlert: event.showAlert,
          isSuccess: false,
        ));
      }
    } catch (e) {
      emit(SyncAlbumEventCompleted(
        showAlert: event.showAlert,
        isSuccess: false,
      ));
    }
  }
}
