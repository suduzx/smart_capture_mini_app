import 'package:flutter/widgets.dart';

class LoginPageErrorMessageWidget extends StatelessWidget {
  final String errorText;

  const LoginPageErrorMessageWidget({
    Key? key,
    required this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return errorText == ''
        ? const SizedBox(height: 17)
        : Container(
            margin: const EdgeInsets.only(top: 10, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  errorText,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFD4A1E),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          );
  }
}
