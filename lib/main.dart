import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speed_and_success/Screens/auth_screen.dart';
import 'package:speed_and_success/Screens/home_screen.dart';
import 'package:speed_and_success/Screens/landing_screen.dart';
//import 'package:speed_and_success/Screens/test_notification_screen.dart';
import 'package:speed_and_success/StateManagement/blocs/login_cubit.dart';
import 'package:speed_and_success/StateManagement/blocs/posts_cubit.dart';
import 'package:speed_and_success/StateManagement/blocs/verify_video_cubit.dart';
import 'package:speed_and_success/StateManagement/blocs/visit_cubit.dart';
import 'package:speed_and_success/StateManagement/blocs/zoom_cubit.dart';
import 'package:speed_and_success/thems.dart';

import 'Screens/stopping_screen.dart';
import 'StateManagement/blocs/video_cubit.dart';
import 'constants.dart';
import 'helpers/check_physical_device.dart';

//import 'package:device_information/device_information.dart';
//import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));

  SharedPreferences prefs = await SharedPreferences.getInstance();

  if (!prefs.containsKey('first_run')) {
    print('first run so we delete all records in the secure storage');
    await storage
        .deleteAll()
        .timeout(Duration(seconds: 3))
        .onError((error, stackTrace) {
      print("first run so we delete all error " + error.toString());
    });
    await prefs.setBool('first_run', true);
  }

  if (await storage.containsKey(key: "jwt")) {
    print('from main: read the JWT');
    var j = await storage.read(
      key: "jwt",
      iOptions: IOSOptions(accessibility: IOSAccessibility.first_unlock),
    );
    if (j != null) {
      jwt = j;
      print('jwt: $jwt');
    } else {
      jwt = '';
      print('jwt: no found jwt for last login');
    }
  } else {
    jwt = '';
    print('jwt: no found jwt for last login');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext contextMyApp) {
    final Size size = window.physicalSize;
    final double devicePixelRatio = window.devicePixelRatio;

    return FutureBuilder<bool>(
        future: checkPhysicalDevice(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          print('uuid: $deviceUuid');
          print('model: $model');
          print('brand: $brand');
          print('app_version: $app_version');
          if (snapshot.hasError) print("error " + snapshot.error.toString());
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );

          bool x = false;
          try {
            x = snapshot.data!;
          } catch (e) {}

          return MultiBlocProvider(
            providers: [
              BlocProvider<LoginCubit>(
                create: (BuildContext context) {
                  // return LoginCubit()..sessionValidate(context);
                  return LoginCubit();
                  // return sl<LoginCubit>();
                },
              ),
              BlocProvider<PostsCubit>(
                create: (BuildContext context) {
                  return PostsCubit();
                  // return sl<LoginCubit>();
                },
              ),
              BlocProvider<VisitCubit>(
                create: (BuildContext context) {
                  return VisitCubit();
                  // return sl<LoginCubit>();
                },
              ),
              BlocProvider<VideoCubit>(
                create: (BuildContext context) {
                  return VideoCubit();
                  // return sl<LoginCubit>();
                },
              ),
              BlocProvider<VerifyVideoCubit>(
                create: (BuildContext context) {
                  return VerifyVideoCubit();
                  // return sl<LoginCubit>();
                },
              ),
              BlocProvider<ZoomCubit>(
                create: (BuildContext context) {
                  return ZoomCubit();
                  // return sl<LoginCubit>();
                },
              ),
            ],
            child: MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'S square',
              theme: Themes(size: size, aspectRatio: devicePixelRatio)
                  .themeDataProvider('light'),
              home: x
                  ? LandingScreen()
                  : StoppingScreen(
                      text: 'This app is allowed only on Physical Devices',
                    ),
              // initialRoute: '/',
              routes: {
                LandingScreen.routeName: (_) => LandingScreen(
                    // notificationAppLaunchDetails: notificationAppLaunchDetails,
                    ),
                HomeScreen.routeName: (_) => HomeScreen(
                    // notificationAppLaunchDetails: notificationAppLaunchDetails,
                    ),
                AuthScreen.routeName: (_) => AuthScreen(
                    // notificationAppLaunchDetails: notificationAppLaunchDetails,
                    ),
//                NotificationScreen.routeName: (_) => NotificationScreen(
//                  // notificationAppLaunchDetails: notificationAppLaunchDetails
//                )
              },
            ),
          );
        });
  }
}
