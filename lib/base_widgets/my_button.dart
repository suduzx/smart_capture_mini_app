import 'package:flutter/widgets.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color backgroundColor;
  final String image;
  final double heightImage;
  final double widthImage;
  final IconData? icon;
  final Function()? onTap;
  final double fontSize;
  final double height;
  final double width;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets margin;
  final FontWeight fontWeight;
  final EdgeInsets padding;
  final double border;
  final bool isDisable;

  const MyButton({
    Key? key,
    required this.text,
    this.color = Colors.white,
    this.backgroundColor = const Color(0xFF4A6EF6),
    this.image = '',
    this.heightImage = 24,
    this.widthImage = 24,
    this.icon,
    this.fontSize = 18,
    this.height = 40,
    this.width = 40,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.fontWeight = FontWeight.normal,
    this.padding = EdgeInsets.zero,
    this.border = 12.0,
    this.isDisable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(border),
      ),
      child: GestureDetector(
        onTap: isDisable ? () {} : onTap,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            image == ''
                ? (icon == null ? Container() : Icon(icon, color: color))
                : Image.asset(image,
                    height: heightImage, width: widthImage),
            text == ''
                ? Container()
                : Container(
                    padding: padding,
                    child: Text(
                      text,
                      style: TextStyle(
                          fontSize: fontSize,
                          color: isDisable ? Colors.grey : color,
                          fontWeight: fontWeight),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
