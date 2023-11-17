import 'dart:async';

import 'package:smart_capture_mobile/dtos/network_status.dart';
import 'package:mp_connectivity_plus/mp_connectivity.dart';

class NetworkStatusService {
  StreamController<NetworkStatus> networkStatusController =
      StreamController<NetworkStatus>();

  NetworkStatusService() {
    MPConnectivityPlus().onConnectivityChanged?.listen((status) {
      networkStatusController.add(getNetworkStatus(status));
    });
  }

  static NetworkStatus getNetworkStatus(ConnectivityResult status) {
    return status == ConnectivityResult.mobile ||
            status == ConnectivityResult.wifi
        ? NetworkStatus.online
        : NetworkStatus.offline;
  }
}
