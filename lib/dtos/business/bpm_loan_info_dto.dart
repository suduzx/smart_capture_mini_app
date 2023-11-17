import 'package:smart_capture_mobile/dtos/api_response/api_response_data_result_generic.dart';

class BPMLoanInfoDto extends ApiResponseDataResultGeneric {
  String loanId;
  String createdDate;
  int statusId;

  BPMLoanInfoDto({
    required this.loanId,
    required this.createdDate,
    required this.statusId,
  });

  factory BPMLoanInfoDto.fromJson(Map<String, dynamic> json) {
    return BPMLoanInfoDto(
      loanId: json['loanId'],
      createdDate: json['createdDate'],
      statusId: json['statusId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = loanId;
    data['createdDate'] = createdDate;
    data['statusId'] = statusId;
    return data;
  }
}
