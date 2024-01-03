import 'package:get/get.dart';
import 'package:pathfinder/core/utils/execution_utils.dart';
import 'package:pathfinder/core/utils/logger_utils.dart';
import 'package:pathfinder/core/utils/shell_utils.dart';
import 'package:pathfinder/core/status/page_status.dart';
import 'package:pathfinder/feature/domain/entity/device_info.dart';
import 'package:pathfinder/feature/domain/entity/execution_info.dart';
import 'package:pathfinder/feature/domain/entity/execution_logic_info.dart';
import 'package:pathfinder/feature/domain/entity/settings_command.dart';
import 'package:pathfinder/feature/domain/usercase/check_adb_usercase.dart';
import 'package:pathfinder/feature/domain/usercase/exec_command_usercase.dart';
import 'package:pathfinder/feature/domain/usercase/get_device_list_usercase.dart';
import 'package:pathfinder/injection.dart';
import 'package:pathfinder/res/dimens.dart';

class HomeController extends GetxController {
  var test = 'I am text view'.obs;

  List<DeviceInfo> devices = RxList();

  var pageStatus = Rx<PageStatus>(Normal(""));

  var currentDevice = Rxn<DeviceInfo>();

  List<ExecutionLogicInfo> commandInfoList = [
    SettingsCommand.startupSpeedCold,
    SettingsCommand.startupSpeedHot,
    SettingsCommand.frame
  ].obs;

  List<ExecutionInfo> executionResult = RxList();

  late ShellUtils shell;

  @override
  void onInit() {
    _executeTheInitializationProcess();
    super.onInit();
  }

  /// 执行初始化流程
  void _executeTheInitializationProcess() async {
    //依赖注入数据库
    pageStatus.value = Loadings("开始依赖注入数据库");
    ExecutionUtils().addExecution(
        const ExecutionInfo(ExecutionType.start, "依赖注入数据库"), executionResult);
    // Get.put<AdbCommandRepository>(AddCommandRepositoryImpl(), permanent: true);
    ExecutionUtils().addExecution(
        const ExecutionInfo(ExecutionType.end, "依赖注入数据库"), executionResult);
    // 注册shell
    shell = ShellUtils();
    // 获取adb路径
    pageStatus.value = Loadings("开始获取adb路径");
    var checkAdbUserCaseResult = await location
        .get<CheckAdbUserCase>()
        .call(ParamsCheckAdbUserCase(shell, executionResult));
    checkAdbUserCaseResult.fold((l) {
      pageStatus.value = Error("获取adb路径失败");
      Get.defaultDialog(
          title: "获取adb path错误",
          middleText: "请确保adb环境正常再使用",
          backgroundColor: Get.theme.cardColor,
          titleStyle: Get.theme.textTheme.bodyMedium,
          middleTextStyle: Get.theme.textTheme.bodySmall,
          radius: Dimens.commonBorderRadius);
    }, (r) async {
      pageStatus.value = Loadings("开始获取adb路径成功 ${r.successMessage}");

      pageStatus.value = Loadings("开始获取设备列表");
      var result = await location
          .get<GetDeviceListUserCase>()
          .call(ParamsGetDeviceListUserCase(shell, executionResult));
      result.fold((l) {
        pageStatus.value = Error("获取设备列表失败");
      }, (r) {
        devices.clear();
        devices.addAll(r);
        pageStatus.value = Normal("获取设备列表成功");
      });
    });
  }

  void onClickCommandItem(ExecutionLogicInfo commandInfo) {
    logger.d("onClickCommandItem commandInfo $commandInfo");
    if (currentDevice.value == null) {
      ExecutionUtils().addExecution(
          const ExecutionInfo(ExecutionType.error, "未连接设备"), executionResult);
      return;
    }
    location.get<ExecCommandUserCase>().call(ParamsExecCommandUserCase(
        currentDevice.value!, commandInfo, executionResult, shell));
  }

  @override
  void onClose() {
    logger.d("HomeController onClose");
    super.onClose();
  }

  @override
  InternalFinalCallback<void> get onDelete {
    logger.d("HomeController onDelete");
    return super.onDelete;
  }

  @override
  void onReady() {
    logger.d("HomeController onReady");
    super.onReady();
  }

  @override
  InternalFinalCallback<void> get onStart {
    logger.d("HomeController onStart");
    return super.onStart;
  }

  @override
  void dispose() {
    logger.d("HomeController dispose");
    super.dispose();
  }
}
