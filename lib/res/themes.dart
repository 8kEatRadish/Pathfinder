import 'package:flutter/material.dart';

class Themes {
  static final Themes _themes = Themes._();

  Themes._();

  factory Themes() => _themes;

  ThemeData darkMode() {
    return ThemeData(
        //主要部分背景颜色
        primaryColor: const Color(0xff000000),
        //页面背景色
        scaffoldBackgroundColor: const Color(0xff2B2D31),
        //卡片颜色
        cardColor: const Color(0xff1E1F22),
        //鼠标悬停颜色
        hoverColor: const Color(0xff556FEC),
        //高亮颜色
        highlightColor: const Color(0xff556FEC),
        dialogBackgroundColor: const Color(0xff1E1F22),
        textTheme: _textTheme());
  }

  ThemeData lightMode() {
    return darkMode();
  }

  TextTheme _textTheme() => const TextTheme(
        titleLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        bodyMedium: TextStyle(
            fontSize: 24, fontWeight: FontWeight.normal, color: Colors.white),
        bodySmall: TextStyle(
            fontSize: 20, fontWeight: FontWeight.normal, color: Colors.white),
      );
}
