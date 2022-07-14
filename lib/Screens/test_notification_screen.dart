import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:speed_and_success/DataModels/recieved_notification.dart';
import 'package:speed_and_success/Screens/landing_screen.dart';

import '../constants.dart';
import 'package:speed_and_success/helpers/notification_manager.dart';

const MethodChannel platform = MethodChannel('dexterx.dev/flutter_local_notifications_example');

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    this.notificationAppLaunchDetails,
    Key? key,
  }) : super(key: key);

  static const String routeName = 'notification_screen';

  final NotificationAppLaunchDetails? notificationAppLaunchDetails;

  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
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
    final NotificationManager nm = NotificationManager.notificationManager;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Notification settings'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Text('Tap on a notification when it appears to trigger'
                        ' navigation'),
                  ),
                  _InfoValueString(
                    title: 'Did notification launch app?',
                    value: widget.didNotificationLaunchApp,
                  ),
                  if (widget.didNotificationLaunchApp)
                    _InfoValueString(
                      title: 'Launch notification payload:',
                      value: widget.notificationAppLaunchDetails!.payload,
                    ),
                  PaddedElevatedButton(
                    buttonText: 'Show plain notification with payload',
                    onPressed: () async {
                      await nm.showNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show plain notification that has no title with '
                        'payload',
                    onPressed: () async {
                      await nm.showNotificationWithNoTitle();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show plain notification that has no body with '
                        'payload',
                    onPressed: () async {
                      await nm.showNotificationWithNoBody();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Show notification with custom sound',
                    onPressed: () async {
                      await nm.showNotificationCustomSound();
                    },
                  ),
                  if (!kIsWeb && !Platform.isLinux) ...<Widget>[
                    PaddedElevatedButton(
                      buttonText: 'Schedule notification to appear in 5 seconds '
                          'based on local time zone',
                      onPressed: () async {
                        await NotificationManager().zonedScheduleNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Repeat notification every minute',
                      onPressed: () async {
                        await nm.repeatNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Schedule daily 10:00:00 am notification in your '
                          'local time zone',
                      onPressed: () async {
                        await nm.scheduleDailyTenAMNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Schedule daily 10:00:00 am notification in your '
                          "local time zone using last year's date",
                      onPressed: () async {
                        await nm.scheduleDailyTenAMLastYearNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Schedule weekly 10:00:00 am notification in your '
                          'local time zone',
                      onPressed: () async {
                        await nm.scheduleWeeklyTenAMNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Schedule weekly Monday 10:00:00 am notification '
                          'in your local time zone',
                      onPressed: () async {
                        await nm.scheduleWeeklyMondayTenAMNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Check pending notifications',
                      onPressed: () async {
                        await nm.checkPendingNotificationRequests(context);
                      },
                    ),
                  ],
                  PaddedElevatedButton(
                    buttonText: 'Show notification with no sound',
                    onPressed: () async {
                      await nm.showNotificationWithNoSound();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Cancel notification',
                    onPressed: () async {
                      await nm.cancelNotification();
                    },
                  ),
                  PaddedElevatedButton(
                    buttonText: 'Cancel all notifications',
                    onPressed: () async {
                      await nm.cancelAllNotifications();
                    },
                  ),
                  if (!kIsWeb && Platform.isAndroid) ...<Widget>[
                    const Text(
                      'Android-specific examples',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show plain notification with payload and update '
                          'channel description',
                      onPressed: () async {
                        await nm.showNotificationUpdateChannelDescription();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show plain notification as public on every '
                          'lockscreen',
                      onPressed: () async {
                        await nm.showPublicNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with custom vibration pattern, '
                          'red LED and red icon',
                      onPressed: () async {
                        await nm.showNotificationCustomVibrationIconLed();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification using Android Uri sound',
                      onPressed: () async {
                        await nm.showSoundUriNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification that times out after 3 seconds',
                      onPressed: () async {
                        await nm.showTimeoutNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show insistent notification',
                      onPressed: () async {
                        await nm.showInsistentNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show big picture notification using local images',
                      onPressed: () async {
                        await nm.showBigPictureNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show big picture notification using base64 String '
                          'for images',
                      onPressed: () async {
                        await nm.showBigPictureNotificationBase64();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show big picture notification using URLs for '
                          'Images',
                      onPressed: () async {
                        await nm.showBigPictureNotificationURL();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show big picture notification, hide large icon '
                          'on expand',
                      onPressed: () async {
                        await nm.showBigPictureNotificationHiddenLargeIcon();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show media notification',
                      onPressed: () async {
                        await nm.showNotificationMediaStyle();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show big text notification',
                      onPressed: () async {
                        await nm.showBigTextNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show inbox notification',
                      onPressed: () async {
                        await nm.showInboxNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show messaging notification',
                      onPressed: () async {
                        await nm.showMessagingNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show grouped notifications',
                      onPressed: () async {
                        await nm.showGroupedNotifications();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with tag',
                      onPressed: () async {
                        await nm.showNotificationWithTag();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Cancel notification with tag',
                      onPressed: () async {
                        await nm.cancelNotificationWithTag();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show ongoing notification',
                      onPressed: () async {
                        await nm.showOngoingNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with no badge, alert only once',
                      onPressed: () async {
                        await nm.showNotificationWithNoBadge();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show progress notification - updates every second',
                      onPressed: () async {
                        await nm.showProgressNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show indeterminate progress notification',
                      onPressed: () async {
                        await nm.showIndeterminateProgressNotification();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification without timestamp',
                      onPressed: () async {
                        await nm.showNotificationWithoutTimestamp();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with custom timestamp',
                      onPressed: () async {
                        await nm.showNotificationWithCustomTimestamp();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with custom sub-text',
                      onPressed: () async {
                        await nm.showNotificationWithCustomSubText();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with chronometer',
                      onPressed: () async {
                        await nm.showNotificationWithChronometer();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show full-screen notification',
                      onPressed: () async {
                        await nm.showFullScreenNotification(context);
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Create grouped notification channels',
                      onPressed: () async {
                        await nm.createNotificationChannelGroup(context);
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Delete notification channel group',
                      onPressed: () async {
                        await nm.deleteNotificationChannelGroup(context);
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Create notification channel',
                      onPressed: () async {
                        await nm.createNotificationChannel(context);
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Delete notification channel',
                      onPressed: () async {
                        await nm.deleteNotificationChannel(context);
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Get notification channels',
                      onPressed: () async {
                        await nm.getNotificationChannels(context);
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Get active notifications',
                      onPressed: () async {
                        await nm.getActiveNotifications(context);
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Start foreground service',
                      onPressed: () async {
                        await nm.startForegroundService();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Stop foreground service',
                      onPressed: () async {
                        await nm.stopForegroundService();
                      },
                    ),
                  ],
                  if (!kIsWeb && (Platform.isIOS || Platform.isMacOS)) ...<Widget>[
                    const Text(
                      'iOS and macOS-specific examples',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with subtitle',
                      onPressed: () async {
                        await nm.showNotificationWithSubtitle();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with icon badge',
                      onPressed: () async {
                        await nm.showNotificationWithIconBadge();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notification with attachment',
                      onPressed: () async {
                        await nm.showNotificationWithAttachment();
                      },
                    ),
                    PaddedElevatedButton(
                      buttonText: 'Show notifications with thread identifier',
                      onPressed: () async {
                        await nm.showNotificationsWithThreadIdentifier();
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoValueString extends StatelessWidget {
  const _InfoValueString({
    required this.title,
    required this.value,
    Key? key,
  }) : super(key: key);

  final String title;
  final Object? value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: Text.rich(
          TextSpan(
            children: <InlineSpan>[
              TextSpan(
                text: '$title ',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: '$value',
              )
            ],
          ),
        ),
      );
}

class PaddedElevatedButton extends StatelessWidget {
  const PaddedElevatedButton({
    required this.buttonText,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      );
}
