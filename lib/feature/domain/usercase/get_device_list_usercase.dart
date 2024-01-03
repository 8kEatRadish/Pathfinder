import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:pathfinder/core/status/failure.dart';
import 'package:pathfinder/core/usercase/user_case.dart';
import 'package:pathfinder/core/utils/execution_utils.dart';
import 'package:pathfinder/core/utils/logger_utils.dart';
import 'package:pathfinder/core/utils/shell_utils.dart';
import 'package:pathfinder/feature/domain/entity/execution_info.dart';

import '../entity/device_info.dart';

@Injectable(as: UserCase)
class GetDeviceListUserCase
    extends UserCase<List<DeviceInfo>, ParamsGetDeviceListUserCase> {
  @override
  Future<Either<Failure, List<DeviceInfo>>> call(
      ParamsGetDeviceListUserCase params) async {
    ExecutionUtils().addExecution(
        const ExecutionInfo(ExecutionType.start, "获取设别列表"),
        params.executionInfo);
    var devicesList = await params.shellUtils.getDeviceList();
    logger.d("GetDeviceListUserCase devicesList = $devicesList");
    ExecutionUtils().addExecution(
        ExecutionInfo(ExecutionType.end, "获取设别列表 $devicesList"),
        params.executionInfo);
    return right(devicesList);
  }
}

class ParamsGetDeviceListUserCase extends Equatable {
  final ShellUtils shellUtils;
  final List<ExecutionInfo> executionInfo;

  const ParamsGetDeviceListUserCase(
    this.shellUtils,
    this.executionInfo,
  );

  @override
  List<Object?> get props => [shellUtils, executionInfo];
}
