import 'package:smart_capture_mobile/dtos/business/tree_value_sync_bpm/tree_value_sync_bpm_dto.dart';
import 'package:flutter/material.dart';

@immutable
abstract class UploadBPMEvent {
  const UploadBPMEvent();
}

class GetLoanInfoAnDocCodeEvent extends UploadBPMEvent {
  final String albumId;
  final int statusId;

  const GetLoanInfoAnDocCodeEvent({
    required this.albumId,
    required this.statusId,
  });
}

class SyncBPMEvent extends UploadBPMEvent {
  final TreeValueSyncBPMDto treeValueSyncBPMDto;

  const SyncBPMEvent({
    required this.treeValueSyncBPMDto,
  });
}
