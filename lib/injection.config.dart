// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'core/status/success.dart' as _i7;
import 'core/usercase/user_case.dart' as _i6;
import 'feature/domain/entity/device_info.dart' as _i8;
import 'feature/domain/usercase/check_adb_usercase.dart' as _i3;
import 'feature/domain/usercase/exec_command_usercase.dart' as _i4;
import 'feature/domain/usercase/get_device_list_usercase.dart' as _i5;
import 'injection.dart' as _i9;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.lazySingleton<_i3.CheckAdbUserCase>(
        () => appModule.getCheckAdbUserCase());
    gh.lazySingleton<_i4.ExecCommandUserCase>(
        () => appModule.getExecCommandUserCase());
    gh.lazySingleton<_i5.GetDeviceListUserCase>(
        () => appModule.getDeviceListUserCase());
    gh.factory<_i6.UserCase<_i7.CheckAdbSuccess, _i3.ParamsCheckAdbUserCase>>(
        () => _i3.CheckAdbUserCase());
    gh.factory<
            _i6
            .UserCase<List<_i8.DeviceInfo>, _i5.ParamsGetDeviceListUserCase>>(
        () => _i5.GetDeviceListUserCase());
    return this;
  }
}

class _$AppModule extends _i9.AppModule {}
