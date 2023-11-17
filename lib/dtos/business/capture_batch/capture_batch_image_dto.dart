import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_attachment_dto.dart';
import 'package:smart_capture_mobile/dtos/business/coordinates_info_dto.dart';
import 'package:smart_capture_mobile/enum/file_status_enum.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';

class CaptureBatchImageDto extends CaptureBatchAttachmentDto
    with DatetimeUtil
    implements Comparable {
  MetadataImageDto? metadata;

  CaptureBatchImageDto({
    String? id,
    String? captureId,
    String? fileType,
    String? name,
    int? pageIndex,
    String? bucketName,
    String? s3Url,
    String? s3UrlThumbnail,
    dynamic ocrDuration,
    this.metadata,
  }) : super(
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

  CaptureBatchImageDto.fromJson(Map<String, dynamic> json) {
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
        ? MetadataImageDto.fromJson(
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

class MetadataImageDto {
  late String name;
  late String path;
  late String thumbPath;
  late String createdDate;
  late String createdByUser;
  late String modifiedDate;
  late String modifiedByUser;
  String? lat;
  String? lng;
  CoordinatesInfoDto? coordinatesInfo;
  late FileStatus status;
  late bool isSync;
  late bool hasBeenUsed;

  MetadataImageDto({
    required this.name,
    required this.path,
    required this.thumbPath,
    required this.createdDate,
    required this.createdByUser,
    required this.modifiedDate,
    required this.modifiedByUser,
    this.lat,
    this.lng,
    this.coordinatesInfo,
    this.status = FileStatus.inUse,
    this.isSync = false,
    this.hasBeenUsed = false,
    String? districtName,
  });

  MetadataImageDto.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    path = json['path'] ?? '';
    thumbPath = json['thumbPath'] ?? path;
    createdDate = json['createdDate'] ?? '';
    createdByUser = json['createdByUser'] ?? '';
    modifiedDate = json['modifiedDate'] ?? '';
    modifiedByUser = json['modifiedByUser'] ?? '';
    lat = json['lat'];
    lng = json['lng'];
    coordinatesInfo = json['coordinatesInfo'] != null
        ? CoordinatesInfoDto.fromJson(
            Map<String, dynamic>.from(json['coordinatesInfo'] as Map))
        : null;
    status =
        FileStatus.fromString(json['status'] ?? FileStatus.inUse.toString());
    isSync = json['isSync'] ?? false;
    hasBeenUsed = json['hasBeenUsed'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['path'] = path;
    data['thumbPath'] = thumbPath;
    data['createdDate'] = createdDate;
    data['createdByUser'] = createdByUser;
    data['modifiedDate'] = modifiedDate;
    data['modifiedByUser'] = modifiedByUser;
    data['lat'] = lat;
    data['lng'] = lng;
    if (coordinatesInfo != null) {
      data['coordinatesInfo'] = coordinatesInfo!.toJson();
    } else {
      data['coordinatesInfo'] = null;
    }
    data['status'] = status.toString();
    data['isSync'] = isSync;
    data['hasBeenUsed'] = hasBeenUsed;
    return data;
  }
}
