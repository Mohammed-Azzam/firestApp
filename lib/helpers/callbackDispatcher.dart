import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speed_and_success/DataModels/recieved_notification.dart';
import 'package:speed_and_success/Screens/landing_screen.dart';
import 'package:speed_and_success/StateManagement/blocs/posts_cubit.dart';
import 'package:speed_and_success/flutter_wordpress-0.2.1/constants.dart';
import 'package:speed_and_success/flutter_wordpress-0.2.1/requests/params_post_list.dart';
import 'package:speed_and_success/flutter_wordpress-0.2.1/schemas/post.dart';
import 'package:speed_and_success/helpers/notification_manager.dart';
import 'package:workmanager/workmanager.dart';

import '../constants.dart';
import 'config_local_time_zone.dart';
import 'internet_check.dart';

Future<void> pushMyNotification(
    Post post, Map<String, dynamic>? inputData) async {
  const String groupKey = 'com.android.example.WORK_EMAIL';
  const String groupChannelId = 'grouped channel id';
  const String groupChannelName = 'grouped channel name';
  const String groupChannelDescription = 'grouped channel description';
  //push notification
  NotificationManager nm = NotificationManager.notificationManager;
  final String largeIconPath = await nm.downloadAndSaveFile(
      (post.featuredMedia!.sourceUrl) ??
          'https://via.placeholder.com/128x128/00FF00/000000',
      post.title!.rendered ??
          ('${inputData!['userName']}${inputData['categoryName']}'));

  AndroidNotificationDetails firstNotificationAndroidSpecifics =
      AndroidNotificationDetails(
    groupChannelId,
    groupChannelName,
    channelDescription: groupChannelDescription,
    importance: Importance.max,
    priority: Priority.high,
    groupKey: groupKey,
    largeIcon: FilePathAndroidBitmap(largeIconPath),
    styleInformation: const MediaStyleInformation(),
  );

  IOSNotificationDetails firstNotificationIosSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      attachments: [IOSNotificationAttachment(largeIconPath)]);
  NotificationDetails firstNotificationPlatformSpecifics = NotificationDetails(
      android: firstNotificationAndroidSpecifics,
      iOS: firstNotificationIosSpecifics);
  print('Start showing the notification');
  await flutterLocalNotificationsPlugin
      .show(
          post.id!,
          post.title!.rendered,
          'New lesson added in ${inputData!['categoryName']} \n Keep the hard work',
          firstNotificationPlatformSpecifics)
      .then((value) {
    print('Done showing the notification');
  });
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print('start execute task: $task');
    ParamsPostList paramsPostList = ParamsPostList(
        context: WordPressContext.view,
        orderBy: PostOrderBy.date,
        order: Order.asc,
        postStatus: PostPageStatus.publish,
        perPage: 100,
        includeCategories: [inputData!['categoryNum']]);

    bool internetIsConnected = await internetChecks();
    print('done checking internet: $internetIsConnected');

    if (internetIsConnected) {
      List<Post> postsList = await myWordPress
          .fetchPosts(
        postParams: paramsPostList,
        fetchFeaturedMedia: true,
      )
          .catchError((e) {
        print('catch error in fetching posts');
      });

      await configureLocalTimeZone();
      final NotificationAppLaunchDetails? notificationAppLaunchDetails =
          await flutterLocalNotificationsPlugin
              .getNotificationAppLaunchDetails();
      String initialRoute = LandingScreen.routeName;
      if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
        selectedNotificationPayload = notificationAppLaunchDetails!.payload;
        initialRoute = LandingScreen.routeName;
      }

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('speed_and_success');
      final IOSInitializationSettings initializationSettingsIOS =
          IOSInitializationSettings(
              requestAlertPermission: false,
              requestBadgePermission: false,
              requestSoundPermission: false,
              onDidReceiveLocalNotification: (
                int id,
                String? title,
                String? body,
                String? payload,
              ) async {
                didReceiveLocalNotificationSubject.add(
                  ReceivedNotification(
                    id: id,
                    title: title,
                    body: body,
                    payload: payload,
                  ),
                );
              });
      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: (String? payload) async {
        if (payload != null) {
          debugPrint('notification payload: $payload');
        }
        selectedNotificationPayload = payload;
        selectNotificationSubject.add(payload);
      });

      switch (task) {
        case notificationTask:
          print("$notificationTask was executed. inputData = $inputData");
          print('android');

          print('length of posts list is ${postsList.length}');

          // postsList.forEach((element) async {
          //  print((element.title!.rendered!) + ' ' + (element.date!));
          //
          //  DateTime postDate = DateTime.parse(element.date!);
          //  if (DateTime.now().difference(postDate) <= Duration(minutes: 15)) {
          //    print('Post: ${element.title!.rendered}');
          //  }
          //  print(
          //      'Notification: id: ${element.id}, title: ${element.title!
          //          .rendered}, slug: ${element.slug}');
          //
          //  NotificationManager().showCourseNotification(element, inputData);
          //  // }
          //  });
          for (int i = 0; i < postsList.length; i++) {
            Post element = postsList[i];

            DateTime postDate = DateTime.parse(
                element.date!); // server is UTC, so must convert it

            int diff = DateTime.now().difference(postDate).inMinutes;
            print(
                'post:${(element.title!.rendered!)}: ${(element.date!)},and now: ${DateTime.now()}, and diff from now: $diff min');
            if (diff <= 29) {
              print('Post: ${element.title!.rendered}');
              await NotificationManager()
                  .showCourseNotification(element, inputData);
            }
            print(
                'Notification: id: ${element.id}, title: ${element.title!.rendered}, slug: ${element.slug}');
          }

          break;
        case Workmanager.iOSBackgroundTask:
          print("The iOS background fetch was triggered");
          print("$notificationTask was executed. inputData = $inputData");
          print('ios');

          print('length of posts list is ${postsList.length}');
          for (int i = 0; i < postsList.length; i++) {
            Post element = postsList[i];
            print((element.title!.rendered!) + ' ' + (element.date!));

            DateTime postDate = DateTime.parse(element.date!);
            int diff = DateTime.now().difference(postDate).inMinutes;
            print(
                'post:${(element.title!.rendered!)}: ${(element.date!)},and now: ${DateTime.now()}, and diff from now: $diff min');
            if (diff <= 29) {
              print('Post: ${element.title!.rendered}');
              await NotificationManager()
                  .showCourseNotification(element, inputData);
            }
            print(
                'Notification: id: ${element.id}, title: ${element.title!.rendered}, slug: ${element.slug}');
          }

          break;
      }
    }
    return true;
  });
}
