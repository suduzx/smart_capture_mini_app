import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';

enum AlbumType {
  myAlbum(filter: _myAlbum),
  albumSharedWithMe(filter: _shareWithMeAlbum);

  const AlbumType({required this.filter});

  final List<CaptureBatchDto> Function(List<CaptureBatchDto> albums) filter;
}

List<CaptureBatchDto> _myAlbum(List<CaptureBatchDto> albums) {
  return albums
      .where((element) =>
          element.metadata!.ownerUser!.isEmpty ||
          (element.metadata!.ownerUser!.isNotEmpty &&
              element.metadata!.ownerUser == element.metadata!.createdByUser))
      .toList();
}

List<CaptureBatchDto> _shareWithMeAlbum(List<CaptureBatchDto> albums) {
  return albums
      .where((element) =>
          element.metadata!.ownerUser!.isNotEmpty &&
          element.metadata!.ownerUser != element.metadata!.createdByUser)
      .toList();
}
