import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';

mixin TopSnackBarUtil {
  Future<void> showSuccess(String message) async {
    await Future.delayed(const Duration(milliseconds: 200), () {
      ShowFlushBar.showFlushBar(
        flushBarStatus: FlushbarType.SUCCESS,
        titleColor: Colors.white,
        flushBarPosition: FlushbarPosition.TOP,
        flushBarStyle: FlushbarStyle.GROUNDED,
        isDismissible: true,
        backgroundColor: const Color(0xff45D39D),
        duration: 2,
        messageText: message,
      );
    });
  }

  Future<void> showError(String message) async {
    await Future.delayed(const Duration(milliseconds: 200), () {
      ShowFlushBar.showFlushBar(
        flushBarStatus: FlushbarType.ERROR,
        titleColor: Colors.white,
        flushBarPosition: FlushbarPosition.TOP,
        flushBarStyle: FlushbarStyle.GROUNDED,
        isDismissible: true,
        backgroundColor: const Color(0xffFF4A4A),
        duration: 2,
        messageText: message,
      );
    });
  }
}
