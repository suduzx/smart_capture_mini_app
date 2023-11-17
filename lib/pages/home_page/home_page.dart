import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mpcore/mpcore.dart';
import 'package:smart_capture_mobile/base_widgets/my_message_dialog.dart';
import 'package:smart_capture_mobile/base_widgets/my_text_field.dart';
import 'package:smart_capture_mobile/blocs/camera_util_bloc/camera_bloc.dart';
import 'package:smart_capture_mobile/blocs/camera_util_bloc/camera_event.dart';
import 'package:smart_capture_mobile/blocs/camera_util_bloc/camera_state.dart';
import 'package:smart_capture_mobile/blocs/sync_bloc/sync_bloc.dart';
import 'package:smart_capture_mobile/blocs/sync_bloc/sync_event.dart';
import 'package:smart_capture_mobile/blocs/sync_bloc/sync_state.dart';
import 'package:smart_capture_mobile/controllers/load_status_controller.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/widget_dto/detail_album_dto.dart';
import 'package:smart_capture_mobile/enum/album_option_pop_enum.dart';
import 'package:smart_capture_mobile/enum/album_type_enum.dart';
import 'package:smart_capture_mobile/flavor.dart';
import 'package:smart_capture_mobile/pages/home_page/bloc/home_bloc.dart';
import 'package:smart_capture_mobile/pages/home_page/bloc/home_event.dart';
import 'package:smart_capture_mobile/pages/home_page/bloc/home_state.dart';
import 'package:smart_capture_mobile/pages/home_page/widgets/home_page_grid_view_item.dart';
import 'package:smart_capture_mobile/pages/master_page.dart';
import 'package:smart_capture_mobile/pages/master_page_with_loading.dart';
import 'package:smart_capture_mobile/pages/widgets/album_option_widget.dart';
import 'package:smart_capture_mobile/utils/app_overlay.dart';
import 'package:smart_capture_mobile/utils/mixin/top_snack_bar_util.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin, TopSnackBarUtil {
  late TabController _tabController;
  TextEditingController filterController = TextEditingController();
  final LoadStatusController c = Get.put(LoadStatusController());
  late BuildContext providerContext;
  late HomeState homeState;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    filterController.addListener(() {
      providerContext
          .read<HomeBloc>()
          .add(OnLoadAlbumEvent(filterController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      c.stopLoadingAndSync();
    });
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(const HomeState(
            rootAlbumPath: '',
            albums: [],
            filteredAlbum: [],
          ))
            ..add(const AfterInitEvent()),
        ),
        BlocProvider<CameraBloc>(
            create: (context) => CameraBloc(const CameraState()))
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is AfterInitEventSuccess) {
                c.startLoading();
                context
                    .read<HomeBloc>()
                    .add(OnLoadAlbumEvent(filterController.text));
              }
              if (state is OnLoadAlbumEventSuccess) {
                c.stopLoadingAndSync();
              }
              if (state is CreateAlbumEventSuccess) {
                Navigator.of(context)
                    .pushNamed('/create-new-album',
                        arguments: state.limitAlbumParam)
                    .then((value) {
                  if (value != null) {
                    AlbumOptionPopEnum success = value as AlbumOptionPopEnum;
                    if (success == AlbumOptionPopEnum.deleteAlbum) {
                      showSuccess('Xóa album thành công');
                    }
                  }
                  providerContext
                      .read<HomeBloc>()
                      .add(OnLoadAlbumEvent(filterController.text));
                });
              }
              if (state is CreateAlbumEventError) {
                MyMessageDialog(
                  title: state.title,
                  message: state.message,
                  titleButton: state.titleButton,
                ).onShowDialog(context);
              }
              if (state is AlbumItemTapEventSuccess) {
                Navigator.of(context)
                    .pushNamed('/detail-album',
                        arguments: DetailAlbumDto(
                          albumDto: state.albumDto,
                          albumName: state.albumDto.metadata!.captureName!,
                        ))
                    .then((value) {
                  if (value != null) {
                    AlbumOptionPopEnum success = value as AlbumOptionPopEnum;
                    if (success == AlbumOptionPopEnum.deleteAlbum) {
                      showSuccess('Xóa album thành công');
                    }
                  }
                  providerContext
                      .read<HomeBloc>()
                      .add(OnLoadAlbumEvent(filterController.text));
                });
              }
              if (state is AlbumMoreOptionTapEventSuccess) {
                AlbumOptionWidget(
                  context: context,
                  isDefaultAlbum: state.albumDto.metadata!.priorityDisplay == 0,
                  isDetailAlbum: false,
                ).onMoreTap(state.albumDto).then((success) {
                  if (success == AlbumOptionPopEnum.deleteAlbum) {
                    showSuccess('Xóa album thành công');
                    providerContext
                        .read<HomeBloc>()
                        .add(OnLoadAlbumEvent(filterController.text));
                  }
                });
              }
            },
          ),
          BlocListener<CameraBloc, CameraState>(listener: (context, state) {
            /// Xử lý logic khi state là success
            if (state is OnCameraTapEventSuccess) {
              providerContext.read<CameraBloc>().add(TakePhotoEvent(
                    homeState.albums[0],
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
              providerContext
                  .read<HomeBloc>()
                  .add(OnLoadAlbumEvent(filterController.text));
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
              ).onShowDialog(context).then((value) {
                if (state is TakePhotoEventError) {
                  if (state.exceeding) {
                    Navigator.of(context).pushNamed('/detail-album',
                        arguments: DetailAlbumDto(
                          albumDto: homeState.albums[0],
                          albumName: homeState.albums[0].metadata!.captureName!,
                        ));
                  }
                }
              });
            }
          }),
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
                providerContext
                    .read<HomeBloc>()
                    .add(OnLoadAlbumEvent(filterController.text));
              }
            },
          ),
        ],
        child: MasterPageWithLoading(
          childWidget: MasterPage(
            name: 'Smart Capture Mobile',
            isShowBackArrow: F.appFlavor == Flavor.dev ||
                F.appFlavor == Flavor.devMB ||
                F.appFlavor == Flavor.live,
            backgroundColor: Colors.white,
            backgroundBarColor: Colors.transparent,
            isBackGroundHomePage: true,
            trailingButton: Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (c.syncCompleted.value) {
                      c.startSync();
                    }
                    providerContext
                        .read<SyncBloc>()
                        .add(AddSyncDataEvent(context: providerContext));
                  },
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Image.asset(
                      'assets/icons/cloud_icon.svg',
                      width: 25,
                      height: 25,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => providerContext
                      .read<HomeBloc>()
                      .add(const CreateAlbumEvent()),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                    child: Image.asset(
                      'assets/icons/folder_add_icon.svg',
                      width: 25,
                      height: 25,
                    ),
                  ),
                )
              ],
            ),
            onCameraTap: () {
              HideKeyBoard.hidKeyBoard();
              c.startLoading();
              providerContext.read<CameraBloc>().add(const OnCameraTapEvent());
            },
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF73ABFF),
                        Color(0xFF373FE7),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          MyTextField(
                            startIcon: 'assets/icons/search_icon.svg',
                            controller: filterController,
                            placeholder: 'Tìm theo tên album',
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          const SizedBox(height: 20),
                          // Container(
                          //   height: 48,
                          //   padding: EdgeInsets.zero,
                          //   margin: EdgeInsets.symmetric(
                          //       horizontal: 20, vertical: 15),
                          //   decoration: BoxDecoration(
                          //     color: Colors.white.withOpacity(0.1),
                          //     borderRadius: BorderRadius.circular(90),
                          //   ),
                          //   child: TabBar(
                          //     tabController: _tabController,
                          //     indicatorPadding: const EdgeInsets.all(2),
                          //     indicator: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(90),
                          //         color: Colors.white),
                          //     labelStyle: TextStyle(
                          //       fontSize: 16,
                          //       height: 16 / 14,
                          //     ),
                          //     unselectedLabelStyle: TextStyle(
                          //       fontSize: 16,
                          //       height: 16 / 14,
                          //       color: Color(0xFF1F1F1F),
                          //     ),
                          //     unselectedLabelColor:
                          //         Colors.white.withOpacity(0.7),
                          //     labelColor: Color(0xFF4A6EF6),
                          //     tabs: [
                          //       Tab(text: 'Album của tôi'),
                          //       Tab(text: 'Chia sẻ với tôi'),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            AppOverlay().showSuccessAlert(title: "success", content: "okoke");
                          },
                          child: Container(
                            width: 200,
                            height: 100,
                            color: Colors.purple,
                            child: Text("Click Hre"),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: BlocBuilder<HomeBloc, HomeState>(
                            buildWhen: (previous, current) =>
                                previous.filteredAlbum != current.filteredAlbum,
                            builder: (context, state) {
                              providerContext = context;
                              homeState = state;
                              return TabBarView(
                                tabController: _tabController,
                                children: [
                                  HomePageGridViewItemWidget(
                                    rootAlbumPath: state.rootAlbumPath,
                                    albums: AlbumType.myAlbum
                                        .filter(state.filteredAlbum),
                                    onTap: (CaptureBatchDto album) =>
                                        providerContext
                                            .read<HomeBloc>()
                                            .add(AlbumItemTapEvent(album)),
                                    onMoreOptionTap: (CaptureBatchDto
                                            albumDTO) =>
                                        providerContext.read<HomeBloc>().add(
                                            AlbumMoreOptionTapEvent(albumDTO)),
                                    albumType: AlbumType.myAlbum,
                                  ),
                                  // HomePageGridViewItemWidget(
                                  //   rootAlbumPath: state.rootAlbumPath,
                                  //   albums: AlbumType.SHARE_WITH_ME_ALBUM
                                  //       .filter(state.filteredAlbum),
                                  //   onTap: (CaptureBatchDto album) =>
                                  //       providerContext
                                  //           .read<HomeBloc>()
                                  //           .add(AlbumItemTapEvent(album)),
                                  //   onMoreOptionTap: (CaptureBatchDto
                                  //           albumDTO) =>
                                  //       providerContext.read<HomeBloc>().add(
                                  //           AlbumMoreOptionTapEvent(albumDTO)),
                                  //   albumType: AlbumType.SHARE_WITH_ME_ALBUM,
                                  // ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
