import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:flutter/material.dart';

@immutable
abstract class RestoreFileEvent {
  const RestoreFileEvent();
}

@immutable
class RestoreConfirmEvent extends RestoreFileEvent {
  const RestoreConfirmEvent();
}

@immutable
class RestoreEvent extends RestoreFileEvent {
  final CaptureBatchDto albumDto;
  final List<int> imageIndexes;
  final List<int> pdfIndexes;

  const RestoreEvent(
    this.albumDto,
    this.imageIndexes,
    this.pdfIndexes,
  );
}
