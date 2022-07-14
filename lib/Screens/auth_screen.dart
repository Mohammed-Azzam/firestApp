// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:speed_and_success/Widgets/auth/auth_app_logo.dart';
// import 'package:speed_and_success/Widgets/auth/auth_form.dart';
// import 'package:speed_and_success/helpers/sizes_helpers.dart';
//
// import '../constants.dart';
//
// class AuthScreen extends StatefulWidget {
//   @override
//   _AuthScreenState createState() => _AuthScreenState();
// }
//
// class _AuthScreenState extends State<AuthScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final h = displayHeight(context);
//     final w = displayWidth(context);
//     return Scaffold(
//       body: Container(
//         height: double.infinity,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage(
//               'assets/images/background8.jpg',
//             ),
//             fit: BoxFit.fill,
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(
//                   top: 55.0,
//                 ),
//                 child: Column(children: [
//                   AuthAppLogo(
//                     w: w,
//                     h: h,
//                     key: ValueKey('AuthAppLogo'),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'Speed and Success',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: darkYellow,
//                           fontSize: 25),
//                     ),
//                   )
//                 ]),
//               ),
//               Flexible(
//                 fit: FlexFit.loose,
//                 child: Center(
//                   child: AuthForm(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:speed_and_success/Widgets/auth/auth_app_logo.dart';
import 'package:speed_and_success/Widgets/auth/auth_form.dart';
import '../constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  final NotificationAppLaunchDetails? notificationAppLaunchDetails;

  AuthScreen({ this.notificationAppLaunchDetails});

  static const String routeName = 'auth_screen';

  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    // double h = displayHeight(context);
    // double w = displayWidth(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/background8.jpg',
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 60.0,
                  ),
                  child: Column(children: [
                    AuthAppLogo(
                      w: 140,
                      h: 140,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'S square',
                      style: TextStyle(
                        color: darkYellow,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ]),
                ),
                SizedBox(
                  height: 30,
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Center(
                    child: AuthForm(),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
