import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool? disable;
  final bool? hidden;
  final String startIcon;
  final Color enabledBorderColor;
  final Color focusedBorderColor;
  final Color color;
  final Color borderColor;
  final double borderRadius;
  final int? maxLength;
  final EdgeInsets margin;
  final TextInputType textInputType;

  const MyTextField({
    Key? key,
    required this.controller,
    required this.placeholder,
    this.disable,
    this.hidden,
    this.startIcon = '',
    this.enabledBorderColor = Colors.transparent,
    this.focusedBorderColor = Colors.transparent,
    this.color = Colors.white,
    this.borderColor = Colors.transparent,
    this.borderRadius = 12.0,
    this.maxLength,
    this.margin = EdgeInsets.zero,
    this.textInputType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          color: isDisable() ? const Color(0xFFE6E8EE) : color,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          children: [
            if (startIcon.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Image.asset(
                  startIcon,
                  width: 20,
                  height: 20,
                ),
              ),
            Expanded(
              child: onRenderMPEditableText(),
            ),
          ],
        ),
      ),
    );
  }

  bool isDisable() {
    return disable != null && disable == true;
  }

  bool isHidden() {
    return hidden != null && hidden == true;
  }

  TextField onRenderMPEditableText() {
    return TextField(
      inputFormatters: [
        LengthLimitingTextInputFormatter(maxLength),
      ],
      keyboardType: textInputType,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: enabledBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: focusedBorderColor),
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 17.0, horizontal: 15.0),
      ).copyWith(
        hintText: placeholder,
        hintStyle: const TextStyle(fontSize: 15, color: Color(0xFF9AA1BC)),
      ),
      readOnly: isDisable(),
      obscureText: isHidden(),
      textEditingController: controller,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => HideKeyBoard.hidKeyBoard(),
      style: const TextStyle(fontSize: 15, color: Colors.black),
      cursorColor: const Color(0xFF4A6EF6),
    );
  }
}
