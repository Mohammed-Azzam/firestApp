import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';

import 'DataModels/recieved_notification.dart';
import 'flutter_wordpress-0.2.1/flutter_wordpress.dart';

final storage = FlutterSecureStorage();
String jwt = '';
WordPress myWordPress = WordPress(
  baseUrl: baseUrl,
  authenticator: WordPressAuthenticator.JWT,
  adminName: '',
  adminKey: '',
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
BehaviorSubject<ReceivedNotification>();
final BehaviorSubject<String?> selectNotificationSubject = BehaviorSubject<String?>();
String? selectedNotificationPayload;


const simpleTaskKey = "simpleTask";
const rescheduledTaskKey = "rescheduledTask";
const failedTaskKey = "failedTask";
const simpleDelayedTask = "simpleDelayedTask";
const simplePeriodicTask = "simplePeriodicTask";
const simplePeriodic1HourTask = "simplePeriodic1HourTask";
const notificationTask = "notificationTask";
//info devices
var deviceUuid;
var app_version;
var brand;
var model;
bool isFirstTimeLogin = true;

const metalicGolden = Color(0XEAFFD700);
const kBackGroundColor = Color(0xFFffce06);
const darkBlue = Color.fromRGBO(0, 38, 77, 1);
var darkYellow = Colors.yellow[700]!.withBlue(25);
const white = Colors.white;
const white10 = Colors.white10;
const white70 = Colors.white70;

Color? kPrimaryColorLight = Colors.blue[800];
// const kPrimaryColorLight = Color(0xFF141644);
// Color? kAccentColorLight = Colors.yellow[700]!.withBlue(25);
// const kAccentColorLight = Color(Color0xFFAEEEAF);
const kAccentColorLight = Color(0xEEAEEE8F);

Color? kPrimaryColorDark = Colors.orange[900];
Color? kAccentColorDark = Color(0xFF141644);

final navigatorKey = GlobalKey<NavigatorState>();
const loginUrl =
    'https://speedandsuccessphone.website/draft/old/wp-json/jwt-auth/v1/token';
const baseUrl = 'https://speedandsuccessphone.website/draft/old/';
