import 'package:smart_capture_mobile/enum/file_status_enum.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AlbumEvent {
  const AlbumEvent();
}

@immutable
class LoadAlbumEvent extends AlbumEvent {
  final String albumName;
  final FileStatus fileStatus;
  final bool autoSync;

  const LoadAlbumEvent({
    required this.fileStatus,
    required this.albumName,
    required this.autoSync,
  }) : super();
}

@immutable
class SelectionModeEvent extends AlbumEvent {
  final bool selectionMode;

  const SelectionModeEvent({
    required this.selectionMode,
  }) : super();
}

@immutable
class ItemTapEvent extends AlbumEvent {
  final int index;
  final List<int> selectedIndex;
  final bool isImage;

  const ItemTapEvent({
    required this.index,
    required this.selectedIndex,
    required this.isImage,
  }) : super();
}

@immutable
class ConvertPDFEvent extends AlbumEvent {
  const ConvertPDFEvent() : super();
}

@immutable
class ConvertTreeValueEvent extends AlbumEvent {
  const ConvertTreeValueEvent() : super();
}