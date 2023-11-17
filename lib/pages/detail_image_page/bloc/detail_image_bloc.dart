import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mpcore/mpcore.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';
import 'package:smart_capture_mobile/enum/action_log_enum.dart';
import 'package:smart_capture_mobile/flavor.dart';
import 'package:smart_capture_mobile/pages/detail_image_page/bloc/detail_image_event.dart';
import 'package:smart_capture_mobile/pages/detail_image_page/bloc/detail_image_state.dart';
import 'package:smart_capture_mobile/repositories/local_capture_batch_repository.dart';
import 'package:smart_capture_mobile/services/capture_batch_service.dart';
import 'package:smart_capture_mobile/services/diod.dart';
import 'package:smart_capture_mobile/utils/file_utils.dart';
import 'package:smart_capture_mobile/utils/log_util.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';
import 'package:smart_capture_mobile/utils/mixin/number_util.dart';
import 'package:smart_capture_mobile/utils/sync_util.dart';

class DetailImageBloc extends Bloc<DetailImageEvent, DetailImageState>
    with DatetimeUtil, NumberUtil {
  DetailImageBloc(super.initialState) {
    on<LoadImageEvent>(_loadImageEvent);
    on<AfterMovedEvent>(_afterMovedEvent);
    on<EditImageEvent>(_editImageEvent);
    on<AfterEditImageEvent>(_afterEditImageEvent);
  }

  FutureOr<void> _loadImageEvent(
      LoadImageEvent event, Emitter<DetailImageState> emit) async {
    try {
      List<CaptureBatchDto> albums =
          await LocalCaptureBatchRepository().getAll(isReadOnly: true);
      int albumIndex = albums.indexWhere(
          (album) => album.metadata!.captureName == state.albumName);
      CaptureBatchDto album = albums[albumIndex];
      CaptureBatchImageDto image = album.metadata!.images!
          .where((image) => image.metadata!.name == event.imageName)
          .first;
      emit(LoadImageEventSuccess(
        rootAlbumPath: state.rootAlbumPath,
        albumDTO: album,
        imageDTO: image,
        albumName: state.albumName,
      ));
    } catch (e) {
      emit(LoadImageEventError(
        rootAlbumPath: state.rootAlbumPath,
        albumDTO: state.albumDTO,
        imageDTO: state.imageDTO,
        albumName: state.albumName,
      ));
    }
  }

  FutureOr<void> _afterMovedEvent(
      AfterMovedEvent event, Emitter<DetailImageState> emit) async {
    List<CaptureBatchDto> albums =
        await LocalCaptureBatchRepository().getAll(isReadOnly: true);
    int albumIndex = albums.indexWhere(
        (album) => album.metadata!.captureName == event.albumNameReceived);
    emit(AfterMovedEventSuccess(
      rootAlbumPath: state.rootAlbumPath,
      albumDTO: albums[albumIndex],
      imageDTO: event.image,
      albumName: state.albumName,
    ));
  }

  FutureOr<void> _editImageEvent(
      EditImageEvent event, Emitter<DetailImageState> emit) async {
    LogUtil().addActionLog(ActionLogEnum.editImage);
    await ImageEditor()
        .imageEditorWritePath(
          context: event.context,
          image: '${state.rootAlbumPath}${state.imageDTO.metadata!.path}',
          nameImage: state.imageDTO.metadata!.name,
          contentTime: event.contentTime,
          isSync: state.imageDTO.metadata!.isSync,
        )
        .then((isSuccess) => emit(
              EditImageEventComplete(
                isSuccess: isSuccess,
                rootAlbumPath: state.rootAlbumPath,
                albumDTO: state.albumDTO,
                imageDTO: state.imageDTO,
                albumName: state.albumName,
              ),
            ));
  }

  FutureOr<void> _afterEditImageEvent(
      AfterEditImageEvent event, Emitter<DetailImageState> emit) async {
    try {
      CaptureBatchDto album = state.albumDTO;
      CaptureBatchImageDto image = state.imageDTO;
      int indexImage = album.metadata!.images!.indexWhere(
          (element) => element.metadata!.name == image.metadata!.name);
      await FileUtils.deleteFile(
          '${state.rootAlbumPath}${state.imageDTO.metadata!.thumbPath}');
      String? thumbImageName = await FileUtils.compressThumbImage(
          '${state.rootAlbumPath}${album.metadata!.path}',
          image.metadata!.name);
      image.metadata!.thumbPath = '${album.metadata!.path}/$thumbImageName.jpg';
      LocalCaptureBatchRepository localCaptureBatchRepository =
          LocalCaptureBatchRepository();
      image = await localCaptureBatchRepository.updateValueImage(image);
      if (image.id != null) {
        image = await SyncUtil().syncImage(
          CaptureBatchService(dio: DioD().dio, baseUrl: F.apiUrl),
          LocalCaptureBatchRepository(),
          album,
          image,
          state.rootAlbumPath,
        );
      }
      album.metadata!.images![indexImage] = image;
      await localCaptureBatchRepository.sortThenUpdate(album);
      emit(AfterEditImageEventComplete(
        rootAlbumPath: state.rootAlbumPath,
        albumDTO: album,
        imageDTO: image,
        albumName: state.albumName,
      ));
    } catch (e) {
      debugPrint('_afterEditImageEvent: ${e.toString()}');
    }
  }
}
