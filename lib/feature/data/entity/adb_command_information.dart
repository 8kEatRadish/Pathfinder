import 'package:floor/floor.dart';

@entity
class AdbCommandInfo {
  @primaryKey
  final int id;

  final String name;

  final String commandInfo;

  AdbCommandInfo(this.id, this.name, this.commandInfo);
}
