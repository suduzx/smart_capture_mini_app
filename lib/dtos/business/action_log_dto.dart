import 'package:smart_capture_mobile/dtos/api_response/api_response_data_result_generic.dart';
import 'package:smart_capture_mobile/enum/action_log_enum.dart';

class ActionLogDto extends ApiResponseDataResultGeneric {
  String? id;
  String? username;
  String? fullName;
  ActionLogEnum? behavior;
  String? time;
  String? version;
  String? devicePlatform;
  String? deviceInfo;

  ActionLogDto({
    this.id,
    this.username,
    this.fullName,
    this.behavior,
    this.time,
    this.version,
    this.devicePlatform,
    this.deviceInfo,
  });

  ActionLogDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    fullName = json['fullName'];
    behavior = ActionLogEnum.fromString(json['behavior']);
    time = json['time'];
    version = json['version'];
    devicePlatform = json['devicePlatform'];
    deviceInfo = json['deviceInfo'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['fullName'] = fullName;
    data['behavior'] = behavior.toString();
    data['time'] = time;
    data['version'] = version;
    data['devicePlatform'] = devicePlatform;
    data['deviceInfo'] = deviceInfo;
    return data;
  }
}
