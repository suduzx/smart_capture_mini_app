import 'package:flutter/widgets.dart';

class MyLabelWidget extends StatelessWidget {
  final String text;
  final EdgeInsets padding;

  const MyLabelWidget({
    Key? key,
    required this.text,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      alignment: Alignment.centerLeft,
      child: Text(text,
          style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF4F5B89),
              fontWeight: FontWeight.bold)),
    );
  }
}
