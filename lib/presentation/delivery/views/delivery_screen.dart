import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/app/core/routes/app_pages.dart';
import 'package:straight_to_yard/app/extensions/string_ext.dart';
import 'package:straight_to_yard/data/models/get_all_package/get_all_package.dart';
import 'package:straight_to_yard/presentation/auth/widgets/auth_app_bar.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';
import 'package:straight_to_yard/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:straight_to_yard/presentation/delivery/controllers/delivery_controller.dart';
import 'package:straight_to_yard/presentation/widgets/shimmer_widget.dart';

class DeliveryScreen extends GetView<DeliveryController> {
  const DeliveryScreen({super.key});

  static const _green = Color(0xFF087C25);
  static const _deepGreen = Color(0xFF006A1E);
  static const _yellow = Color(0xFFFFB800);
  static const _text = Color(0xFF090D1B);
  static const _muted = Color(0xFF757987);
  static const _line = Color(0xFFE4E8EA);
  static const _background = Color(0xFFF8FBFF);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      showGradients: false,
      value: SystemUiOverlayStyle.dark,
      backgroundColor: _background,
      appBar: AuthCustomAppBar.withSmallAppLogo(
        backID: find<BottomNavController>().bottomNavNestedID,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final horizontal = constraints.maxWidth >= 600 ? 8.w : 3.6.w;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(horizontal, 1.2.h, horizontal, 0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Column(
                      children: [
                        const _DeliveryHero(),
                        SizedBox(height: 1.8.h),
                        _DeliverySearchField(
                          controller: controller.textEditingController,
                        ),
                        SizedBox(height: 1.5.h),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  color: _green,
                  onRefresh: () => Future.sync(() => controller.onRefresh()),
                  child: PagedListView<int, GetAllPackage>.separated(
                    pagingController: controller.pagingController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.fromLTRB(horizontal, 0, horizontal, 13.2.h),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    builderDelegate: PagedChildBuilderDelegate<GetAllPackage>(
                      animateTransitions: true,
                      transitionDuration: 400.milliseconds,
                      firstPageProgressIndicatorBuilder: (_) {
                        return const ShimmerListView();
                      },
                      newPageProgressIndicatorBuilder: (_) {
                        return const ShimmerListView();
                      },
                      noItemsFoundIndicatorBuilder: (_) {
                        return const _StateMessage('No delivery packages found');
                      },
                      itemBuilder: (context, item, index) {
                        return Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 720),
                            child: _DeliveryPackageCard(item: item),
                          ),
                        );
                      },
                    ),
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 1.5.h),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.fromLTRB(horizontal, 0, horizontal, 1.1.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: const _DeliveryFooter(),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DeliveryHero extends StatelessWidget {
  const _DeliveryHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(4.2.w, 2.1.h, 4.2.w, 2.1.h),
      decoration: BoxDecoration(
        color: DeliveryScreen._green,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 7.4.h,
            height: 7.4.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: DeliveryScreen._yellow, width: 1.2),
            ),
            child: Icon(
              Icons.local_shipping_rounded,
              color: Colors.white,
              size: 4.3.h,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Request',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.8.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 0.65.h),
                Text(
                  'Choose ready packages and schedule delivery.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 9.6.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.18,
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

class _DeliverySearchField extends StatelessWidget {
  const _DeliverySearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.8.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: DeliveryScreen._line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 14,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 4.w),
          Icon(
            Icons.search_rounded,
            color: DeliveryScreen._green,
            size: 4.1.h,
          ),
          SizedBox(width: 2.8.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search by HAWB / Tracking / Supplier',
                hintStyle:
                    Theme.of(context).inputDecorationTheme.hintStyle?.copyWith(
                          color: DeliveryScreen._muted,
                          fontSize: 10.2.sp,
                          fontWeight: FontWeight.w400,
                        ) ??
                        TextStyle(
                          color: DeliveryScreen._muted,
                          fontSize: 10.2.sp,
                          fontWeight: FontWeight.w400,
                        ),
              ),
              style: TextStyle(
                color: DeliveryScreen._text,
                fontSize: 10.2.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 3.w),
        ],
      ),
    );
  }
}

class _DeliveryPackageCard extends GetView<DeliveryController> {
  const _DeliveryPackageCard({required this.item});

