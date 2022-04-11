import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'const.dart';

ThemeData lightTheme() => ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      actionsIconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: GoogleFonts.quicksand().copyWith(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 28.0),
      iconTheme: const IconThemeData(color: Colors.black),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
    primarySwatch: defaultColor1,
    scaffoldBackgroundColor: Colors.white,
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      contentPadding: const EdgeInsetsDirectional.only(top: 5, start: 20),
      hintStyle: const TextStyle(color: Colors.black),
      
    ),
    textTheme: GoogleFonts.lailaTextTheme().copyWith(
      caption: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w100,
          color: Colors.black,
          height: 1.3,
        ),
      bodyText1: const TextStyle(color: Colors.black, fontWeight: FontWeight.w400, fontSize: 16),
      subtitle1: const TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
      height: 1.3,
    ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: defaultColor1,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed));
ThemeData darkTheme() => ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF202A44),
        elevation: 0,
        actionsIconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.quicksand().copyWith(
            fontWeight: FontWeight.bold, color: Colors.white, fontSize: 28.0),
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: Color(0xFF202A44),
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      primarySwatch: defaultColor1,
      scaffoldBackgroundColor: const Color(0xFF202A44),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        contentPadding: const EdgeInsetsDirectional.only(top: 5, start: 30),
        hintStyle: const TextStyle(color: Colors.white),
      ),
      textTheme: GoogleFonts.lailaTextTheme().copyWith(
        caption: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w100,
          color: Colors.white,
          height: 1.3,
        ),
        bodyText1:  GoogleFonts.laila().copyWith(
            color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16),
        subtitle1: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          height: 1.3,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF202A44),
          selectedItemColor: defaultColor1,
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed),
      iconTheme: const IconThemeData(color: Colors.white),
      primaryIconTheme: const IconThemeData(color: Colors.white),
    );
