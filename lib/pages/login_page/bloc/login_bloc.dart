import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mpcore/mpcore.dart';
import 'package:smart_capture_mobile/flavor.dart';
import 'package:smart_capture_mobile/dtos/api_response/api_response.dart';
import 'package:smart_capture_mobile/dtos/auth/key_cloak_response_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_business_dto.dart';
import 'package:smart_capture_mobile/dtos/business/user_account_dto.dart';
import 'package:smart_capture_mobile/dtos/exceptions/failures.dart';
import 'package:smart_capture_mobile/dtos/simple_result/api_result.dart';
import 'package:smart_capture_mobile/enum/action_log_enum.dart';
import 'package:smart_capture_mobile/pages/login_page/bloc/login_event.dart';
import 'package:smart_capture_mobile/pages/login_page/bloc/login_state.dart';
import 'package:smart_capture_mobile/repositories/local_capture_business_repository.dart';
import 'package:smart_capture_mobile/repositories/local_user_repository.dart';
import 'package:smart_capture_mobile/services/capture_business_service.dart';
import 'package:smart_capture_mobile/services/diod.dart';
import 'package:smart_capture_mobile/utils/log_util.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';
import 'package:smart_capture_mobile/utils/mixin/number_util.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState>
    with DatetimeUtil, NumberUtil {
  LoginBloc(super.initialState) {
    on<OtherAccountEvent>(_otherAccountEvent);

    on<ReceiveTokenEvent>(_receiveTokenEvent);

    on<InitUserInfoEvent>(_initUserInfoEvent);

    on<SyncAppParamEvent>(_syncAppParamEvent);
  }

  FutureOr<void> _otherAccountEvent(
      OtherAccountEvent event, Emitter<LoginState> emit) async {
    String title = 'Xóa phiên đăng nhập cũ';
    final localUserRepository = LocalUserRepository();
    UserAccountDto? currentUser = await localUserRepository.getCurrentUser();
    if (currentUser == null) {
      emit(
          OtherAccountEventSuccess(title: title, message: '$title thành công'));
    } else {
      bool result = await localUserRepository.removeCurrentUser();
      if (result) {
        emit(OtherAccountEventSuccess(
            title: title, message: '$title thành công'));
      } else {
        emit(OtherAccountEventError(title: title, message: '$title thất bại'));
      }
    }
  }

  Future<void> _receiveTokenEvent(
      ReceiveTokenEvent event, Emitter<LoginState> emit) async {
    String title = 'Nhận thông tin đăng nhập';
    await getInitParams().then((Map<dynamic, dynamic>? value) {
      if (value != null &&
          value['accessToken'] != null &&
          value['refreshToken'] != null) {
        KeyCloakResponseDto authInfo = KeyCloakResponseDto(
          accessToken: value['accessToken'],
          refreshToken: value['refreshToken'],
        );
        emit(ReceiveTokenEventSuccess(
            title: title, message: '$title thành công', authInfo: authInfo));
      } else {
        emit(ReceiveTokenEventError(
            title: title,
            message: '$title thất bại, Vui lòng thoát ra vào lại'));
      }
    }, onError: (error) {
      emit(ReceiveTokenEventError(
          title: title, message: '$title thất bại, Vui lòng thoát ra vào lại'));
    });
  }

  FutureOr<void> _initUserInfoEvent(
      InitUserInfoEvent event, Emitter<LoginState> emit) async {
    UserAccountDto newUser = UserAccountDto(
      username: '',
      token: event.authInfo,
    );
    String title = 'Khởi tạo thông tin người dùng';
    if (await LocalUserRepository().update(newUser)) {
      emit(
          InitUserInfoEventSuccess(title: title, message: '$title thành công'));
    } else {
      emit(InitUserInfoEventError(
          title: title, message: '$title thất bại, Vui lòng thoát ra vào lại'));
    }
  }

  FutureOr<void> _syncAppParamEvent(
      SyncAppParamEvent event, Emitter<LoginState> emit) async {
    String title = 'Đồng bộ thông tin cấu hình';
    try {
      await LogUtil().addActionLog(ActionLogEnum.login);
      CaptureBusinessService captureBusinessService =
          CaptureBusinessService(dio: DioD().dio, baseUrl: F.apiUrl);
      Result<ApiResponse<CaptureBusinessDto>, Failure> resultGetAllAppParam =
          await captureBusinessService.get();
      await resultGetAllAppParam.when(
        success: (apiResponse) async {
          if (await LocalCaptureBusinessRepository()
              .update(apiResponse.data?.result ?? [])) {
            emit(SyncAppParamEventSuccess(
                title: title, message: '$title thành công'));
          } else {
            emit(SyncAppParamEventError(
              title: title,
              message: '$title thất bại, Vui lòng thoát ra vào lại',
            ));
          }
        },
        failure: (failure) {
          emit(SyncAppParamEventError(
            title: title,
            message: '$title thất bại, Vui lòng thoát ra vào lại',
          ));
        },
      );
    } catch (e) {
      debugPrint('_syncAppParamEvent: ${e.toString()}');
      emit(SyncAppParamEventError(
        title: title,
        message: '$title thất bại, Vui lòng thoát ra vào lại',
      ));
    }
  }
}
