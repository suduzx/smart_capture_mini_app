import 'package:mp_permission_handler/mp_permission_handler.dart';

mixin PermissionHandlerUtil {
  Future<bool> requestCameraPermission() async {
    if (!(await Permission.camera.isGranted)) {
      PermissionStatus status = await Permission.camera.request();
      if (status == PermissionStatus.permanentlyDenied) {
        await openAppSetting();
      }
      return status == PermissionStatus.granted;
    }
    return Permission.camera.isGranted;
  }

  Future<bool> requestStoragePermission() async {
    if (!(await Permission.storage.isGranted)) {
      PermissionStatus status = await Permission.storage.request();
      if (status == PermissionStatus.granted) {
        return true;
      }
      status = await Permission.photos.request();
      if (status == PermissionStatus.granted) {
        return true;
      }
      if (status == PermissionStatus.permanentlyDenied) {
        await openAppSetting();
      }
    }
    return Permission.storage.isGranted;
  }

  Future<bool> requestLocationPermission() async {
    if (!(await Permission.location.isGranted)) {
      PermissionStatus status = await Permission.location.request();
      if (status == PermissionStatus.permanentlyDenied) {
        await openAppSetting();
      }
      return status == PermissionStatus.granted;
    }
    return Permission.location.isGranted;
  }
}
