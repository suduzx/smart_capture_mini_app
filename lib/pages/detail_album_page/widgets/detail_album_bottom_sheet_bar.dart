import 'package:smart_capture_mobile/base_widgets/my_split_auto_width_button.dart';
import 'package:smart_capture_mobile/enum/file_status_enum.dart';
import 'package:flutter/widgets.dart';

class DetailAlbumBottomSheetBar extends StatelessWidget {
  final int lengthSelectedPDF;
  final bool isSyncedSelectedItems;
  final FileStatus fileStatus;
  final Function()? onConvertPDFTap;
  final Function()? onUploadTap;
  final Function()? onMoveTap;
  final Function()? onDeleteTap;
  final Function()? onRestoreTap;

  const DetailAlbumBottomSheetBar({
    Key? key,
    required this.fileStatus,
    this.onConvertPDFTap,
    this.onMoveTap,
    this.onDeleteTap,
    this.onUploadTap,
    required this.lengthSelectedPDF,
    required this.isSyncedSelectedItems,
    this.onRestoreTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (fileStatus == FileStatus.inUse) {
      return Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black12))),
        child: Row(
          children: [
            if (lengthSelectedPDF == 0 && isSyncedSelectedItems)
              MySplitAutoWidthButton(
                icon: 'assets/icons/convertPDF.svg',
                text: 'Xuất tệp PDF',
                textColor: const Color(0xFF4F5B89),
                onTap: onConvertPDFTap,
              ),
            if (isSyncedSelectedItems)
              MySplitAutoWidthButton(
                icon: 'assets/icons/upload_file_icon.svg',
                text: 'Upload',
                textColor: const Color(0xFF4F5B89),
                onTap: onUploadTap,
              ),
            if (lengthSelectedPDF == 0)
              MySplitAutoWidthButton(
                icon: 'assets/icons/folder_minus.svg',
                text: 'Di chuyển',
                textColor: const Color(0xFF4F5B89),
                onTap: onMoveTap,
              ),
            MySplitAutoWidthButton(
              icon: 'assets/icons/trash.svg',
              text: 'Xóa',
              textColor: const Color(0xFF4F5B89),
              onTap: onDeleteTap,
            ),
          ],
        ),
      );
    } else {
      return Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black12))),
        child: Row(
          children: [
            MySplitAutoWidthButton(
              icon: 'assets/icons/refresh-outline.svg',
              text: 'Khôi phục',
              textColor: const Color(0xFF4F5B89),
              onTap: onRestoreTap,
            ),
            MySplitAutoWidthButton(
              icon: 'assets/icons/trash.svg',
              text: 'Xóa',
              textColor: const Color(0xFF4F5B89),
              onTap: onDeleteTap,
            ),
          ],
        ),
      );
    }
  }
}
