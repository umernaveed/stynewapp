import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/routes/app_routes.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';
import 'package:straight_to_yard/presentation/bottom_nav/controllers/bottom_nav_controller.dart';

class BottomNavScreen extends GetView<BottomNavController> {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      value: SystemUiOverlayStyle.dark,
      showGradients: true,
      extendBody: true,
      wrapWithAnnotatedRegion: true,
      body: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        child: Navigator(
          key: Get.nestedKey(controller.bottomNavNestedID),
          onGenerateRoute: (settings) {
            Get.routing.args = settings.arguments;
            final page = AppRoutes.routes.firstWhere(
              (r) => r.name == settings.name,
            );
            return GetPageRoute<dynamic>(
              page: page.page,
              settings: settings,
              binding: page.binding,
              transition: page.transition,
              parameter: page.parameters,
              opaque: page.opaque,
              popGesture: page.popGesture,
              fullscreenDialog: page.fullscreenDialog,
              maintainState: page.maintainState,
              curve: page.curve,
              middlewares: page.middlewares,
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 9.8.h,
        margin: EdgeInsets.fromLTRB(3.w, 0, 3.w, 1.1.h),
        padding: EdgeInsets.only(top: 0.25.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: const Color(0xFFE4E8EA), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black38.withOpacity(0.08),
              spreadRadius: 0,
              offset: const Offset(0, 10),
              blurRadius: 24,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Obx(
            () => BottomNavigationBar(
              backgroundColor: Colors.white,
              elevation: 0,
              selectedItemColor: const Color(0xFF087C25),
              unselectedItemColor: const Color(0xFF090D1B),
              selectedLabelStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 8.sp,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 8.sp,
                fontWeight: FontWeight.w400,
              ),
              currentIndex: controller.currentIndex.value,
              onTap: controller.onTabChange,
              items: [
                BottomNavigationBarItem(
                  activeIcon: Padding(
                    padding: EdgeInsets.only(top: 0.35.h, bottom: 0.25.h),
                    child: SvgPicture.asset(
                      'assets/svgs/ic_home.svg',
                      color: const Color(0xFF087C25),
                      height: 2.2.h,
                    ),
                  ),
                  icon: Padding(
                    padding: EdgeInsets.only(top: 0.35.h, bottom: 0.25.h),
                    child: SvgPicture.asset(
                      'assets/svgs/ic_home.svg',
                      color: const Color(0xFF090D1B),
                      height: 2.2.h,
                    ),
                  ),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  activeIcon: Padding(
                    padding: EdgeInsets.only(top: 0.35.h, bottom: 0.25.h),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: const Color(0xFF087C25),
                      size: 2.45.h,
                    ),
                  ),
                  icon: Padding(
                    padding: EdgeInsets.only(top: 0.35.h, bottom: 0.25.h),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: const Color(0xFF090D1B),
                      size: 2.45.h,
                    ),
                  ),
                  label: 'Addresses',
                ),
                BottomNavigationBarItem(
                  activeIcon: Padding(
                    padding: EdgeInsets.only(top: 0.35.h, bottom: 0.25.h),
                    child: SvgPicture.asset(
                      'assets/svgs/ic_delivery.svg',
                      color: const Color(0xFF087C25),
                      height: 2.55.h,
                    ),
                  ),
                  icon: Padding(
                    padding: EdgeInsets.only(top: 0.35.h, bottom: 0.25.h),
                    child: SvgPicture.asset(
                      'assets/svgs/ic_delivery.svg',
                      color: const Color(0xFF090D1B),
                      height: 2.55.h,
                    ),
                  ),
                  label: 'Delivery',
                ),
                BottomNavigationBarItem(
                  activeIcon: Padding(
                    padding: EdgeInsets.only(top: 0.35.h, bottom: 0.25.h),
                    child: Icon(
                      Icons.calendar_month_outlined,
                      color: const Color(0xFF087C25),
                      size: 2.55.h,
                    ),
                  ),
                  icon: Padding(
                    padding: EdgeInsets.only(top: 0.35.h, bottom: 0.25.h),
                    child: Icon(
                      Icons.calendar_month_outlined,
                      color: const Color(0xFF090D1B),
                      size: 2.55.h,
                    ),
                  ),
                  label: 'News',
                ),
                BottomNavigationBarItem(
                  activeIcon: Padding(
                    padding: EdgeInsets.only(top: 0.35.h, bottom: 0.25.h),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      color: const Color(0xFF087C25),
                      size: 2.55.h,
                    ),
                  ),
                  icon: Padding(
                    padding: EdgeInsets.only(top: 0.35.h, bottom: 0.25.h),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      color: const Color(0xFF090D1B),
                      size: 2.55.h,
                    ),
                  ),
                  label: 'Packages',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
