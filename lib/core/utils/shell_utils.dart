import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pathfinder/config/config.dart';
import 'package:pathfinder/feature/domain/entity/device_info.dart';
import 'package:process_run/shell.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../manager/eventbus/event.dart';

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

  /// 获取adb路径
  checkAdb() async {
    if (Config.adbPath.isEmpty) {
      // 先从缓存获取
      Config.adbPath = await _getAdbPath();
    }
    if (Config.adbPath.isNotEmpty && await File(Config.adbPath).exists()) {
      return;
    }
    var executable = Platform.isWindows ? "where" : "which";
    var result = await exec(executable, ['adb']);
    if (result != null && result.exitCode == 0) {
      Config.adbPath = result.stdout.toString().trim();
      await _setAdbPath(Config.adbPath);
      return;
    }
  }

  /// 获取设备列表
  Future<List<DeviceInfo>> getDeviceList() async {
    List<DeviceInfo> deviceList = [];
    var devices = await execAdb(['devices']);
    if (devices == null) {
      return deviceList;
    }
    for (var value in devices.outLines) {
      if (value.contains("List of devices attached")) {
        continue;
      }
      if (value.contains("device")) {
        var deviceLine = value.split("\t");
        if (deviceLine.isEmpty) {
          continue;
        }
        var device = deviceLine[0];
        var brand = await _getBrand(device);
        var model = await _getModel(device);
        deviceList.add(DeviceInfo(device, brand, model));
      }
    }
    return deviceList;
  }

  /// 保存设备ID
  Future<void> _setDeviceId(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Config.deviceIdKey, deviceId);
  }

  /// 获取设备ID
  Future<String> _getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Config.deviceIdKey) ?? "";
  }

  /// 获取设备品牌
  Future<String> _getBrand(String device) async {
    var brand =
        await execAdb(['-s', device, 'shell', 'getprop', 'ro.product.brand']);
    if (brand == null) return "";
    var outLines = brand.outLines;
    if (outLines.isEmpty) {
      return device;
    } else {
      return outLines.first;
    }
  }

  /// 获取设备型号
  Future<String> _getModel(String device) async {
    var model =
        await execAdb(['-s', device, 'shell', 'getprop', 'ro.product.model']);
    if (model == null) return "";
    var outLines = model.outLines;
    if (outLines.isEmpty) {
      return device;
    } else {
      return outLines.first;
    }
  }

  /// 保存ADB路径
  Future<void> _setAdbPath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(Config.adbFilePathKey, path);
  }

  /// 获取ADB缓存路径
  Future<String> _getAdbPath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(Config.adbFilePathKey) ?? "";
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
