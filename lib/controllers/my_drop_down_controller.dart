import 'package:get/get.dart';

class MyDropDownController extends GetxController {
  RxString dropDownDisplayText = ''.obs;

  updateDisplayText(String value) => dropDownDisplayText.value = value;
  clearDisplayText() => dropDownDisplayText.value = '';
}
