import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/pages/home_page/bloc/home_event.dart';
import 'package:smart_capture_mobile/pages/home_page/bloc/home_state.dart';
import 'package:smart_capture_mobile/repositories/local_capture_batch_repository.dart';
import 'package:smart_capture_mobile/repositories/local_capture_business_repository.dart';
import 'package:smart_capture_mobile/utils/file_utils.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';
import 'package:smart_capture_mobile/utils/mixin/number_util.dart';
import 'package:smart_capture_mobile/utils/mixin/permission_handler_util.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>
    with PermissionHandlerUtil, DatetimeUtil, NumberUtil {
  HomeBloc(super.initialState) {
    on<AfterInitEvent>(_afterInitEvent);
    on<OnLoadAlbumEvent>(_onLoadAlbumEvent);
    on<CreateAlbumEvent>(_createAlbumEvent);
    on<AlbumItemTapEvent>(_albumItemTapEvent);
    on<AlbumMoreOptionTapEvent>(_albumMoreOptionTapEvent);
  }

  FutureOr<void> _afterInitEvent(
      AfterInitEvent event, Emitter<HomeState> emit) async {
    bool hasStoragePermission = await requestStoragePermission();
    if (!hasStoragePermission) {
      emit(AfterInitEventError());
      return;
    }
    emit(AfterInitEventSuccess());
  }

  FutureOr<void> _onLoadAlbumEvent(
      OnLoadAlbumEvent event, Emitter<HomeState> emit) async {
    try {
      String rootAlbumPath = await FileUtils.getRootAlbumPath();
      List<CaptureBatchDto> albums =
          await LocalCaptureBatchRepository().getAll(isReadOnly: true);
      if (event.textFilter.isEmpty) {
        emit(OnLoadAlbumEventSuccess(
          rootAlbumPath: rootAlbumPath,
          albums: albums,
          filteredAlbum: albums,
        ));
      } else {
        List<CaptureBatchDto> filteredAlbum = albums
            .where((album) => album.metadata!.captureName!
                .toLowerCase()
                .contains(event.textFilter.toLowerCase()))
            .toList();
        emit(OnLoadAlbumEventSuccess(
          rootAlbumPath: rootAlbumPath,
          albums: albums,
          filteredAlbum: filteredAlbum,
        ));
      }
    } catch (e) {
      emit(OnLoadAlbumEventError());
    }
  }

  FutureOr<void> _createAlbumEvent(
      CreateAlbumEvent event, Emitter<HomeState> emit) async {
    final int? limitAlbumParam =
        await LocalCaptureBusinessRepository().getLimitNumberOfAlbums();
    if (limitAlbumParam == null) {
      emit(CreateAlbumEventError(
          homeState: state,
          title: 'Cấu hình chưa được đồng bộ',
          message:
              'Vui lòng đăng nhập lại để đồng bộ thêm cấu hình từ hệ thống',
          titleButton: 'ĐÃ HIỂU'));
      return;
    }
    if (state.albums.length >= limitAlbumParam) {
      emit(CreateAlbumEventError(
          homeState: state,
          title: 'Tài khoản đã đủ $limitAlbumParam album',
          message: 'Vui lòng kiểm tra lại hoặc xóa các album không cần thiết',
          titleButton: 'QUAY TRỞ LẠI'));
      return;
    }
    emit(CreateAlbumEventSuccess(
      homeState: state,
      limitAlbumParam: limitAlbumParam,
    ));
  }

  FutureOr<void> _albumItemTapEvent(
      AlbumItemTapEvent event, Emitter<HomeState> emit) async {
    emit(AlbumItemTapEventSuccess(
      homeState: state,
      albumDto: event.albumDto,
    ));
    return;
  }

  FutureOr<void> _albumMoreOptionTapEvent(
      AlbumMoreOptionTapEvent event, Emitter<HomeState> emit) async {
    emit(AlbumMoreOptionTapEventSuccess(
      homeState: state,
      albumDto: event.albumDto,
    ));
    return;
  }
}
