class PropertiesDto {
  String? name;
  String? nodeType;
  String? type;

  PropertiesDto({String? name, String? nodeType, String? type}) {
    if (name != null) {
      this.name = name;
    }
    if (nodeType != null) {
      this.nodeType = nodeType;
    }
    if (type != null) {
      this.type = type;
    }
  }

  PropertiesDto.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    nodeType = json['nodeType'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['nodeType'] = nodeType;
    data['type'] = type;
    return data;
  }
}
