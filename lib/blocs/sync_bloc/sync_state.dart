import 'package:flutter/material.dart';

@immutable
class SyncState {
  final bool showAlert;
  final String alert;

  const SyncState({
    this.showAlert = true,
    this.alert = '',
  });
}

class AddSyncDataEventSuccess extends SyncState {
  final String? imagePath;
  final String? albumPath;

  const AddSyncDataEventSuccess({
    this.imagePath,
    this.albumPath,
    required bool showAlert,
  }) : super(showAlert: showAlert, alert: '');
}

class AddSyncDataEventError extends SyncState {
  const AddSyncDataEventError({
    required bool showAlert,
  }) : super(
          showAlert: showAlert,
          alert: 'Có lỗi xảy ra.\nĐồng bộ không thành công!',
        );
}

class SyncAlbumEventCompleted extends SyncState {
  final bool isSuccess;
  final String? albumName;

  const SyncAlbumEventCompleted({
    required this.isSuccess,
    this.albumName,
    required bool showAlert,
  }) : super(
          showAlert: showAlert,
          alert: isSuccess
              ? 'Đồng bộ thành công'
              : 'Có lỗi xảy ra.\nĐồng bộ không thành công!',
        );
}

class SyncAlbumEventError extends SyncState {
  final String title;
  final String message;
  final String titleButton;

  const SyncAlbumEventError({
    required this.title,
    required this.message,
    required this.titleButton,
    required bool showAlert,
  }) : super(
          showAlert: showAlert,
          alert: '',
        );
}
