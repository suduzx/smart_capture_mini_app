import 'package:flutter/widgets.dart';

class FileNotSyncedWidget extends StatelessWidget {
  final Function() sync;

  const FileNotSyncedWidget({
    Key? key,
    required this.sync,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE6E8EE)),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: sync,
                child: Image.asset('assets/icons/load_icon.svg', height: 36),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Bạn còn có file chưa được chia sẻ với hệ thống',
            style: TextStyle(color: Color(0xff9aa1bc)),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            'Vui lòng kiểm tra lại kết nối Internet và thử lại!',
            style: TextStyle(color: Color(0xff9aa1bc)),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
