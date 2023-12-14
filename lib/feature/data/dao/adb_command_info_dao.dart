import 'package:floor/floor.dart';

import '../entity/adb_command_information.dart';

@dao
abstract class AdbCommandInfoDao {
  @Query('SELECT * FROM AdbCommandInfo')
  Future<List<AdbCommandInfo>> findAllAdbCommandInfo();

  @Query('SELECT name FROM AdbCommandInfo')
  Stream<List<String>> findAllAdbCommandInfoName();

  @Query('SELECT * FROM AdbCommandInfo WHERE id = :id')
  Future<AdbCommandInfo?> findAdbCommandInfoById(int id);

  @insert
  Future<void> insertAdbCommandInfo(AdbCommandInfo adbCommandInfo);

  @insert
  Future<List<int>> insertAdbCommandInfoList(
      List<AdbCommandInfo> adbCommandInfo);
}
