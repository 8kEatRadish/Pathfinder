import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathfinder/res/messages.dart';
import 'package:pathfinder/res/themes.dart';
import 'package:pathfinder/app/routes/app_pages.dart';

void main() {
  runApp(const MyApp());
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(960, 540);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Hummingbird";
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Messages(),
      locale: const Locale('zh', 'CN'),
      fallbackLocale: const Locale('en', 'US'),
      theme: Themes().darkMode(),
      title: 'app_name'.tr,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
