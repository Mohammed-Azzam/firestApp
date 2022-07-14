import 'package:flutter/material.dart';
import 'package:speed_and_success/Screens/landing_screen.dart';
import 'package:speed_and_success/StateManagement/blocs/login_cubit.dart';

import '../constants.dart';

void logout(BuildContext context) {
  print('logout called');
  storage.delete(key: 'jwt');
  jwt='';
  LoginCubit loginCubit = LoginCubit.instance(context);
  loginCubit.init();
  loginCubit.emit(LogoutState());
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => LandingScreen()));
}
