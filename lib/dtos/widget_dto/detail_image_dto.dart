import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';

class DetailImageDto {
  final CaptureBatchDto albumDto;
  final String albumName;
  final CaptureBatchImageDto imageDTO;
  final String rootAlbumPath;

  const DetailImageDto({
    required this.albumDto,
    required this.albumName,
    required this.imageDTO,
    required this.rootAlbumPath,
  });
}
