import 'package:equatable/equatable.dart';

class CommandInfo extends Equatable {
  final int id;
  final String name;
  final String commandValue;


  const CommandInfo(this.id, this.name, this.commandValue);

  @override
  List<Object?> get props => [id, name, commandValue];
}