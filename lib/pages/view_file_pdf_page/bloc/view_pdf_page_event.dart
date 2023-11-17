import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_pdf_dto.dart';
import 'package:flutter/widgets.dart';

@immutable
abstract class ViewPdfPageEvent {
  const ViewPdfPageEvent();
}

@immutable
class LoadPdfFileEvent extends ViewPdfPageEvent {
  final CaptureBatchDto album;
  final CaptureBatchPdfDto pdf;

  const LoadPdfFileEvent(this.album, this.pdf);
}
