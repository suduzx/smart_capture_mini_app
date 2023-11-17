import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_pdf_dto.dart';

enum FileStatus {
  inUse(filter: _imageInUse, filterPDF: _pdfInUse),
  deleted(filter: _deletedImage, filterPDF: _deletedPDF);

  const FileStatus({required this.filter, required this.filterPDF});

  final List<CaptureBatchImageDto> Function(List<CaptureBatchImageDto> images)
      filter;
  final List<CaptureBatchPdfDto> Function(List<CaptureBatchPdfDto> pdfs)
      filterPDF;

  @override
  String toString() => name;

  static FileStatus fromString(String value) {
    Iterable<FileStatus> iterable =
        FileStatus.values.where((element) => element.name == value);
    return iterable.isEmpty ? FileStatus.deleted : iterable.first;
  }
}

List<CaptureBatchImageDto> _imageInUse(List<CaptureBatchImageDto> images) {
  return images
      .where((image) => image.metadata!.status == FileStatus.inUse)
      .toList();
}

List<CaptureBatchImageDto> _deletedImage(List<CaptureBatchImageDto> images) {
  return images
      .where((image) => image.metadata!.status == FileStatus.deleted)
      .toList();
}

List<CaptureBatchPdfDto> _pdfInUse(List<CaptureBatchPdfDto> pdfs) {
  return pdfs.where((pdf) => pdf.metadata!.status == FileStatus.inUse).toList();
}

List<CaptureBatchPdfDto> _deletedPDF(List<CaptureBatchPdfDto> pdfs) {
  return pdfs
      .where((pdf) => pdf.metadata!.status == FileStatus.deleted)
      .toList();
}
