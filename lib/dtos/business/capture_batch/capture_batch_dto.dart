import 'package:smart_capture_mobile/dtos/api_response/api_response_data_result_generic.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_pdf_dto.dart';
import 'package:smart_capture_mobile/enum/album_customer_type_enum.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';

class CaptureBatchDto extends ApiResponseDataResultGeneric
    with DatetimeUtil
    implements Comparable {
  String? id;
  String? businessCode;
  dynamic captureTreeValueId;
  String? branchCode;
  String? batchId;
  String? status;
  bool? activated;
  dynamic desktopConfig;
  String? owner;
  MetadataAlbumDto? metadata;
  dynamic captureTreeValue;

  CaptureBatchDto({
    this.id,
    this.businessCode,
    this.captureTreeValueId,
    this.branchCode,
    this.batchId,
    this.status,
    this.activated,
    this.desktopConfig,
    this.owner,
    this.metadata,
    this.captureTreeValue,
  });

  CaptureBatchDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessCode = json['businessCode'];
    captureTreeValueId = json['captureTreeValueId'];
    branchCode = json['branchCode'];
    batchId = json['batchId'];
    status = json['status'];
    activated = json['activated'];
    desktopConfig = json['desktopConfig'];
    owner = json['owner'];
    if (json['metadata'] != null) {
      metadata = MetadataAlbumDto.fromJson(json['metadata']);
    } else {
      metadata = null;
    }
    captureTreeValue = json['captureTreeValue'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['businessCode'] = businessCode;
    data['captureTreeValueId'] = captureTreeValueId;
    data['branchCode'] = branchCode;
    data['batchId'] = batchId;
    data['status'] = status;
    data['activated'] = activated;
    data['desktopConfig'] = desktopConfig;
    data['owner'] = owner;
    if (metadata != null) {
      data['metadata'] = metadata!.toJson();
    }
    data['captureTreeValue'] = captureTreeValue;
    return data;
  }

  @override
  int compareTo(other) {
    int pd1 = metadata?.priorityDisplay ?? 1;
    int pd2 = other.metadata?.priorityDisplay ?? 1;
    int compare = pd1.compareTo(pd2);
    if (compare == 0) {
      DateTime d1 = string2Datetime(
          metadata?.modifiedDate ?? DateTime.now().toUtc().toString());
      DateTime d2 = string2Datetime(
          other.metadata?.modifiedDate ?? DateTime.now().toUtc().toString());
      return d2.compareTo(d1);
    } else {
      return compare;
    }
  }
}

class MetadataAlbumDto {
  String? nationalId;
  String? captureName;
  String? customerId;
  String? customerName;
  String? customerType;

  //-----Client User-------//
  String? ownerUser;
  int? priorityDisplay;
  String? path;
  int? numberOfImage;
  List<CaptureBatchImageDto>? images;
  List<CaptureBatchPdfDto>? pdfs;
  bool? isSync;
  String? thumbnailImage;
  String? createdDate;
  String? createdByUser;
  String? modifiedDate;
  String? modifiedByUser;
  int? lastImageIndex;

  MetadataAlbumDto({
    this.nationalId,
    this.captureName,
    this.customerId,
    this.customerName,
    this.customerType,
    //-----Client User-------//
    this.ownerUser,
    this.priorityDisplay = 1,
    this.path,
    this.numberOfImage,
    this.images,
    this.pdfs,
    this.isSync = false,
    this.thumbnailImage,
    this.createdDate,
    this.createdByUser,
    this.modifiedDate,
    this.modifiedByUser,
    this.lastImageIndex = 0,
  });

  MetadataAlbumDto.fromJson(Map<String, dynamic> json) {
    nationalId = json['national_id'];
    captureName = json['capture_name'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    customerType = CustomerType.fromString(json['customer_type']).name;
    //-----Client User-------//
    ownerUser = json['ownerUser'];
    priorityDisplay = json['priorityDisplay'];
    path = json['path'];
    numberOfImage = json['numberOfImage'];
    lastImageIndex = json['lastImageIndex'];
    List<CaptureBatchImageDto> listImages = <CaptureBatchImageDto>[];
    if (json['images'] != null) {
      json['images'].forEach((image) {
        listImages.add(CaptureBatchImageDto.fromJson(image));
      });
    }
    images = listImages;
    List<CaptureBatchPdfDto> listPdf = <CaptureBatchPdfDto>[];
    if (json['pdfs'] != null) {
      json['pdfs'].forEach((pdf) {
        listPdf.add(CaptureBatchPdfDto.fromJson(pdf));
      });
    }
    pdfs = listPdf;
    isSync = json['isSync'] ?? false;
    thumbnailImage = json['thumbnailImage'];
    createdDate = json['createdDate'] ?? '';
    createdByUser = json['createdByUser'] ?? '';
    modifiedDate = json['modifiedDate'] ?? '';
    modifiedByUser = json['modifiedByUser'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['national_id'] = nationalId;
    data['capture_name'] = captureName;
    data['customer_id'] = customerId;
    data['customer_name'] = customerName;
    data['customer_type'] = customerType.toString();
    //-----Client User-------//
    data['ownerUser'] = ownerUser;
    data['priorityDisplay'] = priorityDisplay;
    data['path'] = path;
    data['numberOfImage'] = numberOfImage;
    data['images'] = (images ?? []).map((image) => image.toJson()).toList();
    data['pdfs'] = (pdfs ?? []).map((pdf) => pdf.toJson()).toList();
    data['isSync'] = isSync;
    data['thumbnailImage'] = thumbnailImage;
    data['createdDate'] = createdDate;
    data['createdByUser'] = createdByUser;
    data['modifiedDate'] = modifiedDate;
    data['modifiedByUser'] = modifiedByUser;
    data['lastImageIndex'] = lastImageIndex;
    return data;
  }
}
