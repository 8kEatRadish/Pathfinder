import 'package:dartz/dartz.dart';
import 'package:pathfinder/core/error/failure.dart';
import 'package:pathfinder/feature/domain/entity/command_info.dart';

abstract class AdbCommandRepository {
  Future<Either<Failure, List<String>>> getCommandValue(int id);

  Future<Either<Failure, List<int>>> addCommandsValue(
      List<CommandInfo> commands);
}
