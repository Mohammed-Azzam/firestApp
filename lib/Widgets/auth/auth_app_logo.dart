import 'package:flutter/material.dart';
import 'package:speed_and_success/Widgets/common/logoIcon.dart';

import '../../constants.dart';

class AuthAppLogo extends StatelessWidget {
  const AuthAppLogo({
    required this.w,
    required this.h,
  }) ;

  final double w;
  final double h;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: metalicGolden,
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            metalicGolden,
            metalicGolden,
            metalicGolden,
            metalicGolden,
            metalicGolden,
            metalicGolden,
            metalicGolden,
            metalicGolden,
            metalicGolden,
            metalicGolden,
            metalicGolden.withOpacity(0.2),
            metalicGolden.withOpacity(0.2),
            Colors.red,
          ],
        ),
      ),
      height: h,
      width: w,
      padding: EdgeInsets.all(15),
      child: LogoAsIcon(
        height: 95,
        width: 95,
        iconLocation: 'assets/icons/speed_and_success.png',
      ),
    );
  }
}
