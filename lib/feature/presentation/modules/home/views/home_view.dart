import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pathfinder/core/status/page_status.dart';
import 'package:pathfinder/core/utils/execution_utils.dart';
import 'package:pathfinder/feature/domain/entity/device_info.dart';
import 'package:pathfinder/res/assets.dart';
import 'package:pathfinder/res/dimens.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  /// windows title bar widget
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
              style: Get.theme.textTheme.bodyMedium,
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

  /// 控制面板
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

  /// 选择设备Widget
  Widget _choseDevicesWidget() {
    return Obx(() => Container(
          width: Dimens.controlWidgetWidth,
          height: Dimens.choseDevicesHeight,
          decoration: BoxDecoration(
              color: Get.theme.cardColor,
              borderRadius: const BorderRadius.all(
                  Radius.circular(Dimens.commonBorderRadius))),
          child: DropdownButton2<DeviceInfo>(
            buttonStyleData: ButtonStyleData(
                decoration: BoxDecoration(
                    color: Get.theme.cardColor,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(Dimens.commonBorderRadius)))),
            hint: Text(
              'connect_devices_phone'.tr,
              style: Get.theme.textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            value: controller.currentDevice.value,
            underline: Container(),
            isExpanded: true,
            dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                    color: Get.theme.cardColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(Dimens.commonBorderRadius),
                        bottomRight:
                            Radius.circular(Dimens.commonBorderRadius)))),
            items: controller.devices
                .map((DeviceInfo item) => DropdownMenuItem<DeviceInfo>(
                      value: item,
                      child: Text(
                        '${item.id} ${item.brand} ${item.model}',
                        style: Get.theme.textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                      ),
                    ))
                .toList(),
            onChanged: (value) {
              controller.currentDevice.value = value!;
            },
          ),
        ));
  }

  /// 功能列表Widget
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
      child: Padding(
        padding: const EdgeInsets.all(Dimens.paddingCommonSize),
        child: Obx(() => ListView.builder(
            itemCount: controller.commandInfoList.length,
            itemBuilder: (buildContext, index) {
              return TextButton(
                  style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.hovered)) {
                          return Get.theme.hoverColor;
                        }
                        return Get.theme.cardColor;
                      })),
                  onPressed: () {
                    controller
                        .onClickCommandItem(controller.commandInfoList[index]);
                  },
                  child: Text(
                    controller.commandInfoList[index].name,
                    style: Get.theme.textTheme.bodySmall,
                  ));
            })),
      ),
    );
  }

  /// 执行结果面板
  Widget _executionResultWidget(BuildContext context) {
    return Obx(() => Container(
          padding: const EdgeInsets.all(Dimens.paddingCommonSize),
          height: context.height -
              appWindow.titleBarHeight -
              Dimens.paddingCommonSize * 2,
          decoration: BoxDecoration(
              color: Get.theme.primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(6))),
          child: ListView.builder(
              reverse: true,
              itemCount: controller.executionResult.length,
              itemBuilder: (buildContext, index) {
                return Text.rich(ExecutionUtils().getExecutionSpan(
                    controller.executionResult[index],
                    Get.theme.textTheme.bodyMedium));
              }),
        ));
  }

  /// 主页面
  Widget _mainWidget(BuildContext context) {
    var mainWidget = Padding(
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
    );
    return Obx(() {
      if (controller.pageStatus.value is Loadings) {
        return _getLoadingWidget(controller.pageStatus.value.value);
      }
      if (controller.pageStatus.value is Error) {
        return _getErrorWidget(controller.pageStatus.value.value);
      }
      return mainWidget;
    });
  }

  Widget _getErrorWidget(String content) {
    var errorWidget = Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(
          Icons.error,
          color: Colors.red,
          size: 200,
        ),
        const SizedBox(
          height: Dimens.paddingCommonSize,
        ),
        Text(content, style: Get.theme.textTheme.bodyMedium)
      ],
    ));
    return errorWidget;
  }

  Widget _getLoadingWidget(String content) {
    var loadingWidget = Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LoadingAnimationWidget.inkDrop(color: Get.theme.hoverColor, size: 50),
        const SizedBox(
          height: Dimens.paddingCommonSize,
        ),
        Text(content, style: Get.theme.textTheme.bodyMedium)
      ],
    ));
    return loadingWidget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [_windowsTitleBar(), _mainWidget(context)],
    )));
  }
}
