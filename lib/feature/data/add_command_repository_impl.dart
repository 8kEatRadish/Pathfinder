import 'package:dartz/dartz.dart';
import 'package:get/get.dart';

import 'package:pathfinder/core/error/failure.dart';
import 'package:pathfinder/core/utils/logger_utils.dart';

import 'package:pathfinder/feature/domain/entity/command_info.dart';

import '../../main.dart';
import '../domain/repository/adb_command_repository.dart';
import 'entity/adb_command_information.dart';

class AddCommandRepositoryImpl extends AdbCommandRepository {
  @override
  Future<Either<Failure, List<int>>> addCommandsValue(
      List<CommandInfo> commands) async {
    final result = await adbCommandInfoDao.insertAdbCommandInfoList(
        _adbCommandInfoListCoverToAdbCommandInfoList(commands));
    return right(result);
  }

  List<AdbCommandInfo> _adbCommandInfoListCoverToAdbCommandInfoList(
      List<CommandInfo> commandInfoList) {
    return commandInfoList.map((e) {
      return AdbCommandInfo(e.id, e.name, e.commandValue);
    }).toList();
  }

  @override
  Future<Either<Failure, List<String>>> getCommandValue(int id) async {
    final result = await adbCommandInfoDao.findAdbCommandInfoById(id);
    logger.d("getCommandValue result = $result");
    if (result == null) {
      return left(const TestFail("没有找到这个命令"));
    }
    return right(_adbCommandInfoCoverToCommandValue(result));
  }

  List<String> _adbCommandInfoCoverToCommandValue(
      AdbCommandInfo adbCommandInfo) {
    return adbCommandInfo.commandInfo.split('@');
  }
}
