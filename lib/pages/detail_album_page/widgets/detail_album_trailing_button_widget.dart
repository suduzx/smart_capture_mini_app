import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';
import 'package:smart_capture_mobile/base_widgets/my_button.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/enum/album_option_pop_enum.dart';
import 'package:smart_capture_mobile/enum/file_status_enum.dart';
import 'package:smart_capture_mobile/pages/widgets/album_option_widget.dart';

class DetailAlbumTrailingButton extends StatelessWidget {
  final CaptureBatchDto albumDto;
  final Function() onSelectionModeTap;
  final Function() onDeleteAllImage;
  final Function() onImageDeletedTap;
  final FileStatus fileStatus;
  final bool selectionMode;

  const DetailAlbumTrailingButton({
    Key? key,
    required this.albumDto,
    required this.onSelectionModeTap,
    required this.onDeleteAllImage,
    required this.onImageDeletedTap,
    required this.fileStatus,
    this.selectionMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool notNull = fileStatus.filter(albumDto.metadata!.images!).isNotEmpty ||
        fileStatus.filterPDF(albumDto.metadata!.pdfs!).isNotEmpty;
    return Row(
      children: [
        if (selectionMode && notNull)
          MyButton(
            text: 'Hủy',
            color: const Color(0xFF4A6EF6),
            backgroundColor: Colors.transparent,
            onTap: onSelectionModeTap,
            fontSize: 16,
            height: 59,
          ),
        if (!selectionMode && notNull)
          MyButton(
            text: 'Chọn',
            color: const Color(0xFF4A6EF6),
            backgroundColor: Colors.transparent,
            onTap: onSelectionModeTap,
            fontSize: 16,
            height: 59,
            width: 50,
          ),
        if (fileStatus == FileStatus.deleted && notNull)
          MyButton(
            margin: const EdgeInsets.only(right: 10),
            text: 'Xóa tất cả',
            color: Colors.red,
            fontSize: 16,
            backgroundColor: Colors.transparent,
            onTap: () => onDeleteAllImage(),
            height: 59,
            width: 100,
            isDisable: selectionMode,
          ),
        if (fileStatus == FileStatus.inUse)
          MyButton(
            text: '',
            color: const Color(0xFF9AA1BC),
            backgroundColor: Colors.transparent,
            icon: Icons.more_vert,
            onTap: () {
              AlbumOptionWidget(
                context: context,
                isDefaultAlbum: albumDto.metadata!.priorityDisplay == 0,
                isDetailAlbum: true,
                onImageDeletedTap: onImageDeletedTap,
              ).onMoreTap(albumDto).then((success) {
                if (success == AlbumOptionPopEnum.deleteAlbum) {
                  Navigator.of(context).pop(success);
                }
              });
            },
            height: 59,
          ),
      ],
    );
  }
}
