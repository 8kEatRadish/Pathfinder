import 'package:equatable/equatable.dart';

class ExecutionInfo extends Equatable {
  final ExecutionType executionType;
  final String executionMessage;

  const ExecutionInfo(this.executionType, this.executionMessage);

  @override
  List<Object?> get props => [executionType, executionMessage];
}

enum ExecutionType { start, end, error, info, debug }
