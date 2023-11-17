import 'package:smart_capture_mobile/dtos/business/coordinates_info_dto.dart';

class RequestMetadataImageDto {
  String? lat;
  String? lng;
  CoordinatesInfoDto? coordinatesInfo;

  RequestMetadataImageDto({
    this.lat,
    this.lng,
    this.coordinatesInfo,
  });

  RequestMetadataImageDto.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    coordinatesInfo = json['coordinatesInfo'] != null
        ? CoordinatesInfoDto.fromJson(
            Map<String, dynamic>.from(json['coordinatesInfo'] as Map))
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    if (coordinatesInfo != null) {
      data['coordinatesInfo'] = coordinatesInfo!.toJson();
    } else {
      data['coordinatesInfo'] = null;
    }
    return data;
  }
}
