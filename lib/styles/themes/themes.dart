import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors.dart';

ThemeData darktheme = ThemeData(
    fontFamily: 'jannah',
    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      labelStyle: TextStyle(
        color: Colors.grey,
      ),
      hintStyle: TextStyle(
        color: Colors.grey,
      ),
    ),
    //primarySwatch: defaultColor,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xff333739),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: defaultColor,
        unselectedItemColor: Colors.grey),
    appBarTheme: const AppBarTheme(
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xff333739),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Color(0xff333739),
            statusBarIconBrightness: Brightness.light),
        titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold)),
    scaffoldBackgroundColor: Color(0xff333739),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
      subtitle1: TextStyle(color: Colors.white),
    ));
ThemeData lighttheme = ThemeData(
    // fontFamily: 'jannah',
    //primarySwatch: defaultColor,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
    ),
    //selectedItemColor: defaultColor),
    appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle(
            //statusBarColor: defaultColor,
            statusBarIconBrightness: Brightness.light),
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold)),
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
        subtitle1: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
        bodyText1: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black))
    /*  TextTheme(
        bodyText1: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black)) */
    );
