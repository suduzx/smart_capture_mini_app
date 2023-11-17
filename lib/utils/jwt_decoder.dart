import 'dart:convert';

import 'package:smart_capture_mobile/dtos/auth/access_token_info.dart';
import 'package:smart_capture_mobile/dtos/auth/refresh_token_info.dart';
import 'package:smart_capture_mobile/dtos/business/user_account_dto.dart';

class JwtDecoder {
  Map<String, dynamic>? _decodeToken(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }
    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    var resp = utf8.decode(base64Url.decode(normalized));
    final payloadMap = json.decode(resp);
    if (payloadMap is! Map<String, dynamic>) {
      return null;
    }
    return payloadMap;
  }

  AccessTokenInfo? decodeAccessToken(String accessToken) {
    Map<String, dynamic>? payloadMap = _decodeToken(accessToken);
    if (payloadMap == null) {
      return null;
    }
    return AccessTokenInfo.fromJson(payloadMap);
  }

  RefreshTokenInfo? decodeRefreshToken(String refreshToken) {
    Map<String, dynamic>? payloadMap = _decodeToken(refreshToken);
    if (payloadMap == null) {
      return null;
    }
    return RefreshTokenInfo.fromJson(payloadMap);
  }

  bool isAccessTokenExpired(UserAccountDto? userAccountDto) {
    if (userAccountDto == null) {
      return false;
    }
    if (userAccountDto.accessTokenInfo == null ||
        userAccountDto.accessTokenInfo?.exp == null) {
      return true;
    }
    DateTime expireTime = DateTime.fromMillisecondsSinceEpoch(
        userAccountDto.accessTokenInfo!.exp! * 1000);
    if (DateTime.now().isAfter(expireTime)) {
      return true;
    }
    return false;
  }

  bool isRefreshTokenExpired(UserAccountDto? userAccountDto) {
    if (userAccountDto == null) {
      return false;
    }
    if (userAccountDto.refreshTokenInfo == null ||
        userAccountDto.refreshTokenInfo?.exp == null) {
      return true;
    }
    DateTime expireTime = DateTime.fromMillisecondsSinceEpoch(
        userAccountDto.refreshTokenInfo!.exp! * 1000);
    if (DateTime.now().isAfter(expireTime)) {
      return true;
    }
    return false;
  }
}
