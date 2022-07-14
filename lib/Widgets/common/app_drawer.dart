import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:speed_and_success/Screens/courses_page.dart';
import 'package:speed_and_success/Screens/profile_page.dart';
import 'package:speed_and_success/StateManagement/blocs/login_cubit.dart';
import 'package:speed_and_success/helpers/logout.dart';

class AppDrawer extends StatelessWidget {
  final Function? onDrawerClicked;

  const AppDrawer({Key? key, this.onDrawerClicked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginCubit cubit = LoginCubit.instance(context);
    return SafeArea(
      child: ClipPath(
        clipper: _CustomClipper(),
        child: Drawer(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40),
                  ),
                ),
                height: 90,
                width: double.infinity,
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: cubit.wpUser!.avatarUrls!.s96!,
                      placeholder: (context, s) {
                        return Container(
                          height: 90,
                          width: 90,
                          color: Colors.lightGreen,
                        );
                      },
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hi, ${cubit.wpUser!.name}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          // FittedBox(
                          //   child: Padding(
                          //     padding:
                          //         const EdgeInsets.symmetric(horizontal: 8.0),
                          //     child: Text(
                          //       '${cubit.wpUser!.email ?? ''}',
                          //       style: TextStyle(
                          //         fontSize: 16,
                          //         color: Theme.of(context).primaryColor,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    )
                  ],
                ),

                // child: ListTile(
                //   leading: CachedNetworkImage(
                //       imageUrl: cubit.wpUser!.avatarUrls!.s96!),
                //   title: Text(
                //     'Hi, ${cubit.wpUser!.name}',
                //   ),
                //   subtitle: Text(
                //     '${cubit.wpUser!.email}',
                //   ),
                // ),
              ),
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AppDrawerItem(
                        title: 'Profile',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Scaffold(
                                    body: ProfilePage(),
                                    appBar: AppBar(
                                      title: Text('Profile'),
                                    ),
                                  )));
                        },
                        iconData: Icons.person,
                      ),
                      // AppDrawerItem(
                      //   title: 'Doctors',
                      //   onTap: () {
                      //     VisitCubit.instance(context).getDoctorsMap(context);
                      //     VisitCubit.instance(context).getHtmlContent();
                      //     Navigator.of(context)
                      //         .push(MaterialPageRoute(builder: (context) => VisitScreen2()));
                      //   },
                      //   iconData: Icons.groups,
                      // ),
                      AppDrawerItem(
                        title: 'Courses',
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Scaffold(
                                    body: CoursesPage(),
                                    appBar: AppBar(
                                      title: Text('Courses'),
                                    ),
                                  )));
                        },
                        iconData: Icons.menu_book_rounded,
                      ),
                      // AppDrawerItem(
                      //   title: 'Notification center',
                      //   onTap: () => Navigator.of(context).pushNamed(NotificationScreen.routeName),
                      //   iconData: Icons.notifications_active_outlined,
                      // ),
                      AppDrawerItem(
                        title: 'Logout',
                        onTap: () => logout(context),
                        iconData: Icons.logout,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                  ),
                  child: Column(children: [
                    Text(
                      'S square',
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: Image.asset('assets/icons/speed_and_success.png')),
                  ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AppDrawerItem extends StatelessWidget {
  final String? title;
  final Function()? onTap;
  final IconData? iconData;

  AppDrawerItem({
    this.onTap,
    this.title,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: InkWell(
        splashColor: Colors.grey,
        child: ListTile(
          title: Text(
            title!,
            style: TextStyle(fontSize: 18),
          ),
          leading: Icon(
            iconData,
            size: 25,
            color: Theme.of(context).primaryColor,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _CustomClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    double shift = 0.0;
    path.moveTo(size.width - shift, 0);
    path.quadraticBezierTo(size.width, size.height / 2, size.width - shift, size.height);
    // path.lineTo(size.width,size.height/2 );
    // path.lineTo(size.width-50,size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}
