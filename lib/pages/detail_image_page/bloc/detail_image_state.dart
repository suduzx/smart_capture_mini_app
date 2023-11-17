import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';
import 'package:flutter/material.dart';

@immutable
class DetailImageState {
  final String rootAlbumPath;
  final CaptureBatchDto albumDTO;
  final CaptureBatchImageDto imageDTO;
  final String albumName;

  const DetailImageState({
    required this.rootAlbumPath,
    required this.albumDTO,
    required this.imageDTO,
    required this.albumName,
  });

  List<Object> get props => [rootAlbumPath, albumDTO, imageDTO, albumName];
}

class EditImageEventComplete extends DetailImageState {
  final bool isSuccess;

  const EditImageEventComplete({
    required this.isSuccess,
    required String rootAlbumPath,
    required CaptureBatchDto albumDTO,
    required CaptureBatchImageDto imageDTO,
    required String albumName,
  }) : super(
          rootAlbumPath: rootAlbumPath,
          albumDTO: albumDTO,
          imageDTO: imageDTO,
          albumName: albumName,
        );

  @override
  List<Object> get props => [rootAlbumPath, albumDTO, imageDTO, albumName];
}

class AfterEditImageEventComplete extends DetailImageState {
  const AfterEditImageEventComplete({
    required String rootAlbumPath,
    required CaptureBatchDto albumDTO,
    required CaptureBatchImageDto imageDTO,
    required String albumName,
  }) : super(
          rootAlbumPath: rootAlbumPath,
          albumDTO: albumDTO,
          imageDTO: imageDTO,
          albumName: albumName,
        );

  @override
  List<Object> get props => [rootAlbumPath, albumDTO, imageDTO, albumName];
}

class AfterMovedEventSuccess extends DetailImageState {
  const AfterMovedEventSuccess({
    required String rootAlbumPath,
    required CaptureBatchDto albumDTO,
    required CaptureBatchImageDto imageDTO,
    required String albumName,
  }) : super(
          rootAlbumPath: rootAlbumPath,
          albumDTO: albumDTO,
          imageDTO: imageDTO,
          albumName: albumName,
        );

  @override
  List<Object> get props => [rootAlbumPath, albumDTO, imageDTO, albumName];
}

class LoadImageEventSuccess extends DetailImageState {
  const LoadImageEventSuccess({
    required String rootAlbumPath,
    required CaptureBatchDto albumDTO,
    required CaptureBatchImageDto imageDTO,
    required String albumName,
  }) : super(
    rootAlbumPath: rootAlbumPath,
    albumDTO: albumDTO,
    imageDTO: imageDTO,
    albumName: albumName,
  );

  @override
  List<Object> get props => [rootAlbumPath, albumDTO, imageDTO, albumName];
}

class LoadImageEventError extends DetailImageState {
  const LoadImageEventError({
    required String rootAlbumPath,
    required CaptureBatchDto albumDTO,
    required CaptureBatchImageDto imageDTO,
    required String albumName,
  }) : super(
    rootAlbumPath: rootAlbumPath,
    albumDTO: albumDTO,
    imageDTO: imageDTO,
    albumName: albumName,
  );

  @override
  List<Object> get props => [rootAlbumPath, albumDTO, imageDTO, albumName];
}
