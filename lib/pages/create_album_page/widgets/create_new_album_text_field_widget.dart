import 'package:smart_capture_mobile/base_widgets/my_text_field.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';

class CreateNewAlbumTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final int? maxLength;
  final bool isError;
  final TextInputType textInputType;

  const CreateNewAlbumTextFieldWidget(
      {Key? key,
      required this.controller,
      required this.placeholder,
      this.maxLength,
      required this.isError,
      required this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyTextField(
      controller: controller,
      textInputType: textInputType,
      placeholder: placeholder,
      margin: const EdgeInsets.symmetric(vertical: 5),
      maxLength: maxLength,
      enabledBorderColor: isError ? Colors.red : const Color(0xFFE6E8EE),
      focusedBorderColor: const Color(0xFF4A6EF6),
      borderRadius: 8.0,
    );
  }
}
