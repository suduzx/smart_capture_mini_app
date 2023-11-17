import 'package:flutter/material.dart';

@immutable
class PdfState {
  final bool isDisableConvert;

  const PdfState({required this.isDisableConvert});

  List<Object> get props => [isDisableConvert];
}

class CheckDisableConvertEventSuccess extends PdfState {
  const CheckDisableConvertEventSuccess({required bool isDisableConvert})
      : super(isDisableConvert: isDisableConvert);
}

class ConvertPdfEventSuccess extends PdfState {
  const ConvertPdfEventSuccess({required bool isDisableConvert})
      : super(isDisableConvert: isDisableConvert);
}

class ConvertPdfEventError extends PdfState {
  final String textError;

  const ConvertPdfEventError({
    required bool isDisableConvert,
    required this.textError,
  }) : super(isDisableConvert: isDisableConvert);

  @override
  List<Object> get props => [isDisableConvert, textError];
}
