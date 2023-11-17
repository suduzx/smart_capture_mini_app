import 'package:flutter/material.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';

class CameraState {
  const CameraState();

  List<Object?> get props => [];
}

class OnCameraTapEventSuccess extends CameraState {
  final int limitAlbumImageParam;
  final int locationChangeInterval;

  const OnCameraTapEventSuccess({
    required this.limitAlbumImageParam,
    required this.locationChangeInterval,
  });

  @override
  List<Object> get props => [limitAlbumImageParam, locationChangeInterval];
}

class CameraStateError extends CameraState {
  final String title;
  final String message;
  final String titleButton;

  const CameraStateError({
    required this.title,
    required this.message,
    required this.titleButton,
  }) : super();

  @override
  List<Object?> get props => [];
}

class OnCameraTapEventError extends CameraStateError {
  final String datetime;
  const OnCameraTapEventError({
    required super.title,
    required super.message,
    required super.titleButton,
    required this.datetime,
  });

  @override
  List<Object?> get props => [];
}

class TakePhotoEventSuccess extends CameraState {
  final CaptureBatchDto albumDto;
  final int image;

  const TakePhotoEventSuccess({
    required this.albumDto,
    required this.image,
  });

  @override
  List<Object> get props => [albumDto];
}

class NotTakeMorePhoto extends CameraState {
  const NotTakeMorePhoto();
}

class TakePhotoEventError extends CameraStateError {
  final String datetime;
  final bool exceeding;

  const TakePhotoEventError({
    required this.datetime,
    this.exceeding = false,
    required String title,
    required String message,
    required String titleButton,
  }) : super(title: title, message: message, titleButton: titleButton);

  @override
  List<Object?> get props => [exceeding, title, message, titleButton];
}

class AddLocationAndWaterMarkEventSuccess extends CameraStateError {
  final String alertSuccess;

  const AddLocationAndWaterMarkEventSuccess({
    required this.alertSuccess,
    String title = '',
    String message = '',
    String titleButton = '',
  }) : super(title: title, message: message, titleButton: titleButton);

  @override
  List<Object?> get props => [title, message, titleButton];
}
