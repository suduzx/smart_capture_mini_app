import 'package:flutter/material.dart';
import 'package:smart_capture_mobile/dtos/business/bpm_doc_code_dto.dart';
import 'package:smart_capture_mobile/dtos/business/bpm_loan_info_dto.dart';

@immutable
class UploadBPMState {
  final List<BPMLoanInfoDto> loanInfoDtos;
  final List<BPMDocCodeDto> docCodeDtos;
  final String codeT24;
  final String? title;
  final String? message;
  final String? titleButton;

  const UploadBPMState({
    required this.loanInfoDtos,
    required this.docCodeDtos,
    required this.codeT24,
    this.title,
    this.message,
    this.titleButton,
  });

  List<Object?> get props => [
        loanInfoDtos,
        docCodeDtos,
        title,
        message,
        titleButton,
      ];
}

class GetLoanInfoAndDocCodeEventSuccess extends UploadBPMState {
  const GetLoanInfoAndDocCodeEventSuccess({
    required List<BPMLoanInfoDto> loanInfoDTO,
    required List<BPMDocCodeDto> docCodeDTO,
    required String codeT24,
  }) : super(
          loanInfoDtos: loanInfoDTO,
          docCodeDtos: docCodeDTO,
          codeT24: codeT24,
        );
}

class GetLoanInfoAndDocCodeEventError extends UploadBPMState {
  GetLoanInfoAndDocCodeEventError({
    required super.message,
  }) : super(loanInfoDtos: [], docCodeDtos: [], codeT24: '');
}

class SyncBPMEventComplete extends UploadBPMState {
  SyncBPMEventComplete({
    required String title,
    required String message,
  }) : super(
          loanInfoDtos: [],
          docCodeDtos: [],
          codeT24: '',
          title: title,
          message: message,
          titleButton: 'OK',
        );
}
