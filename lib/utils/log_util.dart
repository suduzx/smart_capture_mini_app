import 'package:smart_capture_mobile/flavor.dart';
import 'package:smart_capture_mobile/dtos/business/action_log_dto.dart';
import 'package:smart_capture_mobile/dtos/business/user_account_dto.dart';
import 'package:smart_capture_mobile/enum/action_log_enum.dart';
import 'package:smart_capture_mobile/repositories/local_action_log_repository.dart';
import 'package:smart_capture_mobile/repositories/local_user_repository.dart';
import 'package:smart_capture_mobile/services/action_log_service.dart';
import 'package:smart_capture_mobile/services/diod.dart';
import 'package:device_info_plus/base_info.dart';
import 'package:device_info_plus/mp_device_info.dart';
import 'package:flutter/material.dart';
import 'package:mpcore/utils/mp_platform.dart';

class LogUtil {
  Future<void> addActionLog(ActionLogEnum actionBehavior) async {
    try {
      debugPrint(actionBehavior.name);
      LocalActionLogRepository localActionLogRepository =
          LocalActionLogRepository();
      List<ActionLogDto> actionLogs = await localActionLogRepository.getAll();
      UserAccountDto? currentUser =
          await LocalUserRepository().getCurrentUser();
      var username = currentUser?.username ?? '';
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      BaseDeviceInfo deviceInfo = await MPPlatform.isAndroid
          ? await deviceInfoPlugin.androidInfo
          : await deviceInfoPlugin.iosInfo;
      var time = DateTime.now().toUtc().toString();
      var id = '$username-$time-${actionBehavior.name}';
      ActionLogDto actionLogDto = ActionLogDto(
        id: id,
        username: username,
        fullName: currentUser?.accessTokenInfo?.name ?? '',
        behavior: actionBehavior,
        time: time,
        version: '',
        devicePlatform: await MPPlatform.isAndroid ? 'Android' : 'iOS',
        deviceInfo: deviceInfo.toString(),
      );
      actionLogs.add(actionLogDto);
      debugPrint('actionLogs.length: ${actionLogs.length.toString()}');
      if (actionLogs.length >= 5) {
        // Đồng bộ action log lên server
        ActionLogService actionLogService =
            ActionLogService(dio: DioD().dio, baseUrl: F.apiUrl);
        final result = await actionLogService.post(actionLogs);
        await result.when(
          success: (success) async {
            actionLogs = List.empty(growable: true);
            debugPrint('actionLogService.post success');
          },
          failure: (failure) {
            debugPrint('addActionLog failure');
          },
        );
      }
      await localActionLogRepository.update(actionLogs);
    } catch (e) {
      debugPrint('LogUtil.addActionLog: ${e.toString()}');
    }
  }
}
