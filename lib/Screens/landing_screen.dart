import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:speed_and_success/DataModels/recieved_notification.dart';
import 'package:speed_and_success/StateManagement/blocs/login_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';
import '../Widgets/posts/post_page.dart';
import '../constants.dart';
import 'auth_screen.dart';
import 'home_screen.dart';

class LandingScreen extends StatefulWidget {
  final NotificationAppLaunchDetails? notificationAppLaunchDetails;

  LandingScreen({this.notificationAppLaunchDetails});

  static const String routeName = 'landing_screen';

  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
//    Firebase.initializeApp();
    LoginCubit.instance(context).sessionValidate(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));

    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null ? Text(receivedNotification.title!) : null,
          content: receivedNotification.body != null ? Text(receivedNotification.body!) : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => LandingScreen(),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String? payload) async {
      await Navigator.popAndPushNamed(context, LandingScreen.routeName);
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Upgrader.clearSavedSettings();
    return UpgradeAlert(
      // debugLogging: true,
      // showIgnore: false,
      // showLater: true,
      // canDismissDialog:false,
      child: Container(
        child: BlocConsumer<LoginCubit, LoginStates>(
          listener: (context, state) {
            // do stuff here based on BlocA's state
//            if (state is LoginFinishedSuccessfully) {
//              PostsCubit postsCubit = PostsCubit.instance(context);
//              LoginCubit loginCubit = LoginCubit.instance(context);
//            }
          },
          builder: (context, state) {
            // return widget here based on BlocA's state

            if (state is LoginFinishedSuccessfully) {
              return HomeScreen();
            }  else {
              return AuthScreen();
            }
          },
        ),
      ),
    );

/*
    return Container(
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          // do stuff here based on BlocA's state
//          if (state is LoginFinishedSuccessfully) {
//            PostsCubit postsCubit = PostsCubit.instance(context);
//            LoginCubit loginCubit = LoginCubit.instance(context);
//          }
        },
        builder: (context, state) {
          // return widget here based on BlocA's state

          if (state is LoginFinishedSuccessfully) {
            return HomeScreen();
          }  else {
            return AuthScreen();
          }
        },
      ),
    );


 */
  }
}
