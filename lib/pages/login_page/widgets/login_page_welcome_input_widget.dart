import 'package:smart_capture_mobile/base_widgets/my_text_field.dart';
import 'package:smart_capture_mobile/enum/login_error_enum.dart';
import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';

class LoginPageWelcomeInputWidget extends StatelessWidget {
  final TextEditingController userController;
  final LoginErrorValue? errorValue;

  const LoginPageWelcomeInputWidget({
    Key? key,
    required this.userController,
    this.errorValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Đăng nhập',
          style: TextStyle(
            fontSize: 24,
            color: Color(0xFF041557),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Chào mừng bạn đến với Smart CRM',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF041557),
          ),
        ),
        const SizedBox(height: 30),
        MyTextField(
          startIcon: 'assets/icons/account_icon.svg',
          controller: userController,
          placeholder: 'Tài khoản',
          borderRadius: 8.0,
          borderColor: Color(
              errorValue != null && errorValue != LoginErrorValue.password
                  ? 0xFFFF4A4A
                  : 0xFFE6E8EB),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
