import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_pdf_dto.dart';
import 'package:flutter/widgets.dart';

class DetailAlbumPDFItemWidget extends StatelessWidget {
  final int index;
  final bool isChecked;
  final bool isDefaultAlbum;
  final CaptureBatchPdfDto pdfDto;
  final bool isSelectionMode;
  final Function() onTap;
  final Function() onLongPress;

  const DetailAlbumPDFItemWidget({
    Key? key,
    required this.index,
    required this.isChecked,
    required this.pdfDto,
    required this.isSelectionMode,
    required this.isDefaultAlbum,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
      ),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF6F8FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 15),
                  height: 51,
                  width: 34,
                  child: Image.asset(
                    'assets/icons/pdf_icon.svg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 25,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE6E8EE),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(7),
                      bottomRight: Radius.circular(7),
                    ),
                  ),
                  child: Row(),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: isDefaultAlbum ? 10 : 25,
                    bottom: 5,
                  ),
                  child: Text(
                    pdfDto.metadata!.name.substring(
                        pdfDto.metadata!.name.lastIndexOf('_') + 1,
                        pdfDto.metadata!.name.length - 4),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4F5B89),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              if (isSelectionMode)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: const EdgeInsets.only(top: 5, right: 5),
                    child: isChecked
                        ? Image.asset('assets/icons/radio_is_checked_icon.svg',
                            width: 20, height: 20)
                        : Image.asset('assets/icons/radio_icon.svg',
                            width: 20, height: 20),
                  ),
                ),
              if (!isDefaultAlbum)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 5, bottom: 5),
                    height: 15,
                    width: 15,
                    child: pdfDto.metadata!.isSync
                        ? Image.asset('assets/icons/checkcirle_icon.svg')
                        : Image.asset('assets/icons/sync_icon.svg'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
