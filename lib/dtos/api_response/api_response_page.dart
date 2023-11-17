import 'package:smart_capture_mobile/dtos/api_response/api_response_data_result_generic.dart';
import 'package:smart_capture_mobile/dtos/api_response/api_response_page_pageable.dart';
import 'package:smart_capture_mobile/dtos/api_response/api_response_page_sort.dart';

class ApiResponsePage<T extends ApiResponseDataResultGeneric> {
  List<T>? content;
  ApiResponsePagePageable? pageable;
  bool? last;
  int? totalPages;
  int? totalElements;
  int? size;
  int? number;
  ApiResponsePageSort? sort;
  bool? first;
  int? numberOfElements;
  bool? empty;

  ApiResponsePage({
    this.content,
    this.pageable,
    this.last,
    this.totalPages,
    this.totalElements,
    this.size,
    this.number,
    this.sort,
    this.first,
    this.numberOfElements,
    this.empty,
  });

  factory ApiResponsePage.fromJson(
      Map<String, dynamic> json, Function fromJsonModel) {
    final items = json['content'].cast<Map<String, dynamic>>();
    List<T> content =
        List<T>.from(items.map((itemsJson) => fromJsonModel(itemsJson)));
    return ApiResponsePage(
      content: content,
      pageable: ApiResponsePagePageable.fromJson(json['pageable']),
      last: json['last'],
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
      size: json['size'],
      number: json['number'],
      sort: ApiResponsePageSort.fromJson(json['sort']),
      first: json['first'],
      numberOfElements: json['numberOfElements'],
      empty: json['empty'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.content != null) {
      data['content'] = this.content!.map((v) => v.toJson()).toList();
    }
    data['pageable'] = this.pageable!.toJson();
    data['last'] = this.last;
    data['totalPages'] = this.totalPages;
    data['totalElements'] = this.totalElements;
    data['size'] = this.size;
    data['number'] = this.number;
    data['sort'] = this.sort!.toJson();
    data['first'] = this.first;
    data['numberOfElements'] = this.numberOfElements;
    data['empty'] = this.empty;
    return data;
  }
}
