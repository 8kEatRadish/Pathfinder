import 'package:get/get.dart';

import '../modules/home/controllers/home_controller.dart';
import '../modules/home/views/home_view.dart';


part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;
  static final routes = [
    GetPage(
        name: Routes.home,
        page: () => const HomeView(),
        binding: BindingsBuilder(() {
          Get.lazyPut(() => HomeController());
        }))
  ];
}
