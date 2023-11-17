import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_pdf_dto.dart';

class ViewPdfPageDto {
  final CaptureBatchDto albumDto;
  final CaptureBatchPdfDto pdf;
  final int indexPdf;

  const ViewPdfPageDto({
    required this.albumDto,
    required this.pdf,
    required this.indexPdf,
  });
}
