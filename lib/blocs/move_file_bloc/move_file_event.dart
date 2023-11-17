import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';
import 'package:flutter/material.dart';

@immutable
abstract class MoveFileEvent {
  const MoveFileEvent();
}

@immutable
class ShowMoveBottomSheetEvent extends MoveFileEvent {
  const ShowMoveBottomSheetEvent();
}

@immutable
class CheckLengthImageCanMoveEvent extends MoveFileEvent {
  final String albumNameSelected;
  final List<int> imageIndexes;

  const CheckLengthImageCanMoveEvent(this.albumNameSelected, this.imageIndexes);
}

@immutable
class MoveEvent extends MoveFileEvent {
  final CaptureBatchDto albumDto;
  final CaptureBatchDto sharedAlbum;
  final List<int> imageIndexes;
  final List<CaptureBatchImageDto>? listImageMove;
  final int? lengthCanMove;

  const MoveEvent(
    this.albumDto,
    this.sharedAlbum,
    this.imageIndexes,
    this.listImageMove,
    this.lengthCanMove,
  );
}
