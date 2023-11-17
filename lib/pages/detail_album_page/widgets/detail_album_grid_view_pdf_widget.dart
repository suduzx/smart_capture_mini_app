import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_pdf_dto.dart';
import 'package:smart_capture_mobile/pages/detail_album_page/widgets/detail_album_pdf_item_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';

class DetailAlbumGridViewPDFWidget extends StatelessWidget {
  final int priorityDisplay;
  final List<CaptureBatchPdfDto> pdfs;
  final Function(int index) onPDFItemTap;
  final Function(int index) onPDFItemLongPress;
  final List<int> selectedPDFs;
  final bool selectionMode;

  const DetailAlbumGridViewPDFWidget({
    Key? key,
    required this.onPDFItemTap,
    required this.onPDFItemLongPress,
    required this.priorityDisplay,
    required this.pdfs,
    required this.selectionMode,
    required this.selectedPDFs,
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
      itemCount: pdfs.length,
      itemBuilder: (context, index) => DetailAlbumPDFItemWidget(
        index: index,
        isChecked: selectedPDFs.contains(index),
        isDefaultAlbum: priorityDisplay == 0,
        pdfDto: pdfs[index],
        isSelectionMode: selectionMode,
        onTap: () => onPDFItemTap(index),
        onLongPress: () => onPDFItemLongPress(index),
      ),
    );
  }
}
