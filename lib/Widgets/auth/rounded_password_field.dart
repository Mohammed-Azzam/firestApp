import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speed_and_success/Widgets/auth/text_field_container.dart';
import 'package:speed_and_success/helpers/sizes_helpers.dart';
import '../../constants.dart';

class RoundedPasswordField extends StatefulWidget {
  @override
  _RoundedPasswordFieldState createState() {
    return _RoundedPasswordFieldState();
  }

  final ValueChanged<String>? onChanged;
  final String? labelText;
  final String? hintText;
  final ValueChanged<String>? onSubmitted;
  final bool? errorFlag;
  final String? errorText;
  final double? heightRatio;
  final String? Function(String?) ?validator;
  final Function(String?) ?onSave;
  final TextEditingController? controller;

  const RoundedPasswordField({
    Key ?key,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.errorText,
    this.errorFlag = false,
    this.heightRatio= 0.08,
    this.validator,
    this.onSave,
    TextInputType? keyboardType,
    this.controller,
  }) : super(key: key);
}
//final Size size = window.physicalSize;

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool visibleFlag = false;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Stack(
        children: <Widget>[
          TextFieldContainer(
            heightRatio: widget.heightRatio!,
            child: Center(
              child: TextFormField(
                controller: widget.controller,
                validator: widget.validator,
                onSaved: widget.onSave,
                obscureText: !visibleFlag,
                onFieldSubmitted: widget.onSubmitted,
                onChanged: widget.onChanged,
                cursorColor: kPrimaryColorLight,
                scrollPadding: EdgeInsets.all(0),
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  labelStyle: Theme.of(context).textTheme.subtitle2,
                  errorText: widget.errorText,
                  filled: true,
                  fillColor: Colors.transparent,

                  contentPadding: EdgeInsets.only(
                    bottom: displayHeight(context) * 0.02,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  // isCollapsed: true,
                  isDense: true,
                  icon: Icon(
                    Icons.lock,
                    color: kPrimaryColorLight,
                  ),
                  suffixIcon: null,
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Positioned(
            width: displayWidth(context) * 0.15,
            height: widget.heightRatio == null
                ? 65
                : (displayHeight(context) * widget.heightRatio!),
            right: displayWidth(context) * 0.05,
            top: displayHeight(context) * 0.007,
            child: Container(
              decoration: BoxDecoration(
                color:
                    Colors.lightGreen.withOpacity((visibleFlag) ? 0.9 : 0.42),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(displayHeight(context) / 30),
                    bottomRight: Radius.circular(displayHeight(context) / 30)),
              ),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                focusColor: Colors.red,
                splashColor: Colors.red,
                onTap: () {
                  setState(() {
                    visibleFlag ^= true;
                    print(visibleFlag);
                  });
                },
                onTapCancel: () {
                  setState(() {
                    visibleFlag = true;
                  });
                },
                child: Icon(
                  (visibleFlag) ? Icons.visibility : Icons.visibility_off,
                  color: kPrimaryColorLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
