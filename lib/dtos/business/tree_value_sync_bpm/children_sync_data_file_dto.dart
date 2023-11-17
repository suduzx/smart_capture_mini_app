class ChildrenSyncDataFileDto {
  String? id;
  String? allowPush;

  ChildrenSyncDataFileDto({String? id, String? allowPush}) {
    if (id != null) {
      this.id = id;
    }
    if (allowPush != null) {
      this.allowPush = allowPush;
    }
  }

  ChildrenSyncDataFileDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    allowPush = json['allowPush'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['allowPush'] = allowPush;
    return data;
  }
}
