import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/app/core/routes/app_pages.dart';
import 'package:straight_to_yard/app/extensions/string_ext.dart';
import 'package:straight_to_yard/data/models/get_packages_ready_for_pickup_response/get_packages_ready_for_pickup_response.dart';
import 'package:straight_to_yard/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:straight_to_yard/presentation/controller/download_file_controller.dart';
import 'package:straight_to_yard/presentation/dashboard/controllers/dashboard_packages_controller.dart';
import 'package:straight_to_yard/presentation/widgets/dialogs/download_dialog.dart';
import 'package:straight_to_yard/presentation/widgets/dialogs/file_upload_dialog.dart';
import 'package:straight_to_yard/presentation/widgets/shimmer_widget.dart';

class Packages extends GetView<DashboardPackagesController> {
  const Packages({super.key});

  static const _green = Color(0xFF087C25);
  static const _blue = Color(0xFF2176EF);
  static const _yellow = Color(0xFFFFB800);
  static const _text = Color(0xFF090D1B);
  static const _muted = Color(0xFF757987);
  static const _line = Color(0xFFE4E8EA);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
                      const _PackagesHeader(),
                      SizedBox(height: 3.2.h),
                      _PackageSearchField(
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
                child: PagedListView<int, Package>.separated(
                  padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 3.h),
                  physics: const AlwaysScrollableScrollPhysics(),
                  pagingController: controller.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Package>(
                    animateTransitions: true,
                    transitionDuration: 500.milliseconds,
                    firstPageProgressIndicatorBuilder: (context) {
                      return const ShimmerListView();
                    },
                    newPageProgressIndicatorBuilder: (context) {
                      return const ShimmerListView();
                    },
                    noItemsFoundIndicatorBuilder: (context) {
                      return const _StateMessage('No packages found');
                    },
                    itemBuilder: (context, item, index) {
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 720),
                          child: _PackageCard(item),
                        ),
                      );
                    },
                  ),
                  separatorBuilder: (context, index) => SizedBox(height: 2.4.h),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PackagesHeader extends StatelessWidget {
  const _PackagesHeader();

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
            if (Get.isRegistered<BottomNavController>()) {
              find<BottomNavController>().currentIndex.value = 0;
            }
            Get.find<BottomNavController>()
                .onTabChange(0);
          },
          icon: const Icon(Icons.chevron_left_rounded, color: Packages._green),
        ),
        const Spacer(),
        SvgPicture.asset(
          'assets/svgs/app_logo_straight_to_yard.svg',
          width: math.min(context.width * 0.34, 170.0),
          fit: BoxFit.contain,
        ),
        const Spacer(),
        Container(
          width: 8.8.h,
          height: 8.8.h,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF7F1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.local_shipping_rounded,
            color: Packages._green.withOpacity(0.45),
            size: 5.h,
          ),
        ),
      ],
    );
  }
}

class _PackageSearchField extends StatelessWidget {
  const _PackageSearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 7.4.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Packages._line),
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
          Icon(Icons.search_rounded, color: Packages._green, size: 4.2.h),
          SizedBox(width: 3.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search by HAWB / Tracking / Package No.',
                hintStyle: TextStyle(
                  color: Packages._muted,
                  fontSize: 13.2.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: TextStyle(
                color: Packages._text,
                fontSize: 13.2.sp,
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

class _PackageCard extends GetView<DashboardPackagesController> {
  const _PackageCard(this.item);

  final Package item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(3.4.w, 3.h, 3.4.w, 2.7.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Packages._line),
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
              Expanded(
                child: _PackageInfoRow(
                  icon: Icons.calendar_month_outlined,
                  label: 'Date:',
                  value: item.createdAt.toDDMMYYYY,
                ),
              ),
              SizedBox(width: 2.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InlineValue(label: 'Quantity:', value: _dash(item.quantity)),
                  SizedBox(height: 2.2.h),
                  _InlineValue(
                    label: 'Weight:',
                    value: _weight(item.weight),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.4.h),
          _PackageInfoRow(
            icon: Icons.business_center_outlined,
            label: 'HAWB:',
            value: _hawb,
          ),
          const _CardRule(),
          _PackageInfoRow(
            icon: Icons.inventory_2_outlined,
            iconColor: Packages._yellow,
            label: 'Carrier:',
            value: _dash(item.courier),
          ),
          const _CardRule(),
          _PackageInfoRow(
            icon: Icons.location_on_outlined,
            iconColor: Color(0xFF22AFC8),
            label: 'Carrier Tracking No:',
            value: _dash(item.supplierTrackingNo),
          ),
          const _CardRule(),
          _PackageInfoRow(
            icon: Icons.sell_outlined,
            iconColor: Color(0xFF22283A),
            label: 'Package No:',
            value: _dash(item.pkNo),
          ),
          const _CardRule(),
          _PackageInfoRow(
            icon: Icons.local_shipping_outlined,
            iconColor: Color(0xFF22AFC8),
            label: 'Shipment Status:',
            customValue: _StatusPill(text: _dash(item.statusName)),
          ),
          const _CardRule(),
          _PackageInfoRow(
            icon: Icons.description_outlined,
            iconColor: Color(0xFF22283A),
            label: 'Description:',
            value: _dash(item.itemDescription),
          ),
          SizedBox(height: 2.4.h),
          SizedBox(
            width: double.infinity,
            height: 6.9.h,
            child: ElevatedButton(
              onPressed: () => _openInvoiceDetail(item),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Packages._green,
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
                      fontSize: 15.3.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.chevron_right_rounded, size: 4.h),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.1.h),
          _InvoiceFileAction(
            showDownloadButton: item.invoice.isNotEmpty,
            onTap: () => _openInvoiceFileAction(item),
          ),
        ],
      ),
    );
  }

  String get _hawb {
    if (item.trackingNo.trim().isNotEmpty) return item.trackingNo;
    if (item.packageCode.trim().isNotEmpty) return item.packageCode;
    if (item.manifestNo.trim().isNotEmpty) return item.manifestNo;
    return '-';
  }

  static String _dash(String value) {
    return value.trim().isEmpty ? '-' : value.trim();
  }

  static String _weight(String value) {
    final clean = _dash(value);
    if (clean == '-') return clean;
    return clean.toLowerCase().contains('lb') ? clean : '$clean lb';
  }

  void _openInvoiceDetail(Package item) {
    if (item.invoiceNo <= 0) {
      FlushSnackbar.showSnackBar('Invoice detail is not available', isError: true);
      return;
    }
    final bottomNavNestedID = find<BottomNavController>().bottomNavNestedID;
    Get.toNamed(
      AppPages.invoiceDetails,
      id: bottomNavNestedID,
      arguments: item.invoiceNo.toString(),
    );
  }

  void _openInvoiceFileAction(Package item) {
    if (item.invoice.isNotEmpty) {
      find<FileDownloadController>().downloadFile(item.invoice);
      Get.dialog(const DownloadDialog());
      return;
    }
    Get.dialog(
      FileUploadDialog(
        id: item.packegId,
        onDone: () {
          if (Get.isDialogOpen ?? false) Get.back();
          controller.onUploadingInvoiceDone(item.packegId);
        },
      ),
    );
  }
}

