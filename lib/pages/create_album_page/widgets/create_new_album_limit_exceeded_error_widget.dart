import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';

class CreateNewAlbumLimitExceededErrorWidget extends StatelessWidget {
  const CreateNewAlbumLimitExceededErrorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 20, bottom: 5),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 5),
            child: const Icon(Icons.error, color: Colors.redAccent),
          ),
          const Text(
            'Khách hàng chỉ được sở hữu tối đa 30 album,\nVui lòng kiểm tra lại!',
            style: TextStyle(fontSize: 14, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
