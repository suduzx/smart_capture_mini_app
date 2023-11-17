import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/enum/album_customer_type_enum.dart';
import 'package:smart_capture_mobile/enum/create_album_error.dart';
import 'package:flutter/material.dart';

@immutable
class CreateAlbumState {
  final CustomerType customerType;
  final CreateAlbumError? error;
  final bool isEnable;
  final String? errorNumber;
  final String? errorName;
  final String currentIdentity;

  const CreateAlbumState({
    required this.customerType,
    this.error,
    required this.isEnable,
    this.errorNumber,
    this.errorName,
    required this.currentIdentity,
  });

  List<Object?> get props => [
        customerType,
        error,
        isEnable,
        errorNumber,
        errorName,
        currentIdentity,
      ];
}

class SingleSelectEventSuccess extends CreateAlbumState {
  const SingleSelectEventSuccess({
    required CustomerType customerType,
  }) : super(
          customerType: customerType,
          error: null,
          isEnable: false,
          errorNumber: null,
          errorName: null,
          currentIdentity: '',
        );
}

class CheckLimitEventSuccess extends CreateAlbumState {
  const CheckLimitEventSuccess({
    required bool isEnable,
    required String currentIdentity,
    required CustomerType customerType,
  }) : super(
          customerType: customerType,
          error: null,
          isEnable: isEnable,
          errorNumber: null,
          errorName: null,
          currentIdentity: currentIdentity,
        );
}

class CheckLimitEventError extends CreateAlbumState {
  const CheckLimitEventError({
    required CustomerType customerType,
  }) : super(
          customerType: customerType,
          error: null,
          isEnable: false,
          errorNumber: null,
          errorName: null,
          currentIdentity: '',
        );

  @override
  List<Object> get props => [customerType];
}

class CheckCustomerIdentityEventSuccess extends CreateAlbumState {
  final String? customerCode;
  final String customerName;

  const CheckCustomerIdentityEventSuccess({
    required this.customerCode,
    required this.customerName,
    required CustomerType customerType,
    required CreateAlbumError? error,
    required bool isEnable,
    required String currentIdentity,
  }) : super(
          customerType: customerType,
          error: error,
          isEnable: isEnable,
          errorNumber: null,
          errorName: null,
          currentIdentity: currentIdentity,
        );
}

class CheckCustomerIdentityEventError extends CreateAlbumState {
  final String? numberError;
  final String? nameError;

  const CheckCustomerIdentityEventError({
    required this.numberError,
    required this.nameError,
    required CustomerType customerType,
    required CreateAlbumError? error,
    required String currentIdentity,
  }) : super(
          customerType: customerType,
          error: error,
          isEnable: false,
          errorNumber: numberError,
          errorName: nameError,
          currentIdentity: currentIdentity,
        );

  @override
  List<Object?> get props => [numberError, nameError];
}

class SaveAlbumEventSuccess extends CreateAlbumState {
  final CaptureBatchDto albumDto;

  const SaveAlbumEventSuccess({
    required String? errorNumber,
    required String? errorName,
    required CustomerType customerType,
    required CreateAlbumError? error,
    required String currentIdentity,
    required this.albumDto,
  }) : super(
          customerType: customerType,
          error: error,
          isEnable: false,
          errorNumber: errorNumber,
          errorName: errorName,
          currentIdentity: currentIdentity,
        );
}

class SaveAlbumEventError extends CreateAlbumState {
  const SaveAlbumEventError({
    required String? errorNumber,
    required String? errorName,
    required CustomerType customerType,
    required CreateAlbumError? error,
    required String currentIdentity,
  }) : super(
          customerType: customerType,
          error: error,
          isEnable: false,
          errorNumber: errorNumber,
          errorName: errorName,
          currentIdentity: currentIdentity,
        );
}

class OnTextChangedEventComplete extends CreateAlbumState {
  final bool isClearNameController;

  const OnTextChangedEventComplete({
    required this.isClearNameController,
    required String? errorNumber,
    required String? errorName,
    required CustomerType customerType,
    required bool isEnable,
    required CreateAlbumError? error,
    required String currentIdentity,
  }) : super(
          customerType: customerType,
          error: error,
          isEnable: isEnable,
          errorNumber: errorNumber,
          errorName: errorName,
          currentIdentity: currentIdentity,
        );
}
