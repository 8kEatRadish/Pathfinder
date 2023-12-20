import 'package:dartz/dartz.dart';
import 'package:pathfinder/feature/domain/entity/command_info.dart';

import '../../../core/status/failure.dart';

abstract class AdbCommandRepository {
  Future<Either<Failure, List<String>>> getCommandValue(int id);

  Future<Either<Failure, List<int>>> addCommandsValue(
      List<CommandInfo> commands);
}
