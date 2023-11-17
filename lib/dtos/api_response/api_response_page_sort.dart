class ApiResponsePageSort {
  bool? sorted;
  bool? unsorted;
  bool? empty;

  ApiResponsePageSort({
    this.sorted,
    this.unsorted,
    this.empty,
  });

  factory ApiResponsePageSort.fromJson(Map<String, dynamic> json) {
    return ApiResponsePageSort(
      sorted: json['sorted'],
      unsorted: json['unsorted'],
      empty: json['empty'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sorted'] = sorted;
    data['unsorted'] = unsorted;
    data['empty'] = empty;
    return data;
  }
}
