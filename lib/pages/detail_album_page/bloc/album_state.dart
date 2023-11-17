import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_pdf_dto.dart';
import 'package:smart_capture_mobile/dtos/business/tree_value_sync_bpm/tree_value_sync_bpm_dto.dart';
import 'package:smart_capture_mobile/enum/file_status_enum.dart';
import 'package:flutter/material.dart';

@immutable
class AlbumState {
  final String rootAlbumPath;
  final List<CaptureBatchDto> albums;
  final CaptureBatchDto albumDTO;
  final String albumName;
  final bool selectionMode;
  final List<int> selectedImages;
  final List<int> selectedPDFs;
  final FileStatus fileStatus;
  final List<CaptureBatchImageDto> images;
  final List<CaptureBatchPdfDto> pdfs;

  const AlbumState({
    required this.rootAlbumPath,
    required this.albums,
    required this.albumDTO,
    required this.albumName,
    required this.selectionMode,
    required this.selectedImages,
    required this.selectedPDFs,
    required this.fileStatus,
    required this.images,
    required this.pdfs,
  });

  List<Object?> get props => [
        rootAlbumPath,
        albums,
        albumDTO,
        albumName,
        selectionMode,
        selectedImages,
        selectedPDFs,
        fileStatus,
      ];
}

class LoadAlbumEventSuccess extends AlbumState {
  final bool autoSync;

  LoadAlbumEventSuccess({
    required this.autoSync,
    required String rootAlbumPath,
    required List<CaptureBatchDto> albums,
    required CaptureBatchDto albumDTO,
    required String albumName,
    required FileStatus fileStatus,
    required List<CaptureBatchImageDto> images,
    required List<CaptureBatchPdfDto> pdfs,
  }) : super(
          rootAlbumPath: rootAlbumPath,
          albums: albums,
          albumDTO: albumDTO,
          albumName: albumName,
          selectionMode: false,
          selectedImages: [],
          selectedPDFs: [],
          fileStatus: fileStatus,
          images: images,
          pdfs: pdfs,
        );
}

class LoadAlbumEventError extends AlbumState {
  LoadAlbumEventError({
    required CaptureBatchDto albumDto,
  }) : super(
          rootAlbumPath: '',
          albums: [],
          albumDTO: albumDto,
          albumName: '',
          selectionMode: false,
          selectedImages: [],
          selectedPDFs: [],
          fileStatus: FileStatus.inUse,
          images: [],
          pdfs: [],
        );
}

class SelectionModeEventSuccess extends AlbumState {
  SelectionModeEventSuccess({
    required AlbumState state,
    required bool selectionMode,
  }) : super(
          rootAlbumPath: state.rootAlbumPath,
          albums: state.albums,
          albumDTO: state.albumDTO,
          albumName: state.albumName,
          selectionMode: selectionMode,
          selectedImages: [],
          selectedPDFs: [],
          fileStatus: state.fileStatus,
          images: state.images,
          pdfs: state.pdfs,
        );
}

class ItemTapEventSuccess extends AlbumState {
  ItemTapEventSuccess({
    required AlbumState state,
    required List<int> selectedImages,
    required List<int> selectedPDFs,
  }) : super(
          rootAlbumPath: state.rootAlbumPath,
          albums: state.albums,
          albumDTO: state.albumDTO,
          albumName: state.albumName,
          selectionMode: state.selectionMode,
          selectedImages: selectedImages,
          selectedPDFs: selectedPDFs,
          fileStatus: state.fileStatus,
          images: state.images,
          pdfs: state.pdfs,
        );
}

class ConvertPDFEventSuccess extends AlbumState {
  ConvertPDFEventSuccess({
    required AlbumState state,
  }) : super(
          rootAlbumPath: state.rootAlbumPath,
          albums: state.albums,
          albumDTO: state.albumDTO,
          albumName: state.albumName,
          selectionMode: state.selectionMode,
          selectedImages: state.selectedImages,
          selectedPDFs: state.selectedPDFs,
          fileStatus: state.fileStatus,
          images: state.images,
          pdfs: state.pdfs,
        );
}

class ConvertPDFEventError extends AlbumState {
  final String title;
  final String message;
  final String titleButton;

  ConvertPDFEventError({
    required AlbumState state,
    required this.title,
    required this.message,
    required this.titleButton,
  }) : super(
          rootAlbumPath: state.rootAlbumPath,
          albums: state.albums,
          albumDTO: state.albumDTO,
          albumName: state.albumName,
          selectionMode: state.selectionMode,
          selectedImages: state.selectedImages,
          selectedPDFs: state.selectedPDFs,
          fileStatus: state.fileStatus,
          images: state.images,
          pdfs: state.pdfs,
        );
}

class DeletePDFSuccess extends AlbumState {
  final String message;

  DeletePDFSuccess({
    required this.message,
    required AlbumState state,
  }) : super(
          rootAlbumPath: state.rootAlbumPath,
          albums: state.albums,
          albumDTO: state.albumDTO,
          albumName: state.albumName,
          selectionMode: state.selectionMode,
          selectedImages: state.selectedImages,
          selectedPDFs: state.selectedPDFs,
          fileStatus: state.fileStatus,
          images: state.images,
          pdfs: state.pdfs,
        );
}

class ConvertTreeValueEventSuccess extends AlbumState {
  final TreeValueSyncBPMDto treeValueSyncBPMDto;

  ConvertTreeValueEventSuccess({
    required this.treeValueSyncBPMDto,
    required AlbumState state,
  }) : super(
          rootAlbumPath: state.rootAlbumPath,
          albums: state.albums,
          albumDTO: state.albumDTO,
          albumName: state.albumName,
          selectionMode: state.selectionMode,
          selectedImages: state.selectedImages,
          selectedPDFs: state.selectedPDFs,
          fileStatus: state.fileStatus,
          images: state.images,
          pdfs: state.pdfs,
        );
}

class ConvertTreeValueEventError extends AlbumState {
  final String title;
  final String message;
  final String titleButton;

  ConvertTreeValueEventError({
    required this.title,
    required this.message,
    required this.titleButton,
    required AlbumState state,
  }) : super(
          rootAlbumPath: state.rootAlbumPath,
          albums: state.albums,
          albumDTO: state.albumDTO,
          albumName: state.albumName,
          selectionMode: state.selectionMode,
          selectedImages: state.selectedImages,
          selectedPDFs: state.selectedPDFs,
          fileStatus: state.fileStatus,
          images: state.images,
          pdfs: state.pdfs,
        );
}
