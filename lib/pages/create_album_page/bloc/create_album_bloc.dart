import 'dart:async';
import 'dart:math';

import 'package:smart_capture_mobile/flavor.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/user_account_dto.dart';
import 'package:smart_capture_mobile/enum/album_customer_type_enum.dart';
import 'package:smart_capture_mobile/enum/create_album_error.dart';
import 'package:smart_capture_mobile/pages/create_album_page/bloc/create_album_event.dart';
import 'package:smart_capture_mobile/pages/create_album_page/bloc/create_album_state.dart';
import 'package:smart_capture_mobile/repositories/local_capture_batch_repository.dart';
import 'package:smart_capture_mobile/repositories/local_user_repository.dart';
import 'package:smart_capture_mobile/services/capture_batch_service.dart';
import 'package:smart_capture_mobile/services/diod.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';
import 'package:smart_capture_mobile/utils/mixin/number_util.dart';
import 'package:smart_capture_mobile/utils/mixin/permission_handler_util.dart';
import 'package:smart_capture_mobile/utils/vietnames_parser.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class CreateAlbumBloc extends Bloc<CreateAlbumEvent, CreateAlbumState>
    with DatetimeUtil, NumberUtil, PermissionHandlerUtil {
  CreateAlbumBloc(super.initialState) {
    on<SingleSelectEvent>(_singleSelectEvent);
    on<OnTextChangedEvent>(_onTextChangedEvent);
    on<CheckLimitEvent>(_checkLimitEvent);
    on<CheckCustomerIdentityEvent>(_checkCustomerIdentityEvent);
    on<SaveAlbumEvent>(_saveAlbumEvent);
  }

  FutureOr<void> _singleSelectEvent(
      SingleSelectEvent event, Emitter<CreateAlbumState> emit) async {
    emit(SingleSelectEventSuccess(customerType: event.customerType));
  }

  FutureOr<void> _onTextChangedEvent(
      OnTextChangedEvent event, Emitter<CreateAlbumState> emit) async {
    if (state.currentIdentity != event.customerIdentity) {
      emit(OnTextChangedEventComplete(
        isClearNameController: true,
        isEnable: event.customerIdentity.isNotEmpty ? true : false,
        error: null,
        errorName: null,
        errorNumber: null,
        currentIdentity: event.customerIdentity,
        customerType: state.customerType,
      ));
      return;
    }

    if (state.error != null) {
      emit(OnTextChangedEventComplete(
        isClearNameController: false,
        isEnable: event.customerName.isNotEmpty ? true : false,
        error: state.error,
        errorName: null,
        errorNumber: state.errorNumber,
        currentIdentity: state.currentIdentity,
        customerType: state.customerType,
      ));
      return;
    }
    if (state.currentIdentity == event.customerIdentity &&
        state.error != null) {
      emit(OnTextChangedEventComplete(
        isClearNameController: false,
        isEnable: event.customerName.isNotEmpty ? true : false,
        error: state.error,
        errorName: state.errorName,
        errorNumber: null,
        currentIdentity: event.customerIdentity,
        customerType: state.customerType,
      ));
      return;
    }
  }

  FutureOr<void> _checkLimitEvent(
      CheckLimitEvent event, Emitter<CreateAlbumState> emit) async {
    List<CaptureBatchDto> albums =
        await LocalCaptureBatchRepository().getAll(isReadOnly: true);
    if (albums.length >= event.limitAlbumParam) {
      emit(CheckLimitEventError(customerType: state.customerType));
    } else {
      emit(CheckLimitEventSuccess(
        isEnable: state.isEnable,
        currentIdentity: state.currentIdentity,
        customerType: state.customerType,
      ));
    }
  }

  FutureOr<void> _checkCustomerIdentityEvent(
      CheckCustomerIdentityEvent event, Emitter<CreateAlbumState> emit) async {
    try {
      if (!RegExp(r"^\d*$").hasMatch(event.customerIdentity)) {
        emit(CheckCustomerIdentityEventError(
          currentIdentity: state.currentIdentity,
          customerType: state.customerType,
          numberError: 'Vui lòng chỉ nhập ký tự số',
          nameError: state.errorNumber,
          error: state.error,
        ));
        return;
      }
      if (event.error != null) {
        if (event.customerName.trim().isEmpty) {
          emit(CheckCustomerIdentityEventError(
            currentIdentity: state.currentIdentity,
            customerType: state.customerType,
            numberError: null,
            nameError: 'Tên khách hàng không được để trống',
            error: event.error,
          ));
          return;
        }
        if (!RegExp(
                r"^[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳýỵỷỹ\s]+$")
            .hasMatch(event.customerName)) {
          emit(CheckCustomerIdentityEventError(
            currentIdentity: state.currentIdentity,
            customerType: state.customerType,
            numberError: null,
            nameError: state.customerType == CustomerType.khcn
                ? 'Tên khách hàng không được chứa ký tự số hoặc ký tự đặc biệt.'
                : 'Tên doanh nghiệp không được chứa ký tự số hoặc ký tự đặc biệt.',
            error: event.error,
          ));
          return;
        }
      }
      if (event.customerName.isNotEmpty) {
        emit(CheckCustomerIdentityEventSuccess(
          customerType: state.customerType,
          customerCode: null,
          customerName: event.customerName,
          error: event.error,
          isEnable: state.isEnable,
          currentIdentity: state.currentIdentity,
        ));
        return;
      }

      LocalCaptureBatchRepository localCaptureBatchRepository =
          LocalCaptureBatchRepository();
      UserAccountDto? currentUser =
          await LocalUserRepository().getCurrentUser();
      if (currentUser!.accessTokenInfo!.groups == null ||
          (currentUser.accessTokenInfo!.groups ?? []).isEmpty) {
        emit(CheckCustomerIdentityEventError(
          currentIdentity: state.currentIdentity,
          customerType: state.customerType,
          nameError: null,
          numberError: null,
          error: CreateAlbumError.groupsIsNull,
        ));
        return;
      }
      String group = currentUser.accessTokenInfo!.groups![0];
      String branchCode = group.substring(group.lastIndexOf("/") + 1);
      CaptureBatchService captureBatchService =
          CaptureBatchService(dio: DioD().dio, baseUrl: F.apiUrl);

      /// CREATE
      final result = await captureBatchService.create(
        branchCode: branchCode,
        nationalId: event.customerIdentity,
      );
      CaptureBatchDto captureBatchDto = CaptureBatchDto();
      await result.when(success: (apiResponse) async {
        try {
          captureBatchDto = apiResponse.data!.result![0];
          captureBatchDto.metadata = await localCaptureBatchRepository
              .createMetadataAlbumDto(currentUser, captureBatchDto);
          await localCaptureBatchRepository.sortThenUpdate(
            captureBatchDto,
          );
          emit(SaveAlbumEventSuccess(
            albumDto: captureBatchDto,
            error: state.error,
            errorName: state.errorName,
            errorNumber: state.errorNumber,
            currentIdentity: event.customerIdentity,
            customerType: state.customerType,
          ));
        } catch (e) {
          debugPrint('_checkCustomerIdentityEvent result.when $e');
          emit(SaveAlbumEventError(
            error: state.error,
            errorName: state.errorName,
            errorNumber: state.errorNumber,
            currentIdentity: event.customerIdentity,
            customerType: state.customerType,
          ));
        }
      }, failure: (failure) async {
        emit(CheckCustomerIdentityEventError(
          currentIdentity: state.currentIdentity,
          customerType: state.customerType,
          nameError: null,
          numberError: null,
          error: CreateAlbumError.notInfo,
        ));
      });
    } catch (e) {
      debugPrint('CREATE ALBUM BLOC: _checkCustomerIdentityEvent $e');
      emit(CheckCustomerIdentityEventError(
        currentIdentity: state.currentIdentity,
        customerType: state.customerType,
        nameError: null,
        numberError: null,
        error: CreateAlbumError.canNotGetInfo,
      ));
    }
  }

  FutureOr<void> _saveAlbumEvent(
      SaveAlbumEvent event, Emitter<CreateAlbumState> emit) async {
    try {
      bool hasStoragePermission = await requestStoragePermission();
      if (!hasStoragePermission) {
        return;
      }
      LocalCaptureBatchRepository localCaptureBatchRepository =
          LocalCaptureBatchRepository();
      String? captureName = event.customerCode == null
          ? (await _generateCaptureBatchName(
              event.customerCode, event.customerName))
          : null;
      UserAccountDto? currentUser =
          await LocalUserRepository().getCurrentUser();
      String group = currentUser!.accessTokenInfo!.groups![0];
      String branchCode = group.substring(group.lastIndexOf("/") + 1);
      CaptureBatchService captureBatchService =
          CaptureBatchService(dio: DioD().dio, baseUrl: F.apiUrl);
      final result = await captureBatchService.create(
        branchCode: branchCode,
        nationalId: event.customerIdentity,
        customerName: event.customerName,
        captureName: captureName,
      );
      CaptureBatchDto captureBatchDto = CaptureBatchDto();
      await result.when(success: (apiResponse) {
        captureBatchDto = apiResponse.data!.result![0];
      }, failure: (failure) async {
        // captureBatchDto.branchCode = branchCode;
        // captureBatchDto.metadata = MetadataAlbumDto(
        //     nationalId: event.customerIdentity,
        //     customerType: event.customerType,
        //     customerName: event.customerName,
        //     captureName: captureName ??
        //         (await _generateCaptureBatchName(
        //             event.customerCode, event.customerName)));
        emit(SaveAlbumEventError(
          error: state.error,
          errorName: state.errorName,
          errorNumber: state.errorNumber,
          currentIdentity: event.customerIdentity,
          customerType: state.customerType,
        ));
        return;
      });
      captureBatchDto.metadata = await localCaptureBatchRepository
          .createMetadataAlbumDto(currentUser, captureBatchDto);
      await localCaptureBatchRepository.sortThenUpdate(
        captureBatchDto,
      );
      emit(SaveAlbumEventSuccess(
        albumDto: captureBatchDto,
        error: state.error,
        errorName: state.errorName,
        errorNumber: state.errorNumber,
        currentIdentity: event.customerIdentity,
        customerType: state.customerType,
      ));
    } catch (e) {
      debugPrint('CREATE ALBUM BLOC: _saveAlbumEvent $e');
      emit(SaveAlbumEventError(
        error: state.error,
        errorName: state.errorName,
        errorNumber: state.errorNumber,
        currentIdentity: event.customerIdentity,
        customerType: state.customerType,
      ));
    }
  }

  Future<String> _generateCaptureBatchName(
      String? customerCode, String customerName) async {
    List<CaptureBatchDto> albums =
        await LocalCaptureBatchRepository().getAll(isReadOnly: true);
    String captureName =
        VietnameseParser.toUnsigned(customerName).replaceAll(' ', '');
    if (customerCode != null) {
      captureName += '.$customerCode';
    }
    final Iterable<int> idxs = albums
        .where((a) =>
            a.metadata!.captureName!
                    .substring(
                        0,
                        a.metadata!.captureName!.contains('.')
                            ? a.metadata!.captureName!.lastIndexOf('.')
                            : a.metadata!.captureName!.length - 1)
                    .toLowerCase()
                    .compareTo(captureName.toLowerCase()) ==
                0 &&
            a.metadata!.captureName!.contains('.'))
        .map((e) => string2Int(e.metadata!.captureName!
            .substring(e.metadata!.captureName!.lastIndexOf('.') + 1)));
    int maxIndex;
    if (idxs.isEmpty) {
      maxIndex = 0;
    } else {
      maxIndex = idxs.reduce(max);
    }
    captureName += '.${(maxIndex + 1).toString().padLeft(2, '0')}';
    return captureName;
  }
}
