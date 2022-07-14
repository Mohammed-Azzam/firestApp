import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:speed_and_success/Widgets/common/dialogs.dart';

Future<bool> internetChecks([BuildContext? context]) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    if (context != null)
      Dialogs().showErrorDialog(context, errorStatement: 'please, check the internet connectivity');
    return false;
  }
}
