import 'dart:io';

import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_pdf_dto.dart';
import 'package:flutter/material.dart';

@immutable
class ViewPdfPageState {
  final String rootAlbumPath;
  final CaptureBatchDto albumDto;
  final CaptureBatchPdfDto pdf;
  final File? file;

  const ViewPdfPageState({
    required this.rootAlbumPath,
    required this.albumDto,
    required this.pdf,
    this.file,
  });

  List<Object?> get props => [rootAlbumPath, albumDto, pdf, file];
}

class LoadPdfFileEventSuccess extends ViewPdfPageState {
  const LoadPdfFileEventSuccess({
    required String rootAlbumPath,
    required CaptureBatchDto albumDto,
    required CaptureBatchPdfDto pdf,
    required File? file,
  }) : super(
          rootAlbumPath: rootAlbumPath,
          albumDto: albumDto,
          pdf: pdf,
          file: file,
        );
}

class LoadPdfFileEventError extends ViewPdfPageState {
  final String title;
  final String message;
  final String titleButton;

  const LoadPdfFileEventError({
    required this.title,
    required this.message,
    required this.titleButton,
    required CaptureBatchDto albumDto,
    required CaptureBatchPdfDto pdf,
  }) : super(
          rootAlbumPath: '',
          albumDto: albumDto,
          pdf: pdf,
          file: null,
        );
}
