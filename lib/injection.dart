import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pathfinder/feature/domain/usercase/check_adb_usercase.dart';
import 'package:pathfinder/feature/domain/usercase/exec_command_usercase.dart';
import 'package:pathfinder/feature/domain/usercase/get_device_list_usercase.dart';

import 'injection.config.dart';

final location = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
void configureDependencies() => location.init();

@module
abstract class AppModule {
  @LazySingleton()
  CheckAdbUserCase getCheckAdbUserCase() => CheckAdbUserCase();

  @LazySingleton()
  GetDeviceListUserCase getDeviceListUserCase() => GetDeviceListUserCase();

  @LazySingleton()
  ExecCommandUserCase getExecCommandUserCase() => ExecCommandUserCase();
}
