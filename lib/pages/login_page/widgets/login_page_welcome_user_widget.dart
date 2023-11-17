import 'package:flutter/widgets.dart';

class LoginPageWelcomeUserWidget extends StatelessWidget {
  final String name;

  const LoginPageWelcomeUserWidget({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            margin: const EdgeInsets.only(right: 20),
            child: Image.asset('assets/images/Avaterdefault.svg'),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              const Text(
                'Chào mừng',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF041557),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFF4A6EF6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
