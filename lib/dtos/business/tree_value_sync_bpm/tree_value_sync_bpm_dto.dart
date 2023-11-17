import 'package:smart_capture_mobile/dtos/business/tree_value_sync_bpm/root_dto.dart';

class TreeValueSyncBPMDto {
  String? albumId;
  RootDto? root;

  TreeValueSyncBPMDto({RootDto? root, String? albumId}) {
    if (root != null) {
      this.root = root;
    }
    if (albumId != null) {
      this.albumId = albumId;
    }
  }

  TreeValueSyncBPMDto.fromJson(Map<String, dynamic> json) {
    root = json['root'] != null ? RootDto.fromJson(json['root']) : null;
    albumId = json['albumId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (root != null) {
      data['root'] = root!.toJson();
    }
    if (albumId != null) {
      data['albumId'] = albumId!;
    }
    return data;
  }
}
