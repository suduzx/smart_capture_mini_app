import 'package:get/get.dart';

class LoadStatusController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isSync = false.obs;
  RxBool syncCompleted = true.obs;

  startLoading() => isLoading.value = true;

  startSync() => isSync.value = true;

  updateSyncCompleted(bool value) => syncCompleted.value = value;

  stopLoadingAndSync() {
    isLoading.value = false;
    isSync.value = false;
  }
}
