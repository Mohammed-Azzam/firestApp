import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'constants.dart';
export './main.dart';

class Themes {
  final Size size;
  final double aspectRatio;

  Themes({
    required this.size,
    required this.aspectRatio,
  });

  ThemeData themeDataProvider(String themeName) {
    double h = (size.height / aspectRatio) * 1.8;
    double w = (size.width / aspectRatio) * 1.5;
    double s = h * w / (3.3);
    //print('H: '+h.toString());
    //print('W: '+w.toString());

    bool darkFlag = false;
    Color color = kPrimaryColorLight!;
    Brightness brightness = Brightness.light;
    Brightness otherBrightness = Brightness.dark;

    if (themeName == 'dark') {
      darkFlag = true;
      color = Colors.white;
      brightness = Brightness.dark;
    }
    ThemeData themeData = ThemeData(
      brightness: brightness,
      primaryColorBrightness: otherBrightness,
      accentColorBrightness: otherBrightness,
      backgroundColor: darkYellow.withGreen(180),

      cardColor: Colors.white,
      accentColor: (darkFlag) ? kAccentColorDark : kAccentColorLight,
      primaryColor: (darkFlag) ? kPrimaryColorDark : kPrimaryColorLight,
      bottomAppBarColor: (darkFlag) ? kPrimaryColorDark : kPrimaryColorLight,
      buttonColor: (darkFlag) ? kPrimaryColorDark : kPrimaryColorLight,

      colorScheme: (darkFlag) ? ColorScheme.dark() : ColorScheme.light(),
      primarySwatch: (darkFlag) ? Colors.orange : Colors.blue,

      buttonBarTheme: ButtonBarThemeData(
        mainAxisSize: MainAxisSize.max,
        buttonTextTheme: ButtonTextTheme.primary,
      ),

      // indicatorColor: color,
      pageTransitionsTheme: PageTransitionsTheme(builders: {
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
      }),

      accentIconTheme: IconThemeData(color: color),

      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        elevation: 20,
        textStyle: TextStyle(
            fontSize: s * 0.00007, fontWeight: FontWeight.bold, color: color),
        //color: Colors.blueGrey,
      ),

      bottomAppBarTheme: BottomAppBarTheme(
        elevation: 0.0,
      ),
      appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          titleTextStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          elevation: 5,
          // color: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.white, size: 25),
          textTheme: TextTheme(
            headline6: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          actionsIconTheme: IconThemeData(color: Colors.white) //,size: 20),
          ),
      primaryIconTheme: IconThemeData(color: Colors.white),
      //buttonBarTheme: ButtonBarThemeData() ,
      //bannerTheme: MaterialBannerThemeData(backgroundColor: Colors.green),
      //bottomSheetTheme: BottomSheetThemeData(),
      //navigationRailTheme: NavigationRailThemeData(backgroundColor: Colors.green),
      //tabBarTheme: TabBarTheme(),
      cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          color: darkFlag ? Colors.grey[700] : Colors.grey[300],
          clipBehavior: Clip.hardEdge),

      tabBarTheme: TabBarTheme(
        unselectedLabelColor: (darkFlag) ? Colors.grey : Colors.blueGrey,
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        labelColor: color,
        indicator: BoxDecoration(
          border: Border(bottom: BorderSide(width: s * 0.000008, color: color)),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
      ),

      dialogTheme: DialogTheme(
        contentTextStyle:
            TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold),
        titleTextStyle:
            TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: color,
        type: BottomNavigationBarType.shifting,
        unselectedItemColor: (darkFlag) ? Colors.grey : Colors.blueGrey,
        selectedLabelStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle:
            TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        selectedIconTheme: IconThemeData(
          size: 20,
          color: color,
        ),
        unselectedIconTheme: IconThemeData(
          size: 18,
          color: Colors.blueGrey,
        ),
      ),
      iconTheme: IconThemeData(
        size: 22,
        color: color,
      ),
      buttonTheme: ButtonThemeData(
          buttonColor: color,
          alignedDropdown: true,
          minWidth: 25,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: darkFlag ? Colors.black : white,
          backgroundColor: color,
          hoverColor: Colors.greenAccent),

      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: s * 0.00021,
          fontWeight: FontWeight.normal,
        ),
        headline2: TextStyle(
          fontSize: s * 0.00017,
          fontWeight: FontWeight.normal,
        ),
        headline3: TextStyle(
          fontSize: s * 0.00014,
          fontWeight: FontWeight.normal,
        ),
        headline4: TextStyle(
          fontSize: s * 0.00011,
          fontWeight: FontWeight.normal,
        ),
        headline5: TextStyle(
          fontSize: s * 0.00009,
          fontWeight: FontWeight.normal,
        ),
        headline6: TextStyle(
          fontSize: s * 0.000075,
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.italic,
        ),
        subtitle1: TextStyle(
          fontSize: s * 0.000075,
          fontWeight: FontWeight.normal,
        ),
        subtitle2: TextStyle(
          fontSize: s * 0.00006,
          fontWeight: FontWeight.normal,
        ),
        bodyText1: TextStyle(
          fontSize: s * 0.000065,
          fontWeight: FontWeight.normal,
        ),
        bodyText2: TextStyle(
          fontSize: s * 0.00006,
          fontWeight: FontWeight.normal,
        ),
        button: TextStyle(
          fontSize: s * 0.00007,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
/*
    ThemeData dark = ThemeData(
      brightness: Brightness.dark,
      primaryColorBrightness: Brightness.dark,
      accentColorBrightness: Brightness.dark,
      colorScheme: ColorScheme.dark(),
      primarySwatch: Colors.indigo,
      primaryColor: Colors.indigo,
      bottomAppBarColor: Colors.indigo,
      buttonColor: Colors.indigo[800],
      bottomAppBarTheme: BottomAppBarTheme(color: Colors.transparent, elevation: 0.0),
      appBarTheme: AppBarTheme(
        brightness: Brightness.dark,
        elevation: 0.0,
        color: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white70, size: 30),
        textTheme: TextTheme(
            headline6: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white70)),
        actionsIconTheme: IconThemeData(color: Colors.white70, size: 30),
      ),

      //buttonBarTheme: ButtonBarThemeData() ,
      //bannerTheme: MaterialBannerThemeData(backgroundColor: Colors.green),
      //bottomSheetTheme: BottomSheetThemeData(),
      //navigationRailTheme: NavigationRailThemeData(backgroundColor: Colors.green),
      //tabBarTheme: TabBarTheme(),
      tabBarTheme: TabBarTheme(
        unselectedLabelColor: Colors.grey,
        unselectedLabelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        labelColor: Colors.white,
        indicatorSize: TabBarIndicatorSize.tab,
      ),

      dialogTheme: DialogTheme(
        contentTextStyle: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
        titleTextStyle: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        selectedIconTheme: IconThemeData(
          size: 30,
          color: Colors.white,
        ),
        unselectedIconTheme: IconThemeData(
          size: 30,
          color: Colors.grey,
        ),
      ),

      buttonTheme:
          ButtonThemeData(buttonColor: Colors.deepOrange, alignedDropdown: true, minWidth: 30),
      cardColor: Colors.grey[800],

      floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepOrange,
          hoverColor: Colors.greenAccent),
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyText2: TextStyle(fontSize: 14.0),
      ),
    );

    if (themeName == 'dark') {
      return dark;
    } else {
      return light;
    }

 */
    return themeData;
  }
}
