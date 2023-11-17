import 'package:flutter/widgets.dart';

class MySplitAutoWidthButton extends StatelessWidget {
  final String text;
  final String icon;
  final double iconHeight;
  final double iconWidth;
  final Color color;
  final Color textColor;
  final Function()? onTap;

  const MySplitAutoWidthButton({
    Key? key,
    this.text = '',
    this.icon = '',
    this.iconHeight = 20,
    this.iconWidth = 20,
    this.color = Colors.white,
    this.textColor = Colors.black,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        height: text.isNotEmpty ? 100 : 75,
        color: color,
        width: MediaQuery.of(context).size.width * 0.25,
        padding: const EdgeInsets.only(top: 20),
        child: GestureDetector(
          onTap: onTap,
          child: Column(
            children: [
              if (icon.isNotEmpty)
                Center(
                  child: Image.asset(
                    icon,
                    height: iconHeight,
                    width: iconWidth,
                  ),
                ),
              if (text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: Text(text,
                        style: TextStyle(fontSize: 14, color: textColor)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
