import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:flutter/material.dart';

@immutable
abstract class CameraEvent {
  const CameraEvent();
}

@immutable
class OnCameraTapEvent extends CameraEvent {
  const OnCameraTapEvent();
}

@immutable
class TakePhotoEvent extends CameraEvent {
  final CaptureBatchDto albumDTO;
  final int limitAlbumImageParam;
  final int locationChangeInterval;

  const TakePhotoEvent(
    this.albumDTO,
    this.limitAlbumImageParam,
    this.locationChangeInterval,
  );
}

@immutable
class AddLocationAndWaterMarkEvent extends CameraEvent {
  final CaptureBatchDto albumDTO;
  final int image;

  const AddLocationAndWaterMarkEvent(this.albumDTO, this.image);
}
