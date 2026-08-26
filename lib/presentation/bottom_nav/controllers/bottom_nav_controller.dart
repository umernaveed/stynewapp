import 'dart:math';

import 'package:get/get.dart';
import 'package:straight_to_yard/app/core/routes/app_pages.dart';
import 'package:straight_to_yard/presentation/dashboard/controllers/dashboard_tabbar_controller.dart';

class BottomNavController extends GetxController {
  final bottomNavNestedID = Random().nextInt(999);

  var currentIndex = 0.obs;

  void onTabChange(int e) {
    if (currentIndex.value == e) {
      if (e == 0) _selectDashboardTab(0);
      if (e == 1) _selectDashboardTab(2);
      if (e == 4) _selectDashboardTab(1);
      return;
    }
    currentIndex.value = e;
    switch (e) {
      case 0:
        Get.toNamed(AppPages.dashboard, id: bottomNavNestedID);
        _selectDashboardTab(0);
        break;
      case 1:
        Get.toNamed(AppPages.dashboard, id: bottomNavNestedID);
        _selectDashboardTab(2);
        break;
      case 2:
        Get.toNamed(AppPages.deliveryScreen, id: bottomNavNestedID);
        break;
      case 3:
        Get.toNamed(AppPages.newsScreen, id: bottomNavNestedID);
        break;
      case 4:
        Get.toNamed(AppPages.dashboard, id: bottomNavNestedID);
        _selectDashboardTab(1);
        break;
    }
  }

  void onPageChanged(e) => currentIndex.value = e;

  void _selectDashboardTab(int index) {
    Future.delayed(50.milliseconds, () {
      if (Get.isRegistered<DashboardTabBarController>()) {
        Get.find<DashboardTabBarController>().tabController.animateTo(index);
      }
    });
  }
}
