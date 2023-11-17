import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mpcore/mpcore.dart';
import 'package:smart_capture_mobile/base_widgets/my_bottom_sheet.dart';
import 'package:smart_capture_mobile/base_widgets/my_button.dart';
import 'package:smart_capture_mobile/controllers/my_bottom_sheet_controller.dart';
import 'package:smart_capture_mobile/controllers/my_drop_down_controller.dart';
import 'package:smart_capture_mobile/dtos/widget_dto/list_view_item_dto.dart';

class MyDropDown extends StatefulWidget {
  final MyDropDownController controller;
  final List<ListViewItemDto> items;
  final String bottomSheetText;
  final String? placeholder;
  final bool isMultiSelect;
  final bool buttonIsDisplayed;
  final Function(List<String> selectedValues)? callBack;

  const MyDropDown({
    Key? key,
    required this.controller,
    required this.items,
    this.bottomSheetText = '',
    this.placeholder,
    this.isMultiSelect = false,
    this.buttonIsDisplayed = false,
    this.callBack,
  }) : super(key: key);

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  final MyDropDownController c =
      Get.put(MyDropDownController(), tag: '_MyDropDownState');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Future.delayed(Duration(milliseconds: 10),
    //     () => widget.controller.updateDisplayText(onRenderText()));
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: GestureDetector(
        onTap: () async {
          if (widget.buttonIsDisplayed) {
            c.clearDisplayText();
            for (var element in widget.items) {
              element.isSelected = false;
            }
          }
          await showBottomSheet(context);
        },
        child: Container(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE6E8EE)),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Obx(() {
                    return SizedBox(
                      width: (size.width - 100),
                      child: Text(
                        widget.controller.dropDownDisplayText.value.isEmpty
                            ? widget.bottomSheetText
                            : "${widget.controller.dropDownDisplayText}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(
                            widget.controller.dropDownDisplayText.value.isEmpty
                                ? 0xFF9AA1BC
                                : 0xFF041557,
                          ),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    'assets/icons/drop_down_icon.svg',
                    width: 10,
                    height: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String onRenderText() {
    if (widget.isMultiSelect) {
      List<String> temp = widget.items
          .where((element) => element.isSelected)
          .map((e) => e.text)
          .toList();
      return temp[0] + (temp.length - 1 > 0 ? '(${temp.length - 1} Khác)' : '');
    } else {
      return widget.items
          .firstWhere(
            (element) => element.isSelected,
            orElse: () => ListViewItemDto(
              value: '',
              text: '',
              isSelected: true,
            ),
          )
          .text;
    }
  }

  Future<void> showBottomSheet(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    String? chooseValue = await showModalBottomSheet<String>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (_) {
        return MyBottomSheet(
          items: widget.items,
          bottomSheetText: widget.bottomSheetText,
          placeholder: widget.placeholder,
          size: size,
          callBack: (List<ListViewItemDto> editedItems) {
            if (widget.buttonIsDisplayed) {
              c.updateDisplayText(
                editedItems.firstWhere((item) => item.isSelected).value,
              );
            } else {
              widget.items.length = 0;
              widget.items.addAll(editedItems);
            }
          },
          floatingBody: widget.buttonIsDisplayed
              ? Obx(
                  () => MyButton(
                    width: size.width,
                    margin: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                    text: 'XONG',
                    height: 48,
                    fontSize: 16,
                    border: 8,
                    backgroundColor: c.dropDownDisplayText.value.isEmpty ||
                            Get.put(MyBottomSheetController())
                                .keywordNotFound
                                .isNotEmpty
                        ? const Color(0xFFE6E8EE)
                        : const Color(0xFF4A6EF6),
                    isDisable: c.dropDownDisplayText.value.isEmpty ||
                        Get.put(MyBottomSheetController())
                            .keywordNotFound
                            .isNotEmpty,
                    fontWeight: FontWeight.w500,
                    onTap: () {
                      widget.controller
                          .updateDisplayText(c.dropDownDisplayText.value);
                      widget.callBack!([c.dropDownDisplayText.value]);
                      c.clearDisplayText();
                      Navigator.of(context).pop();
                    },
                  ),
                )
              : null,
        );
      },
    );
    if (chooseValue != null && widget.callBack != null) {
      widget.controller.updateDisplayText(chooseValue);
      widget.callBack!([chooseValue]);
    }
  }
}
