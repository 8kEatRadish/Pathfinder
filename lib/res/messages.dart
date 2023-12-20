import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': {
          'app_name': 'Hummingbird',
          'connect_devices_phone': '请先连接手机设备',
        },
        'en_US': {
          'app_name': 'Hummingbird',
          'connect_devices_phone': '请先连接手机设备',
        }
      };
}
