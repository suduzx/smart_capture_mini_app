import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';
import 'package:flutter/material.dart';

@immutable
class MoveFileState {
  const MoveFileState();

  List<Object?> get props => [];
}

class ShowMoveBottomSheetEventSuccess extends MoveFileState {
  final List<CaptureBatchDto> albums;

  const ShowMoveBottomSheetEventSuccess({
    required this.albums,
  }) : super();
}

class CheckLengthImageCanMoveEventSuccess extends MoveFileState {
  final CaptureBatchDto sharedAlbum;

  const CheckLengthImageCanMoveEventSuccess({
    required this.sharedAlbum,
  }) : super();
}

class CheckLengthImageCanMoveEventError extends MoveFileState {
  final String title;
  final String message;
  final String titleButton;

  const CheckLengthImageCanMoveEventError({
    required this.title,
    required this.message,
    required this.titleButton,
  }) : super();
}

class ConfirmLengthImageCanMove extends MoveFileState {
  final CaptureBatchDto sharedAlbum;
  final List<CaptureBatchImageDto>? listImageMove;
  final int? lengthCanMove;
  final String title;
  final String message;

  const ConfirmLengthImageCanMove({
    required this.sharedAlbum,
    this.listImageMove,
    this.lengthCanMove,
    required this.title,
    required this.message,
  }) : super();
}

class MoveEventSuccess extends MoveFileState {
  final CaptureBatchImageDto image;
  final String albumNameReceived;
  final int lengthMove;

  const MoveEventSuccess({
    required this.image,
    required this.albumNameReceived,
    required this.lengthMove,
  }) : super();
}

class MoveEventError extends MoveFileState {
  final String title;
  final String message;
  final String titleButton;

  const MoveEventError({
    required this.title,
    required this.message,
    required this.titleButton,
  }) : super();
}