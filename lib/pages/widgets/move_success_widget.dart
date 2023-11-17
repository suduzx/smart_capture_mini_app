import 'package:flutter/widgets.dart';
import 'package:mpcore/mpcore.dart';

class MoveImagesSuccessWidget {
  final int lengthImages;
  final Function() onViewDetail;

  MoveImagesSuccessWidget({
    required this.lengthImages,
    required this.onViewDetail,
  });

  Future<void> onShowDialog(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    await showDialog(
      barrierColor: Colors.black.withOpacity(0.1),
      dialogPosition: const Alignment(0, 0.9),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 126,
          width: size.width * 0.9,
          decoration: BoxDecoration(
            color: const Color(0xFFF6F8FF),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 8,
                child: Container(
                  padding: const EdgeInsets.only(top: 25, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(children: <TextSpan>[
                        const TextSpan(
                          text: 'Di chuyển ',
                          style:
                              TextStyle(fontSize: 18, color: Color(0xFF4F5B89)),
                        ),
                        TextSpan(
                          text: '$lengthImages ảnh',
                          style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF4F5B89),
                              fontWeight: FontWeight.w600),
                        ),
                        const TextSpan(
                          text: ' đến thư \nmục mới thành công',
                          style:
                              TextStyle(fontSize: 18, color: Color(0xFF4F5B89)),
                        ),
                      ])),
                      const SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          onViewDetail();
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Xem chi tiết',
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xFF4A6EF6)),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              'assets/icons/next_icon.svg',
                              width: 14,
                              height: 14,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.only(top: 25, left: 10),
                    child: Image.asset(
                      'assets/icons/btn_close.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
