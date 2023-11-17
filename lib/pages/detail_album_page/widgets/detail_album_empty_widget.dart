import 'package:smart_capture_mobile/enum/file_status_enum.dart';
import 'package:flutter/widgets.dart';

class DetailAlbumEmptyWidget extends StatelessWidget {
  final FileStatus imageStatus;

  const DetailAlbumEmptyWidget({
    Key? key,
    this.imageStatus = FileStatus.inUse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Image.asset(
          'assets/icons/not_image_icon.svg',
          height: 100,
          width: 100,
        ),
        const SizedBox(height: 5),
        Text(
          imageStatus == FileStatus.inUse
              ? 'Album chưa có ảnh'
              : 'Không có ảnh đã xóa',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
