import 'package:smart_capture_mobile/dtos/auth/key_cloak_response_dto.dart';
import 'package:flutter/material.dart';

@immutable
abstract class LoginEvent {
  const LoginEvent();
}

@immutable
class OtherAccountEvent extends LoginEvent {
  const OtherAccountEvent();
}

@immutable
class ReceiveTokenEvent extends LoginEvent {
  const ReceiveTokenEvent();
}

@immutable
class InitUserInfoEvent extends LoginEvent {
  final KeyCloakResponseDto authInfo;

  const InitUserInfoEvent(this.authInfo);
}

@immutable
class SyncAppParamEvent extends LoginEvent {
  const SyncAppParamEvent();
}
