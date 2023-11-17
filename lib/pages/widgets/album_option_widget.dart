import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mpcore/mpcore.dart';
import 'package:mpcore/mpkit/divider.dart';
import 'package:smart_capture_mobile/base_widgets/my_button.dart';
import 'package:smart_capture_mobile/base_widgets/my_confirm_dialog.dart';
import 'package:smart_capture_mobile/blocs/delete_album_bloc/delete_album_bloc.dart';
import 'package:smart_capture_mobile/blocs/delete_album_bloc/delete_album_event.dart';
import 'package:smart_capture_mobile/blocs/delete_album_bloc/delete_album_state.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/enum/album_option_pop_enum.dart';
import 'package:smart_capture_mobile/enum/confirm_value_enum.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';
import 'package:smart_capture_mobile/utils/mixin/number_util.dart';
import 'package:smart_capture_mobile/utils/mixin/top_snack_bar_util.dart';

class AlbumOptionWidget with TopSnackBarUtil, DatetimeUtil, NumberUtil {
  final BuildContext context;
  final bool isDefaultAlbum;
  final bool isDetailAlbum;
  final Function()? onImageDeletedTap;

  AlbumOptionWidget({
    required this.context,
    required this.isDefaultAlbum,
    required this.isDetailAlbum,
    this.onImageDeletedTap,
  });

  Future<AlbumOptionPopEnum?> onMoreTap(CaptureBatchDto albumDto) async {
    late BuildContext providerContext;
    Size size = MediaQuery.of(context).size;
    return await showDialog(
      dialogPosition: const Alignment(0, 0.9),
      barrierColor: Colors.black.withOpacity(0.3),
      context: context,
      builder: (_) {
        return BlocProvider<DeleteAlbumBloc>(
          create: (context) => DeleteAlbumBloc(const DeleteAlbumState()),
          child: BlocListener<DeleteAlbumBloc, DeleteAlbumState>(
            listener: (context, state) async {
              if (state is DeleteAlbumEventSuccess) {
                Navigator.of(_).pop(AlbumOptionPopEnum.deleteAlbum);
              }
            },
            child: BlocBuilder<DeleteAlbumBloc, DeleteAlbumState>(
              builder: (context, state) {
                providerContext = context;
                return SizedBox(
                  width: size.width - 30,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // if (!isDefaultAlbum)
                      //   Padding(
                      //     padding: EdgeInsets.only(left: 40),
                      //     child: MyButton(
                      //       text: 'Chia sẻ album',
                      //       color: Colors.black,
                      //       backgroundColor: Colors.white,
                      //       image: 'assets/icons/share_icon.svg',
                      //       height: 65,
                      //       width: double.infinity,
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       padding: EdgeInsets.only(left: 15),
                      //       //margin: EdgeInsets.fromLTRB(20, 5, 10, 5),
                      //     ),
                      //   ),
                      // if (!isDefaultAlbum)
                      //   Divider(
                      //     color: Color(0xffE6E8EE),
                      //   ),
                      if (isDetailAlbum)
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: MyButton(
                            text: 'Ảnh đã xóa',
                            color: Colors.black,
                            backgroundColor: Colors.white,
                            image: 'assets/icons/folder_cross_icon.svg',
                            height: 65,
                            width: double.infinity,
                            mainAxisAlignment: MainAxisAlignment.start,
                            padding: const EdgeInsets.only(left: 15),
                            onTap: () {
                              if (onImageDeletedTap != null) {
                                onImageDeletedTap!();
                              }
                              Navigator.of(_)
                                  .pop(AlbumOptionPopEnum.deleteImage);
                            },
                          ),
                        ),
                      if (isDetailAlbum && !isDefaultAlbum)
                        const Divider(
                          color: Color(0xffE6E8EE),
                        ),
                      if (!isDefaultAlbum)
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: MyButton(
                            text: 'Xóa album',
                            color: Colors.black,
                            backgroundColor: Colors.white,
                            image: 'assets/icons/delete_album_icon.svg',
                            height: 65,
                            width: double.infinity,
                            mainAxisAlignment: MainAxisAlignment.start,
                            padding: const EdgeInsets.only(left: 15),
                            onTap: () {
                              MyConfirmDialog(
                                title: 'Xóa album ảnh',
                                message:
                                    'Thao tác này sẽ không thể khôi phục lại.\nBạn có chắc chắn muốn xóa album ảnh này?',
                              ).showConfirmDialog(context).then((res) {
                                if (res != null &&
                                    res == ConfirmValue.confirm) {
                                  providerContext
                                      .read<DeleteAlbumBloc>()
                                      .add(DeleteAlbumEvent(albumDto));
                                }
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
