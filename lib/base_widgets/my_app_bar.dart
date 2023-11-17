import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext context;
  final String name;
  final Widget? trailingButton;
  final double appBarHeight;
  final Color backgroundColor;
  final Color color;
  final bool isShowBackArrow;
  final Function()? backArrowTap;
  final bool isBackGroundHomePage;

  const MyAppBar({
    Key? key,
    required this.context,
    required this.name,
    this.trailingButton,
    this.backgroundColor = Colors.white,
    this.color = Colors.white,
    this.appBarHeight = 44,
    this.isShowBackArrow = true,
    this.backArrowTap,
    this.isBackGroundHomePage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: isShowBackArrow,
      leading: isShowBackArrow
          ? GestureDetector(
              onTap: backArrowTap ??
                  () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
              child: Icon(
                Icons.arrow_back,
                color: color,
              ),
            )
          : null,
      title: Text(
        name,
        style: TextStyle(fontSize: 18, color: color),
      ),
      elevation: 0,
      flexibleSpace: Container(
        decoration: isBackGroundHomePage
            ? const BoxDecoration(
                gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF73ABFF),
                  Color(0xFF373FE7),
                ],
              ))
            : BoxDecoration(color: backgroundColor),
      ),
      actions: [trailingButton ?? const SizedBox()],
      backgroundColor: backgroundColor,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(appBarHeight + MediaQuery.of(context).padding.top);
}
