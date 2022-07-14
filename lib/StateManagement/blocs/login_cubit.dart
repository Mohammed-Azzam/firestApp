import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:speed_and_success/Widgets/common/dialogs.dart';
import 'package:speed_and_success/Widgets/common/rounded_button.dart';
import 'package:speed_and_success/constants.dart';
import 'package:speed_and_success/flutter_wordpress-0.2.1/flutter_wordpress.dart';
import 'package:speed_and_success/flutter_wordpress-0.2.1/schemas/user.dart';
import 'package:speed_and_success/helpers/logout.dart';
import 'package:speed_and_success/helpers/remove_html_tags.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginStateInitial());

  User? wpUser;
  Map<String, int> userCategories = {};
  List<String> catNames = [];
  List<String> catDescriptiveNames = [];
  List<int> catNumbers = [];
  List<String> catUrls = [];
  List<String> catDrs = [];
  List<String>? rolesList = [];
  List<Category> catList = [];

  static LoginCubit instance(BuildContext context) => BlocProvider.of(context);

  Future<bool> internetChecks(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      Dialogs().showErrorDialog(context,
          errorStatement: 'please, check the internet connectivity');
      return false;
    }
  }

  void init() {
    userCategories = {};
    catNames = [];
    catNumbers = [];
    rolesList = [];
//    List<Category> catList = [];
    catUrls = [];
    catDrs = [];
  }

  Future<void> authenticateLogin(
      BuildContext context, String userName, String pass) async {
    bool internetIsConnected = await internetChecks(context);
    if (internetIsConnected) {
      emit(LoginStarted());

      Future<User> response = myWordPress.authenticateUser(
        username: userName,
        password: pass,
      );
      response.then((user) {
        wpUser = user;
        print(myWordPress.getToken());

        _verifyUserDevice(user.id, deviceUuid).then((verifyResponse) {
          if (verifyResponse == 'matched') {
            _mapRolesToCategories().then((value) {
              emit(LoginFinishedSuccessfully(
                wpUser: wpUser!,
                catNames: catNames,
                rolesList: rolesList!,
                userCategories: userCategories,
                catNumbers: catNumbers,
                catUrls: catUrls,
                catDrs: catDrs,
                catDescriptiveNames: catDescriptiveNames,
              ));
              storage.write(
                key: 'jwt',
                value: myWordPress.getToken(),
                iOptions:
                    IOSOptions(accessibility: IOSAccessibility.first_unlock),
              );
            });
          } else if (verifyResponse == 'first_time') {
            //&& isFirstTimeLogin) {
            _addUserDevice(user.id, deviceUuid).then((value) {
              _mapRolesToCategories().then((value) {
                emit(LoginFinishedSuccessfully(
                  wpUser: wpUser!,
                  catNames: catNames,
                  rolesList: rolesList!,
                  userCategories: userCategories,
                  catNumbers: catNumbers,
                  catUrls: catUrls,
                  catDrs: catDrs,
                  catDescriptiveNames: catDescriptiveNames,
                ));
                storage.write(
                  key: 'jwt',
                  value: myWordPress.getToken(),
                  iOptions:
                      IOSOptions(accessibility: IOSAccessibility.first_unlock),
                );
                // storage.write(key: "isFTLogin", value: 'true');
              });
            });
          } else {
            logout(context);
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Policy Error'),
                    content:
                        Text('Sorry this account is used by another person'),
                    actions: [
                      RoundedButton(
                        text: 'Ok',
                        heightRatio: 0.05,
                        press: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
            emit(LoginFinishedWithPolicy());
          }
        });
      }).catchError((err) {
        print('Failed to fetch user: $err');
        print('err type:${err.runtimeType}');
        emit(LoginFinishedWithError());
        WordPressError e = err;
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Login Error'),
                content: Text(
                    '${json.decode(removeAllHtmlTags(e.message!))['message'] ?? 'Please try again'}'),
                actions: [
                  RoundedButton(
                    text: 'Ok',
                    heightRatio: 0.05,
                    press: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      });
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Network Error'),
              content: Text('Please check your network adaptor'),
              actions: [
                RoundedButton(
                  text: 'Ok',
                  heightRatio: 0.05,
                  press: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  Future<void> sessionValidate(BuildContext context) async {
    bool internetIsConnected = await internetChecks(context);
    if (internetIsConnected) {
      print('from validation jwt function: '
          '\n    jwt is ${jwt.isEmpty ? 'empty' : 'not empty'}');
      if (jwt.isNotEmpty) {
        emit(LoginStarted());
        Future<User> response = myWordPress.authenticateViaToken(jwt);
        response.then((user) {
          wpUser = user;

          _verifyUserDevice(user.id, deviceUuid).then((verifyResponse) {
            if (verifyResponse == 'matched') {
              print('matched>> approve login');
              _mapRolesToCategories().then((value) {
                emit(LoginFinishedSuccessfully(
                  wpUser: wpUser!,
                  catNames: catNames,
                  rolesList: rolesList!,
                  userCategories: userCategories,
                  catNumbers: catNumbers,
                  catUrls: catUrls,
                  catDrs: catDrs,
                  catDescriptiveNames: catDescriptiveNames,
                ));
                // print('after verified user device jwt: ${myWordPress.getToken()}');
                // storage.write(
                //   key: 'jwt',
                //   value: myWordPress.getToken(),
                //   iOptions: IOSOptions(accessibility: IOSAccessibility.first_unlock),
                // );
              });
            } else if (verifyResponse == 'first_time') {
              //&& isFirstTimeLogin) {
              print('first time>> approve login');

              _addUserDevice(user.id, deviceUuid).then((value) {
                _mapRolesToCategories().then((value) {
                  emit(LoginFinishedSuccessfully(
                    wpUser: wpUser!,
                    catNames: catNames,
                    rolesList: rolesList!,
                    userCategories: userCategories,
                    catNumbers: catNumbers,
                    catUrls: catUrls,
                    catDrs: catDrs,
                    catDescriptiveNames: catDescriptiveNames,
                  ));
                  storage.write(
                    key: 'jwt',
                    value: myWordPress.getToken(),
                    iOptions: IOSOptions(
                        accessibility: IOSAccessibility.first_unlock),
                  );
                  // storage.write(key: "isFTLogin", value: 'true');
                });
              });
            } else {
              print('not matched>> denied login');
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Policy Error'),
                      content:
                          Text('Sorry this account is used by another person'),
                      actions: [
                        RoundedButton(
                          text: 'Ok',
                          heightRatio: 0.05,
                          press: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
              // logout(context);
              emit(LoginFinishedWithPolicy());
            }
          });

          // _mapRolesToCategories().then((value) {
          //   emit(LoginFinishedSuccessfully(
          //     wpUser: wpUser!,
          //     catNames: catNames,
          //     rolesList: rolesList!,
          //     userCategories: userCategories,
          //     catNumbers: catNumbers,
          //     catUrls: catUrls,
          //     catDrs: catDrs,
          //   ));
          // });
          //
        }).catchError((err) {
          print('Failed to fetch user: ${err.message}');
          emit(LoginFinishedWithError());
        });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Network Error'),
              content: Text('Please check your network adaptor'),
              actions: [
                RoundedButton(
                  text: 'Ok',
                  heightRatio: 0.05,
                  press: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  Future<Map<String, int>> _getCategories() async {
    catList = await myWordPress.fetchCategories(
        params:
            ParamsCategoryList(orderBy: CategoryTagOrderBy.name, perPage: 100));

    Map<String, int> catMap = {};
    catList.forEach((element) {
      String catName = element.name.toLowerCase().replaceAll(RegExp(r' '), '_');
      catMap[catName] = element.id;
    });
    return catMap;
  }

  Future<void> _mapRolesToCategories() async {
    Map<String, int> catMap = await _getCategories();
    print('all Categories: $catMap');
    rolesList = wpUser!.roles;
    print('all roles for current user: $rolesList');
    rolesList!.forEach((role) {
      if (catMap.containsKey(role)) {
        catNames.add(role);
        catNumbers.add(catMap[role] ?? 0);
        String description = (catList
                .where((element) => element.id == catMap[role])
                .first
                .description) ??
            '';
        List splitDescription= description.split(',');
        print('split');
        print(splitDescription.length);
        String url = (splitDescription.length>=0)?splitDescription[0]:"";
        String subject = (splitDescription.length>=2)?splitDescription[1]:"subject";
        String dr = (splitDescription.length>=3)?splitDescription[2]:"Dr";
        print(description + "\t" + url + "\t" + dr + "\t" + subject);
        catDescriptiveNames.add(subject);
        catUrls.add(url);
        catDrs.add(dr);
        userCategories[role] = catMap[role] ?? 0;
      }
    });
    // catMap.forEach((key, value) {
    //   catNames.add(key);
    //   catNumbers.add(value);
    //   userCategories[key]=value;
    // });
    // emit(MapReady());
  }

  Future<bool> _addUserDevice(userId, uuid) async {
    /*
    final String url =
        'https://speedandsuccessphone.website/api.php?cmd=add_user_device&user_id=$userId&uuid=$uuid&release=${release.toString()}&brand=${brand.toString()}&model=${model.toString()}';

   */
    //final String url =' https://speedandsuccessphone.website/api.php?cmd=add_user_device&amp;user_id=6&amp;uuid=uuid&amp;app_version=app_version&amp;brand=brand&amp;modal=modal' ;
    final String url =
        'https://speedandsuccessphone.website/api.php?cmd=add_user_device&user_id=$userId&uuid=$uuid&app_version=${app_version.toString()}&brand=${brand.toString()}&modal=${model.toString()}';
    print('$url');
    final response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      final j = json.decode(response.body);
      final r = j['response'];
      if (r == 'success') {
        return true;
      } else {
        return false;
      }
    } else {
      print('error: in add user device');
      return false;
    }
  }

  Future<String> _verifyUserDevice(userId, uuid) async {
    final String url =
        'https://speedandsuccessphone.website/api.php?cmd=verify_user_device&user_id=$userId&uuid=$uuid&app_version=${app_version.toString()}&brand=${brand.toString()}&modal=${model.toString()}';
    final response =
        await http.get(Uri.parse(url), headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      final j = json.decode(response.body);
      final r = j['response'];
      print('verifyUserDevice:$r');
      return r;
    } else {
      print('error: in verify user device');
      return 'error';
    }
  }
}
