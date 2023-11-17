import 'package:smart_capture_mobile/dtos/auth/access_token_info.dart';
import 'package:smart_capture_mobile/dtos/auth/key_cloak_response_dto.dart';
import 'package:smart_capture_mobile/dtos/auth/refresh_token_info.dart';

class UserAccountDto {
  String username;
  KeyCloakResponseDto token;
  AccessTokenInfo? accessTokenInfo;
  RefreshTokenInfo? refreshTokenInfo;

  UserAccountDto({
    required this.username,
    required this.token,
    this.accessTokenInfo,
    this.refreshTokenInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'token': token.toJson(),
      'accessTokenInfo':
          accessTokenInfo == null ? null : accessTokenInfo!.toJson(),
      'refreshTokenInfo':
          refreshTokenInfo == null ? null : refreshTokenInfo!.toJson(),
    };
  }

  factory UserAccountDto.fromJson(Map<String, dynamic> json) {
    return UserAccountDto(
      username: json['username'],
      token: KeyCloakResponseDto.fromJson(json['token']),
      accessTokenInfo: json['accessTokenInfo'] == null
          ? null
          : AccessTokenInfo.fromJson(json['accessTokenInfo']),
      refreshTokenInfo: json['refreshTokenInfo'] == null
          ? null
          : RefreshTokenInfo.fromJson(json['refreshTokenInfo']),
    );
  }
}
