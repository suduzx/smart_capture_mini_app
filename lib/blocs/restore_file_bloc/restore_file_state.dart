import 'package:flutter/material.dart';

@immutable
class RestoreFileState {
  final String title;
  final String? message;

  const RestoreFileState({required this.title, this.message});

  List<Object?> get props => [title, message];
}

class RestoreConfirmEventSuccess extends RestoreFileState {
  const RestoreConfirmEventSuccess({
    required String title,
    required String message,
  }) : super(title: title, message: message);
}

class RestoreEventSuccess extends RestoreFileState {
  const RestoreEventSuccess({
    required String title,
  }) : super(title: title, message: null);
}
