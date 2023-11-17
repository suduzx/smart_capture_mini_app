import 'package:smart_capture_mobile/dtos/api_response/api_response_data_result_generic.dart';

class CaptureBusinessDto extends ApiResponseDataResultGeneric {
  String? id;
  String? name;
  String? description;
  String? code;
  String? deviceType;
  String? desktopConfig;
  MobileConfig? mobileConfig;
  int? treeValueLevel;
  bool? activated;
  String? iconImageId;
  bool? allowAttachment;
  AttachmentConfig? attachmentConfig;
  String? shortCode;
  int? remainTime;
  String? deleteTime;
  DeliveryConfig? deliveryConfig;
  String? deviceAccessRole;

  CaptureBusinessDto({
    this.id,
    this.name,
    this.description,
    this.code,
    this.deviceType,
    this.desktopConfig,
    this.mobileConfig,
    this.treeValueLevel,
    this.activated,
    this.iconImageId,
    this.allowAttachment,
    this.attachmentConfig,
    this.shortCode,
    this.remainTime,
    this.deleteTime,
    this.deliveryConfig,
    this.deviceAccessRole,
  });

  CaptureBusinessDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    code = json['code'];
    deviceType = json['deviceType'];
    desktopConfig = json['desktopConfig'];
    mobileConfig = json['mobileConfig'] != null
        ? MobileConfig.fromJson(json['mobileConfig'])
        : null;
    treeValueLevel = json['treeValueLevel'];
    activated = json['activated'];
    iconImageId = json['iconImageId'];
    allowAttachment = json['allowAttachment'];
    attachmentConfig = json['attachmentConfig'] != null
        ? AttachmentConfig.fromJson(json['attachmentConfig'])
        : null;
    shortCode = json['shortCode'];
    remainTime = json['remainTime'];
    deleteTime = json['deleteTime'];
    deliveryConfig = json['deliveryConfig'] != null
        ? DeliveryConfig.fromJson(json['deliveryConfig'])
        : null;
    deviceAccessRole = json['deviceAccessRole'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['code'] = code;
    data['deviceType'] = deviceType;
    data['desktopConfig'] = desktopConfig;
    if (mobileConfig != null) {
      data['mobileConfig'] = mobileConfig!.toJson();
    }
    data['treeValueLevel'] = treeValueLevel;
    data['activated'] = activated;
    data['iconImageId'] = iconImageId;
    data['allowAttachment'] = allowAttachment;
    if (attachmentConfig != null) {
      data['attachmentConfig'] = attachmentConfig!.toJson();
    }
    data['shortCode'] = shortCode;
    data['remainTime'] = remainTime;
    data['deleteTime'] = deleteTime;
    if (deliveryConfig != null) {
      data['deliveryConfig'] = deliveryConfig!.toJson();
    }
    data['deviceAccessRole'] = deviceAccessRole;
    return data;
  }
}

class MobileConfig {
  int? maxPagesPerCapture;
  int? maxPagesPerDoc;
  int? maxSizePerPage;
  String? imageLayoutStyle;
  int? cacheIntervalTime;

  MobileConfig({
    this.maxPagesPerCapture,
    this.maxPagesPerDoc,
    this.maxSizePerPage,
    this.imageLayoutStyle,
    this.cacheIntervalTime,
  });

  MobileConfig.fromJson(Map<String, dynamic> json) {
    maxPagesPerCapture = json['maxPagesPerCapture'];
    maxPagesPerDoc = json['maxPagesPerDoc'];
    maxSizePerPage = json['maxSizePerPage'];
    imageLayoutStyle = json['imageLayoutStyle'];
    cacheIntervalTime = json['cacheIntervalTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maxPagesPerCapture'] = maxPagesPerCapture;
    data['maxPagesPerDoc'] = maxPagesPerDoc;
    data['maxSizePerPage'] = maxSizePerPage;
    data['imageLayoutStyle'] = imageLayoutStyle;
    data['cacheIntervalTime'] = cacheIntervalTime;
    return data;
  }
}

class AttachmentConfig {
  List<String>? allowExtensions;
  List<String>? allowAcceptType;
  int? maxAttachmentPerCapture;
  int? maxSizePerAttachment;
  int? maxAllowPushPerCapture;

  AttachmentConfig({
    this.allowExtensions,
    this.allowAcceptType,
    this.maxAttachmentPerCapture,
    this.maxSizePerAttachment,
    this.maxAllowPushPerCapture,
  });

  AttachmentConfig.fromJson(Map<String, dynamic> json) {
    allowExtensions = json['allowExtensions'].cast<String>();
    allowAcceptType = json['allowAcceptType'].cast<String>();
    maxAttachmentPerCapture = json['maxAttachmentPerCapture'];
    maxSizePerAttachment = json['maxSizePerAttachment'];
    maxAllowPushPerCapture = json['maxAllowPushPerCapture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['allowExtensions'] = allowExtensions;
    data['allowAcceptType'] = allowAcceptType;
    data['maxAttachmentPerCapture'] = maxAttachmentPerCapture;
    data['maxSizePerAttachment'] = maxSizePerAttachment;
    data['maxAllowPushPerCapture'] = maxAllowPushPerCapture;
    return data;
  }
}

class DeliveryConfig {
  String? actionName;
  String? flowName;

  DeliveryConfig({this.actionName, this.flowName});

  DeliveryConfig.fromJson(Map<String, dynamic> json) {
    actionName = json['actionName'];
    flowName = json['flowName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['actionName'] = actionName;
    data['flowName'] = flowName;
    return data;
  }
}
