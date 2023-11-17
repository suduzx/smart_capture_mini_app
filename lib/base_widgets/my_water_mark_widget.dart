import 'dart:math';

import 'package:flutter/widgets.dart';

class MyWaterMarkWidget extends StatelessWidget {
  final int rowCount;
  final int columnCount;
  final String text;

  const MyWaterMarkWidget(
      {Key? key, this.rowCount = 2, this.columnCount = 3, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Column(
        children: creatColumnWidgets(),
      ),
    );
  }

  List<Widget> creatRowWdiges() {
    List<Widget> list = [];
    for (var i = 0; i < rowCount; i++) {
      final widget = Expanded(
          child: Center(
              child: Transform.rotate(
        angle: -pi / 4,
        child: Text(
          text,
          style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 20,
              decoration: TextDecoration.none),
        ),
      )));
      list.add(widget);
    }
    return list;
  }

  List<Widget> creatColumnWidgets() {
    List<Widget> list = [];
    for (var i = 0; i < columnCount; i++) {
      final widget = Expanded(
          child: Row(
        children: creatRowWdiges(),
      ));
      list.add(widget);
    }
    return list;
  }
}
