import 'package:smart_capture_mobile/dtos/api_response/api_response_data_result_generic.dart';

class StringResponseDto extends ApiResponseDataResultGeneric {
  String? result;

  StringResponseDto({this.result});

  StringResponseDto.fromJson(Map<String, dynamic> json) {
    result = json['result'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    return data;
  }
}