  final GetAllPackage item;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedItems.contains(item);
      return Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => controller.onItemChecked(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(3.4.w, 2.h, 3.4.w, 1.9.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: selected
                    ? DeliveryScreen._green
                    : DeliveryScreen._line,
                width: selected ? 1.35 : 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SelectBadge(selected: selected),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'HAWB: ${_hawb(item)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: DeliveryScreen._text,
                                    fontSize: 10.4.sp,
                                    fontWeight: FontWeight.w800,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              SizedBox(width: 2.w),
                              _AmountPill(amount: _money(item.packageInvoice)),
                            ],
                          ),
                          SizedBox(height: 1.2.h),
                          _DeliveryInfoRow(
                            icon: Icons.calendar_month_outlined,
                            label: 'Date:',
                            value: item.createdAt.toDDMMYYYY,
                          ),
                          const _CardRule(),
                          _DeliveryInfoRow(
                            icon: Icons.person_outline_rounded,
                            label: 'Name:',
                            value: _dash(item.userName),
                          ),
                          const _CardRule(),
                          _DeliveryInfoRow(
                            icon: Icons.inventory_2_outlined,
                            iconColor: DeliveryScreen._yellow,
                            label: 'Supplier:',
                            value: _dash(item.courier),
                          ),
                          const _CardRule(),
                          _DeliveryInfoRow(
                            icon: Icons.location_on_outlined,
                            iconColor: Color(0xFF22AFC8),
                            label: 'Tracking:',
                            value: _dash(item.supplierTrackingNo),
                          ),
                          const _CardRule(),
                          _DeliveryInfoRow(
                            icon: Icons.description_outlined,
                            iconColor: Color(0xFF22283A),
                            label: 'Description:',
                            value: _dash(item.itemDescription),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  static String _hawb(GetAllPackage item) {
    if (item.trackingNo.trim().isNotEmpty) return item.trackingNo.trim();
    if (item.packageCode.trim().isNotEmpty) return item.packageCode.trim();
    if (item.manifestNo.trim().isNotEmpty) return item.manifestNo.trim();
    return '-';
  }

  static String _dash(String? value) {
    final clean = value?.trim() ?? '';
    return clean.isEmpty ? '-' : clean;
  }

  static String _money(String? value) {
    final amount = num.tryParse(value ?? '0') ?? 0;
    return 'JMD ${amount.toStringAsFixed(2)}';
  }
}

class _SelectBadge extends StatelessWidget {
  const _SelectBadge({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 5.6.h,
      height: 5.6.h,
      decoration: BoxDecoration(
        color: selected ? DeliveryScreen._green : const Color(0xFFEFF7F1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        selected ? Icons.check_rounded : Icons.local_shipping_outlined,
        color: selected ? Colors.white : DeliveryScreen._green,
        size: selected ? 3.2.h : 3.h,
      ),
    );
  }
}

class _AmountPill extends StatelessWidget {
  const _AmountPill({required this.amount});

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.4.w, vertical: 0.75.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5DF),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        amount,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: DeliveryScreen._deepGreen,
          fontSize: 8.6.sp,
          fontWeight: FontWeight.w800,
          height: 1.1,
        ),
      ),
    );
  }
}

class _DeliveryInfoRow extends StatelessWidget {
  const _DeliveryInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = DeliveryScreen._green,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 4.2.h,
          child: Icon(icon, color: iconColor, size: 2.6.h),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: DeliveryScreen._text,
            fontSize: 9.3.sp,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: DeliveryScreen._green,
              fontSize: 9.3.sp,
              fontWeight: FontWeight.w500,
              height: 1.1,
            ),
          ),
        ),
      ],
    );
  }
}

class _CardRule extends StatelessWidget {
  const _CardRule();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.25.h),
      child: Container(height: 1, color: DeliveryScreen._line),
    );
  }
}

class _DeliveryFooter extends GetView<DeliveryController> {
  const _DeliveryFooter();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final count = controller.selectedItems.length;
      return Container(
        padding: EdgeInsets.fromLTRB(3.4.w, 1.4.h, 3.4.w, 1.4.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: DeliveryScreen._line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x18000000),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: _FooterMetric(
                    label: 'Packages',
                    value: count.toString(),
                  ),
                ),
                Container(
                  width: 1,
                  height: 4.7.h,
                  color: DeliveryScreen._line,
                ),
                Expanded(
                  child: _FooterMetric(
                    label: 'Total Due',
                    value: 'JMD ${controller.totalAmount.value.toStringAsFixed(2)}',
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.2.h),
            Row(
              children: [
                SizedBox(
                  width: 24.w,
                  height: 5.6.h,
                  child: OutlinedButton(
                    onPressed: count <= 0 ? null : () => controller.onClear(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: DeliveryScreen._green,
                      side: const BorderSide(color: Color(0xFFD8E9DD)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 9.6.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: SizedBox(
                    height: 5.6.h,
                    child: ElevatedButton(
                      onPressed: count <= 0 ? null : _openRequest,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: DeliveryScreen._green,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFFE4E8EA),
                        disabledForegroundColor: DeliveryScreen._muted,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Create Request',
                            style: TextStyle(
                              fontSize: 10.2.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 1.2.w),
                          Icon(Icons.arrow_forward_rounded, size: 2.3.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  void _openRequest() {
    final bottomNavNestedID = find<BottomNavController>().bottomNavNestedID;
    Get.toNamed(
      AppPages.managePickupRequest,
      id: bottomNavNestedID,
    );
  }
}

class _FooterMetric extends StatelessWidget {
  const _FooterMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: DeliveryScreen._text,
            fontSize: 11.2.sp,
            fontWeight: FontWeight.w900,
            height: 1.05,
          ),
        ),
        SizedBox(height: 0.45.h),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: DeliveryScreen._muted,
            fontSize: 8.7.sp,
            fontWeight: FontWeight.w600,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 12.h),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: DeliveryScreen._muted,
            fontSize: 10.5.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
