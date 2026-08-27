import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/app/core/routes/app_pages.dart';
import 'package:straight_to_yard/app/extensions/string_ext.dart';
import 'package:straight_to_yard/data/models/invoice/invoice.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';
import 'package:straight_to_yard/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:straight_to_yard/presentation/invoices/controller/invoices_controller.dart';
import 'package:straight_to_yard/presentation/widgets/dynamic_app_header.dart';
import 'package:straight_to_yard/presentation/widgets/shimmer_widget.dart';

class InvoicesScreen extends GetView<InvoicesController> {
  const InvoicesScreen({super.key});

  static const _green = Color(0xFF087C25);
  static const _blue = Color(0xFF2176EF);
  static const _yellow = Color(0xFFFFB800);
  static const _purple = Color(0xFF4C2EAE);
  static const _text = Color(0xFF090D1B);
  static const _muted = Color(0xFF757987);
  static const _line = Color(0xFFE4E8EA);

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      showGradients: false,
      wrapWithAnnotatedRegion: true,
      backgroundColor: const Color(0xFFF8FBFF),
      value: SystemUiOverlayStyle.dark,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth >= 600 ? 8.w : 4.2.w;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontal),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: const _InvoicesHeader(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontal,
                    2.1.h,
                    horizontal,
                    1.2.h,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: _InvoiceSearchField(
                        controller: controller.textEditingController,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    color: _green,
                    onRefresh: () => Future.sync(
                      () => controller.pagingController.refresh(),
                    ),
                    child: PagedListView<int, Invoice>.separated(
                      pagingController: controller.pagingController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        horizontal,
                        0.8.h,
                        horizontal,
                        2.5.h,
                      ),
                      builderDelegate: PagedChildBuilderDelegate<Invoice>(
                        animateTransitions: true,
                        transitionDuration: 500.milliseconds,
                        firstPageProgressIndicatorBuilder: (context) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: const _InvoiceShimmerList(),
                          );
                        },
                        newPageProgressIndicatorBuilder: (context) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 2.h),
                            child: const _InvoiceShimmerList(),
                          );
                        },
                        noItemsFoundIndicatorBuilder: (context) {
                          return const _StateMessage('No invoices found');
                        },
                        itemBuilder: (context, item, index) {
                          return Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 720),
                              child: _InvoiceCard(invoice: item),
                            ),
                          );
                        },
                      ),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 2.h),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _InvoicesHeader extends StatelessWidget {
  const _InvoicesHeader();

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
                    if (Get.isRegistered<BottomNavController>()) {
                      Get.back(id: find<BottomNavController>().bottomNavNestedID);
                    } else {
                      Get.back();
                    }
                  },
                  icon: Icon(
                    Icons.chevron_left_rounded,
                    color: InvoicesScreen._green,
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

class _InvoiceSearchField extends StatelessWidget {
  const _InvoiceSearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7.4.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: InvoicesScreen._line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 2.8.w),
          Icon(Icons.search_rounded, color: InvoicesScreen._green, size: 3.4.h),
          SizedBox(width: 2.2.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search by invoice no, user name...',
                hintStyle: TextStyle(
                  color: InvoicesScreen._muted,
                  fontSize: 10.2.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: TextStyle(
                color: InvoicesScreen._text,
                fontSize: 10.2.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(width: 1, height: 4.3.h, color: InvoicesScreen._line),
          SizedBox(width: 1.5.w),
          SizedBox(
            width: 10.6.w,
            height: 5.3.h,
            child: Material(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(13),
              child: InkWell(
                borderRadius: BorderRadius.circular(13),
                onTap: () {},
                child: Icon(
                  Icons.filter_alt_outlined,
                  color: InvoicesScreen._green,
                  size: 3.2.h,
                ),
              ),
            ),
          ),
          SizedBox(width: 1.2.w),
        ],
      ),
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  const _InvoiceCard({required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    final status = invoice.status.trim().isEmpty ? 'Unpaid' : invoice.status;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(3.2.w, 2.2.h, 3.2.w, 1.9.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: InvoicesScreen._line),
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
            children: [
              _InvoiceIconBadge(
                icon: Icons.receipt_long_outlined,
                color: InvoicesScreen._green,
              ),
              SizedBox(width: 3.5.w),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Invoice #${invoice.invoiceNo}',
                    maxLines: 1,
                    style: TextStyle(
                      color: InvoicesScreen._text,
                      fontSize: 11.2.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.05,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              _TopStatusBadge(status: status),
            ],
          ),
          SizedBox(height: 1.9.h),
          const Divider(color: InvoicesScreen._line, height: 1, thickness: 1),
          SizedBox(height: 2.2.h),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _InvoiceMetric(
                        icon: Icons.calendar_month_outlined,
                        label: 'Date Created',
                        value: _date(invoice.createdAt),
                        color: InvoicesScreen._green,
                      ),
                      const _MetricRule(),
                      _InvoiceMetric(
                        icon: Icons.request_quote_outlined,
                        label: 'Invoice Paid',
                        value: _money(invoice.totalPaid),
                        color: InvoicesScreen._purple,
                        iconBackground: const Color(0xFFF0EAFF),
                      ),
                      const _MetricRule(),
                      _InvoiceMetric(
                        icon: Icons.account_balance_wallet_outlined,
                        label: 'Invoice Unpaid',
                        value: _money(invoice.totalInvoice),
                        color: InvoicesScreen._green,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 16.5.h,
                  margin: EdgeInsets.symmetric(horizontal: 2.2.w),
                  color: InvoicesScreen._line,
                ),
                Expanded(
                  child: Column(
                    children: [
                      _InvoiceMetric(
                        icon: Icons.event_available_outlined,
                        label: 'Date Paid',
                        value: _date(invoice.datePaid),
                        color: InvoicesScreen._green,
                      ),
                      const _MetricRule(),
                      _InvoiceMetric(
                        icon: Icons.person_outline_rounded,
                        label: 'User Name',
                        value: _dash(invoice.userName),
                        color: InvoicesScreen._purple,
                        iconBackground: const Color(0xFFF0EAFF),
                      ),
                      const _MetricRule(),
                      _InvoiceMetric(
                        icon: Icons.check_circle_outline_rounded,
                        label: 'Paid Status',
                        color: InvoicesScreen._blue,
                        customValue: _PaidStatusButton(status: status),
                        iconBackground: const Color(0xFFEAF4FF),
                      ),
                    ],
                  ),
                ),
              ],
          ),
          SizedBox(height: 2.2.h),
          SizedBox(
            width: double.infinity,
            height: 6.2.h,
            child: ElevatedButton(
              onPressed: _openInvoiceDetail,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: InvoicesScreen._green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    'Invoice Detail',
                    style: TextStyle(
                      fontSize: 10.8.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right_rounded, size: 3.4.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _dash(String value) {
    return value.trim().isEmpty ? '-' : value.trim();
  }

  static String _date(String value) {
    final formatted = value.toDDMMYYYY;
    return formatted.trim().isEmpty ? '-' : formatted;
  }

  static String _money(dynamic value) {
    final text = value?.toString().trim() ?? '';
    if (text.isEmpty) return '-';
    return text.toUpperCase().contains('JMD') ? text : '$text JMD';
  }

  void _openInvoiceDetail() {
    final bottomNavNestedID = find<BottomNavController>().bottomNavNestedID;
    Get.toNamed(
      AppPages.invoiceDetails,
      id: bottomNavNestedID,
      arguments: invoice.invoiceNo.toString(),
    );
  }
}

class _InvoiceMetric extends StatelessWidget {
  const _InvoiceMetric({
    required this.icon,
    required this.label,
    required this.color,
    this.value,
    this.customValue,
    this.iconBackground = const Color(0xFFEFF7F1),
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? customValue;
  final Color color;
  final Color iconBackground;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _InvoiceIconBadge(
          icon: icon,
          color: color,
          background: iconBackground,
        ),
        SizedBox(width: 2.7.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF2D303A),
                  fontSize: 8.8.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                ),
              ),
              SizedBox(height: 0.45.h),
              customValue ??
                  Text(
                    value ?? '-',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: color,
                      fontSize: 9.8.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InvoiceIconBadge extends StatelessWidget {
  const _InvoiceIconBadge({
    required this.icon,
    required this.color,
    this.background = const Color(0xFFEFF7F1),
    this.size,
    this.iconSize,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final double? size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final badgeSize = size ?? 6.1.h;
    return Container(
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, color: color, size: iconSize ?? 3.h),
    );
  }
}

class _TopStatusBadge extends StatelessWidget {
  const _TopStatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.6.w, vertical: 0.9.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5DF),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        status,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: const Color(0xFFE59A00),
          fontSize: 9.2.sp,
          fontWeight: FontWeight.w700,
          height: 1.1,
        ),
      ),
    );
  }
}

class _PaidStatusButton extends StatelessWidget {
  const _PaidStatusButton({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.4.w, vertical: 0.55.h),
      decoration: BoxDecoration(
        color: InvoicesScreen._blue,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_rounded, color: Colors.white, size: 1.9.h),
          SizedBox(width: 1.3.w),
          Text(
            status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 8.8.sp,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricRule extends StatelessWidget {
  const _MetricRule();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.95.h),
      child: const Divider(color: InvoicesScreen._line, thickness: 1),
    );
  }
}

class _InvoiceShimmerList extends StatelessWidget {
  const _InvoiceShimmerList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: 2,
      itemBuilder: (context, index) => const _InvoiceShimmerCard(),
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
    );
  }
}

class _InvoiceShimmerCard extends StatelessWidget {
  const _InvoiceShimmerCard();

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      radius: BorderRadius.circular(16),
      child: SizedBox(width: context.width, height: 62.h),
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height / 2,
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 14.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                color: InvoicesScreen._green,
                size: 8.h,
              ),
              SizedBox(height: 1.5.h),
              Text(
                message,
                style: TextStyle(
                  color: InvoicesScreen._text,
                  fontSize: 10.5.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
