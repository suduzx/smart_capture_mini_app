import 'package:flutter/widgets.dart';

class CreateNewAlbumTextFiledErrorWidget extends StatelessWidget {
  final String? textError;

  const CreateNewAlbumTextFiledErrorWidget({
    Key? key,
    required this.textError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          textError ?? '',
          style: const TextStyle(
              fontSize: 14, color: Colors.redAccent),
        ),
      ),
    );
  }
}
