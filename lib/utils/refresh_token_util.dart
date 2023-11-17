import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mpcore/mpcore.dart';
import 'package:smart_capture_mobile/dtos/business/user_account_dto.dart';
import 'package:smart_capture_mobile/repositories/local_user_repository.dart';
import 'package:smart_capture_mobile/services/key_cloak_service.dart';
import 'package:smart_capture_mobile/utils/jwt_decoder.dart';
import 'package:smart_capture_mobile/flavor.dart';

class RefreshTokenUtil {
  Future<void> refreshToken(
      Function(UserAccountDto newUser, Dio dio)? refreshTokenSuccess,
      Function(String error) refreshTokenError) async {
    UserAccountDto? currentUser = await LocalUserRepository().getCurrentUser();
    if (JwtDecoder().isRefreshTokenExpired(currentUser)) {
      debugPrint('JwtDecoder().RefreshTokenExpired');
      var message = {
        'type': 'refresh_token_has_expired',
        'message': {
          'action': 'refreshToken',
          'refreshToken': '${currentUser!.token.refreshToken}',
        }
      };
      MPCore.postMapMessage(message);
    } else {
      debugPrint('JwtDecoder().AccessTokenExpired');
      final dio = Dio();
      dio.options.connectTimeout = 10000;
      dio.options.sendTimeout = 15000;
      dio.options.receiveTimeout = 15000;
      KeyCloakService keyCloakService = KeyCloakService(
          dio: dio, baseUrl: F.keyCloakUrl, realm: F.keyCloakRealm);
      final result = await keyCloakService.refreshToken(
          currentUser!.token.refreshToken!, currentUser.accessTokenInfo!.azp!);
      await result.when(
        success: (apiResponse) async {
          debugPrint(apiResponse.data!.result![0].toString());
          UserAccountDto newUser = UserAccountDto(
            username: '',
            token: apiResponse.data!.result![0],
          );
          if (await LocalUserRepository().update(newUser)) {
            debugPrint('Refresh Thành Công');
            if (refreshTokenSuccess != null) {
              refreshTokenSuccess(newUser, dio);
            }
          } else {
            String error = 'Đã có lỗi khi cập nhật lại user local';
            debugPrint(error);
            refreshTokenError(error);
          }
        },
        failure: (failure) async {
          debugPrint(failure.message);
          String error = 'Vui lòng thoát ra đăng nhập lại hệ thống';
          debugPrint(error);
          refreshTokenError(error);
        },
      );
    }
  }
}
