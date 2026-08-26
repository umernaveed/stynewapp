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
      backgroundColor: const Color(0xFFF8FBFD),
      value: SystemUiOverlayStyle.dark,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontal = constraints.maxWidth >= 600 ? 8.w : 3.6.w;
            return Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.fromLTRB(horizontal, 1.2.h, horizontal, 0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 720),
                      child: Column(
                        children: [
                          const _InvoicesHeader(),
                          SizedBox(height: 3.2.h),
                          _InvoiceSearchField(
                            controller: controller.textEditingController,
                          ),
                          SizedBox(height: 2.6.h),
                        ],
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
                      padding:
                          EdgeInsets.fromLTRB(horizontal, 0, horizontal, 3.h),
                      builderDelegate: PagedChildBuilderDelegate<Invoice>(
                        animateTransitions: true,
                        transitionDuration: 500.milliseconds,
                        firstPageProgressIndicatorBuilder: (context) {
                          return const _InvoiceShimmerList();
                        },
                        newPageProgressIndicatorBuilder: (context) {
                          return const _InvoiceShimmerList();
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
                          SizedBox(height: 2.4.h),
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
    return DynamicAppHeader(
      logoWidthFactor: 0.38,
      maxLogoWidth: 190,
      onBack: () {
            if (Get.isRegistered<BottomNavController>()) {
              Get.back(id: find<BottomNavController>().bottomNavNestedID);
            } else {
              Get.back();
            }
      },
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: InvoicesScreen._line),
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
          Icon(Icons.search_rounded, color: InvoicesScreen._green, size: 4.2.h),
          SizedBox(width: 3.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search by invoice no, user name...',
                hintStyle: TextStyle(
                  color: InvoicesScreen._muted,
                  fontSize: 13.2.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: TextStyle(
                color: InvoicesScreen._text,
                fontSize: 13.2.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(width: 1, height: 5.h, color: InvoicesScreen._line),
          SizedBox(width: 2.w),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.filter_alt_outlined,
              color: InvoicesScreen._green,
              size: 4.h,
            ),
          ),
          SizedBox(width: 1.w),
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
      padding: EdgeInsets.fromLTRB(3.4.w, 3.h, 3.4.w, 2.7.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
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
              SizedBox(width: 3.w),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Invoice #${invoice.invoiceNo}',
                    maxLines: 1,
                    style: TextStyle(
                      color: InvoicesScreen._text,
                      fontSize: 18.sp,
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h),
            child: const Divider(color: InvoicesScreen._line, thickness: 1),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                Container(width: 1, color: InvoicesScreen._line),
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
          ),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            height: 7.h,
            child: ElevatedButton(
              onPressed: _openInvoiceDetail,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: InvoicesScreen._green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    'Invoice Detail',
                    style: TextStyle(
                      fontSize: 15.5.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right_rounded, size: 4.2.h),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.6.w),
      child: Row(
        children: [
          _InvoiceIconBadge(
            icon: icon,
            color: color,
            background: iconBackground,
            size: 7.3.h,
          ),
          SizedBox(width: 2.5.w),
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
                    fontSize: 12.6.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 1.h),
                customValue ??
                    Text(
                      value ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: color,
                        fontSize: 12.8.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
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

class _InvoiceIconBadge extends StatelessWidget {
  const _InvoiceIconBadge({
    required this.icon,
    required this.color,
    this.background = const Color(0xFFEFF7F1),
    this.size,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final badgeSize = size ?? 8.3.h;
    return Container(
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(icon, color: color, size: badgeSize * 0.52),
    );
  }
}

class _TopStatusBadge extends StatelessWidget {
  const _TopStatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5DF),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Text(
        status,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: const Color(0xFFE59A00),
          fontSize: 13.4.sp,
          fontWeight: FontWeight.w800,
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
      height: 4.6.h,
      padding: EdgeInsets.symmetric(horizontal: 2.6.w),
      decoration: BoxDecoration(
        color: InvoicesScreen._blue,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_rounded, color: Colors.white, size: 2.5.h),
          SizedBox(width: 1.3.w),
          Text(
            status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.6.sp,
              fontWeight: FontWeight.w800,
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
      padding: EdgeInsets.symmetric(horizontal: 2.6.w, vertical: 2.4.h),
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
      separatorBuilder: (context, index) => SizedBox(height: 2.4.h),
    );
  }
}

class _InvoiceShimmerCard extends StatelessWidget {
  const _InvoiceShimmerCard();

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      radius: BorderRadius.circular(24),
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
        child: Text(
          message,
          style: const TextStyle(
            color: InvoicesScreen._text,
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
