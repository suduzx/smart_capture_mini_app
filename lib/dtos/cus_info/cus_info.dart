import 'package:smart_capture_mobile/dtos/api_response/api_response_data_result_generic.dart';

class CusInfo extends ApiResponseDataResultGeneric {
  String? customerId;
  String? name1;

  CusInfo({
    this.customerId,
    required this.name1,
  });

  CusInfo.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    name1 = json['name1'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customerId'] = customerId;
    data['name1'] = name1;
    return data;
  }
}
