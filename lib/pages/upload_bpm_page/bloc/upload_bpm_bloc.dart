import 'dart:async';
import 'dart:convert';

import 'package:smart_capture_mobile/flavor.dart';
import 'package:smart_capture_mobile/dtos/business/bpm_doc_code_dto.dart';
import 'package:smart_capture_mobile/dtos/business/bpm_loan_info_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/user_account_dto.dart';
import 'package:smart_capture_mobile/pages/upload_bpm_page/bloc/upload_bpm_event.dart';
import 'package:smart_capture_mobile/pages/upload_bpm_page/bloc/upload_bpm_state.dart';
import 'package:smart_capture_mobile/repositories/local_capture_batch_repository.dart';
import 'package:smart_capture_mobile/repositories/local_user_repository.dart';
import 'package:smart_capture_mobile/services/capture_batch_service.dart';
import 'package:smart_capture_mobile/services/diod.dart';
import 'package:smart_capture_mobile/utils/encrypt_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UploadBPMBloc extends Bloc<UploadBPMEvent, UploadBPMState> {
  UploadBPMBloc(super.initialState) {
    on<GetLoanInfoAnDocCodeEvent>(_getLoanInfoAnDocCodeEvent);
    on<SyncBPMEvent>(_syncBPMEvent);
  }

  FutureOr<void> _getLoanInfoAnDocCodeEvent(
      GetLoanInfoAnDocCodeEvent event, Emitter<UploadBPMState> emit) async {
    List<BPMDocCodeDto> docCodes = [];
    List<BPMLoanInfoDto> loanInfoList = [];
    CaptureBatchService service =
        CaptureBatchService(dio: DioD().dio, baseUrl: F.apiUrl);
    List<CaptureBatchDto> albums =
        await LocalCaptureBatchRepository().getAll(isReadOnly: false);
    String codeT24 = albums
        .firstWhere((album) => album.id == event.albumId)
        .metadata!
        .customerId!;
    final getListLoanInfoResult = await service.getLoanInfo(
      codeT24: codeT24,
      statusId: event.statusId,
    );
    final getListDocCodeResult = await service.getListDocCode();
    if (getListLoanInfoResult.isSuccess) {
      loanInfoList = getListLoanInfoResult.success!.data!.result!;
    }
    if (getListDocCodeResult.isSuccess) {
      docCodes = getListDocCodeResult.success!.data!.result!;
    }
    if (getListLoanInfoResult.isFailure ||
        getListDocCodeResult.isFailure ||
        loanInfoList.isEmpty ||
        docCodes.isEmpty) {
      emit(GetLoanInfoAndDocCodeEventError(
        message: 'Hiện tại hệ thống BPM chưa có mã phương án phù hợp',
      ));
    } else {
      emit(GetLoanInfoAndDocCodeEventSuccess(
        loanInfoDTO: loanInfoList,
        docCodeDTO: docCodes,
        codeT24: codeT24,
      ));
    }
  }

  FutureOr<void> _syncBPMEvent(
      SyncBPMEvent event, Emitter<UploadBPMState> emit) async {
    try {
      CaptureBatchService service =
          CaptureBatchService(dio: DioD().dio, baseUrl: F.apiUrl);
      final getListLoanInfoResult = await service.getLoanInfo(
        codeT24: state.codeT24,
        loanId: event.treeValueSyncBPMDto.root!.properties!.bpmLoanId!,
      );
      int statusId = 171;
      if (getListLoanInfoResult.isSuccess) {
        statusId = getListLoanInfoResult.success!.data!.result!.first.statusId;
      }
      if (statusId == 171) {
        UserAccountDto? currentUser =
            await LocalUserRepository().getCurrentUser();
        String encryptedText = EncryptUtil.encryptData(
            jsonEncode(event.treeValueSyncBPMDto),
            currentUser!.accessTokenInfo!.sessionState!);
        CaptureBatchService captureBatchService =
            CaptureBatchService(dio: DioD().dio, baseUrl: F.apiUrl);
        final result = await captureBatchService.syncBpm(
          albumId: event.treeValueSyncBPMDto.albumId!,
          encryptedText: encryptedText,
        );
        if (result.isFailure) {
          emit(SyncBPMEventComplete(
            title: 'Upload thất bại',
            message: 'Upload thất bại. Vui lòng thử lại!',
          ));
          return;
        }
        LocalCaptureBatchRepository repository = LocalCaptureBatchRepository();
        List<CaptureBatchDto> albums =
            await repository.getAll(isReadOnly: true);
        CaptureBatchDto album = albums.firstWhere(
            (album) => album.id == event.treeValueSyncBPMDto.albumId);
        List<String?> imageIds = List.empty(growable: true);
        List<String?> pdfIds = List.empty(growable: true);
        for (var node in event.treeValueSyncBPMDto.root!.childrenNodes!) {
          if (node.childrenSyncDataFiles != null) {
            imageIds = node.childrenSyncDataFiles!
                .where((element) => element.allowPush == "true")
                .map((e) => e.id)
                .toList();
          }
          if (node.syncDataFile != null &&
              node.syncDataFile?.allowPush == "true") {
            // if(node.syncDataFile!.allowPush == "true") {
            pdfIds.add(node.syncDataFile!.id);
            // }
          }
        }

        ///Lấy id những ảnh chứa trong file pdf được upload add vào imageIds
        for (var pdf in album.metadata!.pdfs!) {
          if (pdfIds.contains(pdf.id)) {
            imageIds.addAll(pdf.metadata!.dataFileIds!);
          }
        }

        ///Cập nhật hasBeenUsed = true với những ảnh có id nằm trong list imageIds
        for (var img in album.metadata!.images!) {
          img.metadata!.hasBeenUsed =
              img.metadata!.hasBeenUsed || imageIds.contains(img.id);
        }
        await repository.sortThenUpdate(album);

        emit(SyncBPMEventComplete(
          title: 'Upload thành công',
          message: 'Phương án đã được tải thành công lên hệ thống!',
        ));
      } else {
        emit(SyncBPMEventComplete(
          title: 'Upload thất bại',
          message:
              'Phương án được chọn không được phép upload. Vui lòng kiểm tra lại',
        ));
      }
    } catch (e) {
      debugPrint('UploadBPMBloc: _syncBPMEvent $e');
      emit(SyncBPMEventComplete(
        title: 'Upload thất bại',
        message: 'Upload thất bại. Vui lòng thử lại!',
      ));
    }
  }
}
