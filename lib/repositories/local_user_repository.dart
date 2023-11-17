import 'dart:convert';

import 'package:smart_capture_mobile/dtos/business/user_account_dto.dart';
import 'package:smart_capture_mobile/utils/jwt_decoder.dart';
import 'package:smart_capture_mobile/utils/encrypt_util.dart';
import 'package:smart_capture_mobile/utils/file_utils.dart';
import 'package:flutter/material.dart';

class LocalUserRepository {
  final String _fileName = 'user.json';

  Future<bool> update(UserAccountDto newUser) async {
    try {
      if (newUser.token.accessToken == null) {
        return false;
      }
      final jwtDecoder = JwtDecoder();
      newUser.accessTokenInfo =
          jwtDecoder.decodeAccessToken(newUser.token.accessToken!);
      if (newUser.accessTokenInfo == null) {
        return false;
      }
      newUser.refreshTokenInfo =
          jwtDecoder.decodeRefreshToken(newUser.token.refreshToken!);
      if (newUser.username == '') {
        newUser.username = newUser.accessTokenInfo?.preferredUsername ?? '';
      }
      final userFile = await FileUtils.getJson(_fileName);
      String jsonUser = jsonEncode(newUser);
      jsonUser = await EncryptUtil.encrypt(jsonUser);
      await userFile.writeAsString(jsonUser);
      return true;
    } catch (e) {
      debugPrint('createUserAccount: $e');
      return false;
    }
  }

  Future<UserAccountDto?> getCurrentUser() async {
    UserAccountDto userAccount;
    try {
      final file = await FileUtils.getJson(_fileName);
      String content = await file.readAsString();
      content = await EncryptUtil.decrypt(content);
      dynamic user = jsonDecode(content);
      userAccount = UserAccountDto.fromJson(user);
      return userAccount;
    } catch (e) {
      debugPrint('getUserLocal: $e');
      return null;
    }
  }

  Future<bool> removeCurrentUser() async {
    try {
      return FileUtils.deleteFile(_fileName, isRelativePath: true);
    } catch (e) {
      debugPrint('removeUserLocal: $e');
      return false;
    }
  }
}
