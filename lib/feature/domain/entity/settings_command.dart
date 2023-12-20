import 'dart:io';

import 'package:logger/logger.dart';
import 'package:pathfinder/core/utils/logger_utils.dart';
import 'package:pathfinder/feature/domain/entity/execution_logic_info.dart';
import 'package:process_run/shell.dart';

abstract class SettingsCommand {
  static ExecutionLogicInfo startupSpeedCold =
      ExecutionLogicInfo(0, "应用冷启动检测", [
    AdbCommand([
      'shell',
      'atrace',
      '-z',
      '-b',
      '10000',
      'gfx',
      'input',
      'view',
      'wm',
      'am',
      'res',
      'dalvik',
      'rs',
      'sched',
      'freq',
      'idle',
      'disk',
      'binder_driver',
      'binder_lock',
      '-t',
      '10',
      '>',
      '/sdcard/startupSpeedCold.trace'
    ], false),
    CountDownCommand("距离采集结束还有 %d 秒，请打开设置应用", 10),
    AdbCommand(['pull', '/sdcard/startupSpeedCold.trace', 'd:/'], false),
    ShowTextCommand("已采集完成，trace文件存放在d:/startupSpeedCold.trace")
  ]);

  static ExecutionLogicInfo startupSpeedHot = ExecutionLogicInfo(1, "应用热启动检测", [
    AdbCommand([
      'shell',
      'atrace',
      '-z',
      '-b',
      '10000',
      'gfx',
      'input',
      'view',
      'wm',
      'am',
      'res',
      'dalvik',
      'rs',
      'sched',
      'freq',
      'idle',
      'disk',
      'binder_driver',
      'binder_lock',
      '-t',
      '10',
      '>',
      '/sdcard/startupSpeedHot.trace'
    ], false),
    CountDownCommand("距离采集结束还有 %d 秒，请打开设置应用", 10),
    AdbCommand(['pull' ,'/sdcard/startupSpeedHot.trace', 'd:/'], false),
    ShowTextCommand("已采集完成，trace文件存放在d:/startupSpeedHot.trace")
  ]);

  static ExecutionLogicInfo frame = ExecutionLogicInfo(2, "帧数检测", [
    FrameAdbCommand(
        ['shell','dumpsys', 'gfxinfo', 'com.konka.MultiScreen'], true),
    CountDownCommand("距离采集结束还有 %d 秒，请移动设置焦点", 5),
    FrameAdbCommand(
        ['shell','dumpsys', 'gfxinfo', 'com.konka.MultiScreen'
          // ,'|', 'grep', '-i', 'jank', '-C', '5'
        ], true),
    CalculationFrame("当前帧率为：")
  ]);
}

class CalculationFrame extends CalculationResults {
  CalculationFrame(super.title);

  @override
  calculation(List<int> params) {
    logger.d("suihw $params");
    int jankyFrame = params[3] - params[1];
    int totalFrame = params[2] - params[0];

    double frame = 60 - jankyFrame / totalFrame;

    logger.d("suihw $frame");
    return frame;
  }
}

class CheckSettingsProcessIsActive extends CycleDetection {
  CheckSettingsProcessIsActive(
      super.duration, super.errorTip, super.adbCommand);

  @override
  bool isPass(ProcessResult? processResult) {
    if (processResult == null) {
      return false;
    }

    for (var element in processResult.outLines) {
      if (element.contains("com.tcl.settings")) {
        return true;
      }
    }

    return false;
  }
}

class CheckSettingsProcessIsNotActive extends CycleDetection {
  CheckSettingsProcessIsNotActive(
      super.duration, super.errorTip, super.adbCommand);

  @override
  bool isPass(ProcessResult? processResult) {
    if (processResult == null) {
      return true;
    }

    if (processResult.outLines.isEmpty) {
      return true;
    }

    return false;
  }
}

class FrameAdbCommand extends AdbCommand {
  List<int> save = [];

  FrameAdbCommand(super.adbCommandString, super.isSaveResult);

  @override
  void saveResult(ProcessResult? processResult) {
    if (processResult == null) {
      return;
    }

    for (var element in processResult.outLines) {
      if (element.contains("Total frames rendered:")) {
        var list = element.split(" ");
        save.add(int.parse(list[3]));
        continue;
      }
      if (element.contains("Janky frames:")) {
        var list = element.split(" ");
        save.add(int.parse(list[2]));
        continue;
      }
    }

    super.saveResult(processResult);
  }
}
