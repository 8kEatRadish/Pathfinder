import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathfinder/res/messages.dart';
import 'package:pathfinder/res/themes.dart';

import 'core/utils/logger_utils.dart';
import 'feature/data/dao/adb_command_info_dao.dart';
import 'feature/data/database/database.dart';
import 'feature/presentation/routes/app_pages.dart';

late AppDatabase database;
late AdbCommandInfoDao adbCommandInfoDao;

void main() async {
  database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  adbCommandInfoDao = database.adbCommandInfoDao;

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
    logger.i("app start");
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
