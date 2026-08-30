import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/app/core/routes/app_pages.dart';
import 'package:straight_to_yard/app/util/flush_snackbar.dart';
import 'package:straight_to_yard/presentation/account/controllers/account_controller.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';
import 'package:straight_to_yard/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:straight_to_yard/presentation/widgets/cache_image.dart';
import 'package:straight_to_yard/presentation/widgets/dialogs/account_delete_dialog.dart';
import 'package:straight_to_yard/presentation/widgets/dynamic_app_header.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  static const _green = Color(0xFF087C25);
  static const _darkGreen = Color(0xFF005D1B);
  static const _yellow = Color(0xFFFFB800);
  static const _text = Color(0xFF090D1B);
  static const _muted = Color(0xFF5C6070);
  static const _line = Color(0xFFE4E8EA);
  static const _danger = Color(0xFFE50914);

  @override
  Widget build(BuildContext context) {
    final bottomNavController = find<BottomNavController>();
    final horizontal = context.width >= 600 ? 8.w : 3.w;

    return BaseScreen(
      backgroundColor: const Color(0xFFF8FBFF),
      showGradients: false,
      value: SystemUiOverlayStyle.dark,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 2.4.h),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    children: [
                      _AccountHeader(bottomNavController: bottomNavController),
                      SizedBox(height: 2.1.h),
                      const _ProfileHero(),
                      SizedBox(height: 2.2.h),
                      _MenuCard(bottomNavController: bottomNavController),
                      SizedBox(height: 1.4.h),
                      const _ActionsCard(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AccountHeader extends StatelessWidget {
  const _AccountHeader({required this.bottomNavController});

  final BottomNavController bottomNavController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8.2.h,
      child: Row(
        children: [
          SizedBox(
            width: 12.w,
            child: Align(
              alignment: Alignment.centerLeft,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 10.w, minHeight: 5.h),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(minWidth: 10.w, minHeight: 5.h),
                  onPressed: () {
                    final navigator = Get.nestedKey(
                      bottomNavController.bottomNavNestedID,
                    )
                        ?.currentState;
                    if (navigator?.canPop() ?? false) {
                      Get.back(id: bottomNavController.bottomNavNestedID);
                    } else {
                      bottomNavController.onTabChange(0);
                    }
                  },
                  icon: Icon(
                    Icons.chevron_left_rounded,
                    color: AccountScreen._green,
                    size: 2.5.h,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          AppLogo(width: 20.5.w, height: 8.2.h),
          const Spacer(),
          SizedBox(width: 12.w),
        ],
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero();

  @override
  Widget build(BuildContext context) {
    final controller = find<AccountController>();
    return Obx(() {
      final user = controller.user.value;
      final name = user.completeName.trim().isNotEmpty
          ? user.completeName.trim()
          : user.userName.trim().isNotEmpty
              ? user.userName.trim()
              : 'User';
      final email = user.email.trim().isNotEmpty ? user.email.trim() : '-';

      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(17),
          onTap: () => Get.toNamed(AppPages.updateProfile),
          child: Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            padding: EdgeInsets.symmetric(horizontal: 4.2.w, vertical: 2.6.h),
            decoration: BoxDecoration(
              color: AccountScreen._green,
              borderRadius: BorderRadius.circular(17),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 22,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: CustomPaint(
              painter: const _HeroWavePainter(),
              child: Row(
                children: [
                  _ProfileAvatar(imageUrl: user.image),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.2.sp,
                                  fontWeight: FontWeight.w900,
                                  height: 1.05,
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Icon(
                              Icons.edit_outlined,
                              color: AccountScreen._yellow,
                              size: 2.8.h,
                            ),
                          ],
                        ),
                        SizedBox(height: 0.6.h),
                        Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.8.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AccountScreen._yellow,
                    size: 4.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      decoration: const BoxDecoration(
        color: AccountScreen._danger,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.priority_high_rounded,
        color: Colors.white,
        size: 5.4.h,
      ),
    );

    return Container(
      width: 8.6.h,
      height: 8.6.h,
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: imageUrl.trim().isEmpty
            ? fallback
            : CachedImage(
                imageUrl: imageUrl,
                width: 8.6.h,
                height: 8.6.h,
                fit: BoxFit.cover,
                errorWidget: fallback,
              ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.bottomNavController});

  final BottomNavController bottomNavController;

  @override
  Widget build(BuildContext context) {
    return _ShadowCard(
      padding: EdgeInsets.all(1.3.w),
      blurRadius: 18,
      offset: const Offset(0, 8),
      child: Column(
        children: [
          _NormalMenuTile(
            title: 'Dashboard',
            icon: Icons.home_outlined,
            onTap: () => bottomNavController.onTabChange(0),
          ),
          const _CardDivider(),
          _ExpandableMenuTile(
            title: 'Authorize User',
            icon: Icons.person_outline_rounded,
            children: [
              _MenuChildTile(
                title: 'Create Authorize User',
                onTap: () {
                  Get.toNamed(
                    AppPages.addAuthorizeUser,
                    id: bottomNavController.bottomNavNestedID,
                  );
                },
              ),
              _MenuChildTile(
                title: 'Authorize Users',
                onTap: () => bottomNavController.onTabChange(1),
              ),
            ],
          ),
          const _CardDivider(),
          _ExpandableMenuTile(
            title: 'My Account',
            icon: Icons.credit_card_outlined,
            children: [
              _MenuChildTile(
                title: 'Add Pre-Alert',
                onTap: () {
                  Get.toNamed(
                    AppPages.addPreAlertScreen,
                    id: bottomNavController.bottomNavNestedID,
                  );
                },
              ),
              _MenuChildTile(
                title: 'Track Packages',
                onTap: () {
                  Get.toNamed(
                    AppPages.trackPackages,
                    id: bottomNavController.bottomNavNestedID,
                  );
                },
              ),
              _MenuChildTile(
                title: 'Invoices',
                onTap: () {
                  Get.toNamed(
                    AppPages.invoices,
                    id: bottomNavController.bottomNavNestedID,
                  );
                },
              ),
            ],
          ),
          const _CardDivider(),
          _ExpandableMenuTile(
            title: 'Delivery System',
            icon: Icons.location_on_outlined,
            iconColor: AccountScreen._yellow,
            iconBackground: const Color(0xFFFFF5DF),
            children: [
              _MenuChildTile(
                title: 'Request Delivery',
                onTap: () => bottomNavController.onTabChange(2),
              ),
            ],
          ),
          const _CardDivider(),
          _ExpandableMenuTile(
            title: 'Purchase Request',
            icon: Icons.shopping_cart_outlined,
            children: [
              _MenuChildTile(
                title: 'Create Purchase Request',
                onTap: () {
                  Get.toNamed(
                    AppPages.addPurchase,
                    id: bottomNavController.bottomNavNestedID,
                  );
                },
              ),
              _MenuChildTile(
                title: 'Purchase Requests',
                onTap: () {
                  Get.toNamed(
                    AppPages.purchase,
                    id: bottomNavController.bottomNavNestedID,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShadowCard extends StatelessWidget {
  const _ShadowCard({
    required this.child,
    required this.padding,
    required this.blurRadius,
    required this.offset,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double blurRadius;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AccountScreen._line),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A1530).withOpacity(0.08),
            blurRadius: blurRadius,
            offset: offset,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _NormalMenuTile extends StatelessWidget {
  const _NormalMenuTile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.iconColor = AccountScreen._green,
    this.iconBackground = const Color(0xFFEFF7F1),
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  final Color iconBackground;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.75.h),
          child: Row(
            children: [
              _MenuIconBox(
                icon: icon,
                color: iconColor,
                background: iconBackground,
              ),
              SizedBox(width: 4.w),
              Expanded(child: _MenuTitle(title)),
              Icon(
                Icons.chevron_right_rounded,
                color: AccountScreen._darkGreen,
                size: 3.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExpandableMenuTile extends StatefulWidget {
  const _ExpandableMenuTile({
    required this.title,
    required this.icon,
    required this.children,
    this.iconColor = AccountScreen._green,
    this.iconBackground = const Color(0xFFEFF7F1),
  });

  final String title;
  final IconData icon;
  final List<Widget> children;
  final Color iconColor;
  final Color iconBackground;

  @override
  State<_ExpandableMenuTile> createState() => _ExpandableMenuTileState();
}

class _ExpandableMenuTileState extends State<_ExpandableMenuTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.75.h),
              child: Row(
                children: [
                  _MenuIconBox(
                    icon: widget.icon,
                    color: widget.iconColor,
                    background: widget.iconBackground,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(child: _MenuTitle(widget.title)),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: AccountScreen._darkGreen,
                    size: 3.h,
                  ),
                ],
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: 180.milliseconds,
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: EdgeInsets.fromLTRB(17.w, 0, 4.w, 1.2.h),
            child: Column(children: widget.children),
          ),
        ),
      ],
    );
  }
}

class _MenuChildTile extends StatelessWidget {
  const _MenuChildTile({
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0.9.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AccountScreen._muted,
                    fontSize: 9.4.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AccountScreen._darkGreen,
                size: 2.3.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuIconBox extends StatelessWidget {
  const _MenuIconBox({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 5.7.h,
      height: 5.7.h,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(icon, color: color, size: 3.h),
    );
  }
}

class _MenuTitle extends StatelessWidget {
  const _MenuTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: AccountScreen._text,
        fontSize: 11.2.sp,
        fontWeight: FontWeight.w800,
        height: 1.1,
      ),
    );
  }
}

class _CardDivider extends StatelessWidget {
  const _CardDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AccountScreen._line,
    );
  }
}

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: AccountScreen._line,
    );
  }
}

class _ActionsCard extends StatelessWidget {
  const _ActionsCard();

  @override
  Widget build(BuildContext context) {
    return _ShadowCard(
      padding: EdgeInsets.all(1.3.w),
      blurRadius: 18,
      offset: const Offset(0, 8),
      child: Column(
        children: const [
          _ActionTile(
            title: 'Log Out',
            subtitle: 'Securely log out from your account',
            icon: Icons.logout_rounded,
            color: AccountScreen._green,
            background: Color(0xFFEFF7F1),
            action: _AccountAction.logout,
          ),
          SizedBox(height: 0),
          _ActionTile(
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            icon: Icons.delete_outline_rounded,
            color: AccountScreen._danger,
            background: Color(0xFFFFECEF),
            action: _AccountAction.delete,
          ),
        ],
      ),
    );
  }
}

enum _AccountAction { logout, delete }

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.background,
    required this.action,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color background;
  final _AccountAction action;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _handleAction(action),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.7.h),
          child: Row(
            children: [
              _MenuIconBox(icon: icon, color: color, background: Colors.white),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: color,
                        fontSize: 11.2.sp,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                    SizedBox(height: 0.25.h),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AccountScreen._muted,
                        fontSize: 9.2.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AccountScreen._darkGreen,
                size: 3.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleAction(_AccountAction action) async {
    switch (action) {
      case _AccountAction.logout:
        final c = find<AccountController>();
        final value = await c.onLogOut();
        if (value.isDone) {
          Get.offAllNamed(AppPages.login);
        } else if (value.message.isNotEmpty) {
          FlushSnackbar.showSnackBar(value.message);
        }
        break;
      case _AccountAction.delete:
        final result =
            await Get.dialog<bool>(const AccountDeleteConfirmationDialog());
        if (!(result ?? false)) return;
        await find<AccountController>().deleteAccount();
        break;
    }
  }
}

class _HeroWavePainter extends CustomPainter {
  const _HeroWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.13)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (var i = 0; i < 16; i++) {
      final path = Path();
      final y = size.height * (0.18 + i * 0.04);
      path.moveTo(size.width * 0.45, y);
      path.cubicTo(
        size.width * 0.64,
        y - 24,
        size.width * 0.72,
        y + 24,
        size.width,
        y - 4,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
