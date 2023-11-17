import 'package:smart_capture_mobile/dtos/api_response/api_response_page_sort.dart';

class ApiResponsePagePageable {
  ApiResponsePageSort? sort;
  int? offset;
  int? pageNumber;
  int? pageSize;
  bool? unpaged;
  bool? paged;

  ApiResponsePagePageable({
    this.sort,
    this.offset,
    this.pageNumber,
    this.pageSize,
    this.unpaged,
    this.paged,
  });

  factory ApiResponsePagePageable.fromJson(
      Map<String, dynamic> json) {
    return ApiResponsePagePageable(
      sort: ApiResponsePageSort.fromJson(json['sort']),
      offset: json['offset'],
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      unpaged: json['unpaged'],
      paged: json['paged'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sort'] = sort!.toJson();
    data['offset'] = offset;
    data['pageNumber'] = pageNumber;
    data['pageSize'] = pageSize;
    data['unpaged'] = unpaged;
    data['paged'] = paged;
    return data;
  }
}
