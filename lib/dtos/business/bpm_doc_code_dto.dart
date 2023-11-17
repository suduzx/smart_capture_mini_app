import 'package:smart_capture_mobile/dtos/api_response/api_response_data_result_generic.dart';

class BPMDocCodeDto extends ApiResponseDataResultGeneric {
  String docCode;
  String description;

  BPMDocCodeDto({
    required this.docCode,
    required this.description,
  });

  factory BPMDocCodeDto.fromJson(Map<String, dynamic> json) {
    return BPMDocCodeDto(
      docCode: json['docCode'],
      description: json['description'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['docCode'] = docCode;
    data['description'] = description;
    return data;
  }
}
