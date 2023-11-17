import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';
import 'package:flutter/material.dart';

@immutable
abstract class DetailImageEvent {
  const DetailImageEvent();
}

@immutable
class AfterMovedEvent extends DetailImageEvent {
  final CaptureBatchImageDto image;
  final String albumNameReceived;

  const AfterMovedEvent({
    required this.image,
    required this.albumNameReceived,
  }) : super();
}

@immutable
class LoadImageEvent extends DetailImageEvent {
  final String imageName;

  const LoadImageEvent({
    required this.imageName,
  }) : super();
}

@immutable
class EditImageEvent extends DetailImageEvent {
  final BuildContext context;
  final String contentTime;

  const EditImageEvent({
    required this.context,
    required this.contentTime,
  }) : super();
}

@immutable
class AfterEditImageEvent extends DetailImageEvent {
  const AfterEditImageEvent() : super();
}
