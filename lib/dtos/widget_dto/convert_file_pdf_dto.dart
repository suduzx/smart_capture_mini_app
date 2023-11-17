import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';

class ConvertFilePDFDto {
  final CaptureBatchDto albumDto;
  final List<int> selectedImages;

  const ConvertFilePDFDto({
    required this.albumDto,
    required this.selectedImages,
  });
}
