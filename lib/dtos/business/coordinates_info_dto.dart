import 'package:smart_capture_mobile/dtos/api_response/api_response_data_result_generic.dart';

class CoordinatesInfoDto extends ApiResponseDataResultGeneric {
  String? title;
  String? name;
  String? address;
  String? lat;
  String? lng;
  String? communes;
  String? district;
  String? province;

  CoordinatesInfoDto({
    String? title,
    String? name,
    String? address,
    String? lat,
    String? lng,
    String? communes,
    String? district,
    String? province,
  }) {
    if (title != null) this.title = title;
    if (name != null) this.name = name;
    if (address != null) this.address = address;
    if (lat != null) this.lat = lat;
    if (lng != null) this.lng = lng;
    if (communes != null) this.communes = communes;
    if (district != null) this.district = district;
    if (province != null) this.province = province;
  }

  CoordinatesInfoDto.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    name = json['name'];
    address = json['address'];
    lat = json['lat'].toString();
    lng = json['lng'].toString();
    communes = json['communes'];
    district = json['district'];
    province = json['province'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['name'] = name;
    data['address'] = address;
    data['lat'] = lat;
    data['lng'] = lng;
    data['communes'] = communes;
    data['district'] = district;
    data['province'] = province;
    return data;
  }
}
