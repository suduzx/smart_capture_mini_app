import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class PdfEvent {
  const PdfEvent();
}

@immutable
class CheckDisableConvertEvent extends PdfEvent {
  final String pdfName;

  const CheckDisableConvertEvent(this.pdfName);
}

@immutable
class ConvertPdfEvent extends PdfEvent {
  final String pdfName;
  final CaptureBatchDto albumDto;
  final List<int> selectedImages;

  const ConvertPdfEvent(
    this.pdfName,
    this.albumDto,
    this.selectedImages,
  );
}
