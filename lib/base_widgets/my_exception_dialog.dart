import 'package:flutter/widgets.dart';
import 'package:smart_capture_mobile/base_widgets/my_button.dart';
import 'package:smart_capture_mobile/dtos/exceptions/failures.dart';

class MyExceptionDialog extends StatelessWidget {
  final Failure failure;

  const MyExceptionDialog({
    Key? key,
    required this.failure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 38),
          Image.asset(
            failure.icon ?? '',
            width: 68,
            height: 68,
          ),
          const SizedBox(height: 20),
          Text(
            failure.title,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
                color: Color(0xFF041557)),
          ),
          const SizedBox(height: 5),
          Text(
            failure.message ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Color(0xFF9AA1BC)),
          ),
          const SizedBox(height: 41),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: MyButton(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 45,
                  border: 8,
                  backgroundColor: Colors.black.withOpacity(0.015),
                  color: const Color(0xFF4F5B89),
                  text: 'ĐỒNG Ý',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
