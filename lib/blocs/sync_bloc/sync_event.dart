import 'package:flutter/material.dart';

@immutable
abstract class SyncEvent {
  const SyncEvent();
}

@immutable
class AddSyncDataEvent extends SyncEvent {
  final String? albumPath;
  final String? imagePath;
  final bool showAlert;
  final BuildContext context;

  const AddSyncDataEvent({
    this.albumPath,
    this.imagePath,
    this.showAlert = true,
    required this.context,
  }) : super();
}

@immutable
class SyncAlbumEvent extends SyncEvent {
  final String? imagePath;
  final String? albumPath;
  final bool isSyncCompleted;
  final bool showAlert;
  final BuildContext context;

  const SyncAlbumEvent({
    this.imagePath,
    this.albumPath,
    required this.isSyncCompleted,
    required this.showAlert,
    required this.context,
  }) : super();
}
