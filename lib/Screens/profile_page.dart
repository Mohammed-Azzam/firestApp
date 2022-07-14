import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:speed_and_success/StateManagement/blocs/login_cubit.dart';
import 'package:speed_and_success/flutter_wordpress-0.2.1/schemas/user.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginCubit loginCubit = LoginCubit.instance(context);
    User currentUser = loginCubit.wpUser!;
    return Container(
      padding: EdgeInsets.only(top: 5),
      margin: EdgeInsets.all(5),
      child: Card(
        child: Container(
          margin: EdgeInsets.all(5),
          child: ListView(
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
                      imageUrl: currentUser.avatarUrls!.s96!,
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
                            'Hi, ${currentUser.name}',
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
                          //       '${currentUser.email ?? ''}',
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
              ),

              SizedBox(
                height: 20,
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {0: FractionColumnWidth(0.3), 1: FractionColumnWidth(0.7)},
                children: [
                  //user id
                  buildTableRow('User Id', currentUser.id),
                  //user name
                  buildTableRow('User Name', currentUser.username),
                  // email
                  // buildTableRow('E-mail', currentUser.email),
                  // //first name
                  // buildTableRow('First Name', currentUser.firstName),
                  // //last name
                  // buildTableRow('Last Name', currentUser.lastName),
                  // //registered date
                  // buildTableRow('Registered date', currentUser.registeredDate),
                  // //roles
                  // buildTableRow('Roles', currentUser.roles, height: 100.0),
                ],
              ),

              // Text('User is Admin: ${currentUser.extraCapabilities!.administrator}'),

            ],
          ),
        ),
      ),
    );
  }

  TableRow buildTableRow(String name, dynamic value,
      {double height = 50.0, double fontSize = 18.0}) {
    return TableRow(decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)), children: [
      Column(children: [
        Container(
          height: height,
          alignment: Alignment.topLeft,
          width: double.infinity,
          child: Text(
            '$name',
            softWrap: true,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
        ),
      ]),
      Container(
        height: height,
        // color: Colors.red,
        alignment: Alignment.topLeft,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                width: double.infinity,
                child: Text(
                  '$value',
                  softWrap: true,
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }
}
