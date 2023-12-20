import 'package:flutter/material.dart';
import 'package:pathfinder/feature/domain/entity/execution_info.dart';

class ExecutionUtils {
  static final _executionUtils = ExecutionUtils._();

  ExecutionUtils._();

  factory ExecutionUtils() => _executionUtils;

  void addExecution(ExecutionInfo executionInfo,
      List<ExecutionInfo> targetExecutionInfoList) {
    targetExecutionInfoList.insert(0, executionInfo);
  }

  InlineSpan getExecutionSpan(
      ExecutionInfo executionInfo, TextStyle? defaultStyle) {
    final TextStyle headStyle;
    final String head;

    switch (executionInfo.executionType) {
      case ExecutionType.start:
        {
          headStyle =
              const TextStyle(color: Colors.blue, decorationColor: Colors.blue);
          head = "开始执行 : ";
        }
      case ExecutionType.end:
        {
          headStyle =
              const TextStyle(color: Colors.blue, decorationColor: Colors.blue);
          head = "执行完毕 : ";
        }
      case ExecutionType.error:
        {
          headStyle =
              const TextStyle(color: Colors.red, decorationColor: Colors.red);
          head = "ERROR : ";
        }
      case ExecutionType.info:
        {
          headStyle =
              const TextStyle(color: Colors.grey, decorationColor: Colors.grey);
          head = "INFO : ";
        }
      case ExecutionType.debug:
        {
          headStyle = const TextStyle(
              color: Colors.green, decorationColor: Colors.green);
          head = "DEBUG : ";
        }
    }
    return TextSpan(children: [
      TextSpan(text: head, style: headStyle),
      TextSpan(text: executionInfo.executionMessage, style: defaultStyle),
    ]);
  }
}
