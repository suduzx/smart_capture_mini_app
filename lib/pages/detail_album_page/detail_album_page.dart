import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mpcore/mpcore.dart';
import 'package:smart_capture_mobile/base_widgets/my_confirm_dialog.dart';
import 'package:smart_capture_mobile/base_widgets/my_drop_down.dart';
import 'package:smart_capture_mobile/base_widgets/my_message_dialog.dart';
import 'package:smart_capture_mobile/blocs/camera_util_bloc/camera_bloc.dart';
import 'package:smart_capture_mobile/blocs/camera_util_bloc/camera_event.dart';
import 'package:smart_capture_mobile/blocs/camera_util_bloc/camera_state.dart';
import 'package:smart_capture_mobile/blocs/delete_file_bloc/delete_file_bloc.dart';
import 'package:smart_capture_mobile/blocs/delete_file_bloc/delete_file_event.dart';
import 'package:smart_capture_mobile/blocs/delete_file_bloc/delete_file_state.dart';
import 'package:smart_capture_mobile/blocs/move_file_bloc/move_file_bloc.dart';
import 'package:smart_capture_mobile/blocs/move_file_bloc/move_file_event.dart';
import 'package:smart_capture_mobile/blocs/move_file_bloc/move_file_state.dart';
import 'package:smart_capture_mobile/blocs/restore_file_bloc/restore_file_bloc.dart';
import 'package:smart_capture_mobile/blocs/restore_file_bloc/restore_file_event.dart';
import 'package:smart_capture_mobile/blocs/restore_file_bloc/restore_file_state.dart';
import 'package:smart_capture_mobile/blocs/sync_bloc/sync_bloc.dart';
import 'package:smart_capture_mobile/blocs/sync_bloc/sync_data.dart';
import 'package:smart_capture_mobile/blocs/sync_bloc/sync_event.dart';
import 'package:smart_capture_mobile/blocs/sync_bloc/sync_state.dart';
import 'package:smart_capture_mobile/controllers/load_status_controller.dart';
import 'package:smart_capture_mobile/controllers/my_drop_down_controller.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_pdf_dto.dart';
import 'package:smart_capture_mobile/dtos/widget_dto/convert_file_pdf_dto.dart';
import 'package:smart_capture_mobile/dtos/widget_dto/detail_album_dto.dart';
import 'package:smart_capture_mobile/dtos/widget_dto/detail_image_dto.dart';
import 'package:smart_capture_mobile/dtos/widget_dto/list_view_item_dto.dart';
import 'package:smart_capture_mobile/dtos/widget_dto/view_pdf_page_dto.dart';
import 'package:smart_capture_mobile/enum/confirm_value_enum.dart';
import 'package:smart_capture_mobile/enum/file_status_enum.dart';
import 'package:smart_capture_mobile/pages/detail_album_page/bloc/album_bloc.dart';
import 'package:smart_capture_mobile/pages/detail_album_page/bloc/album_event.dart';
import 'package:smart_capture_mobile/pages/detail_album_page/bloc/album_state.dart';
import 'package:smart_capture_mobile/pages/detail_album_page/widgets/detail_album_bottom_sheet_bar.dart';
import 'package:smart_capture_mobile/pages/detail_album_page/widgets/detail_album_empty_widget.dart';
import 'package:smart_capture_mobile/pages/detail_album_page/widgets/detail_album_grid_view_pdf_widget.dart';
import 'package:smart_capture_mobile/pages/detail_album_page/widgets/detail_album_grid_view_widget.dart';
import 'package:smart_capture_mobile/pages/detail_album_page/widgets/detail_album_image_not_sync_widget.dart';
import 'package:smart_capture_mobile/pages/detail_album_page/widgets/detail_album_trailing_button_widget.dart';
import 'package:smart_capture_mobile/pages/master_page.dart';
import 'package:smart_capture_mobile/pages/master_page_with_loading.dart';
import 'package:smart_capture_mobile/pages/upload_bpm_page/bloc/upload_bpm_state.dart';
import 'package:smart_capture_mobile/pages/widgets/move_image_widget.dart';
import 'package:smart_capture_mobile/pages/widgets/move_success_widget.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';
import 'package:smart_capture_mobile/utils/mixin/top_snack_bar_util.dart';

