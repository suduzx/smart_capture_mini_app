import 'package:smart_capture_mobile/base_widgets/my_loading_widget.dart';
import 'package:smart_capture_mobile/base_widgets/my_sync_widget.dart';
import 'package:smart_capture_mobile/controllers/load_status_controller.dart';
import 'package:smart_capture_mobile/dtos/network_status.dart';
import 'package:smart_capture_mobile/services/network_status_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mp_connectivity_plus/mp_connectivity.dart';
import 'package:mpcore/mpcore.dart';

class MasterPageWithLoading extends StatefulWidget {
  final Widget childWidget;
  final Widget? syncWidget;

  const MasterPageWithLoading({
    Key? key,
    required this.childWidget,
    this.syncWidget,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MasterPageWithLoadingState();
}

class _MasterPageWithLoadingState extends State<MasterPageWithLoading> {
  ConnectivityResult? connectivityResult;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      connectivityResult = await MPConnectivityPlus().checkConnectivity();
      setState(() {
        connectivityResult = connectivityResult;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final LoadStatusController c = Get.put(LoadStatusController());
    return connectivityResult == null
        ? Container()
        : MPScaffold(
            body: StreamBuilder<NetworkStatus>(
              stream: NetworkStatusService().networkStatusController.stream,
              initialData:
                  NetworkStatusService.getNetworkStatus(connectivityResult!),
              builder: (context, snapshot) => Stack(
                children: [
                  if (snapshot.data == NetworkStatus.offline)
                    Column(
                      children: [
                        const SizedBox(height: 69),
                        Image.asset(
                          'assets/icons/ic_nonet.svg',
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Lỗi kết nối mạng',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Xin vui lòng kiểm tra lại kết nối mạng của bạn!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    )
                  else
                    GestureDetector(
                      onTap: () => HideKeyBoard.hidKeyBoard(),
                      child: widget.childWidget,
                    ),
                  Obx(() {
                    if (c.isLoading.value) {
                      return const Positioned(child: MyLoadingWidget());
                    } else if (c.isSync.value) {
                      return Positioned(
                        child: widget.syncWidget != null
                            ? widget.syncWidget!
                            : const MySyncWidget(
                                title: 'Đang đồng bộ album lên hệ thống',
                                message:
                                    'Quá trình này có thể diễn ra trong vài phút',
                              ),
                      );
                    } else {
                      return Container();
                    }
                  }),
                ],
              ),
            ),
          );
  }
}
