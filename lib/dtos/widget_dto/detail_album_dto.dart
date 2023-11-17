import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';

class DetailAlbumDto {
  final CaptureBatchDto albumDto;
  final String albumName;
  final bool? createAlbumSuccess;

  const DetailAlbumDto({
    required this.albumDto,
    required this.albumName,
    this.createAlbumSuccess,
  });
}
