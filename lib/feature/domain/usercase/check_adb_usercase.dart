import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:pathfinder/config/config.dart';
import 'package:pathfinder/core/status/failure.dart';
import 'package:pathfinder/core/status/success.dart';
import 'package:pathfinder/core/usercase/user_case.dart';
import 'package:pathfinder/core/utils/execution_utils.dart';
import 'package:pathfinder/core/utils/shell_utils.dart';

import '../entity/execution_info.dart';

@Injectable(as: UserCase)
class CheckAdbUserCase
    extends UserCase<CheckAdbSuccess, ParamsCheckAdbUserCase> {
  @override
  Future<Either<Failure, CheckAdbSuccess>> call(
      ParamsCheckAdbUserCase params) async {
    ExecutionUtils().addExecution(
        const ExecutionInfo(ExecutionType.start, "获取adbPath"),
        params.executionInfoList);
    await params.shellUtils.checkAdb();
    if (Config.adbPath.isEmpty) {
      ExecutionUtils().addExecution(
          const ExecutionInfo(ExecutionType.error, "获取adb地址失败"),
          params.executionInfoList);
      return left(const CheckAdbFail("获取adb地址失败"));
    } else {
      ExecutionUtils().addExecution(
          ExecutionInfo(ExecutionType.end, "获取adbPath ${Config.adbPath}"),
          params.executionInfoList);
      return right(CheckAdbSuccess(Config.adbPath));
    }
  }
}

class ParamsCheckAdbUserCase extends Equatable {
  final ShellUtils shellUtils;
  final List<ExecutionInfo> executionInfoList;

  const ParamsCheckAdbUserCase(this.shellUtils, this.executionInfoList);

  @override
  List<Object?> get props => [shellUtils, executionInfoList];
}
