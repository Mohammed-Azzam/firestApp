import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
//import 'package:device_information/device_information.dart';
//import 'package:permission_handler/permission_handler.dart';
import '../constants.dart';

Future<bool> checkPhysicalDevice() async {

  //
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final deviceInfo2 = await deviceInfo.deviceInfo;
  //String version = packageInfo.version;

  final map = deviceInfo2.toMap();
  model = (Platform.isAndroid ? 'Android ' : Platform.isIOS ? 'IOS ' : 'Unknown') +  map['version']['release'] ;
  brand = map['brand'] + ' ' +  map['model'] ;
  app_version = packageInfo.version ;
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    /*
    Map<Permission, PermissionStatus> statuses = await [
      Permission.phone,
    ].request();

     */
    deviceUuid = map['androidId'] ;



    /*
    try {
      //deviceUuid = await DeviceInformation.deviceIMEINumber;
      //print(imeiNo);
    }catch(e){
      print('imei error ===== $e')  ;
    }

     */
    /*
    try {
      String? identifier = await UniqueIdentifier.serial;
      //debugPrint('imei == $identifier') ;
      deviceUuid= identifier;
    } on PlatformException {
      // 'Failed to get Unique Identifier';
      return false ;
    }

     */
    bool x = false;
    try{
      x=androidInfo.isPhysicalDevice!;
    }catch(e){}
    return x;

  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    print('Running on ${iosInfo.utsname.machine}');
    print('Device type: ${iosInfo.isPhysicalDevice ? 'physical device' : 'simulator device'}');
    deviceUuid= iosInfo.identifierForVendor;
    print('uuid: $deviceUuid');
    return iosInfo.isPhysicalDevice;
  } else {
    print('error deciding platform');
    return false;
  }
}
