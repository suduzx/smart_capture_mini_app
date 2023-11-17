import 'dart:convert';

import 'package:smart_capture_mobile/dtos/business/capture_business_dto.dart';
import 'package:smart_capture_mobile/utils/encrypt_util.dart';
import 'package:smart_capture_mobile/utils/file_utils.dart';
import 'package:flutter/cupertino.dart';

class LocalCaptureBusinessRepository {
  final String _fileName = 'capture_business.json';

  Future<bool> update(List<CaptureBusinessDto> dtos) async {
    final userFile = await FileUtils.getJson(_fileName);
    try {
      String json = jsonEncode(dtos);
      json = await EncryptUtil.encrypt(json);
      await userFile.writeAsString(json);
      return true;
    } on Exception catch (e) {
      debugPrint('LocalCaptureBusinessUtils.update: ${e.toString()}');
      return false;
    }
  }

  Future<CaptureBusinessDto?> _getCaptureBusinessCATD() async {
    try {
      final file = await FileUtils.getJson(_fileName);
      String content = await file.readAsString();
      content = await EncryptUtil.decrypt(content);
      List<dynamic> list = jsonDecode(content);
      List<CaptureBusinessDto> dtos = List<CaptureBusinessDto>.from(
          list.map<CaptureBusinessDto>((e) => CaptureBusinessDto.fromJson(e)));
      return dtos.firstWhere((dto) => dto.code == 'CATD');
    } catch (e) {
      debugPrint('getLimitNumberOfAlbums: ${e.toString()}');
      return null;
    }
  }

  Future<int?> getRemainTime() async {
    CaptureBusinessDto? dto = await _getCaptureBusinessCATD();
    return dto?.remainTime ?? 30;
  }

  Future<int?> getLimitNumberOfAlbums() async {
    CaptureBusinessDto? dto = await _getCaptureBusinessCATD();
    return dto?.mobileConfig?.maxPagesPerCapture ?? 30;
  }

  Future<int?> getLimitNumberOfImagePerAlbum() async {
    CaptureBusinessDto? dto = await _getCaptureBusinessCATD();
    return dto?.mobileConfig?.maxPagesPerDoc ?? 30;
  }

  Future<int?> getLimitNumberOfPdfPerAlbum() async {
    CaptureBusinessDto? dto = await _getCaptureBusinessCATD();
    return dto?.attachmentConfig?.maxAttachmentPerCapture ?? 30;
  }

  Future<int> getMaxAllowPushPerCapture() async {
    CaptureBusinessDto? dto = await _getCaptureBusinessCATD();
    return dto?.attachmentConfig?.maxAllowPushPerCapture ?? 10;
  }

  Future<int> getMaxSizePerAttachment() async {
    CaptureBusinessDto? dto = await _getCaptureBusinessCATD();
    return (dto?.attachmentConfig?.maxSizePerAttachment ?? 10240) * 1024;
  }

  Future<int?> getLocationChangeInterval() async {
    CaptureBusinessDto? dto = await _getCaptureBusinessCATD();
    return dto?.mobileConfig?.cacheIntervalTime ?? 10;
  }
}
