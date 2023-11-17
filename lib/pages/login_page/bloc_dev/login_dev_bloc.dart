import 'dart:async';

import 'package:smart_capture_mobile/flavor.dart';
import 'package:smart_capture_mobile/dtos/auth/sign_in_resquest_dto.dart';
import 'package:smart_capture_mobile/dtos/business/user_account_dto.dart';
import 'package:smart_capture_mobile/enum/exception_enum.dart';
import 'package:smart_capture_mobile/enum/login_error_enum.dart';
import 'package:smart_capture_mobile/pages/login_page/bloc_dev/login_dev_event.dart';
import 'package:smart_capture_mobile/pages/login_page/bloc_dev/login_dev_state.dart';
import 'package:smart_capture_mobile/repositories/local_user_repository.dart';
import 'package:smart_capture_mobile/services/diod.dart';
import 'package:smart_capture_mobile/services/key_cloak_service.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';
import 'package:smart_capture_mobile/utils/mixin/number_util.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class LoginDevBloc extends Bloc<LoginDevEvent, LoginDevState>
    with DatetimeUtil, NumberUtil {
  LoginDevBloc(super.initialState) {
    on<CheckUserLocalEvent>(_checkUserLocalEvent);

    on<SignInEvent>(_signInEvent);
  }

  FutureOr<void> _checkUserLocalEvent(
      CheckUserLocalEvent event, Emitter<LoginDevState> emit) async {
    UserAccountDto? currentUser =
        await LocalUserRepository().getCurrentUser();
    if (currentUser == null) {
      emit(const CheckUserLocalEventError());
    } else {
      emit(CheckUserLocalEventSuccess(userLocal: currentUser));
    }
  }

  FutureOr<void> _signInEvent(
      SignInEvent event, Emitter<LoginDevState> emit) async {
    const String invalidCredentials =
        'Thông tin Tài khoản hoặc Mật khẩu không đúng.\nVui lòng thử lại!';
    const String emptyField = 'Vui lòng nhập Tài khoản/Mật khẩu';
    // const String shortPassword = 'Độ dài mật khẩu phải từ 8 ký tự trở lên.';

    if (event.username.isEmpty && event.password.isEmpty) {
      emit(SignInEventError(
          error: emptyField,
          errorValue: LoginErrorValue.all,
          userLocal: event.userLocal));
      return;
    } else if (event.username.isEmpty) {
      emit(SignInEventError(
          error: emptyField,
          errorValue: LoginErrorValue.username,
          userLocal: event.userLocal));
      return;
    } else if (event.password.isEmpty) {
      emit(SignInEventError(
          error: emptyField,
          errorValue: LoginErrorValue.password,
          userLocal: event.userLocal));
      return;
    }
    // else if (event.password.length < Constant.MIN_PASSWORD_LENGTH) {
    //   emit(SignInEventError(
    //       error: shortPassword,
    //       errorValue: LoginErrorValue.PASSWORD,
    //       userLocal: event.userLocal));
    //   return;
    // }
    try {
      KeyCloakService keyCloakService = KeyCloakService(
          dio: DioD().dio, baseUrl: F.keyCloakUrl, realm: F.keyCloakRealm);
      final result = await keyCloakService.signIn(SignInRequestDto(
          username: event.username,
          password: event.password,
          clientId: F.keyCloakClientId));
      await result.when(
        success: (apiResponse) async {
          emit(SignInEventSuccess(
            authInfo: apiResponse.data!.result![0],
            userLocal: event.userLocal,
          ));
        },
        failure: (failure) async {
          if (failure.exceptionEnum == ExceptionEnum.responseException) {
            emit(SignInEventError(
              error: invalidCredentials,
              userLocal: event.userLocal,
              errorValue: LoginErrorValue.all,
            ));
          } else {
            emit(SignInEventError(
              error: 'Có lỗi xảy ra',
              userLocal: event.userLocal,
              errorValue: null,
            ));
          }
        },
      );
    } catch (e) {
      debugPrint('_signInEvent: ${e.toString()}');
      emit(SignInEventError(
        error: 'Có lỗi xảy ra',
        userLocal: event.userLocal,
        errorValue: null,
      ));
    }
  }
}
