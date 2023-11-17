import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_capture_mobile/dtos/exceptions/unauthorized_exception.dart';
import 'package:smart_capture_mobile/utils/refresh_token_util.dart';

class ErrorInterceptor extends Interceptor {
  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    debugPrint('ErrorInterceptor.onError: ${jsonEncode(err.response?.data)}');
    print('ErrorInterceptor.onError123: ${jsonEncode(err.response?.data)}  + \n ${err} \n error type ${err.type} \n status code ${err.response?.statusCode}');
    switch (err.type) {
      case DioErrorType.response:
        switch (err.response?.statusCode) {
          case 401:
          case 403:
            await RefreshTokenUtil().refreshToken((newUser, dio) async {
              debugPrint('LocalUserRepository().update');
              err.requestOptions.headers['Authorization'] =
                  '${newUser.token.tokenType ?? 'Bearer'} ${newUser.token.accessToken}';
              final cloneReq = await dio.fetch<dynamic>(err.requestOptions);
              return handler.resolve(cloneReq);
            }, (error) {
              throw UnauthorizedException(
                requestOptions: err.requestOptions,
                response: err.response,
              );
            });
            break;
          case 400:
          case 404:
          case 409:
          case 500:
          // throw ResponseException(
          //   requestOptions: err.requestOptions,
          //   response: err.response,
          // );
          case 502:
            // throw ServiceUnavailableException(
            //     requestOptions: err.requestOptions);
            break;
        }
        break;
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
      // throw TimeoutException(err.requestOptions);
      case DioErrorType.cancel:
      // break;
      case DioErrorType.other:
        // throw BadNetworkException(err.requestOptions);
        break;
    }

    return handler.next(err);
  }
}
