import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:speed_and_success/Screens/profile_page.dart';
import 'package:speed_and_success/Widgets/common/app_drawer.dart';
import 'package:speed_and_success/helpers/logout.dart';
import 'courses_page.dart';

class HomeScreen extends StatefulWidget {
  final NotificationAppLaunchDetails? notificationAppLaunchDetails;

  HomeScreen({this.notificationAppLaunchDetails});

  static const String routeName = 'home_screen';

  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  List<Widget> pages = [CoursesPage(), ProfilePage()];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("S square"),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        iconSize: 18,
        selectedFontSize: 18,
        unselectedFontSize: 14,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_sharp),
              label: 'Courses',
              tooltip: 'Your applied courses'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: 'Profile', tooltip: 'Your profile'),
        ],
      ),
      body: pages[currentIndex],
    );
  }
}
