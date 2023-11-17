import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_image_dto.dart';
import 'package:smart_capture_mobile/pages/detail_album_page/widgets/detail_album_image_item_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';

class DetailAlbumGridViewImageWidget extends StatelessWidget {
  final int priorityDisplay;
  final String path;
  final Function(int index) onImageItemTap;
  final Function(int index) onImageItemLongPress;
  final List<CaptureBatchImageDto> images;
  final List<int> selectedImages;
  final List<int> selectedPDFs;
  final bool selectionMode;

  const DetailAlbumGridViewImageWidget({
    Key? key,
    required this.onImageItemTap,
    required this.path,
    required this.onImageItemLongPress,
    required this.priorityDisplay,
    required this.images,
    required this.selectedImages,
    required this.selectedPDFs,
    required this.selectionMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return DetailAlbumImageItemWidget(
          index: index,
          selectedIndexes: selectedImages,
          selectedPDFIndexes: selectedPDFs,
          imagePath: '$path${images[index].metadata!.thumbPath}',
          isSelectionMode: selectionMode,
          isSync: images[index].metadata!.isSync,
          priorityDisplay: priorityDisplay,
          onTap: () => onImageItemTap(index),
          onLongPress: () => onImageItemLongPress(index),
        );
      },
    );
  }
}
