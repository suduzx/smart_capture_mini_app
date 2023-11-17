import 'package:smart_capture_mobile/dtos/auth/key_cloak_response_dto.dart';
import 'package:smart_capture_mobile/dtos/business/user_account_dto.dart';
import 'package:smart_capture_mobile/enum/login_error_enum.dart';
import 'package:flutter/material.dart';

@immutable
class LoginDevState {
  final UserAccountDto? userLocal;

  const LoginDevState({
    required this.userLocal,
  });

  List<Object?> get props => [userLocal];
}

class CheckUserLocalEventSuccess extends LoginDevState {
  const CheckUserLocalEventSuccess({
    required UserAccountDto? userLocal,
  }) : super(userLocal: userLocal);

  @override
  List<Object?> get props => [userLocal];
}

class CheckUserLocalEventError extends LoginDevState {
  const CheckUserLocalEventError() : super(userLocal: null);
}

class SignInEventSuccess extends LoginDevState {
  final KeyCloakResponseDto authInfo;

  const SignInEventSuccess({
    required this.authInfo,
    required UserAccountDto? userLocal,
  }) : super(userLocal: userLocal);

  @override
  List<Object?> get props => [authInfo];
}

class SignInEventError extends LoginDevState {
  final String error;
  final LoginErrorValue? errorValue;

  const SignInEventError({
    required this.error,
    required this.errorValue,
    required UserAccountDto? userLocal,
  }) : super(userLocal: userLocal);

  @override
  List<Object?> get props => [error, errorValue];
}
