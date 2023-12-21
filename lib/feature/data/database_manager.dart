import 'dao/adb_command_info_dao.dart';
import 'database/database.dart';

class DataBaseManager {
  late AppDatabase database;
  late AdbCommandInfoDao adbCommandInfoDao;
  static final _dataBaseManager = DataBaseManager._();

  DataBaseManager._() {
    initManager();
  }

  initManager() async {
    database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    adbCommandInfoDao = database.adbCommandInfoDao;
  }

  factory DataBaseManager() => _dataBaseManager;
}
