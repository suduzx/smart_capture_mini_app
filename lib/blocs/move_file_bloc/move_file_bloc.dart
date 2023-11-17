import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:smart_capture_mobile/flavor.dart';
import 'package:smart_capture_mobile/blocs/move_file_bloc/move_file_event.dart';
import 'package:smart_capture_mobile/blocs/move_file_bloc/move_file_state.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';
import 'package:smart_capture_mobile/enum/file_status_enum.dart';
import 'package:smart_capture_mobile/repositories/local_capture_batch_repository.dart';
import 'package:smart_capture_mobile/repositories/local_capture_business_repository.dart';
import 'package:smart_capture_mobile/services/capture_batch_service.dart';
import 'package:smart_capture_mobile/services/diod.dart';
import 'package:smart_capture_mobile/utils/file_utils.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';
import 'package:smart_capture_mobile/utils/mixin/number_util.dart';

class MoveFileBloc extends Bloc<MoveFileEvent, MoveFileState>
    with DatetimeUtil, NumberUtil {
  MoveFileBloc(super.initialState) {
    on<ShowMoveBottomSheetEvent>(_showMoveBottomSheetEvent);
    on<CheckLengthImageCanMoveEvent>(_checkLengthImageCanMoveEvent);
    on<MoveEvent>(_moveEvent);
  }

  FutureOr<void> _showMoveBottomSheetEvent(
      ShowMoveBottomSheetEvent event, Emitter<MoveFileState> emit) async {
    List<CaptureBatchDto> albums =
        await LocalCaptureBatchRepository().getAll(isReadOnly: true);
    emit(ShowMoveBottomSheetEventSuccess(albums: albums));
  }

  FutureOr<void> _checkLengthImageCanMoveEvent(
      CheckLengthImageCanMoveEvent event, Emitter<MoveFileState> emit) async {
    LocalCaptureBatchRepository repository = LocalCaptureBatchRepository();
    List<CaptureBatchDto> albums = await repository.getAll(isReadOnly: true);
    final int? limitAlbumParam =
        await LocalCaptureBusinessRepository().getLimitNumberOfImagePerAlbum();
    if (limitAlbumParam == null) {
      emit(const CheckLengthImageCanMoveEventError(
        title: 'Cấu hình chưa được đồng bộ',
        message: 'Vui lòng đăng nhập lại để đồng bộ thêm cấu hình từ hệ thống',
        titleButton: 'ĐÃ HIỂU',
      ));
      return;
    }
    List<int> selectedImages = event.imageIndexes;
    int sharedAlbumIndex = albums.indexWhere(
        (album) => album.metadata!.captureName == event.albumNameSelected);
    CaptureBatchDto sharedAlbum = albums.elementAt(sharedAlbumIndex);
    int lengthImage = sharedAlbum.metadata!.images!.length;
    if (lengthImage >= limitAlbumParam) {
      emit(const CheckLengthImageCanMoveEventError(
        title: 'Di chuyển ảnh thất bại',
        message:
            "Ảnh không di chuyển thành công do Album đã đạt số lượng ảnh tối đa.\nVui lòng kiểm tra lại album hoặc xóa các ảnh không cần thiết.",
        titleButton: 'OK',
      ));
      return;
    }

    int lengthCanMove = limitAlbumParam - lengthImage;
    if (lengthCanMove < selectedImages.length) {
      emit(ConfirmLengthImageCanMove(
        sharedAlbum: sharedAlbum,
        lengthCanMove: lengthCanMove,
        title: 'Không thể di chuyển tất cả',
        message:
            'Chỉ di chuyển được $lengthCanMove/${selectedImages.length} ảnh do album nhận hiện đã có $lengthImage ảnh.\nBạn có muốn tiếp tục di chuyển không?',
      ));
      return;
    }
    emit(CheckLengthImageCanMoveEventSuccess(sharedAlbum: sharedAlbum));
  }

  Future<void> _moveEvent(MoveEvent event, Emitter<MoveFileState> emit) async {
    final rootAlbumPath = await FileUtils.getRootAlbumPath();
    final albumDTO = event.albumDto;
    final sharedAlbum = event.sharedAlbum;

    List<CaptureBatchImageDto> listImageMove = [];
    if (event.listImageMove != null) {
      listImageMove = event.listImageMove!
          .where((img) => img.metadata!.hasBeenUsed == false)
          .toList();
    } else {
      final listIndexCanMove = event.lengthCanMove == null
          ? event.imageIndexes
          : event.imageIndexes.sublist(0, event.lengthCanMove!);

      final listInUseImage =
          FileStatus.inUse.filter(albumDTO.metadata!.images!);
      listImageMove =
          listIndexCanMove.map((index) => listInUseImage[index]).toList();

      final lengthImageHasBeenUsed = listImageMove
          .where((img) => img.metadata!.hasBeenUsed == true)
          .length;
      if (lengthImageHasBeenUsed > 0) {
        final lengthCanMove = listImageMove.length - lengthImageHasBeenUsed;
        if (lengthCanMove > 0) {
          emit(ConfirmLengthImageCanMove(
            sharedAlbum: sharedAlbum,
            listImageMove: listImageMove,
            title: 'Không thể di chuyển tất cả',
            message:
                'Chỉ di chuyển được $lengthCanMove/${listImageMove.length} ảnh do có $lengthImageHasBeenUsed ảnh đã được các kênh sử dụng.\nBạn có muốn tiếp tục di chuyển không?',
          ));
          return;
        } else {
          emit(const MoveEventError(
            title: 'Di chuyển thất bại',
            message:
                'Ảnh không di chuyển thành công do đã được các kênh sử dụng. Vui lòng kiểm tra lại!',
            titleButton: 'OK',
          ));
          return;
        }
      }
    }

    final captureBatchService = CaptureBatchService(
      dio: DioD().dio,
      baseUrl: F.apiUrl,
    );
    final captureBatchImageIds = listImageMove
        .where((img) => img.id != null && img.metadata!.isSync)
        .map((img) => img.id!)
        .join(',');

    await captureBatchService.deleteImages(
      captureBatchImageIds: captureBatchImageIds,
    );

    final movedImageName = <String>[];
    CaptureBatchImageDto? imageDto;
    for (final image in listImageMove) {
      final movedImage = await _moveImage(rootAlbumPath, sharedAlbum, image);
      sharedAlbum.metadata!.images!.add(movedImage);
      sharedAlbum.metadata!.lastImageIndex = _getLastImageIndex(sharedAlbum);
      movedImageName.add(movedImage.metadata!.name);
      imageDto = movedImage;
    }

    final localCaptureBatchRepository = LocalCaptureBatchRepository();

    sharedAlbum.metadata!.images!.sort();
    await localCaptureBatchRepository.sortThenUpdate(sharedAlbum);

    albumDTO.metadata!.images!.retainWhere(
      (img) => !movedImageName.contains(img.metadata!.name),
    );
    await localCaptureBatchRepository.sortThenUpdate(albumDTO);

    emit(MoveEventSuccess(
      image: imageDto!,
      albumNameReceived: sharedAlbum.metadata!.captureName!,
      lengthMove: listImageMove.length,
    ));
  }

  Future<CaptureBatchImageDto> _moveImage(String rootAlbumPath,
      CaptureBatchDto album, CaptureBatchImageDto image) async {
    String oldAbsoluteImagePath = '$rootAlbumPath${image.metadata!.path}';
    final imageIndex = album.metadata!.lastImageIndex! + 1;
    image.metadata!.name =
        '${album.metadata!.captureName}_${imageIndex.toString().padLeft(3, '0')}';
    image.metadata!.path =
        '${album.metadata!.path}/${image.metadata!.name}.jpg';
    String newAbsoluteImagePath = '$rootAlbumPath${image.metadata!.path}';
    await FileUtils.move(oldAbsoluteImagePath, newAbsoluteImagePath);
    await FileUtils.deleteFile('$rootAlbumPath${image.metadata!.thumbPath}');
    String? thumbImageName = await FileUtils.compressThumbImage(
        '$rootAlbumPath${album.metadata!.path}', image.metadata!.name);
    image.metadata!.thumbPath = '${album.metadata!.path}/$thumbImageName.jpg';
    image.id = null;
    image = await LocalCaptureBatchRepository().updateValueImage(image);
    return image;
  }

  int _getLastImageIndex(CaptureBatchDto album) {
    final images = album.metadata!.images ?? [];
    final imageNumbers = images
        .map((image) => int.parse(image.metadata!.name.split('_').last))
        .toList();

    final maxImageNumber =
        imageNumbers.isNotEmpty ? imageNumbers.reduce(max) : 0;
    final lastImageIndex = album.metadata!.lastImageIndex!;
    return lastImageIndex >= maxImageNumber ? lastImageIndex : maxImageNumber;
  }
}
