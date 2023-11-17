import 'dart:convert';

import 'package:smart_capture_mobile/dtos/business/action_log_dto.dart';
import 'package:smart_capture_mobile/utils/encrypt_util.dart';
import 'package:smart_capture_mobile/utils/file_utils.dart';
import 'package:flutter/material.dart';

class LocalActionLogRepository {
  final String _fileName = 'actionLog.json';

  Future<List<ActionLogDto>> getAll() async {
    try {
      final file = await FileUtils.getJson(_fileName);
      String content = await file.readAsString();
      content = await EncryptUtil.decrypt(content);
      List<dynamic> list = jsonDecode(content);
      return List<ActionLogDto>.from(
          list.map<ActionLogDto>((e) => ActionLogDto.fromJson(e)));
    } catch (e) {
      debugPrint('LocalActionLogRepository.getAll: ${e.toString()}');
      return [];
    }
  }

  Future<bool> update(List<ActionLogDto> actionLogs) async {
    try {
      String json = jsonEncode(actionLogs);
      json = await EncryptUtil.encrypt(json);
      final file = await FileUtils.getJson(_fileName);
      await file.writeAsString(json);
      return true;
    } catch (e) {
      debugPrint('LocalActionLogRepository.update: ${e.toString()}');
      return false;
    }
  }
}
