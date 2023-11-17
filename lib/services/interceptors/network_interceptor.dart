import 'package:smart_capture_mobile/dtos/api_response/api_response.dart';
import 'package:smart_capture_mobile/dtos/business/user_account_dto.dart';
import 'package:smart_capture_mobile/repositories/local_user_repository.dart';
import 'package:smart_capture_mobile/utils/jwt_decoder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class NetworkInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.headers.containsKey("no-auth")) {
      options.headers.remove("no-auth");
      return handler.next(options);
    }



    UserAccountDto? currentUser =
        await LocalUserRepository().getCurrentUser();
    if (currentUser != null) {
      Map<String, dynamic> headers = options.headers;
      headers.addAll({
        'Authorization':
            '${currentUser.token.tokenType ?? 'Bearer'} ${currentUser.token.accessToken ?? ''}'
      });
      options.headers = headers;
    }
    super.onRequest(options, handler);
  }


  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {

    //print("Dio Error Handle : ${err}, \n response ${err.response} \n type ${err.type}, \n data ${err.response?.data}, \n status ${err.response?.statusCode}");


    return handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    dynamic responseData = response.data;
    ApiResponse apiResponse = ApiResponse.fromJson(responseData, null);
    response.data = responseData;
    if (apiResponse.status != null && apiResponse.status != 200) {
      response.statusCode = apiResponse.status;
      handler.reject(
          DioError(
            requestOptions: response.requestOptions,
            type: DioErrorType.response,
            response: response,
          ),
          true);
    } else {
      super.onResponse(response, handler);
    }
  }
}
