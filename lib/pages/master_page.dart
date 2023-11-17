import 'package:smart_capture_mobile/base_widgets/my_app_bar.dart';
import 'package:smart_capture_mobile/base_widgets/my_floating_camera.dart';
import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';

class MasterPage extends StatelessWidget {
  final String name;
  final Widget child;
  final Widget? trailingButton;
  final Color backgroundColor;
  final Color backgroundBarColor;
  final Color barColor;
  final Function()? onCameraTap;
  final Widget? floatingBody;
  final bool isBackGroundHomePage;
  final bool isShowBackArrow;
  final Function()? backArrowTap;

  const MasterPage({
    Key? key,
    required this.name,
    required this.child,
    this.trailingButton,
    this.onCameraTap,
    this.backgroundColor = Colors.white,
    this.backgroundBarColor = Colors.blue,
    this.barColor = Colors.white,
    this.floatingBody,
    this.isBackGroundHomePage = false,
    this.isShowBackArrow = true,
    this.backArrowTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MPScaffold(
      name: name,
      appBar: MyAppBar(
        isBackGroundHomePage: isBackGroundHomePage,
        context: context,
        name: name,
        trailingButton: trailingButton,
        backgroundColor: backgroundBarColor,
        color: barColor,
        isShowBackArrow: isShowBackArrow,
        backArrowTap: backArrowTap,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          child,
          if (floatingBody == null)
            Positioned(
              bottom: 20,
              right: 10,
              child: MyFloatingCamera(onTap: onCameraTap),
            )
          else
            Align(
              alignment: Alignment.bottomRight,
              child: floatingBody,
            )
        ],
      ),
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: true,
    );
  }
}
