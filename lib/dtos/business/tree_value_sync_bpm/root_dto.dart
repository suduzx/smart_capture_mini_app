import 'package:smart_capture_mobile/dtos/business/tree_value_sync_bpm/children_node_dto.dart';
import 'package:smart_capture_mobile/dtos/business/tree_value_sync_bpm/root_properties_dto.dart';

class RootDto {
  String? version;
  RootPropertiesDto? properties;
  List<ChildrenNodeDto>? childrenNodes;

  RootDto(
      {String? version,
      RootPropertiesDto? properties,
      List<ChildrenNodeDto>? childrenNodes}) {
    if (version != null) {
      this.version = version;
    }
    if (properties != null) {
      this.properties = properties;
    }
    if (childrenNodes != null) {
      this.childrenNodes = childrenNodes;
    }
  }

  RootDto.fromJson(Map<String, dynamic> json) {
    version = json['version'];
    properties = json['properties'] != null
        ? RootPropertiesDto.fromJson(json['properties'])
        : null;
    if (json['childrenNodes'] != null) {
      childrenNodes = <ChildrenNodeDto>[];
      json['childrenNodes'].forEach((v) {
        childrenNodes!.add(ChildrenNodeDto.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['version'] = version;
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    if (childrenNodes != null) {
      data['childrenNodes'] =
          childrenNodes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
