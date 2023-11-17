import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_pdf_dto.dart';
import 'package:smart_capture_mobile/dtos/business/tree_value_sync_bpm/children_node_dto.dart';
import 'package:smart_capture_mobile/dtos/business/tree_value_sync_bpm/children_sync_data_file_dto.dart';
import 'package:smart_capture_mobile/dtos/business/tree_value_sync_bpm/properties_dto.dart';
import 'package:smart_capture_mobile/dtos/business/tree_value_sync_bpm/root_dto.dart';
import 'package:smart_capture_mobile/dtos/business/tree_value_sync_bpm/root_properties_dto.dart';
import 'package:smart_capture_mobile/dtos/business/tree_value_sync_bpm/tree_value_sync_bpm_dto.dart';
import 'package:smart_capture_mobile/enum/file_status_enum.dart';
import 'package:smart_capture_mobile/pages/detail_album_page/bloc/album_event.dart';
import 'package:smart_capture_mobile/pages/detail_album_page/bloc/album_state.dart';
import 'package:smart_capture_mobile/repositories/local_capture_batch_repository.dart';
import 'package:smart_capture_mobile/repositories/local_capture_business_repository.dart';
import 'package:smart_capture_mobile/utils/file_utils.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';
import 'package:smart_capture_mobile/utils/mixin/number_util.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState>
    with DatetimeUtil, NumberUtil {
  AlbumBloc(super.initialState) {
    on<LoadAlbumEvent>(_loadAlbumEvent);
    on<SelectionModeEvent>(_selectionModeEvent);
    on<ItemTapEvent>(_imageTapEvent);
    on<ConvertPDFEvent>(_convertPDFEvent);
    on<ConvertTreeValueEvent>(_convertTreeValueEvent);
  }

  FutureOr<void> _loadAlbumEvent(
    LoadAlbumEvent event,
    Emitter<AlbumState> emit,
  ) async {
    try {
      String path = await FileUtils.getRootAlbumPath();
      List<CaptureBatchDto> albums =
          await LocalCaptureBatchRepository().getAll(isReadOnly: true);
      CaptureBatchDto albumDTO;
      int albumIndex = albums.indexWhere(
          (album) => album.metadata!.captureName == event.albumName);
      albumDTO = albums[albumIndex];
      List<CaptureBatchImageDto> images =
          event.fileStatus.filter(albumDTO.metadata!.images!);
      List<CaptureBatchPdfDto> pdfs =
          event.fileStatus.filterPDF(albumDTO.metadata!.pdfs!);

      emit(LoadAlbumEventSuccess(
        autoSync: event.autoSync,
        rootAlbumPath: path,
        albums: albums,
        albumDTO: albumDTO,
        albumName: event.albumName,
        fileStatus: event.fileStatus,
        images: images,
        pdfs: pdfs,
      ));
    } on Exception catch (e) {
      debugPrint('addActionLog: $e');
      emit(LoadAlbumEventError(albumDto: state.albumDTO));
    }
  }

  FutureOr<void> _selectionModeEvent(
      SelectionModeEvent event, Emitter<AlbumState> emit) {
    emit(SelectionModeEventSuccess(
      state: state,
      selectionMode: !event.selectionMode,
    ));
  }

  FutureOr<void> _imageTapEvent(ItemTapEvent event, Emitter<AlbumState> emit) {
    if (event.selectedIndex.contains(event.index)) {
      event.selectedIndex.remove(event.index);
    } else {
      event.selectedIndex.add(event.index);
    }

    if (event.isImage) {
      emit(ItemTapEventSuccess(
        state: state,
        selectedImages: event.selectedIndex,
        selectedPDFs: state.selectedPDFs,
      ));
    } else {
      emit(ItemTapEventSuccess(
        state: state,
        selectedImages: state.selectedImages,
        selectedPDFs: event.selectedIndex,
      ));
    }
  }

  FutureOr<void> _convertPDFEvent(
      ConvertPDFEvent event, Emitter<AlbumState> emit) async {
    int limitNumberOfPdfPerAlbum =
        (await LocalCaptureBusinessRepository().getLimitNumberOfPdfPerAlbum())!;
    if (state.albumDTO.metadata!.pdfs!.length >= limitNumberOfPdfPerAlbum) {
      emit(ConvertPDFEventError(
        state: state,
        title: 'Album đã đủ $limitNumberOfPdfPerAlbum PDF',
        message: 'Vui lòng kiểm tra lại album hoặc xóa các PDF không cần thiết',
        titleButton: 'OK',
      ));
      return;
    }
    List<CaptureBatchImageDto> imagesInUse =
        FileStatus.inUse.filter(state.albumDTO.metadata!.images!);
    List<CaptureBatchImageDto> selectedImages =
        state.selectedImages.map((idx) => imagesInUse.elementAt(idx)).toList();
    if (selectedImages
        .any((captureBatchImageDto) => captureBatchImageDto.id == null)) {
      emit(ConvertPDFEventError(
        state: state,
        title: 'Không thể xuất tệp PDF',
        message: 'Vui lòng kiểm tra lại trạng thái đồng bộ các ảnh đã chọn',
        titleButton: 'OK',
      ));
      return;
    }
    String rootAlbumPath = await FileUtils.getRootAlbumPath();
    int totalSize = 0;
    await Future.forEach(selectedImages, (img) async {
      totalSize +=
          await FileUtils.getFileSize('$rootAlbumPath${img.metadata!.path}');
    });
    int maxSizePerAttachment =
        await LocalCaptureBusinessRepository().getMaxSizePerAttachment();
    if (totalSize > maxSizePerAttachment) {
      emit(ConvertPDFEventError(
        state: state,
        title: 'Vượt quá dung lượng xuất tệp PDF',
        message: 'Vui lòng kiểm tra lại dung lượng tối đa xuất tệp PDF',
        titleButton: 'OK',
      ));
      return;
    }
    emit(ConvertPDFEventSuccess(state: state));
  }

  FutureOr<void> _convertTreeValueEvent(
      ConvertTreeValueEvent event, Emitter<AlbumState> emit) async {
    try {
      if (state.albumDTO.metadata!.customerId == null) {
        emit(ConvertTreeValueEventError(
          title: 'Không thể upload',
          message: 'Album chưa đồng bộ code T24. Vui lòng kiểm tra lại!',
          titleButton: 'OK',
          state: state,
        ));
        return;
      }
      List<CaptureBatchImageDto> imagesInUse =
          FileStatus.inUse.filter(state.albumDTO.metadata!.images!);
      List<String> selectedImageIds =
          state.selectedImages.map((idx) => imagesInUse[idx].id!).toList();
      List<CaptureBatchPdfDto> pdfsInUse =
          FileStatus.inUse.filterPDF(state.albumDTO.metadata!.pdfs!);
      List<String> selectedPdfIds =
          state.selectedPDFs.map((idx) => pdfsInUse[idx].id!).toList();
      int maxAllowPushPerCapture = await LocalCaptureBusinessRepository()
          .getMaxAllowPushPerCapture();
      if (state.selectedImages.length + state.selectedPDFs.length >
          maxAllowPushPerCapture) {
        emit(ConvertTreeValueEventError(
          title: 'Không thể upload',
          message:
              'Chỉ được phép upload tối đa $maxAllowPushPerCapture file. Vui lòng kiểm tra lại!',
          titleButton: 'OK',
          state: state,
        ));
        return;
      }
      TreeValueSyncBPMDto treeValueSyncBPMDto = TreeValueSyncBPMDto(
        albumId: state.albumDTO.id,
        root: RootDto(
          version: "1.0",
          properties: RootPropertiesDto(
            name: state.albumDTO.metadata!.captureName,
            nodeType: "folder",
            bpmDocumentCode: null,
            bpmLoanId: null,
          ),
          childrenNodes: [
            ChildrenNodeDto(
              version: "1.0",
              properties: PropertiesDto(
                name: "capture",
                nodeType: "document",
                type: "capture",
              ),
              childrenSyncDataFiles: imagesInUse
                  .where((image) => image.id != null)
                  .map(
                    (image) => ChildrenSyncDataFileDto(
                      id: image.id,
                      allowPush: selectedImageIds.contains(image.id!)
                          ? 'true'
                          : 'false',
                    ),
                  )
                  .toList(),
            ),
            ...pdfsInUse.where((pdf) => pdf.id != null).map(
                  (pdf) => ChildrenNodeDto(
                    version: "1.0",
                    properties: PropertiesDto(
                        name: pdf.name,
                        nodeType: "document",
                        type: "attachment"),
                    syncDataFile: ChildrenSyncDataFileDto(
                      id: pdf.id,
                      allowPush:
                          selectedPdfIds.contains(pdf.id!) ? 'true' : 'false',
                    ),
                  ),
                )
          ],
        ),
      );
      emit(ConvertTreeValueEventSuccess(
          treeValueSyncBPMDto: treeValueSyncBPMDto, state: state));
    } catch (e) {
      emit(ConvertTreeValueEventError(
        title: 'Mạng không ổn định',
        message: 'Vui lòng kiểm tra lại kết nối internet bạn!',
        titleButton: 'OK',
        state: state,
      ));
    }
  }
}
