import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';

class MoveImageReturnValue {
  final CaptureBatchImageDto? imageDTO;
  final int imageMoved;

  MoveImageReturnValue({
    required this.imageDTO,
    required this.imageMoved,
  });
}
