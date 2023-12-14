// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../dao/adb_command_info_dao.dart';
import '../entity/adb_command_information.dart';

part 'database.g.dart'; // the generated code will be there

// Run the generator with flutter packages pub run build_runner build. To automatically run it,
// whenever a file changes, use flutter packages pub run build_runner watch.

@Database(version: 1, entities: [AdbCommandInfo])
abstract class AppDatabase extends FloorDatabase {
  AdbCommandInfoDao get adbCommandInfoDao;
}