class DetailAlbumPage extends StatefulWidget {
  final DetailAlbumDto detailAlbumDto;

  const DetailAlbumPage({
    required this.detailAlbumDto,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailAlbumPageState();
}

class _DetailAlbumPageState extends State<DetailAlbumPage>
    with DatetimeUtil, TopSnackBarUtil {
  final LoadStatusController c = Get.put(LoadStatusController());
  final MyDropDownController myDropDownController =
      Get.put(MyDropDownController(), tag: 'myDropDownController');
  late BuildContext providerContext;
  late AlbumState _albumState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      c.stopLoadingAndSync();
      myDropDownController.updateDisplayText(widget.detailAlbumDto.albumName);
      bool? createSuccess = widget.detailAlbumDto.createAlbumSuccess;
      if (createSuccess != null) {
        if (createSuccess) await showSuccess('Tạo album thành công!');
        // else
        //   await showError(
        //       'Tạo album không thành công. Vui lòng kiểm tra lại kết nối internet và thử lại');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AlbumBloc>(
          create: (context) => AlbumBloc(AlbumState(
            rootAlbumPath: '',
            albums: const [],
            albumDTO: widget.detailAlbumDto.albumDto,
            albumName: '',
            fileStatus: FileStatus.inUse,
            selectionMode: false,
            images: const [],
            pdfs: const [],
            selectedImages: const [],
            selectedPDFs: const [],
          ))
            ..add(LoadAlbumEvent(
              albumName: widget.detailAlbumDto.albumName,
              fileStatus: FileStatus.inUse,
              autoSync: false,
            )),
        ),
        BlocProvider<CameraBloc>(
            create: (context) => CameraBloc(const CameraState())),
        BlocProvider<DeleteFileBloc>(
            create: (context) =>
                DeleteFileBloc(const DeleteFileState(title: ''))),
        BlocProvider<RestoreFileBloc>(
            create: (context) =>
                RestoreFileBloc(const RestoreFileState(title: ''))),
        BlocProvider<MoveFileBloc>(
            create: (context) => MoveFileBloc(const MoveFileState())),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AlbumBloc, AlbumState>(listener: (context, state) {
            if (state is LoadAlbumEventSuccess) {
              myDropDownController.updateDisplayText(state.albumName);
              c.stopLoadingAndSync();
              if (state.autoSync) {
                providerContext.read<SyncBloc>().add(AddSyncDataEvent(
                      context: providerContext,
                      albumPath: _albumState.albumDTO.metadata!.path,
                      showAlert: false,
                    ));
              }
            }
            if (state is LoadAlbumEventError) {
              c.stopLoadingAndSync();
              MyMessageDialog(
                isCenter: true,
                title: 'Có lỗi xảy ra',
                message: 'Không thể mở album này. Vui lòng thử lại!',
                titleButton: 'OK',
              ).onShowDialog(context);
            }
            if (state is ConvertPDFEventSuccess) {
              c.stopLoadingAndSync();
              Navigator.of(context)
                  .pushNamed('/convert-file-pdf',
                      arguments: ConvertFilePDFDto(
                        albumDto: _albumState.albumDTO,
                        selectedImages: _albumState.selectedImages,
                      ))
                  .then((value) async {
                if (value != null) {
                  loadAlbumEvent();
                  if (value as bool) {
                    await showSuccess('Xuất tệp PDF thành công');
                  }
                }
              });
            }
            if (state is ConvertPDFEventError) {
              c.stopLoadingAndSync();
              MyMessageDialog(
                isCenter: true,
                title: state.title,
                message: state.message,
                titleButton: state.titleButton,
              ).onShowDialog(context);
            }
            if (state is DeletePDFSuccess) {
              loadAlbumEvent();
              showSuccess(state.message);
            }
            if (state is ConvertTreeValueEventSuccess) {
              Navigator.of(context)
                  .pushNamed('/upload-bpm',
                      arguments: state.treeValueSyncBPMDto)
                  .then((value) {
                if (value != null) {
                  UploadBPMState state = value as UploadBPMState;
                  MyMessageDialog(
                    isCenter: true,
                    title: state.title!,
                    message: state.message!,
                    titleButton: state.titleButton!,
                  ).onShowDialog(context);
                }
                loadAlbumEvent();
              });
            }
            if (state is ConvertTreeValueEventError) {
              MyMessageDialog(
                isCenter: true,
                title: state.title,
                message: state.message,
                titleButton: state.titleButton,
              ).onShowDialog(context);
            }
          }),
          BlocListener<CameraBloc, CameraState>(listener: (context, state) {
            /// Xử lý logic khi state là success
            if (state is OnCameraTapEventSuccess) {
              providerContext.read<CameraBloc>().add(TakePhotoEvent(
                    _albumState.albumDTO,
                    state.limitAlbumImageParam,
                    state.locationChangeInterval,
                  ));
            }
            if (state is TakePhotoEventSuccess) {
              providerContext.read<CameraBloc>().add(
                  AddLocationAndWaterMarkEvent(state.albumDto, state.image));
            }
            if (state is NotTakeMorePhoto) {
              c.stopLoadingAndSync();
            }
            if (state is AddLocationAndWaterMarkEventSuccess) {
              c.stopLoadingAndSync();
              loadAlbumEvent();
              if (state.title.isNotEmpty) {
                MyMessageDialog(
                  title: state.title,
                  message: state.message,
                  titleButton: state.titleButton,
                ).onShowDialog(context);
              } else {
                showSuccess(state.alertSuccess);
              }
            }

            /// Xử lý logic khi state là error
            if (state is OnCameraTapEventError ||
                state is TakePhotoEventError) {
              final stateError = state as CameraStateError;
              c.stopLoadingAndSync();
              MyMessageDialog(
                title: stateError.title,
                message: stateError.message,
                titleButton: stateError.titleButton,
              ).onShowDialog(context);
            }
          }),
          BlocListener<SyncBloc, SyncState>(
            listener: (context, state) {
              if (state is SyncAlbumEventCompleted) {
                loadAlbumEvent();
                if (state.showAlert) {
                  if (state.isSuccess) {
                    showSuccess(state.alert);
                  } else {
                    showError(state.alert);
                  }
                }
                c.updateSyncCompleted(true);
              }
            },
          ),
          BlocListener<DeleteFileBloc, DeleteFileState>(
              listener: (context, state) {
            if (state is DeleteConfirmEventSuccess) {
              if (_albumState.selectedImages.any((index) => SyncData.datas.contains(
                      '${SyncData.prefixImage}${_albumState.images[index].metadata!.path}')) ||
                  _albumState.selectedPDFs.any((index) => SyncData.datas.contains(
                      '${SyncData.prefixPdf}${_albumState.pdfs[index].metadata!.path}'))) {
                MyMessageDialog(
                  isCenter: true,
                  title: 'Hiện chưa thể thao tác',
                  message:
                      'Hiện tại đang tiến hành đồng bộ tự động ảnh lên hệ thống. Vui lòng thử lại sau!',
                  titleButton: 'OK',
                ).onShowDialog(context);
              } else {
                MyConfirmDialog(
                  title: state.title,
                  message: state.message ?? '',
                ).showConfirmDialog(context).then((res) {
                  if (res != null && res == ConfirmValue.confirm) {
                    providerContext.read<DeleteFileBloc>().add(
                          DeleteEvent(
                            state.isDeleteAll,
                            _albumState.albumDTO,
                            _albumState.fileStatus,
                            _albumState.selectedImages,
                            _albumState.selectedPDFs,
                          ),
                        );
                  }
                });
              }
            }
            if (state is DeleteEventSuccess) {
              loadAlbumEvent();
              showSuccess(state.title);
            }
            if (state is DeleteEventError) {
              loadAlbumEvent();
              showError(state.title);
            }
          }),
          BlocListener<RestoreFileBloc, RestoreFileState>(
              listener: (context, state) {
            if (state is RestoreConfirmEventSuccess) {
              MyConfirmDialog(
                title: state.title,
                message: state.message ?? '',
              ).showConfirmDialog(context).then((res) {
                if (res != null && res == ConfirmValue.confirm) {
                  providerContext.read<RestoreFileBloc>().add(
                        RestoreEvent(
                          _albumState.albumDTO,
                          _albumState.selectedImages,
                          _albumState.selectedPDFs,
                        ),
                      );
                }
              });
            }
            if (state is RestoreEventSuccess) {
              loadAlbumEvent();
              showSuccess(state.title);
            }
          }),
          BlocListener<MoveFileBloc, MoveFileState>(listener: (context, state) {
            if (state is ShowMoveBottomSheetEventSuccess) {
              if (_albumState.selectedImages.any((index) => SyncData.datas.contains(
                      '${SyncData.prefixImage}${_albumState.images[index].metadata!.path}')) ||
                  _albumState.selectedPDFs.any((index) => SyncData.datas.contains(
                      '${SyncData.prefixPdf}${_albumState.pdfs[index].metadata!.path}'))) {
                MyMessageDialog(
                  isCenter: true,
                  title: 'Hiện chưa thể thao tác',
                  message:
                      'Hiện tại đang tiến hành đồng bộ tự động ảnh lên hệ thống. Vui lòng thử lại sau!',
                  titleButton: 'OK',
                ).onShowDialog(context);
              } else {
                showModalBottomSheet<String>(
                  context: context,
                  barrierColor: Colors.black.withOpacity(0.5),
                  isScrollControlled: true,
                  useRootNavigator: true,
                  isDismissible: true,
                  builder: (BuildContext context) {
                    return MoveImageWidget(
                      albums: _albumState.albums,
                      albumDto: _albumState.albumDTO,
                      onMoveImages: (albumNameSelected) => providerContext
                          .read<MoveFileBloc>()
                          .add(CheckLengthImageCanMoveEvent(
                            albumNameSelected,
                            _albumState.selectedImages,
                          )),
                    );
                  },
                );
              }
            }
            if (state is CheckLengthImageCanMoveEventSuccess) {
              c.startLoading();
              providerContext.read<MoveFileBloc>().add(MoveEvent(
                    _albumState.albumDTO,
                    state.sharedAlbum,
                    _albumState.selectedImages,
                    null,
                    null,
                  ));
            }
            if (state is ConfirmLengthImageCanMove) {
              c.stopLoadingAndSync();
              MyConfirmDialog(title: state.title, message: state.message)
                  .showConfirmDialog(context)
                  .then((res) {
                if (res != null && res == ConfirmValue.confirm) {
                  c.startLoading();
                  providerContext.read<MoveFileBloc>().add(
                        MoveEvent(
                          _albumState.albumDTO,
                          state.sharedAlbum,
                          _albumState.selectedImages,
                          state.listImageMove,
                          state.lengthCanMove,
                        ),
                      );
                }
              });
            }
            if (state is MoveEventSuccess) {
              c.stopLoadingAndSync();
              loadAlbumEvent();
              Future.delayed(
                  const Duration(milliseconds: 500),
                  () => MoveImagesSuccessWidget(
                        onViewDetail: () => loadAlbumEvent(
                            otherAlbumName: state.albumNameReceived),
                        lengthImages: state.lengthMove,
                      ).onShowDialog(context));
            }
            if (state is MoveEventError) {
              c.stopLoadingAndSync();
              MyMessageDialog(
                title: state.title,
                message: state.message,
                titleButton: state.titleButton,
              ).onShowDialog(context);
            }
            if (state is CheckLengthImageCanMoveEventError) {
              MyMessageDialog(
                title: state.title,
                message: state.message,
                titleButton: state.titleButton,
              ).onShowDialog(context);
            }
          }),
        ],
        child: MasterPageWithLoading(
          childWidget: BlocBuilder<AlbumBloc, AlbumState>(
            builder: (context, state) {
              providerContext = context;
              _albumState = state;
              DateTime modifiedDate =
                  string2Datetime(state.albumDTO.metadata!.modifiedDate!);
              String time = dateTime2HhMi(modifiedDate);
              String date = dateTime2DdMmYyyy(modifiedDate);
              bool albumIsEmpty = _albumState.rootAlbumPath.isEmpty ||
                  (_albumState.images.isEmpty && _albumState.pdfs.isEmpty);
              bool hasFileNotSynced = _albumState.fileStatus ==
                      FileStatus.inUse &&
                  _albumState.albumDTO.metadata!.priorityDisplay == 1 &&
                  (_albumState.images.any((image) => !image.metadata!.isSync) ||
                      _albumState.pdfs.any((pdf) => !pdf.metadata!.isSync));
              return MasterPage(
                name: _albumState.fileStatus == FileStatus.inUse
                    ? ''
                    : 'Ảnh đã xóa',
                backgroundBarColor: Colors.white,
                barColor: Colors.black,
                backArrowTap: _albumState.fileStatus == FileStatus.inUse
                    ? null
                    : () => loadAlbumEvent(fileStatus: FileStatus.inUse),
                trailingButton: DetailAlbumTrailingButton(
                  albumDto: _albumState.albumDTO,
                  onSelectionModeTap: selectionModeEvent,
                  onDeleteAllImage: () => providerContext
                      .read<DeleteFileBloc>()
                      .add(DeleteConfirmEvent(true, _albumState.fileStatus)),
                  onImageDeletedTap: () =>
                      loadAlbumEvent(fileStatus: FileStatus.deleted),
                  fileStatus: _albumState.fileStatus,
                  selectionMode: _albumState.selectionMode,
                ),
                onCameraTap: () {
                  HideKeyBoard.hidKeyBoard();
                  c.startLoading();
                  providerContext
                      .read<CameraBloc>()
                      .add(const OnCameraTapEvent());
                },
                floatingBody: (_albumState.selectionMode &&
                        (_albumState.selectedImages.isNotEmpty ||
                            _albumState.selectedPDFs.isNotEmpty))
                    ? DetailAlbumBottomSheetBar(
                        fileStatus: _albumState.fileStatus,
                        onConvertPDFTap: () {
                          c.startLoading();
                          providerContext
                              .read<AlbumBloc>()
                              .add(const ConvertPDFEvent());
                        },
                        onUploadTap: () {
                          providerContext
                              .read<AlbumBloc>()
                              .add(const ConvertTreeValueEvent());
                        },
                        onMoveTap: () => providerContext
                            .read<MoveFileBloc>()
                            .add(const ShowMoveBottomSheetEvent()),
                        onDeleteTap: () => providerContext
                            .read<DeleteFileBloc>()
                            .add(DeleteConfirmEvent(
                                false, _albumState.fileStatus)),
                        onRestoreTap: () => providerContext
                            .read<RestoreFileBloc>()
                            .add(const RestoreConfirmEvent()),
                        lengthSelectedPDF: _albumState.selectedPDFs.length,
                        isSyncedSelectedItems: isSyncedSelectedItems(),
                      )
                    : _albumState.fileStatus == FileStatus.deleted
                        ? Container()
                        : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      MyDropDown(
                        controller: myDropDownController,
                        items: _albumState.albums
                            .map((e) => ListViewItemDto(
                                value: e.metadata!.captureName!,
                                text: e.metadata!.captureName!,
                                isSelected:
                                    e.metadata!.captureName!.toLowerCase() ==
                                        _albumState.albumName.toLowerCase()))
                            .toList(),
                        bottomSheetText: 'Chọn album',
                        callBack: (List<String> selectedItems) {
                          loadAlbumEvent(otherAlbumName: selectedItems.first);
                        },
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Image.asset('assets/icons/sync_icon.svg',
                                height: 15, width: 15),
                            const SizedBox(width: 5),
                            Text(
                              'Cập nhật lần cuối: $time - $date',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Color(0xff9aa1bc),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (hasFileNotSynced)
                        FileNotSyncedWidget(sync: () {
                          if (c.syncCompleted.value) {
                            c.startSync();
                          }
                          providerContext.read<SyncBloc>().add(AddSyncDataEvent(
                              context: providerContext,
                              showAlert: true,
                              albumPath: _albumState.albumDTO.metadata!.path));
                        }),
                      const SizedBox(height: 15),
                      if (albumIsEmpty)
                        Expanded(
                          child: DetailAlbumEmptyWidget(
                              imageStatus: _albumState.fileStatus),
                        ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(
                              bottom: _albumState.selectionMode ? 60 : 35),
                          child: Column(
                            children: [
                              if (_albumState.pdfs.isNotEmpty)
                                Column(
                                  children: [
                                    const SizedBox(height: 15),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Tệp PDF',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF4F5B89),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DetailAlbumGridViewPDFWidget(
                                      priorityDisplay: _albumState
                                          .albumDTO.metadata!.priorityDisplay!,
                                      pdfs: _albumState.pdfs,
                                      onPDFItemTap: onPDFTap,
                                      onPDFItemLongPress: onPDFLongPress,
                                      selectionMode: _albumState.selectionMode,
                                      selectedPDFs: _albumState.selectedPDFs,
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              if (_albumState.images.isNotEmpty)
                                Column(
                                  children: [
                                    const SizedBox(height: 15),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Hình ảnh',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF4F5B89),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DetailAlbumGridViewImageWidget(
                                      priorityDisplay: _albumState
                                          .albumDTO.metadata!.priorityDisplay!,
                                      images: _albumState.images,
                                      path: _albumState.rootAlbumPath,
                                      onImageItemTap: onImageTap,
                                      onImageItemLongPress: onImageLongPress,
                                      selectionMode: _albumState.selectionMode,
                                      selectedImages:
                                          _albumState.selectedImages,
                                      selectedPDFs: _albumState.selectedPDFs,
                                    ),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void loadAlbumEvent(
      {String? otherAlbumName, FileStatus? fileStatus, bool autoSync = false}) {
    providerContext.read<AlbumBloc>().add(LoadAlbumEvent(
          albumName: otherAlbumName ?? _albumState.albumName,
          fileStatus: fileStatus ?? _albumState.fileStatus,
          autoSync: autoSync,
        ));
  }

  void selectionModeEvent({bool? mode}) {
    providerContext.read<AlbumBloc>().add(SelectionModeEvent(
          selectionMode: mode ?? _albumState.selectionMode,
        ));
  }

  void onImageTap(int index) {
    if (_albumState.selectionMode) {
      providerContext.read<AlbumBloc>().add(ItemTapEvent(
            index: index,
            selectedIndex: _albumState.selectedImages,
            isImage: true,
          ));
    } else {
      Navigator.of(context)
          .pushNamed('/detail-image',
              arguments: DetailImageDto(
                albumDto: _albumState.albumDTO,
                albumName: _albumState.albumName,
                imageDTO: _albumState.images[index],
                rootAlbumPath: _albumState.rootAlbumPath,
              ))
          .then((value) {
        String? otherAlbumName;
        if (value is String) {
          otherAlbumName = value;
        }
        loadAlbumEvent(otherAlbumName: otherAlbumName);
      });
    }
  }

  void onImageLongPress(int index) {
    selectionModeEvent();
    providerContext.read<AlbumBloc>().add(ItemTapEvent(
          index: index,
          selectedIndex: _albumState.selectedImages,
          isImage: true,
        ));
  }

  Future<void> onPDFTap(int index) async {
    if (_albumState.selectionMode) {
      providerContext.read<AlbumBloc>().add(ItemTapEvent(
            index: index,
            selectedIndex: _albumState.selectedPDFs,
            isImage: false,
          ));
    } else {
      Navigator.of(context)
          .pushNamed('/view-file-pdf',
              arguments: ViewPdfPageDto(
                albumDto: _albumState.albumDTO,
                pdf: _albumState.pdfs[index],
                indexPdf: index,
              ))
          .then((value) {
        if (value != null) {
          if (value as bool) {
            loadAlbumEvent();
          }
        }
      });
    }
  }

  void onPDFLongPress(int index) {
    selectionModeEvent();
    providerContext.read<AlbumBloc>().add(ItemTapEvent(
          index: index,
          selectedIndex: _albumState.selectedPDFs,
          isImage: false,
        ));
  }

  bool isSyncedSelectedItems() {
    if (_albumState.fileStatus == FileStatus.inUse) {
      List<CaptureBatchImageDto> imageInUse =
          _albumState.fileStatus.filter(_albumState.albumDTO.metadata!.images!);
      List<CaptureBatchImageDto> selectedImage =
          _albumState.selectedImages.map((idx) => imageInUse[idx]).toList();

      List<CaptureBatchPdfDto> pdfInUse = _albumState.fileStatus
          .filterPDF(_albumState.albumDTO.metadata!.pdfs!);
      List<CaptureBatchPdfDto> selectedPdf =
          _albumState.selectedPDFs.map((idx) => pdfInUse[idx]).toList();
      return selectedPdf.every((pdf) => pdf.metadata!.isSync) &&
          selectedImage.every((image) => image.metadata!.isSync);
    }
    return false;
  }
}
