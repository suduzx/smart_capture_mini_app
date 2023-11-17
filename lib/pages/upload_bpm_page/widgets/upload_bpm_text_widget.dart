import 'package:flutter/cupertino.dart';

class UploadBPMTextWidget extends StatelessWidget {
  final String text;

  const UploadBPMTextWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4F5B89),
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
