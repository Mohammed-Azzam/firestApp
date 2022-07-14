import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import 'package:timezone/data/latest.dart' as tz_l;
import 'package:timezone/timezone.dart' as tz;

Future<void> configureLocalTimeZone() async {
  tz_l.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}
