import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';

class CreateNewAlbumErrorMessageWidget extends StatelessWidget {
  final String text;

  const CreateNewAlbumErrorMessageWidget({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      height: 70,
      decoration: const BoxDecoration(
          color: Color(0xFFF6F8FF),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: const Icon(Icons.error, color: Colors.redAccent),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
