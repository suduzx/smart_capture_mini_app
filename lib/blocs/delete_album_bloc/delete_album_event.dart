import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:flutter/material.dart';

@immutable
class DeleteAlbumEvent {
  final CaptureBatchDto captureBatchDto;

  const DeleteAlbumEvent(this.captureBatchDto);
}
