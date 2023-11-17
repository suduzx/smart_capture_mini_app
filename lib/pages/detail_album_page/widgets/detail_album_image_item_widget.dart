import 'package:flutter/material.dart';
import 'package:smart_capture_mobile/utils/file_utils.dart';

class DetailAlbumImageItemWidget extends StatelessWidget {
  final int index;
  final List<int> selectedIndexes;
  final List<int> selectedPDFIndexes;
  final String imagePath;
  final bool isSelectionMode;
  final bool isSync;
  final int priorityDisplay;
  final Function() onTap;
  final Function() onLongPress;

  const DetailAlbumImageItemWidget({
    Key? key,
    required this.index,
    required this.selectedIndexes,
    required this.selectedPDFIndexes,
    required this.imagePath,
    required this.isSelectionMode,
    required this.isSync,
    required this.priorityDisplay,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
      ),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black12.withOpacity(0.01),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12),
          ),
          child: Stack(
            children: [
              SizedBox(
                height: size.width / 3,
                width: size.width / 3,
                child: Image.file(
                  key: UniqueKey(),
                  FileUtils.getFile(imagePath),
                  width: size.width / 3,
                  fit: BoxFit.cover,
                ),
              ),
              if (isSelectionMode)
                Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.only(top: 5, right: 5),
                      child: selectedPDFIndexes.isNotEmpty
                          ? Container(
                              child: selectedIndexes.contains(index)
                                  ? Image.asset(
                                      'assets/icons/radio_is_checked_icon.svg',
                                      width: 20,
                                      height: 20,
                                    )
                                  : Image.asset('assets/icons/radio_icon.svg',
                                      width: 20, height: 20),
                            )
                          : ClipOval(
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(50)),
                                  color: selectedIndexes.contains(index)
                                      ? const Color(0xFF4A6EF6)
                                      : Colors.white,
                                  border: Border.all(
                                      color: selectedIndexes.contains(index)
                                          ? Colors.white
                                          : const Color(0xFF4A6EF6),
                                      width: 0.8),
                                ),
                                child: Center(
                                  child: Text(
                                    '${selectedIndexes.indexOf(index) + 1}',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                    )),
              if (priorityDisplay == 1)
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 5, bottom: 5),
                    height: 15,
                    width: 15,
                    child: isSync
                        ? Image.asset('assets/icons/checkcirle_icon.svg')
                        : Image.asset('assets/icons/sync_icon.svg'),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
