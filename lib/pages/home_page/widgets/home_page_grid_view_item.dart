import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/enum/album_type_enum.dart';
import 'package:smart_capture_mobile/pages/home_page/widgets/home_page_album_item_widget.dart';
import 'package:smart_capture_mobile/base_widgets/keyword_not_found_widget.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';
import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';

class HomePageGridViewItemWidget extends StatelessWidget with DatetimeUtil {
  final String rootAlbumPath;
  final List<CaptureBatchDto> albums;
  final Function(CaptureBatchDto albumDto) onTap;
  final Function(CaptureBatchDto albumDto) onMoreOptionTap;
  final AlbumType albumType;

  const HomePageGridViewItemWidget({
    Key? key,
    required this.rootAlbumPath,
    required this.albums,
    required this.onTap,
    this.albumType = AlbumType.myAlbum,
    required this.onMoreOptionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (albums.isEmpty) {
      return const KeywordNotFoundWidget();
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 30),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 30,
                childAspectRatio: 1
              ),

              itemCount: albums.length,
              itemBuilder: (context, index) => HomePageAlbumItemWidget(
                index: index,
                album: albums[index],
                onTap: () => onTap(albums[index]),
                onMoreOptionTap: () => onMoreOptionTap(albums[index]),
                albumType: albumType,
                imagePath:
                    '$rootAlbumPath${albums[index].metadata!.thumbnailImage}',
              ),
            ),
          ],
        ),
      );
    }
  }
}
