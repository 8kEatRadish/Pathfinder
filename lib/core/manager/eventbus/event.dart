import 'package:dartz/dartz.dart';

import '../../status/failure.dart';
import '../../status/success.dart';

/// 检查Adb路径事件
class CheckAdbEvent {
  final Either<Failure, Success> value;
  CheckAdbEvent(this.value);
  @override
  String toString() {
    return 'CheckAdbEvent $value';
  }
}