class _PackageInfoRow extends StatelessWidget {
  const _PackageInfoRow({
    required this.icon,
    required this.label,
    this.value,
    this.customValue,
    this.iconColor = Packages._green,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? customValue;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 6.4.h,
          child: Icon(icon, color: iconColor, size: 3.8.h),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Packages._text,
            fontSize: 13.4.sp,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: customValue ??
              Text(
                value ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Packages._green,
                  fontSize: 13.1.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
        ),
      ],
    );
  }
}

class _InlineValue extends StatelessWidget {
  const _InlineValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Packages._text,
            fontSize: 13.2.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          value,
          style: TextStyle(
            color: Packages._green,
            fontSize: 13.2.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.2.w, vertical: 1.25.h),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF7F1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Packages._green,
            fontSize: 12.8.sp,
            fontWeight: FontWeight.w800,
            height: 1.1,
          ),
        ),
      ),
    );
  }
}

class _InvoiceFileAction extends StatelessWidget {
  const _InvoiceFileAction({
    required this.showDownloadButton,
    required this.onTap,
  });

  final bool showDownloadButton;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFF5DF),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.6.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFFE2A5)),
          ),
          child: Row(
            children: [
              Container(
                width: 6.5.h,
                height: 6.5.h,
                decoration: const BoxDecoration(
                  color: Packages._yellow,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  showDownloadButton
                      ? Icons.file_download_outlined
                      : Icons.cloud_upload_outlined,
                  color: Colors.white,
                  size: 3.8.h,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      showDownloadButton
                          ? 'Download Invoice File'
                          : 'Upload Invoice File',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Packages._text,
                        fontSize: 13.2.sp,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 0.7.h),
                    Text(
                      showDownloadButton
                          ? 'Tap the icon to download the attached file.'
                          : 'Tap the icon to attach a file for this package.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Packages._muted,
                        fontSize: 11.8.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.18,
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
}

class _CardRule extends StatelessWidget {
  const _CardRule();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 8.h, top: 2.2.h, bottom: 2.2.h),
      child: const Divider(color: Packages._line, thickness: 1),
    );
  }
}

class ShimmerListView extends StatelessWidget {
  const ShimmerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: 2,
      itemBuilder: (context, index) => const PackagesShimmer(),
      separatorBuilder: (context, index) => SizedBox(height: 2.4.h),
    );
  }
}

class PackagesShimmer extends StatelessWidget {
  const PackagesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      radius: BorderRadius.circular(24),
      child: SizedBox(width: context.width, height: 72.h),
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
            color: Packages._text,
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({
    super.key,
    required this.description,
    this.title,
    this.descStyle,
  });

  final String description;
  final String? title;
  final TextStyle? descStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? 'Description:',
          style: TextStyle(
            color: Packages._text,
            fontSize: 9.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          softWrap: true,
          textAlign: TextAlign.start,
          style: descStyle ??
              TextStyle(
                color: Packages._muted,
                fontSize: 9.sp,
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }
}
