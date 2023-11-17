import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';
import 'package:smart_capture_mobile/base_widgets/my_button.dart';

class MyMessageDialog {
  final String title;
  final String message;
  final String titleButton;
  final bool isCenter;

  MyMessageDialog({
    required this.title,
    required this.message,
    required this.titleButton,
    this.isCenter = false,
  });

  Future<bool?> onShowDialog(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: size.width - 30,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment:
                    isCenter ? Alignment.bottomCenter : Alignment.bottomLeft,
                height: 45,
                child: Text(
                  title,
                  textAlign: isCenter ? TextAlign.center : null,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xff041557)),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                message,
                textAlign: isCenter ? TextAlign.center : null,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xff041557),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.topCenter,
                height: 65,
                child: MyButton(
                  width: double.infinity,
                  height: 45,
                  border: 8,
                  text: titleButton,
                  fontSize: 14,
                  onTap: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
