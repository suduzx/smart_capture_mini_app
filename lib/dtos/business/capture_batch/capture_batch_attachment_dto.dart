import 'package:smart_capture_mobile/dtos/api_response/api_response_data_result_generic.dart';

class CaptureBatchAttachmentDto extends ApiResponseDataResultGeneric {
  String? id;
  String? captureId;
  String? fileType;
  String? name;
  int? pageIndex;
  String? bucketName;
  String? s3Url;
  String? s3UrlThumbnail;
  dynamic ocrDuration;

  CaptureBatchAttachmentDto({
    this.id,
    this.captureId,
    this.fileType,
    this.name,
    this.pageIndex,
    this.bucketName,
    this.s3Url,
    this.s3UrlThumbnail,
    this.ocrDuration,
  });

  CaptureBatchAttachmentDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    captureId = json['captureId'];
    fileType = json['fileType'];
    name = json['name'];
    pageIndex = json['pageIndex'];
    bucketName = json['bucketName'];
    s3Url = json['s3Url'];
    s3UrlThumbnail = json['s3UrlThumbnail'];
    ocrDuration = json['ocrDuration'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['captureId'] = captureId;
    data['fileType'] = fileType;
    data['name'] = name;
    data['pageIndex'] = pageIndex;
    data['bucketName'] = bucketName;
    data['s3Url'] = s3Url;
    data['s3UrlThumbnail'] = s3UrlThumbnail;
    data['ocrDuration'] = ocrDuration;
    return data;
  }
}
