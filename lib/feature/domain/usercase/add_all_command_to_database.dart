import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:pathfinder/core/error/failure.dart';
import 'package:pathfinder/core/usercase/user_case.dart';
import 'package:pathfinder/feature/domain/repository/adb_command_repository.dart';

import '../entity/command_info.dart';

class AddAllCommandToDatabase
    extends UseCase<List<int>, ParamsAddAllCommandToDatabase> {
  final AdbCommandRepository adbCommandRepository;

  AddAllCommandToDatabase(this.adbCommandRepository);

  @override
  Future<Either<Failure, List<int>>> call(
      ParamsAddAllCommandToDatabase params) async {
    return await adbCommandRepository.addCommandsValue(params.commandInfoList);
  }
}

class ParamsAddAllCommandToDatabase extends Equatable {
  final List<CommandInfo> commandInfoList;

  const ParamsAddAllCommandToDatabase(this.commandInfoList);

  @override
  List<Object?> get props => commandInfoList;

  @override
  String toString() {
    return '$runtimeType {$commandInfoList}';
  }
}
