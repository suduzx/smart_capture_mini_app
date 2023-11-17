import 'package:flutter/widgets.dart';

class MyFloatingCamera extends StatelessWidget {
  final Function()? onTap;

  const MyFloatingCamera({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: GestureDetector(
        onTap: onTap,
        child: Image.asset(
          'assets/icons/btn_camera_icon.svg',
          height: 68,
          width: 68,
        ),
      ),
    );
  }
}
