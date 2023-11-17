import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';

class MySyncWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final Color? color;

  const MySyncWidget({
    Key? key,
    this.title,
    this.message,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      height: size.height,
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(
              color: const Color(0xFF4A6EF6),
            ),
          ),
          const SizedBox(height: 40),
          if (title != null)
            Text(
              title!,
              style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF041557),
                  fontWeight: FontWeight.w500),
            ),
          const SizedBox(height: 10),
          if (message != null)
            Text(
              message!,
              style: const TextStyle(fontSize: 14, color: Color(0xFF9AA1BC)),
            ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
