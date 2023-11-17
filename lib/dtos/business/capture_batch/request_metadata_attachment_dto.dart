class RequestMetadataAttachmentDto {
  List<String>? dataFileIds;

  RequestMetadataAttachmentDto({
    this.dataFileIds,
  });

  RequestMetadataAttachmentDto.fromJson(Map<String, dynamic> json) {
    dataFileIds = (json['dataFileIds'] ?? []).cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dataFileIds'] = dataFileIds;
    return data;
  }
}
