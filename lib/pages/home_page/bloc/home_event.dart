import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:flutter/material.dart';

@immutable
abstract class HomeEvent {
  const HomeEvent();
}

@immutable
class AfterInitEvent extends HomeEvent {
  const AfterInitEvent();
}

@immutable
class OnLoadAlbumEvent extends HomeEvent {
  final String textFilter;

  const OnLoadAlbumEvent(this.textFilter);
}

@immutable
class CreateAlbumEvent extends HomeEvent {
  const CreateAlbumEvent();
}

@immutable
class AlbumItemTapEvent extends HomeEvent {
  final CaptureBatchDto albumDto;

  const AlbumItemTapEvent(this.albumDto);
}

@immutable
class AlbumMoreOptionTapEvent extends HomeEvent {
  final CaptureBatchDto albumDto;

  const AlbumMoreOptionTapEvent(this.albumDto);
}

