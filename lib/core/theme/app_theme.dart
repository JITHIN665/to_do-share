import 'package:flutter/material.dart';

final ThemeData darkAppTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: Color(0xFFC6B3CA),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    elevation: 0,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: Colors.white70)),
);
