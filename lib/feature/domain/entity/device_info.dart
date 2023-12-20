import 'package:equatable/equatable.dart';

class DeviceInfo extends Equatable {
  final String id;
  final String brand;
  final String model;

  const DeviceInfo(this.id, this.brand, this.model);

  @override
  List<Object?> get props => [id, brand, model];
}
