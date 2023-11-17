import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mpcore/mpcore.dart';
import 'package:smart_capture_mobile/base_widgets/keyword_not_found_widget.dart';
import 'package:smart_capture_mobile/base_widgets/my_app_bar.dart';
import 'package:smart_capture_mobile/base_widgets/my_button.dart';
import 'package:smart_capture_mobile/base_widgets/my_text_field.dart';
import 'package:smart_capture_mobile/controllers/my_bottom_sheet_controller.dart';
import 'package:smart_capture_mobile/dtos/widget_dto/list_view_item_dto.dart';

class MyBottomSheet extends StatelessWidget {
  final List<ListViewItemDto> items;
  final String bottomSheetText;
  final String? placeholder;
  final Size size;
  final bool isMultiSelect;
  final Function(List<ListViewItemDto> items)? callBack;
  final Widget? floatingBody;

  final MyBottomSheetController c = Get.put(MyBottomSheetController());
  final List<ListViewItemDto> filteredItems = List.empty(growable: true);

  MyBottomSheet({
    Key? key,
    required this.items,
    required this.bottomSheetText,
    required this.size,
    this.placeholder,
    this.isMultiSelect = false,
    this.callBack,
    this.floatingBody,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    StreamController controller = StreamController();
    TextEditingController filterController = TextEditingController();
    filterController
        .addListener(() => onFilterItem(controller, filterController));
    onFilterItem(controller, filterController);
    return GestureDetector(
      onTap: () => HideKeyBoard.hidKeyBoard(),
      child: Container(
        height: size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 15),
            MyAppBar(
              context: context,
              name: bottomSheetText,
              color: Colors.black,
              backgroundColor: Colors.transparent,
              isShowBackArrow: false,
              trailingButton: MyButton(
                text: 'Hủy',
                color: const Color(0xFF4A6EF6),
                backgroundColor: Colors.white,
                margin: const EdgeInsets.only(right: 10),
                fontWeight: FontWeight.w500,
                onTap: () {
                  controller.close();
                  Navigator.of(context).pop(null);
                },
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              controller: filterController,
              placeholder: placeholder ?? 'Tìm kiếm',
              startIcon: 'assets/icons/search_icon.svg',
              color: const Color(0xFFF7F8FA),
              margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            ),
            Obx(() {
              if (c.getKeywordNotFound().isNotEmpty) {
                return KeywordNotFoundWidget(
                  keyword: c.getKeywordNotFound(),
                  itemsIsNull: c.getItemsIsNull(),
                );
              } else {
                return Container();
              }
            }),
            Expanded(
              child: StreamBuilder(
                stream: controller.stream,
                builder: (_, __) {
                  return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: const BouncingScrollPhysics(),
                    padding:
                        EdgeInsets.only(bottom: floatingBody != null ? 25 : 70),
                    itemCount: filteredItems.length,
                    itemBuilder: (BuildContext _, int index) {
                      return isMultiSelect
                          ? onRenderListViewMultipleSelect(
                              index, controller, filterController)
                          : onRenderListViewSingleSelect(
                              index, controller, filterController, context);
                    },
                  );
                },
              ),
            ),
            if (floatingBody != null) floatingBody!,
          ],
        ),
      ),
    );
  }

  onFilterItem(
      StreamController controller, TextEditingController filterController) {
    filteredItems.length = 0;
    if (filterController.text != '') {
      filteredItems.addAll(items
          .where((element) => element.text
              .toLowerCase()
              .contains(filterController.text.toLowerCase()))
          .toList());
    } else {
      filteredItems.addAll(items);
    }
    if (items.isEmpty) {
      c.setItemsIsNull(true);
    } else {
      c.setItemsIsNull(false);
    }
    if (filteredItems.isEmpty) {
      // String key = bottomSheetText.substring(bottomSheetText.lastIndexOf(' ') + 1, bottomSheetText.length);
      String key = !bottomSheetText.contains('Chọn')
          ? 'album'
          : bottomSheetText.replaceAll('Chọn ', '');
      c.setKeywordNotFound(key);
    } else {
      c.setKeywordNotFound('');
    }
    controller.add(filteredItems);
  }

  Widget onRenderListViewSingleSelect(int index, StreamController controller,
      TextEditingController filterController, BuildContext context) {
    return GestureDetector(
      onTap: () => onSingleSelect(context, index, controller, filterController),
      child: Container(
        padding: const EdgeInsets.only(left: 15, top: 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.only(right: 10),
              child: filteredItems[index].isSelected
                  ? const Icon(
                      Icons.check_circle,
                      color: Color(0xFF4A6EF6),
                    )
                  : const Icon(
                      Icons.circle_outlined,
                      color: Color(0xFF4A6EF6),
                    ),
            ),
            Expanded(
              child: Text(
                filteredItems[index].text,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  onSingleSelect(BuildContext context, int index, StreamController controller,
      TextEditingController filterController) {
    final String selectedValue = filteredItems[index].value.toLowerCase();
    for (var element in items) {
      element.isSelected = element.value.toLowerCase() == selectedValue;
    }
    onFilterItem(controller, filterController);
    if (callBack != null) {
      callBack!(items);
    }
    if (floatingBody == null) {
      controller.close();
      Navigator.of(context).pop(filteredItems[index].value);
    }
  }

  Widget onRenderListViewMultipleSelect(int index, StreamController controller,
      TextEditingController filterController) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                filteredItems[index].text,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: filteredItems[index].isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.blue,
                      size: 14,
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }

  onMultipleSelect(int index, StreamController controller,
      TextEditingController filterController) {
    onFilterItem(controller, filterController);
  }
}
