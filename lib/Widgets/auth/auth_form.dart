
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:speed_and_success/Screens/visit_screen3.dart';
import 'package:speed_and_success/StateManagement/blocs/login_cubit.dart';
import 'package:speed_and_success/StateManagement/blocs/visit_cubit.dart';
import 'package:speed_and_success/Widgets/auth/rounded_input_field.dart';
import 'package:speed_and_success/Widgets/auth/rounded_password_field.dart';
import 'package:speed_and_success/Widgets/common/rounded_button.dart';

class AuthForm extends StatelessWidget {
   String? _userName;
  String? _password;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final LoginCubit cubit = LoginCubit.instance(context);

    Future<void> trySubmit() async {
      bool isValid = _formKey.currentState!.validate();
      if (isValid) {
        _formKey.currentState!.save();
        print(_userName);
        print(_password);
        LoginCubit.instance(context)
            .authenticateLogin(context, _userName!, _password!);
      } else {
        print('Is not valid');
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Please check your inputs'),
                title: Text('Not valid inputs'),
                actions: [
                  RoundedButton(
                    text: 'Ok',
                    press: () {
                      Navigator.of(context).pop();
                    },
                    heightRatio: 0.06,
                    widthRatio: 0.35,
                  ),
                ],
              );
            });
      }
      print('Valid:' + isValid.toString());
    }

    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      margin: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 20),
      //height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black54.withOpacity(0.35),
        border: Border.all(width: 1, color: Colors.transparent),
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          // color: Colors.black54.withOpacity(0.35),

          border: Border.all(width: 1, color: Colors.transparent),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              RoundedInputField(
                key: ValueKey('UserName'),
                labelText: 'UserName',
                keyboardType: TextInputType.name,
                icon: Icons.email,
                validator: (value) {
                  if (value!.isEmpty) {
                    print('please enter non empty email');
                    return 'please enter non empty email';
                  }
                  return null;
                },
                onSave: (value) {
                  _userName = value!;
                },
              ),
              RoundedPasswordField(
                key: ValueKey('Password'),
                labelText: 'Password',
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) {
                    print('please enter non empty password');
                    return 'please enter non empty password';
                  } else if (value.length < 6) {
                    print('please enter stronger password');
                    return 'please enter stronger password';
                  }
                  return null;
                },
                onSave: (value) {
                  _password = value!;
                },
              ),
              (cubit.state is LoginStarted)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RaisedButton(
                      child: Text('Login'),
                      onPressed: trySubmit,
                      textTheme: ButtonTextTheme.primary,
                      //colorBrightness: Brightness.dark,
                    ),
              FittedBox(
                child: FlatButton(
                  colorBrightness: Brightness.dark,
                  onPressed: () {
                    // VisitCubit.instance(context).getDoctorsMap(context);
                    VisitCubit.instance(context).getHtmlContent();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => VisitScreen3()));
                  },
                  child: Text(
                    'Quick visit',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
