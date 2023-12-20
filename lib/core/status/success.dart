import 'package:equatable/equatable.dart';

abstract class Success extends Equatable {
  final String successMessage;

  const Success(this.successMessage);

  @override
  String toString() {
    return '$runtimeType {successMessage: $successMessage}';
  }
}

class CheckAdbSuccess extends Success {
  const CheckAdbSuccess(super.successMessage);

  @override
  List<Object?> get props => [successMessage];
}
