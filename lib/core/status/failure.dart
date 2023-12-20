import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String errorMessage;

  const Failure(this.errorMessage);

  @override
  String toString() {
    return '$runtimeType {errorMessage: $errorMessage}';
  }
}

class TestFail extends Failure {
  const TestFail(super.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}


class CheckAdbFail extends Failure {
  const CheckAdbFail(super.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
