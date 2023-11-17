import 'package:flutter/material.dart';

@immutable
class DeleteFileState {
  final String title;
  final String? message;

  const DeleteFileState({required this.title, this.message});

  List<Object?> get props => [title, message];
}

class DeleteConfirmEventSuccess extends DeleteFileState {
  final bool isDeleteAll;

  const DeleteConfirmEventSuccess({
    required this.isDeleteAll,
    required String title,
    required String message,
  }) : super(title: title, message: message);

  @override
  List<Object> get props => [isDeleteAll];
}

class DeleteEventSuccess extends DeleteFileState {
  const DeleteEventSuccess({
    required String title,
  }) : super(title: title, message: null);
}

class DeleteEventError extends DeleteFileState {
  const DeleteEventError({
    required String title,
  }) : super(title: title, message: null);
}
