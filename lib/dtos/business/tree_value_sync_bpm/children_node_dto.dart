import 'package:smart_capture_mobile/dtos/business/tree_value_sync_bpm/children_sync_data_file_dto.dart';
import 'package:smart_capture_mobile/dtos/business/tree_value_sync_bpm/properties_dto.dart';

class ChildrenNodeDto {
  String? version;
  PropertiesDto? properties;
  List<ChildrenSyncDataFileDto>? childrenSyncDataFiles;
  ChildrenSyncDataFileDto? syncDataFile;

  ChildrenNodeDto(
      {String? version,
      PropertiesDto? properties,
      List<ChildrenSyncDataFileDto>? childrenSyncDataFiles,
      ChildrenSyncDataFileDto? syncDataFile}) {
    if (version != null) {
      this.version = version;
    }
    if (properties != null) {
      this.properties = properties;
    }
    if (childrenSyncDataFiles != null) {
      this.childrenSyncDataFiles = childrenSyncDataFiles;
    }
    if (syncDataFile != null) {
      this.syncDataFile = syncDataFile;
    }
  }

  ChildrenNodeDto.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    properties = json['properties'] != null
        ? PropertiesDto.fromJson(json['properties'])
        : null;
    if (json['childrenSyncDataFiles'] != null) {
      childrenSyncDataFiles = <ChildrenSyncDataFileDto>[];
      json['childrenSyncDataFiles'].forEach((v) {
        childrenSyncDataFiles!.add(ChildrenSyncDataFileDto.fromJson(v));
      });
    }
    syncDataFile = json['syncDataFile'] != null
        ? ChildrenSyncDataFileDto.fromJson(json['syncDataFile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['version'] = version;
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    if (childrenSyncDataFiles != null) {
      data['childrenSyncDataFiles'] =
          childrenSyncDataFiles!.map((v) => v.toJson()).toList();
    }
    if (syncDataFile != null) {
      data['syncDataFile'] = syncDataFile!.toJson();
    }
    return data;
  }
}
