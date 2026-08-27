import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/data/network/end_points.dart';
import 'package:straight_to_yard/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:straight_to_yard/presentation/onboarding/controllers/on_boarding_controller.dart';
import 'package:straight_to_yard/presentation/widgets/cache_image.dart';

class DynamicAppHeader extends StatelessWidget {
  const DynamicAppHeader({
    super.key,
    this.logoUrl,
    this.trailing,
    this.onBack,
    this.leadingIcon = Icons.chevron_left_rounded,
    this.logoWidthFactor = 0.36,
    this.maxLogoWidth = 180,
    this.iconColor = const Color(0xFF087C25),
  });

  final String? logoUrl;
  final Widget? trailing;
  final VoidCallback? onBack;
  final IconData leadingIcon;
  final double logoWidthFactor;
  final double maxLogoWidth;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 4.h,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tight(Size(6.h, 6.h)),
          onPressed: onBack ?? _pop,
          icon: Icon(leadingIcon, color: iconColor),
        ),
        const Spacer(),
        AppLogo(
          logoUrl: logoUrl,
          width: math.min(context.width * logoWidthFactor, maxLogoWidth),
          height: 9.h,
        ),
        const Spacer(),
        trailing ?? SizedBox(width: 6.h, height: 6.h),
      ],
    );
  }

  static void _pop() {
    if (Get.isRegistered<BottomNavController>()) {
      final controller = Get.find<BottomNavController>();
      final navigator = Get.nestedKey(controller.bottomNavNestedID)?.currentState;
      if (navigator?.canPop() ?? false) {
        Get.back(id: controller.bottomNavNestedID);
      } else if (controller.currentIndex.value != 0) {
        controller.onTabChange(0);
      }
      return;
    }
    Get.back();
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.logoUrl,
    required this.width,
    required this.height,
  });

  final String? logoUrl;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<OnBoardingController>()) {
      return Obx(() {
        final metaLogo =
            Get.find<OnBoardingController>().meta.value.setting?.appLogo;
        return _LogoImage(
          resolvedLogo: _resolveLogoUrl(logoUrl, metaLogo),
          width: width,
          height: height,
        );
      });
    }

    return _LogoImage(
      resolvedLogo: _resolveLogoUrl(logoUrl, null),
      width: width,
      height: height,
    );
  }

  static String _resolveLogoUrl(String? primary, String? fallback) {
    final logo = (primary?.trim().isNotEmpty ?? false)
        ? primary!.trim()
        : (fallback ?? '').trim();
    if (logo.isEmpty) return '';
    final uri = Uri.tryParse(logo);
    if (uri != null && uri.hasScheme) return logo;
    if (logo.startsWith('/')) return '${EndPoints.baseURL}$logo';
    return '${EndPoints.baseURL}/$logo';
  }
}

class _LogoImage extends StatelessWidget {
  const _LogoImage({
    required this.resolvedLogo,
    required this.width,
    required this.height,
  });

  final String resolvedLogo;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final fallback = Image.asset(
      'assets/images/icon.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );

    if (resolvedLogo.isEmpty) return fallback;

    if (_isSvgUrl(resolvedLogo)) {
      return SvgPicture.network(
        resolvedLogo,
        width: width,
        height: height,
        fit: BoxFit.contain,
        placeholderBuilder: (_) => SizedBox(width: width, height: height),
      );
    }

    return CachedImage(
      imageUrl: resolvedLogo,
      width: width,
      height: height,
      fit: BoxFit.contain,
      placeHolder: SizedBox(width: width, height: height),
      errorWidget: fallback,
    );
  }

  static bool _isSvgUrl(String url) {
    final uri = Uri.tryParse(url);
    return (uri?.path ?? url).toLowerCase().endsWith('.svg');
  }
}
