import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/enum/file_status_enum.dart';
import 'package:flutter/material.dart';

@immutable
abstract class DeleteFileEvent {
  const DeleteFileEvent();
}

@immutable
class DeleteConfirmEvent extends DeleteFileEvent {
  final FileStatus fileStatus;
  final bool isDeleteAll;

  const DeleteConfirmEvent(
    this.isDeleteAll,
    this.fileStatus,
  );
}

@immutable
class DeleteEvent extends DeleteFileEvent {
  final bool isDeleteAll;
  final CaptureBatchDto albumDto;
  final FileStatus fileStatus;
  final List<int> imageIndexes;
  final List<int> pdfIndexes;

  const DeleteEvent(
    this.isDeleteAll,
    this.albumDto,
    this.fileStatus,
    this.imageIndexes,
    this.pdfIndexes,
  );
}
