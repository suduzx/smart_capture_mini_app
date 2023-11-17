import 'package:flutter/widgets.dart';

class MyLoadingWidget extends StatelessWidget {
  const MyLoadingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 100,
          child: Image.asset('assets/images/150percent.gif'),
        ),
      ),
    );
  }
}
