import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:flutter/material.dart';

@immutable
class HomeState {
  final String rootAlbumPath;
  final List<CaptureBatchDto> albums;
  final List<CaptureBatchDto> filteredAlbum;

  const HomeState({
    required this.rootAlbumPath,
    required this.albums,
    required this.filteredAlbum,
  });

  List<Object> get props => [
        rootAlbumPath,
        albums,
        filteredAlbum,
      ];
}

class AfterInitEventSuccess extends HomeState {
  AfterInitEventSuccess()
      : super(
          rootAlbumPath: '',
          albums: [],
          filteredAlbum: [],
        );

  @override
  List<Object> get props => [rootAlbumPath, albums, filteredAlbum];
}

class AfterInitEventError extends HomeState {
  AfterInitEventError()
      : super(
          rootAlbumPath: '',
          albums: [],
          filteredAlbum: [],
        );

  @override
  List<Object> get props => [rootAlbumPath, albums, filteredAlbum];
}

class OnLoadAlbumEventSuccess extends HomeState {
  const OnLoadAlbumEventSuccess({
    required String rootAlbumPath,
    required List<CaptureBatchDto> albums,
    required List<CaptureBatchDto> filteredAlbum,
  }) : super(
          rootAlbumPath: rootAlbumPath,
          albums: albums,
          filteredAlbum: filteredAlbum,
        );

  @override
  List<Object> get props => [rootAlbumPath, albums, filteredAlbum];
}

class OnLoadAlbumEventError extends HomeState {
  OnLoadAlbumEventError()
      : super(
          rootAlbumPath: '',
          albums: [],
          filteredAlbum: [],
        );

  @override
  List<Object> get props => [rootAlbumPath, albums, filteredAlbum];
}

class CreateAlbumEventSuccess extends HomeState {
  final int limitAlbumParam;

  CreateAlbumEventSuccess({
    required this.limitAlbumParam,
    required HomeState homeState,
  }) : super(
          rootAlbumPath: homeState.rootAlbumPath,
          albums: homeState.albums,
          filteredAlbum: homeState.filteredAlbum,
        );

  @override
  List<Object> get props => [rootAlbumPath, albums, filteredAlbum];
}

class CreateAlbumEventError extends HomeState {
  final String title;
  final String message;
  final String titleButton;

  CreateAlbumEventError({
    required HomeState homeState,
    required this.title,
    required this.message,
    required this.titleButton,
  }) : super(
          rootAlbumPath: homeState.rootAlbumPath,
          albums: homeState.albums,
          filteredAlbum: homeState.filteredAlbum,
        );

  @override
  List<Object> get props =>
      [rootAlbumPath, albums, filteredAlbum, title, message, titleButton];
}

class AlbumItemTapEventSuccess extends HomeState {
  final CaptureBatchDto albumDto;

  AlbumItemTapEventSuccess({
    required HomeState homeState,
    required this.albumDto,
  }) : super(
          rootAlbumPath: homeState.rootAlbumPath,
          albums: homeState.albums,
          filteredAlbum: homeState.filteredAlbum,
        );

  @override
  List<Object> get props => [rootAlbumPath, albums, filteredAlbum, albumDto];
}

class AlbumMoreOptionTapEventSuccess extends HomeState {
  final CaptureBatchDto albumDto;

  AlbumMoreOptionTapEventSuccess({
    required HomeState homeState,
    required this.albumDto,
  }) : super(
          rootAlbumPath: homeState.rootAlbumPath,
          albums: homeState.albums,
          filteredAlbum: homeState.filteredAlbum,
        );

  @override
  List<Object> get props => [
        rootAlbumPath,
        albums,
        filteredAlbum,
        albumDto,
      ];
}