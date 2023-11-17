import 'package:flutter/widgets.dart';

class KeywordNotFoundWidget extends StatelessWidget {
  final String keyword;
  final bool itemsIsNull;

  const KeywordNotFoundWidget({
    Key? key,
    this.keyword = 'album',
    this.itemsIsNull = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50),
        SizedBox(
          width: 100,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset('assets/icons/not_album_icon.svg')],
          ),
        ),
        if (!itemsIsNull) const SizedBox(height: 24),
        if (!itemsIsNull)
          Text(
            'Không có $keyword bạn muốn tìm',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        const SizedBox(height: 10),
        if (itemsIsNull)
          Text(
            'Không có $keyword nào hợp lệ',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
            ),
          )
        else
          const Text(
            'Vui lòng thử lại với từ khóa khác',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
      ],
    );
  }
}
