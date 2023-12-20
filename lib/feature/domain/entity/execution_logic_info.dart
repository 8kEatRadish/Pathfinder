import 'dart:io';

import 'package:equatable/equatable.dart';

class ExecutionLogicInfo extends Equatable {
  final int id;
  final String name;
  final List<CommandInfo> executionLogic;

  const ExecutionLogicInfo(this.id, this.name, this.executionLogic);

  @override
  List<Object?> get props => [id, name, executionLogic];
}

abstract class CommandInfo {}

class ShowTextCommand extends CommandInfo {
  final String showText;

  ShowTextCommand(this.showText);
}

class CountDownCommand extends CommandInfo {
  final String textFormat;
  final int count;

  CountDownCommand(this.textFormat, this.count);
}

class AdbCommand extends CommandInfo {
  final List<String> adbCommandString;
  final bool isSaveResult;

  AdbCommand(this.adbCommandString, this.isSaveResult);

  void saveResult(ProcessResult? processResult) {
    return;
  }
}

abstract class CalculationResults extends CommandInfo {
  final String title;

  CalculationResults(this.title);

  dynamic calculation(List<int> params) {}
}

abstract class CycleDetection extends CommandInfo {
  final Duration duration;
  final String errorTip;
  final String adbCommand;

  CycleDetection(this.duration, this.errorTip, this.adbCommand);

  bool isPass(ProcessResult? processResult) {
    return true;
  }
}
