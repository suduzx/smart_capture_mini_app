import 'package:smart_capture_mobile/dtos/api_response/api_response_data_result_generic.dart';
import 'package:smart_capture_mobile/dtos/api_response/api_response_page.dart';
import 'package:smart_capture_mobile/dtos/bool_response_dto.dart';
import 'package:smart_capture_mobile/dtos/string_response_dto.dart';

class ApiResponseData<T extends ApiResponseDataResultGeneric> {
  List<T>? result;

  ApiResponseData({this.result});

  factory ApiResponseData.fromJson(
      Map<String, dynamic> json, Function fromJsonModel) {
    List<T> res = [];
    if (json['result'] != null) {
      if (json['result'] is List) {
        final items = json['result'] as List;
        res = List<T>.from(items.map((item) {
          if (item is Map) {
            return fromJsonModel(Map<String, dynamic>.from(item));
          } else if (item is String) {
            return StringResponseDto(result: item);
          }
          return item;
        }));
      } else {
        final item = json['result'];
        if (item is bool) {
          res.add(BoolResponseDto(result: item) as T);
        } else if (item is String) {
          res.add(StringResponseDto(result: item) as T);
        } else if (item != null && item['content'] != null) {
          final page = ApiResponsePage<T>.fromJson(
              Map<String, dynamic>.from(json['result'] as Map), fromJsonModel);
          if (page.content != null) {
            res.addAll(page.content!);
          }
        } else {
          res.add(fromJsonModel(Map<String, dynamic>.from(item as Map)));
        }
      }
    }
    return ApiResponseData(
      result: res,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
