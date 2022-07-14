part of 'login_cubit.dart';

abstract class LoginStates {
  const LoginStates();
}

class LoginStateInitial extends LoginStates {}

class LoginStarted extends LoginStates {}

class LoginFinishedSuccessfully extends LoginStates {
  final User wpUser;
  final Map<String, int> userCategories;
  final List<String> catNames;
  final List<int> catNumbers;
  final List<String> rolesList;
  final List<String> catUrls;
  final List<String> catDrs;
  final List<String> catDescriptiveNames;

  LoginFinishedSuccessfully({
    required this.wpUser,
    required this.userCategories,
    required this.catNames,
    required this.catNumbers,
    required this.rolesList,
    required this.catUrls,
    required this.catDrs,
    required this.catDescriptiveNames,
  });
}

class LoginFinishedWithError extends LoginStates {}

class LoginFinishedWithPolicy extends LoginStates {}

class MapReady extends LoginStates {}

class LogoutState extends LoginStates {}
