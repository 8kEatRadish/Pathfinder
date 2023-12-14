import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pathfinder/feature/data/database/database.dart';
import 'package:pathfinder/res/assets.dart';
import 'package:pathfinder/res/dimens.dart';

import '../../../../data/add_command_repository_impl.dart';
import '../../../../domain/repository/adb_command_repository.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  // windows title bar widget
  Widget _windowsTitleBar() {
    return WindowTitleBarBox(
        child: MoveWindow(
            child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(Assets.appIcon),
        Padding(
            padding: const EdgeInsets.only(left: Dimens.titleMarginStart),
            child: Text(
              'app_name'.tr,
              style: Get.theme.textTheme.bodySmall,
            )),
        Expanded(
          child: Container(),
        ),
        MinimizeWindowButton(),
        MaximizeWindowButton(),
        CloseWindowButton(),
      ],
    )));
  }

  // 控制面板
  Widget _controlWidget(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _choseDevicesWidget(),
        const SizedBox(
          width: Dimens.paddingCommonSize,
          height: Dimens.paddingCommonSize,
        ),
        _featureListWidget(context),
      ],
    );
  }

  // 选择设备Widget
  Widget _choseDevicesWidget() {
    return Container(
      width: Dimens.controlWidgetWidth,
      height: Dimens.choseDevicesHeight,
      decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(6))),
      child: Text('app_name'.tr),
    );
  }

  // 功能列表Widget
  Widget _featureListWidget(BuildContext context) {
    return Container(
      width: Dimens.controlWidgetWidth,
      // 功能列表高度为  父类高度-appbar高度-选择设备widget高度-间距*3
      height: context.height -
          appWindow.titleBarHeight -
          Dimens.choseDevicesHeight -
          Dimens.paddingCommonSize * 3,
      decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(6))),
      child: ListView.builder(
          itemCount: 100,
          itemBuilder: (buildContext, index) {
            return Text("i am test $index");
          }),
    );
  }

  // 执行结果面板
  Widget _executionResultWidget(BuildContext context) {
    return Container(
      height: context.height -
          appWindow.titleBarHeight -
          Dimens.paddingCommonSize * 2,
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(6))),
      child: ListView.builder(
          reverse: true,
          itemCount: 10,
          itemBuilder: (buildContext, index) {
            return Text("i am test $index",
                style: Get.theme.textTheme.bodySmall);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put<AdbCommandRepository>(AddCommandRepositoryImpl(), permanent: true);

    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        _windowsTitleBar(),
        Padding(
          padding: const EdgeInsets.all(Dimens.paddingCommonSize),
          child: Row(
            children: [
              _controlWidget(context),
              const SizedBox(
                width: Dimens.paddingCommonSize,
                height: Dimens.paddingCommonSize,
              ),
              Expanded(
                child: _executionResultWidget(context),
              )
            ],
          ),
        )
      ],
    )));
  }
}
