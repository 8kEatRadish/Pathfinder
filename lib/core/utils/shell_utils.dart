import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pathfinder/config/config.dart';
import 'package:process_run/shell.dart';

class ShellUtils {
  String? get userHome =>
      Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
  late Shell shell;

  ShellUtils() {
    shell = Shell(
      workingDirectory: userHome,
      environment: Platform.environment,
      throwOnError: false,
      stderrEncoding: const Utf8Codec(),
      stdoutEncoding: const Utf8Codec(),
    );
  }

  Future<ProcessResult?> exec(
    String executable,
    List<String> arguments, {
    void Function(Process process)? onProcess,
  }) async {
    try {
      return await shell.runExecutableArguments(executable, arguments,
          onProcess: onProcess);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    } finally {}
  }

  Future<ProcessResult?> execAdb(List<String> arguments,
      {void Function(Process process)? onProcess}) async {
    if (Config.adbPath.isEmpty) {
      return null;
    }
    return await exec(Config.adbPath, arguments, onProcess: onProcess);
  }

  void kill() {
    shell.kill();
  }
}
