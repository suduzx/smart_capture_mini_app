import 'package:smart_capture_mobile/base_widgets/my_bottom_sheet.dart';
import 'package:smart_capture_mobile/base_widgets/my_button.dart';
import 'package:smart_capture_mobile/controllers/my_bottom_sheet_controller.dart';
import 'package:smart_capture_mobile/controllers/my_drop_down_controller.dart';
import 'package:smart_capture_mobile/dtos/business/capture_batch/capture_batch_dto.dart';
import 'package:smart_capture_mobile/dtos/widget_dto/list_view_item_dto.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/parse_route.dart';

class MoveImageWidget extends StatelessWidget {
  final MyDropDownController c =
      Get.put(MyDropDownController(), tag: 'MoveImageWidget');
  final List<CaptureBatchDto> albums;
  final CaptureBatchDto albumDto;
  final Function(String albumNameSelected) onMoveImages;

  MoveImageWidget({
    Key? key,
    required this.albums,
    required this.albumDto,
    required this.onMoveImages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    c.clearDisplayText();
    return MyBottomSheet(
      items: albums
          .where((element) =>
              element.metadata!.priorityDisplay == 1 &&
              element.metadata!.captureName != albumDto.metadata!.captureName)
          .map((e) => ListViewItemDto(
              value: e.metadata!.captureName!,
              text: e.metadata!.captureName!,
              isSelected: e.metadata!.captureName!.toLowerCase() ==
                  albumDto.metadata!.captureName!.toLowerCase()))
          .toList(),
      callBack: (items) => c.updateDisplayText(
        items.firstWhereOrNull((item) => item.isSelected)?.value ?? '',
      ),
      bottomSheetText: 'Di chuyển đến album',
      size: size,
      floatingBody: Obx(
        () => MyButton(
          width: size.width,
          margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
          text: 'DI CHUYỂN',
          height: 48,
          fontSize: 16,
          border: 8,
          backgroundColor: c.dropDownDisplayText.value.isEmpty ||
                  Get.put(MyBottomSheetController()).keywordNotFound.isNotEmpty
              ? const Color(0xFFE6E8EE)
              : const Color(0xFF4A6EF6),
          isDisable: c.dropDownDisplayText.value.isEmpty ||
              Get.put(MyBottomSheetController()).keywordNotFound.isNotEmpty,
          fontWeight: FontWeight.w500,
          onTap: () {
            onMoveImages(c.dropDownDisplayText.value);
            c.dropDownDisplayText();
            Navigator.of(context).pop(null);
          },
        ),
      ),
    );
  }
}
