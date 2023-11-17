import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mpcore/mpcore.dart';
import 'package:smart_capture_mobile/base_widgets/my_button.dart';
import 'package:smart_capture_mobile/base_widgets/my_confirm_dialog.dart';
import 'package:smart_capture_mobile/base_widgets/my_message_dialog.dart';
import 'package:smart_capture_mobile/base_widgets/my_split_auto_width_button.dart';
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
import 'package:smart_capture_mobile/dtos/widget_dto/detail_image_dto.dart';
import 'package:smart_capture_mobile/enum/confirm_value_enum.dart';
import 'package:smart_capture_mobile/enum/file_status_enum.dart';
import 'package:smart_capture_mobile/pages/detail_image_page/bloc/detail_image_bloc.dart';
import 'package:smart_capture_mobile/pages/detail_image_page/bloc/detail_image_event.dart';
import 'package:smart_capture_mobile/pages/detail_image_page/bloc/detail_image_state.dart';
import 'package:smart_capture_mobile/pages/detail_image_page/widgets/detail_image_info_widget.dart';
import 'package:smart_capture_mobile/pages/master_page_with_loading.dart';
import 'package:smart_capture_mobile/pages/widgets/move_image_widget.dart';
import 'package:smart_capture_mobile/pages/widgets/move_success_widget.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';
import 'package:smart_capture_mobile/utils/mixin/top_snack_bar_util.dart';

class DetailImagePage extends StatefulWidget {
  final DetailImageDto detailImageDto;

