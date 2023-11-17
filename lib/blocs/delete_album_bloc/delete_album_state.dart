import 'package:flutter/material.dart';

@immutable
class DeleteAlbumState {
  const DeleteAlbumState();

  List<Object?> get props => [];
}

class DeleteAlbumEventSuccess extends DeleteAlbumState {
  const DeleteAlbumEventSuccess() : super();

  @override
  List<Object> get props => [];
}

class DeleteAlbumEventError extends DeleteAlbumState {
  const DeleteAlbumEventError() : super();
}
