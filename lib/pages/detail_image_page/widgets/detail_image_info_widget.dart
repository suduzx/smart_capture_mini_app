import 'package:flutter/widgets.dart';
import 'package:smart_capture_mobile/utils/mixin/datetime_util.dart';

class DetailImageInfoWidget extends StatelessWidget with DatetimeUtil {
  final String dateTime;
  final String address;
  final bool isSync;

  const DetailImageInfoWidget({
    Key? key,
    required this.dateTime,
    required this.address,
    required this.isSync,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateTime dt = string2Datetime(dateTime);
    String showTime = '${dateTime2HhMi(dt)}  ${dateTime2DdMmYyyy(dt)}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: size.height * 0.55,
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 5),
          Image.asset(
            'assets/icons/vector_icon.svg',
            width: 40,
          ),
          const SizedBox(height: 30),
          Container(
            alignment: Alignment.topLeft,
            child: const Text(
              "Thông tin ảnh",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE6E8EE)),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Trạng Thái",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                isSync
                    ? Row(
                        children: [
                          Image.asset(
                            'assets/icons/checkcirle_icon.svg',
                            height: 15,
                          ),
                          const SizedBox(width: 5),
                          const Text('Đã chia sẻ lên hệ thống'),
                        ],
                      )
                    : Row(
                        children: [
                          Image.asset(
                            'assets/icons/sync_icon.svg',
                            height: 15,
                          ),
                          const SizedBox(width: 5),
                          const Text('Chưa chia sẻ lên hệ thống'),
                        ],
                      ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE6E8EE)),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thời gian",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(showTime),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE6E8EE)),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Địa điểm",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(address == 'null' ? 'Chưa có địa chỉ' : address),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
