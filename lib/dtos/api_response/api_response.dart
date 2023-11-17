import 'package:smart_capture_mobile/dtos/api_response/api_response_data_result_generic.dart';

import 'api_response_data.dart';

class ApiResponse<T extends ApiResponseDataResultGeneric> {
  int? status;
  String? error;
  String? path;
  String? clientMessageId;
  String? soaErrorCode;
  String? soaErrorDesc;
  ApiResponseData<T>? data;

  ApiResponse({
    this.status,
    this.error,
    this.path,
    this.clientMessageId,
    this.soaErrorCode,
    this.soaErrorDesc,
    this.data,
  });

  ApiResponse.fromJson(Map<String, dynamic> json, Function? fromJsonModel) {
    status = json['status'];
    error = json['error'];
    path = json['path'];
    clientMessageId = json['clientMessageId'];
    soaErrorCode = json['soaErrorCode'];
    soaErrorDesc = json['soaErrorDesc'];
    data = json['data'] != null && fromJsonModel != null
        ? ApiResponseData.fromJson(
            Map<String, dynamic>.from(json['data'] as Map), fromJsonModel)
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['error'] = this.error;
    data['path'] = this.path;
    data['clientMessageId'] = this.clientMessageId;
    data['soaErrorCode'] = this.soaErrorCode;
    data['soaErrorDesc'] = this.soaErrorDesc;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
