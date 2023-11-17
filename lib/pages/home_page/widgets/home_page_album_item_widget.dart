import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';
import 'package:smart_capture_mobile/base_widgets/my_button.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/enum/album_type_enum.dart';
import 'package:smart_capture_mobile/utils/file_utils.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';

class HomePageAlbumItemWidget extends StatelessWidget with DatetimeUtil {
  final int index;
  final CaptureBatchDto album;
  final Function() onTap;
  final Function()? onMoreOptionTap;
  final AlbumType albumType;
  final String imagePath;

  const HomePageAlbumItemWidget({
    Key? key,
    required this.index,
    required this.album,
    required this.onTap,
    this.albumType = AlbumType.myAlbum,
    this.onMoreOptionTap,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String date =
        dateTime2DdMmYyyy(string2Datetime(album.metadata!.modifiedDate!));
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 150,
            width: size.width / 2,
            decoration: BoxDecoration(
              color: const Color(0xFFE6E8EE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                if (album.metadata!.thumbnailImage == null ||
                    album.metadata!.thumbnailImage == '')
                  Image.asset(
                    "assets/icons/gallery.svg",
                    key: UniqueKey(),
                    fit: BoxFit.none,
                  )
                else
                  SizedBox(
                    height: (size.width - 30) / 2,
                    width: (size.width - 30) / 2,
                    child: Image.file(
                      key: UniqueKey(),
                      FileUtils.getFile(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                if (album.metadata!.priorityDisplay == 1)
                  Align(
                    alignment: Alignment.topRight,
                    child: MyButton(
                      text: '',
                      color: Colors.white,
                      backgroundColor: Colors.transparent,
                      icon: Icons.more_vert,
                      onTap: onMoreOptionTap,
                    ),
                  ),
                if (album.metadata!.priorityDisplay == 1)
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      margin: const EdgeInsets.only(left: 5, bottom: 5),
                      height: 18,
                      width: 18,
                      child: album.metadata!.isSync!
                          ? Image.asset('assets/icons/checkcirle_icon.svg')
                          : Image.asset('assets/icons/sync_icon.svg'),
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              SizedBox(
                width: (size.width - 45) / 2,
                child: Text(
                  album.metadata!.captureName!,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2.5),
          Row(
            children: [
              Text(
                "${album.metadata!.numberOfImage} Ảnh - $date",
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 2.5),
          if (albumType == AlbumType.albumSharedWithMe)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/icons/account_icon.svg",
                  height: 12,
                  width: 12,
                ),
                const SizedBox(width: 2.5),
                Text(
                  album.metadata!.createdByUser!,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
