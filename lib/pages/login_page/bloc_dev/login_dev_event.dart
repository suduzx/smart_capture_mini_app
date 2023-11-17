import 'package:smart_capture_mobile/dtos/business/user_account_dto.dart';
import 'package:flutter/material.dart';

@immutable
abstract class LoginDevEvent {
  const LoginDevEvent();
}

@immutable
class CheckUserLocalEvent extends LoginDevEvent {
  const CheckUserLocalEvent();
}

@immutable
class SignInEvent extends LoginDevEvent {
  final UserAccountDto? userLocal;
  final String username;
  final String password;

  const SignInEvent(this.username, this.password, this.userLocal);
}
