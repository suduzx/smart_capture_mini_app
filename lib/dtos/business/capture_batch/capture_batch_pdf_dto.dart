import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_attachment_dto.dart';
import 'package:smart_capture_mobile/enum/file_status_enum.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';

class CaptureBatchPdfDto extends CaptureBatchAttachmentDto
    with DatetimeUtil
    implements Comparable {
  MetadataPdfDto? metadata;

  CaptureBatchPdfDto(
      {String? id,
      String? captureId,
      String? fileType,
      String? name,
      int? pageIndex,
      String? bucketName,
      String? s3Url,
      String? s3UrlThumbnail,
      dynamic ocrDuration,
      this.metadata})
      : super(
          id: id,
          captureId: captureId,
          fileType: fileType,
          name: name,
          pageIndex: pageIndex,
          bucketName: bucketName,
          s3Url: s3Url,
          s3UrlThumbnail: s3UrlThumbnail,
          ocrDuration: ocrDuration,
        );

  CaptureBatchPdfDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    captureId = json['captureId'];
    fileType = json['fileType'];
    name = json['name'];
    pageIndex = json['pageIndex'];
    bucketName = json['bucketName'];
    s3Url = json['s3Url'];
    s3UrlThumbnail = json['s3UrlThumbnail'];
    ocrDuration = json['ocrDuration'];
    metadata = json['metadata'] != null
        ? MetadataPdfDto.fromJson(
            Map<String, dynamic>.from(json['metadata'] as Map))
        : null;
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
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    return data;
  }

  @override
  int compareTo(other) {
    DateTime d1 = string2Datetime(
        metadata?.createdDate ?? DateTime.now().toUtc().toString());
    DateTime d2 = string2Datetime(
        other.metadata?.createdDate ?? DateTime.now().toUtc().toString());
    return d2.compareTo(d1);
  }
}

class MetadataPdfDto {
  List<String>? dataFileIds;
  late String name;
  late String path;
  late String createdDate;
  late String createdByUser;
  late String modifiedDate;
  late String modifiedByUser;
  late int pageIndex;
  late FileStatus status;
  late bool isSync;

  MetadataPdfDto({
    this.dataFileIds,
    required this.name,
    required this.path,
    required this.createdDate,
    required this.createdByUser,
    required this.modifiedDate,
    required this.modifiedByUser,
    required this.pageIndex,
    this.status = FileStatus.inUse,
    this.isSync = false,
  });

  MetadataPdfDto.fromJson(Map<String, dynamic> json) {
    dataFileIds = (json['dataFileIds'] ?? []).cast<String>();
    name = json['name'] ?? '';
    path = json['path'] ?? '';
    createdDate = json['createdDate'] ?? '';
    createdByUser = json['createdByUser'] ?? '';
    modifiedDate = json['modifiedDate'] ?? '';
    modifiedByUser = json['modifiedByUser'] ?? '';
    pageIndex = json['pageIndex'] ?? 0;
    status =
        FileStatus.fromString(json['status'] ?? FileStatus.inUse.toString());
    isSync = json['isSync'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dataFileIds'] = dataFileIds;
    data['name'] = name;
    data['path'] = path;
    data['createdDate'] = createdDate;
    data['createdByUser'] = createdByUser;
    data['modifiedDate'] = modifiedDate;
    data['modifiedByUser'] = modifiedByUser;
    data['pageIndex'] = pageIndex;
    data['status'] = status.toString();
    data['isSync'] = isSync;
    return data;
  }
}
