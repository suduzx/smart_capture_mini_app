import 'package:smart_capture_mobile/dtos/auth/key_cloak_response_dto.dart';
import 'package:flutter/material.dart';

@immutable
class LoginState {
  final String title;
  final String message;

  const LoginState({required this.title, required this.message});

  List<Object> get props => [title, message];
}

class OtherAccountEventSuccess extends LoginState {
  const OtherAccountEventSuccess({
    required String title,
    required String message,
  }) : super(title: title, message: message);
}

class OtherAccountEventError extends LoginState {
  const OtherAccountEventError({
    required String title,
    required String message,
  }) : super(title: title, message: message);
}

class ReceiveTokenEventSuccess extends LoginState {
  final KeyCloakResponseDto authInfo;

  const ReceiveTokenEventSuccess({
    required String title,
    required String message,
    required this.authInfo,
  }) : super(title: title, message: message);

  @override
  List<Object> get props => [title, message, authInfo];
}

class ReceiveTokenEventError extends LoginState {
  const ReceiveTokenEventError({
    required String title,
    required String message,
  }) : super(title: title, message: message);

  @override
  List<Object> get props => [title, message];
}

class InitUserInfoEventSuccess extends LoginState {
  const InitUserInfoEventSuccess({
    required String title,
    required String message,
  }) : super(title: title, message: message);

  @override
  List<Object> get props => [title, message];
}

class InitUserInfoEventError extends LoginState {
  const InitUserInfoEventError({
    required String title,
    required String message,
  }) : super(title: title, message: message);

  @override
  List<Object> get props => [title, message];
}

class SyncAppParamEventSuccess extends LoginState {
  const SyncAppParamEventSuccess({
    required String title,
    required String message,
  }) : super(title: title, message: message);

  @override
  List<Object> get props => [title, message];
}

class SyncAppParamEventError extends LoginState {
  const SyncAppParamEventError({required String title, required String message})
      : super(title: title, message: message);

  @override
  List<Object> get props => [title, message];
}
