import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/app/core/routes/app_pages.dart';
import 'package:straight_to_yard/data/models/dashboard_data/dashboard_data.dart';
import 'package:straight_to_yard/data/models/user/user.dart';
import 'package:straight_to_yard/domain/repositories/local_repository.dart';
import 'package:straight_to_yard/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:straight_to_yard/presentation/dashboard/controllers/dashboard_controller.dart';
import 'package:straight_to_yard/presentation/dashboard/controllers/dashboard_tabbar_controller.dart';
import 'package:straight_to_yard/presentation/widgets/shimmer_widget.dart';

class Dashboard extends GetView<DashboardController> {
  const Dashboard({super.key});

  static const _green = Color(0xFF087C25);
  static const _deepGreen = Color(0xFF006A1E);
  static const _yellow = Color(0xFFF9C80E);
  static const _text = Color(0xFF090D1B);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: _green,
      onRefresh: controller.refreshData,
      child: controller.obx(
        onLoading: const _ShimmerWidget(),
        onEmpty: const _StateMessage('No data found'),
        onError: (error) => const _StateMessage(
          'Something went wrong try again late',
        ),
        (state) {
          if (state == null) return const SizedBox.shrink();
          final user = find<LocalRepository>().getInstantUser();
          return LayoutBuilder(
            builder: (context, constraints) {
              final horizontal = constraints.maxWidth >= 600 ? 8.w : 3.w;
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(horizontal, 1.2.h, horizontal, 2.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Column(
                      children: [
                        const _HomeHeader(),
                        SizedBox(height: 2.4.h),
                        _AccountSummaryCard(data: state, user: user),
                        SizedBox(height: 2.1.h),
                        _StatsPanel(data: state),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 4.h,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tight(Size(6.h, 6.h)),
          onPressed: () {
            final bottomNavNestedID = find<BottomNavController>().bottomNavNestedID;
            Get.toNamed(AppPages.account, id: bottomNavNestedID);
          },
          icon: const Icon(Icons.menu_rounded, color: Dashboard._green),
        ),
        const Spacer(),
        SvgPicture.asset(
          'assets/svgs/app_logo_straight_to_yard.svg',
          width: math.min(context.width * 0.36, 180.0),
          fit: BoxFit.contain,
        ),
        const Spacer(),
        IconButton(
          iconSize: 3.9.h,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tight(Size(6.h, 6.h)),
          onPressed: () {},
          icon: const Icon(
            Icons.notifications_none_rounded,
            color: Dashboard._green,
          ),
        ),
      ],
    );
  }
}

class _AccountSummaryCard extends StatelessWidget {
  const _AccountSummaryCard({required this.data, required this.user});

  final DashboardData data;
  final User user;

  @override
  Widget build(BuildContext context) {
    final name = user.firstName.trim().isNotEmpty
        ? user.firstName.trim()
        : user.userName.trim().isNotEmpty
            ? user.userName.trim()
            : 'User';
    final initials = _initials(user);
    final accountId = user.mailbox.trim().isNotEmpty
        ? user.mailbox.trim()
        : data.outletId.trim().isNotEmpty && data.outletId != '-1'
            ? data.outletId.trim()
            : '--';

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Dashboard._green,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: CustomPaint(
        painter: const _SummaryCardPainter(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(4.w, 2.5.h, 4.w, 2.35.h),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _InitialsAvatar(initials: initials),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Hello, $name',
                            maxLines: 1,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              height: 1.05,
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Account ID: $accountId',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  height: 1.1,
                                ),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            GestureDetector(
                              onTap: () async {
                                await Clipboard.setData(
                                  ClipboardData(text: accountId),
                                );
                              },
                              child: Icon(
                                Icons.copy_rounded,
                                color: Colors.white,
                                size: 2.8.h,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 2.w),
                  const Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                    size: 34,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.15.h),
                child: const Divider(color: Colors.white, thickness: 1.1),
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _SummaryMetric(
                        label: 'Outstanding Balance',
                        labelIcon: Icons.visibility_outlined,
                        value: data.outstandingBalance,
                        suffix: _balanceSuffix(data.outstandingBalance),
                        buttonIcon: Icons.description_outlined,
                        buttonLabel: 'View Invoices',
                        onTap: _openInvoices,
                      ),
                    ),
                    VerticalDivider(
                      width: 6.w,
                      thickness: 1,
                      color: Colors.white.withOpacity(0.85),
                    ),
                    Expanded(
                      child: _SummaryMetric(
                        label: 'Packages Ready',
                        labelIcon: Icons.inventory_2_outlined,
                        value: data.outstandingPackage.toString(),
                        suffix: 'For Pickup',
                        buttonIcon: Icons.chevron_right_rounded,
                        buttonLabel: 'View Packages',
                        onTap: _openPackages,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _initials(User user) {
    final first = user.firstName.trim();
    final last = user.lastName.trim();
    if (first.isEmpty && last.isEmpty) return 'UN';
    final parts = [first, last].where((part) => part.isNotEmpty).toList();
    return parts.map((part) => part[0]).take(2).join().toUpperCase();
  }

  static String _balanceSuffix(String value) {
    return value.toUpperCase().contains('JMD') ? '' : 'JMD';
  }

  static void _openInvoices() {
    final bottomNavNestedID = find<BottomNavController>().bottomNavNestedID;
    Get.toNamed(AppPages.invoices, id: bottomNavNestedID);
  }

  static void _openPackages() {
    find<DashboardTabBarController>().tabController.animateTo(1);
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.6.h,
      height: 8.6.h,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD8E7DD), width: 4),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFEDF3EF), width: 2),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              initials,
              style: TextStyle(
                color: Dashboard._green,
                fontSize: 28,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.labelIcon,
    required this.value,
    required this.suffix,
    required this.buttonIcon,
    required this.buttonLabel,
    required this.onTap,
  });

  final String label;
  final IconData labelIcon;
  final String value;
  final String suffix;
  final IconData buttonIcon;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cleanValue = value.replaceAll('JMD', '').trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.08,
                ),
              ),
            ),
            Icon(labelIcon, color: Colors.white, size: 2.6.h),
          ],
        ),
        SizedBox(height: 1.55.h),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 1.4.w,
          children: [
            Text(
              cleanValue,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: label.startsWith('Outstanding')
                    ? Dashboard._yellow
                    : Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w800,
                height: 0.94,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 0.35.h),
              child: Text(
                suffix,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.8.h),
        SizedBox(
          width: double.infinity,
          height: 6.1.h,
          child: ElevatedButton.icon(
            onPressed: onTap,
            icon: Icon(buttonIcon, size: 3.h),
            label: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                buttonLabel,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Dashboard._deepGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsPanel extends StatelessWidget {
  const _StatsPanel({required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 3.8.w, vertical: 2.7.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFE4E8EA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _StatTile(
                    icon: Icons.warehouse_outlined,
                    value: data.wherehouse.toString(),
                    label: 'Miami\nWarehouse',
                  ),
                ),
                const _VerticalRule(),
                Expanded(
                  child: _StatTile(
                    icon: Icons.local_shipping_rounded,
                    iconColor: Dashboard._yellow,
                    badgeColor: const Color(0xFFFFF7DF),
                    value: data.inTransit.toString(),
                    label: 'In Transit',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.3.h),
            child: const Divider(color: Color(0xFFE7ECEF), thickness: 1.2),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _StatTile(
                    icon: Icons.check_circle_rounded,
                    filledIcon: true,
                    value: data.outstandingPackage.toString(),
                    label: 'Ready for Pickup',
                  ),
                ),
                const _VerticalRule(),
                Expanded(
                  child: _StatTile(
                    icon: Icons.account_balance_wallet_outlined,
                    value: data.outstandingBalance.replaceAll('JMD', '').trim(),
                    label: 'Outstanding Balance',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    this.iconColor = Dashboard._green,
    this.badgeColor = const Color(0xFFEFF7F1),
    this.filledIcon = false,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;
  final Color badgeColor;
  final bool filledIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.8.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 9.2.h,
            height: 9.2.h,
            decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
            child: Icon(
              icon,
              color: iconColor,
              size: filledIcon ? 5.8.h : 4.7.h,
            ),
          ),
          SizedBox(height: 1.35.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: TextStyle(
                color: Dashboard._text,
                fontSize: 32,
                fontWeight: FontWeight.w800,
                height: 0.95,
              ),
            ),
          ),
          SizedBox(height: 0.65.h),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.5,
              fontWeight: FontWeight.w400,
              height: 1.22,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalRule extends StatelessWidget {
  const _VerticalRule();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1.2, color: const Color(0xFFE7ECEF));
  }
}

class _SummaryCardPainter extends CustomPainter {
  const _SummaryCardPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()..color = Colors.white.withOpacity(0.08);
    for (double x = size.width * 0.32; x < size.width * 0.83; x += 6) {
      for (double y = size.height * 0.02; y < size.height * 0.92; y += 6) {
        final dx = (x / size.width) - 0.56;
        final dy = (y / size.height) - 0.45;
        if ((dx * dx * 2.2 + dy * dy) < 0.2) {
          canvas.drawCircle(Offset(x, y), 1.1, dotPaint);
        }
      }
    }

    final darkSweep = Paint()
      ..color = const Color(0xFF035918).withOpacity(0.72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 38;
    canvas.drawArc(
      Rect.fromLTWH(
        size.width * -0.25,
        size.height * 0.24,
        size.width * 1.55,
        size.height * 1.25,
      ),
      0.68,
      1.16,
      false,
      darkSweep,
    );

    final yellowSweep = Paint()
      ..color = Dashboard._yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    canvas.drawArc(
      Rect.fromLTWH(
        size.width * -0.22,
        size.height * 0.18,
        size.width * 1.52,
        size.height * 1.22,
      ),
      0.72,
      1.2,
      false,
      yellowSweep,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StateMessage extends StatelessWidget {
  const _StateMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: context.height / 1.5,
        width: context.width,
        child: Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Dashboard._text,
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _ShimmerWidget extends StatelessWidget {
  const _ShimmerWidget();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
      child: Column(
        children: [
          ShimmerWidget(
            radius: BorderRadius.circular(26),
            child: SizedBox(width: context.width, height: 34.h),
          ),
          SizedBox(height: 2.6.h),
          ShimmerWidget(
            radius: BorderRadius.circular(25),
            child: SizedBox(width: context.width, height: 47.h),
          ),
        ],
      ),
    );
  }
}
