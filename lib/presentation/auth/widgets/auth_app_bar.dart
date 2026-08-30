import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:straight_to_yard/presentation/widgets/dynamic_app_header.dart';

enum AuthScreenType {
  withLargeAppLogo,
  withSmallAppLogo;

  bool get isSmall => this == AuthScreenType.withSmallAppLogo;
}

class AuthCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthCustomAppBar({
    super.key,
    this.appLogoVisble = true,
    this.backButtonVisible = true,
    this.usingNavigator = false,
    this.backID,
  }) : _type = AuthScreenType.withLargeAppLogo;
  final bool appLogoVisble;
  final bool backButtonVisible;
  final AuthScreenType _type;
  final bool usingNavigator;
  final int? backID;

  const AuthCustomAppBar.withSmallAppLogo({
    super.key,
    this.backButtonVisible = true,
    this.appLogoVisble = true,
    this.usingNavigator = false,
    this.backID,
  }) : _type = AuthScreenType.withSmallAppLogo;

  @override
  Size get preferredSize => Size.fromHeight(_type.isSmall ? 8.2.h : 17.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8FBFF),
      alignment: Alignment.center,
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (backButtonVisible) ...[
              SizedBox(
                width: 12.w,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 10.w, minHeight: 5.h),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints:
                          BoxConstraints(minWidth: 10.w, minHeight: 5.h),
                      icon: Icon(
                        Icons.chevron_left_rounded,
                        color: const Color(0xFF087C25),
                        size: 2.5.h,
                      ),
                      onPressed: () {
                        if (usingNavigator) {
                          Navigator.of(context).pop();
                        } else if (backID != null) {
                          final navigator = Get.nestedKey(backID!)?.currentState;
                          if (navigator?.canPop() ?? false) {
                            Get.back(id: backID);
                          } else if (Get.isRegistered<BottomNavController>()) {
                            Get.find<BottomNavController>().onTabChange(0);
                          }
                        } else {
                          Get.back(id: backID);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ] else ...[
              SizedBox(width: 12.w),
            ],
            const Spacer(),
            Visibility(
              visible: appLogoVisble,
              child: AppLogo(
                width: _type.isSmall ? 20.5.w : 49.w,
                height: _type.isSmall ? 8.2.h : 14.h,
              ),
            ),
            const Spacer(),
            SizedBox(width: 12.w),
          ],
        ),
      ),
    );
  }
}
