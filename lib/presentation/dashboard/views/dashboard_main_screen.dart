import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';
import 'package:straight_to_yard/presentation/dashboard/controllers/dashboard_tabbar_controller.dart';
import 'package:straight_to_yard/presentation/dashboard/views/address.dart';
import 'package:straight_to_yard/presentation/dashboard/views/dashboard.dart';
import 'package:straight_to_yard/presentation/dashboard/views/packages.dart';

class DashboardMainScreen extends GetView<DashboardTabBarController> {
  const DashboardMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      value: SystemUiOverlayStyle.dark,
      showGradients: false,
      backgroundColor: const Color(0xFFF8FBFD),
      body: SafeArea(
        bottom: false,
        child: TabBarView(
          controller: controller.tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            Dashboard(),
            Packages(),
            Address(),
          ],
        ),
      ),
    );
  }
}
