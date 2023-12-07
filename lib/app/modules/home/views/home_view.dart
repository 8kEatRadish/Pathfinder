import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathfinder/app/modules/home/controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        WindowTitleBarBox(
            child: MoveWindow(
                child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            MinimizeWindowButton(),
            MaximizeWindowButton(),
            CloseWindowButton(),
          ],
        ))),
        Center(
          child: Obx(() => Text("${controller.test}")),
        ),
        InkWell(
          child: const Text("点击我就变了"),
          onTap: () => {
            controller.test.value = "lalalalalala"
          },
        )
      ],
    ));
  }
}
