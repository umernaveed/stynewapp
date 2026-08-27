import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/assets/drawables.dart';
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
  Size get preferredSize => Size.fromHeight(_type.isSmall ? 8.h : 17.h);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: ExactAssetImage(
            'assets/images/main_account_gradient.png',
          ),
        ),
      ),
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (backButtonVisible) ...[
              IconButton(
                icon: SvgPicture.asset(Drawables.icBack),
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
            ] else ...[
              SizedBox(
                width: 10.2.w,
                height: 8.h,
              ),
            ],
            const Spacer(),
            SizedBox(width: 8.1.w),
            Visibility(
              visible: appLogoVisble,
              child: Container(
                margin: _type.isSmall
                    ? EdgeInsets.zero
                    : EdgeInsets.only(top: 2.3.h),
                padding: EdgeInsets.only(right: _type.isSmall ? 0 : 10.w),
                child: AppLogo(
                  width: _type.isSmall ? 20.2 : 49.w,
                  height: _type.isSmall ? 7.h : 14.h,
                ),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
