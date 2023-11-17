import 'package:get/get.dart';

class MyBottomSheetController extends GetxController {
  RxString keywordNotFound = ''.obs;
  RxBool itemsIsNull = false.obs;

  setItemsIsNull(bool value) => itemsIsNull.value = value;

  bool getItemsIsNull() => itemsIsNull.value;

  setKeywordNotFound(String value) => keywordNotFound.value = value;

  String getKeywordNotFound() => keywordNotFound.value;
}
