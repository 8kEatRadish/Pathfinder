import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:pathfinder/core/usercase/user_case.dart';
import 'package:pathfinder/core/utils/execution_utils.dart';
import 'package:pathfinder/core/utils/logger_utils.dart';
import 'package:pathfinder/core/utils/shell_utils.dart';
import 'package:pathfinder/feature/domain/entity/device_info.dart';
import 'package:pathfinder/feature/domain/entity/execution_info.dart';
import 'package:pathfinder/feature/domain/entity/execution_logic_info.dart';

import '../../../core/status/failure.dart';
import '../entity/settings_command.dart';

class ExecCommandUserCase extends UserCase<NoParams, ParamsExecCommandUserCase> {
  ExecCommandUserCase();

  List<int> saveResult = [];

  @override
  Future<Either<Failure, NoParams>> call(
      ParamsExecCommandUserCase params) async {
    ExecutionUtils().addExecution(
        ExecutionInfo(ExecutionType.start, params.executionLogicInfo.name),
        params.executionResultList);

    for (var command in params.executionLogicInfo.executionLogic) {
      logger.d("开始执行$command");
      var result = await _handleCommand(command, params);
      logger.d("执行完毕 $result");
    }
    ExecutionUtils().addExecution(
        ExecutionInfo(ExecutionType.end, params.executionLogicInfo.name),
        params.executionResultList);
    return right(NoParams());
  }

  Future<bool> _handleCommand(
      CommandInfo commandInfo, ParamsExecCommandUserCase params) async {
    if (commandInfo is ShowTextCommand) {
      ExecutionUtils().addExecution(
          ExecutionInfo(ExecutionType.debug, commandInfo.showText),
          params.executionResultList);
      return true;
    }

    if (commandInfo is AdbCommand) {
      var commandList = ['-s', params.deviceInfo.id];
      commandList.addAll(commandInfo.adbCommandString);
      logger.d("suihw $commandList");
      var result = await params.shellUtils.execAdb(commandList);

      if (commandInfo is FrameAdbCommand) {
        if (commandInfo.isSaveResult) {
          commandInfo.saveResult(result);

          saveResult.add(commandInfo.save[0]);
          saveResult.add(commandInfo.save[1]);
        }
      }

      return true;
    }

    if (commandInfo is CountDownCommand) {
      var count = commandInfo.count;
      while (count > 0) {
        ExecutionUtils().addExecution(
            ExecutionInfo(
                ExecutionType.debug, '${commandInfo.textFormat} $count'),
            params.executionResultList);
        count--;
        await Future.delayed(const Duration(seconds: 1));
      }
      return true;
    }

    if (commandInfo is CalculationFrame) {
      ExecutionUtils().addExecution(
          ExecutionInfo(ExecutionType.debug,
              '${commandInfo.title} ${commandInfo.calculation(saveResult)}'),
          params.executionResultList);
      return true;
    }
    if (commandInfo is CycleDetection) {
      var commandList = ['-s', params.deviceInfo.id];
      commandList.addAll(commandInfo.adbCommand.split(" "));
      while (
          !commandInfo.isPass(await params.shellUtils.execAdb(commandList))) {
        ExecutionUtils().addExecution(
            ExecutionInfo(ExecutionType.debug, commandInfo.errorTip),
            params.executionResultList);
        await Future.delayed(commandInfo.duration);
      }
      return true;
    }

    logger.e("_handleCommand 没有匹配上");
    return true;
  }
}

class ParamsExecCommandUserCase extends Equatable {
  final DeviceInfo deviceInfo;
  final ExecutionLogicInfo executionLogicInfo;
  final List<ExecutionInfo> executionResultList;
  final ShellUtils shellUtils;

  const ParamsExecCommandUserCase(this.deviceInfo, this.executionLogicInfo,
      this.executionResultList, this.shellUtils);

  @override
  List<Object?> get props =>
      [deviceInfo, executionLogicInfo, executionResultList, shellUtils];
}
