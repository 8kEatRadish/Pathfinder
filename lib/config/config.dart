class Config {
  static final _config = Config._();

  Config._();

  factory Config() => _config;


  static const String deviceIdKey = "deviceIdKey";
  static const String packageNameKey = "packageNameKey";
  static const String adbFilePathKey = "adbFilePathKey";


  static String adbPath = "";
}
