import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';
import 'package:smart_capture_mobile/base_widgets/my_button.dart';
import 'package:smart_capture_mobile/enum/confirm_value_enum.dart';

class MyConfirmDialog {
  final String title;
  final String message;

  MyConfirmDialog({
    required this.title,
    required this.message,
  });

  Future<ConfirmValue?> showConfirmDialog(BuildContext context) async {
    return await showDialog<ConfirmValue>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width - 30,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                height: 45,
                child: Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xff041557)),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff041557),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.topCenter,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: MyButton(
                        margin: const EdgeInsets.only(right: 5),
                        height: 45,
                        border: 8,
                        text: 'HỦY',
                        backgroundColor: const Color(0xFFF5F7FB),
                        color: Colors.black,
                        fontSize: 14,
                        onTap: () {
                          Navigator.of(context).pop(ConfirmValue.cancel);
                        },
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: MyButton(
                        margin: const EdgeInsets.only(left: 5),
                        height: 45,
                        border: 8,
                        text: 'XÁC NHẬN',
                        fontSize: 14,
                        onTap: () {
                          Navigator.of(context).pop(ConfirmValue.confirm);
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