  const DetailImagePage({
    Key? key,
    required this.detailImageDto,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DetailImagePageState();
}

class _DetailImagePageState extends State<DetailImagePage>
    with DatetimeUtil, TopSnackBarUtil {
  final LoadStatusController c = Get.put(LoadStatusController());
  late BuildContext _providerContext;
  late DetailImageState _detailImageState;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider<DetailImageBloc>(
            create: (context) => DetailImageBloc(DetailImageState(
                  rootAlbumPath: widget.detailImageDto.rootAlbumPath,
                  albumDTO: widget.detailImageDto.albumDto,
                  imageDTO: widget.detailImageDto.imageDTO,
                  albumName: widget.detailImageDto.albumName,
                ))),
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
          BlocListener<DetailImageBloc, DetailImageState>(
            listener: (context, state) {
              if (state is LoadImageEventSuccess) {
                c.stopLoadingAndSync();
              }
              if (state is EditImageEventComplete) {
                if (state.isSuccess) {
                  _providerContext
                      .read<DetailImageBloc>()
                      .add(const AfterEditImageEvent());
                } else {
                  c.stopLoadingAndSync();
                }
              }
              if (state is AfterEditImageEventComplete) {
                c.stopLoadingAndSync();
              }
            },
          ),
          BlocListener<SyncBloc, SyncState>(
            listener: (context, state) {
              if (state is SyncAlbumEventCompleted) {
                if (state.showAlert) {
                  if (state.isSuccess) {
                    showSuccess(state.alert);
                  } else {
                    showError(state.alert);
                  }
                }
                c.updateSyncCompleted(true);
                _providerContext.read<DetailImageBloc>().add(LoadImageEvent(
                      imageName: _detailImageState.imageDTO.metadata!.name,
                    ));
              }
            },
          ),
          BlocListener<DeleteFileBloc, DeleteFileState>(
              listener: (context, state) {
            if (state is DeleteConfirmEventSuccess) {
              if (SyncData.datas.contains(
                  '${SyncData.prefixImage}${_detailImageState.imageDTO.metadata!.path}')) {
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
                    _providerContext.read<DeleteFileBloc>().add(DeleteEvent(
                          state.isDeleteAll,
                          _detailImageState.albumDTO,
                          _detailImageState.imageDTO.metadata!.status,
                          [
                            _detailImageState.imageDTO.metadata!.status
                                .filter(_detailImageState
                                    .albumDTO.metadata!.images!)
                                .indexWhere((image) =>
                                    image.metadata!.name ==
                                    _detailImageState.imageDTO.metadata!.name)
                          ],
                          const [],
                        ));
                  }
                });
              }
            }
            if (state is DeleteEventSuccess) {
              showSuccess(state.title);
              Navigator.pop(context);
            }
            if (state is DeleteEventError) {
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
                  _providerContext.read<RestoreFileBloc>().add(RestoreEvent(
                        _detailImageState.albumDTO,
                        [
                          _detailImageState.imageDTO.metadata!.status
                              .filter(
                                  _detailImageState.albumDTO.metadata!.images!)
                              .indexWhere((image) =>
                                  image.metadata!.name ==
                                  _detailImageState.imageDTO.metadata!.name)
                        ],
                        const [],
                      ));
                }
              });
            }
            if (state is RestoreEventSuccess) {
              showSuccess(state.title);
              Navigator.pop(context);
            }
          }),
          BlocListener<MoveFileBloc, MoveFileState>(listener: (context, state) {
            if (state is ShowMoveBottomSheetEventSuccess) {
              if (SyncData.datas.contains(
                  '${SyncData.prefixImage}${_detailImageState.imageDTO.metadata!.path}')) {
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
                      albums: state.albums,
                      albumDto: _detailImageState.albumDTO,
                      onMoveImages: (albumNameSelected) => _providerContext
                          .read<MoveFileBloc>()
                          .add(CheckLengthImageCanMoveEvent(
                            albumNameSelected,
                            [
                              _detailImageState.imageDTO.metadata!.status
                                  .filter(_detailImageState
                                      .albumDTO.metadata!.images!)
                                  .indexWhere((image) =>
                                      image.metadata!.name ==
                                      _detailImageState.imageDTO.metadata!.name)
                            ],
                          )),
                    );
                  },
                );
              }
            }
            if (state is CheckLengthImageCanMoveEventSuccess) {
              c.startLoading();
              _providerContext.read<MoveFileBloc>().add(MoveEvent(
                  _detailImageState.albumDTO,
                  state.sharedAlbum,
                  [
                    _detailImageState.imageDTO.metadata!.status
                        .filter(_detailImageState.albumDTO.metadata!.images!)
                        .indexWhere((image) =>
                            image.metadata!.name ==
                            _detailImageState.imageDTO.metadata!.name)
                  ],
                  null,
                  null));
            }
            if (state is MoveEventSuccess) {
              c.stopLoadingAndSync();
              _providerContext.read<DetailImageBloc>().add(AfterMovedEvent(
                    image: state.image,
                    albumNameReceived: state.albumNameReceived,
                  ));
              Future.delayed(
                  const Duration(milliseconds: 100),
                  () => MoveImagesSuccessWidget(
                        onViewDetail: () =>
                            Navigator.pop(context, state.albumNameReceived),
                        lengthImages: state.lengthMove,
                      ).onShowDialog(context));
            }
            if (state is CheckLengthImageCanMoveEventError) {
              MyMessageDialog(
                title: state.title,
                message: state.message,
                titleButton: state.titleButton,
              ).onShowDialog(context);
            }
            if (state is MoveEventError) {
              c.stopLoadingAndSync();
              MyMessageDialog(
                title: state.title,
                message: state.message,
                titleButton: state.titleButton,
              ).onShowDialog(context);
            }
          }),
        ],
        child: MasterPageWithLoading(
          childWidget: BlocBuilder<DetailImageBloc, DetailImageState>(
            builder: (context, state) {
              _providerContext = context;
              _detailImageState = state;
              DateTime modifiedDate =
                  string2Datetime(state.imageDTO.metadata!.modifiedDate);
              String time = dateTime2HhMi(modifiedDate);
              String date = dateTime2DdMmYyyy(modifiedDate);
              return MPScaffold(
                appBar: AppBar(
                  leading: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  title: Column(
                    children: [
                      Row(
                        children: [
                          if (state.albumDTO.metadata!.priorityDisplay == 1)
                            if (state.imageDTO.metadata!.isSync)
                              Image.asset(
                                'assets/icons/checkcirle_icon.svg',
                                height: 15,
                                fit: BoxFit.fitHeight,
                              )
                            else
                              Image.asset(
                                'assets/icons/sync_icon.svg',
                                height: 15,
                                fit: BoxFit.fitHeight,
                              ),
                          if (state.albumDTO.metadata!.priorityDisplay == 1)
                            const SizedBox(width: 5),
                          const Text(
                            'Ảnh ',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          Expanded(
                            child: Text(
                              state.imageDTO.metadata!.name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            '$date - $time',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  backgroundColor: Colors.black,
                  actions: [
                    if (state.imageDTO.metadata!.status == FileStatus.inUse)
                      MyButton(
                        margin: const EdgeInsets.only(right: 10),
                        text: 'Chỉnh sửa',
                        color: const Color(0xFF4A6EF6),
                        backgroundColor: Colors.transparent,
                        width: 90,
                        fontSize: 16,
                        isDisable: c.isLoading.value,
                        onTap: () async {
                          if (SyncData.datas.contains(
                              '${SyncData.prefixImage}${_detailImageState.imageDTO.metadata!.path}')) {
                            await MyMessageDialog(
                              isCenter: true,
                              title: 'Hiện chưa thể thao tác',
                              message:
                                  'Hiện tại đang tiến hành đồng bộ tự động ảnh lên hệ thống. Vui lòng thử lại sau!',
                              titleButton: 'OK',
                            ).onShowDialog(context);
                          } else {
                            c.startLoading();
                            _providerContext.read<DetailImageBloc>().add(
                                  EditImageEvent(
                                    context: context,
                                    contentTime: '$date $time',
                                  ),
                                );
                          }
                        },
                      ),
                  ],
                ),
                backgroundColor: Colors.black,
                name: '',
                body: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 75,
                      child: Image.memoryV2(
                        key: UniqueKey(),
                        gaplessPlayback: true,
                        '${state.rootAlbumPath}${state.imageDTO.metadata!.path}',
                      ),
                    ),
                    if (!state.imageDTO.metadata!.isSync &&
                        state.albumDTO.metadata!.priorityDisplay == 1 &&
                        state.imageDTO.metadata!.status == FileStatus.inUse)
                      Positioned(
                        bottom: 100,
                        child: Container(
                          height: 72,
                          width: size.width * 0.95,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(6.0),
                            color: Colors.white.withOpacity(0.4),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 15),
                              GestureDetector(
                                child:
                                    Image.asset('assets/icons/load_icon.svg'),
                                onTap: () async {
                                  if (c.syncCompleted.value) {
                                    c.startSync();
                                  }
                                  _providerContext
                                      .read<SyncBloc>()
                                      .add(AddSyncDataEvent(
                                        context: _providerContext,
                                        imagePath:
                                            state.imageDTO.metadata!.path,
                                      ));
                                },
                              ),
                              const SizedBox(width: 15),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Ảnh chưa được chia sẻ với hệ thống',
                                    style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Vui lòng kiểm tra lại kết nối Internet và thử lại!',
                                    style: TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        color: Colors.black,
                        child: state.imageDTO.metadata!.status ==
                                FileStatus.inUse
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MySplitAutoWidthButton(
                                    icon: 'assets/icons/folder_minus_icon.svg',
                                    text: '',
                                    color: Colors.transparent,
                                    onTap: () => _providerContext
                                        .read<MoveFileBloc>()
                                        .add(const ShowMoveBottomSheetEvent()),
                                  ),
                                  MySplitAutoWidthButton(
                                      icon: 'assets/icons/info_circle_icon.svg',
                                      text: '',
                                      color: Colors.transparent,
                                      onTap: () async {
                                        await showModalBottomSheet<String>(
                                          context: context,
                                          barrierColor:
                                              Colors.black.withOpacity(0.5),
                                          isScrollControlled: true,
                                          useRootNavigator: true,
                                          builder: (BuildContext context) {
                                            return DetailImageInfoWidget(
                                              dateTime: state.imageDTO.metadata!
                                                  .createdDate,
                                              address: state
                                                      .imageDTO
                                                      .metadata!
                                                      .coordinatesInfo
                                                      ?.address ??
                                                  '',
                                              isSync: state
                                                  .imageDTO.metadata!.isSync,
                                            );
                                          },
                                        );
                                      }),
                                  MySplitAutoWidthButton(
                                    icon: 'assets/icons/delete_image_icon.svg',
                                    text: '',
                                    color: Colors.transparent,
                                    onTap: () => _providerContext
                                        .read<DeleteFileBloc>()
                                        .add(DeleteConfirmEvent(false,
                                            state.imageDTO.metadata!.status)),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  MySplitAutoWidthButton(
                                      icon: 'assets/icons/refresh.svg',
                                      text: 'Khôi phục',
                                      color: Colors.transparent,
                                      textColor: Colors.white,
                                      onTap: () => _providerContext
                                          .read<RestoreFileBloc>()
                                          .add(const RestoreConfirmEvent())),
                                  MySplitAutoWidthButton(
                                    icon: 'assets/icons/delete_image_icon.svg',
                                    text: 'Xóa vĩnh viễn',
                                    color: Colors.transparent,
                                    textColor: Colors.white,
                                    onTap: () => _providerContext
                                        .read<DeleteFileBloc>()
                                        .add(const DeleteConfirmEvent(
                                            false, FileStatus.deleted)),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
                floatingActionButton: Container(),
              );
            },
          ),
        ),
      ),
    );
  }
}
