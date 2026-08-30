import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/app/core/routes/app_pages.dart';
import 'package:straight_to_yard/app/extensions/string_ext.dart';
import 'package:straight_to_yard/data/models/unpaid_invoice/unpaid_invoice.dart';
import 'package:straight_to_yard/presentation/account/views/account_screen.dart';
import 'package:straight_to_yard/presentation/auth/views/login_screen.dart';
import 'package:straight_to_yard/presentation/auth/widgets/auth_app_bar.dart';
import 'package:straight_to_yard/presentation/auth/widgets/text_field.dart';
import 'package:straight_to_yard/presentation/authorize/views/authorize_screen.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';
import 'package:straight_to_yard/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:straight_to_yard/presentation/unpaid_invoices/controllers/unpaid_invoices.dart';

class UnpaidInvoicesScreen extends GetView<UnpaidInvoicesController> {
  const UnpaidInvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      showGradients: false,
      value: SystemUiOverlayStyle.dark,
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: const AuthCustomAppBar.withSmallAppLogo(
        backButtonVisible: true,
        usingNavigator: true,
      ),
      body: Container(
        width: context.width,
        margin:
            EdgeInsets.only(left: 4.2.w, right: 4.2.w, top: 1.4.h, bottom: 2.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: const Color(0xFFE4E8EA)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 18,
              offset: Offset(0, 8),
            )
          ],
        ),
        child: Padding(
          padding:
              EdgeInsets.only(left: 3.2.w, right: 3.2.w, top: 2.2.h, bottom: 1.9.h),
          child: Column(
            children: [
              const SearchField(),
              SizedBox(height: 1.6.h),
              const AppDivider(),
              SizedBox(height: 1.6.h),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => Future.sync(
                    () => controller.onRefresh(),
                  ),
                  child: GetBuilder<UnpaidInvoicesController>(
                    id: 'unpaidInvoices',
                    builder: (_) {
                      return PagedListView<int, UnpaidInvoice>.separated(
                        pagingController: controller.pagingController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        restorationId: '1',
                        addAutomaticKeepAlives: true,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        shrinkWrap: true,
                        builderDelegate: PagedChildBuilderDelegate(
                          itemBuilder: (context, item, index) {
                            return _UnpaidItem(
                              item: item,
                              onChanged: (e) {
                                controller.onItemChecked(item);
                              },
                            );
                          },
                        ),
                        separatorBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 1.35.h),
                          child: Column(
                            children: [
                              const AppDivider(),
                              SizedBox(height: 1.35.h),
                              const AppDivider(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 1.6.h),
              const AppDivider(),
              const _NoOfPackages(),
              const AppDivider(),
              const _TotalAmount(),
              const AppDivider(),
              SizedBox(height: 1.2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: AppButton(
                      title: 'Clear',
                      onTap: () => controller.onClear(),
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        width: 1,
                        color: const Color(0xFFD8E9DD),
                      ),
                      textColor: const Color(0xFF087C25),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    flex: 2,
                    child: Obx(
                      () {
                        final count = controller.selectedItems.length;
                        return AppButton(
                          title: 'Pay Now',
                          onTap: count <= 0
                              ? null
                              : () async {
                                  final result =
                                      await controller.performPayment();
                                },
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _UnpaidItem extends StatelessWidget {
  const _UnpaidItem({required this.onChanged, required this.item});
  final void Function(bool?)? onChanged;
  final UnpaidInvoice item;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 1.h),
        _CheckBoxTitle(
          item: item,
          onChanged: onChanged,
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: _TrackPackagesItemKeyValueBuilder(
                subTitle: item.createdAt?.toDDMMYYYY,
                title: 'Date created:',
                mainAxisAlignment: MainAxisAlignment.start,
                spaceBTW: 1.w,
              ),
            ),
            Expanded(
              child: _TrackPackagesItemKeyValueBuilder(
                subTitle: item.totalInvoice.toString(),
                title: 'Invoice Unpaid:',
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                spaceBTW: 1.w,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.25.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _TrackPackagesItemKeyValueBuilder(
                subTitle: item.invoiceNo.toString(),
                title: 'Invoice#:',
                mainAxisAlignment: MainAxisAlignment.start,
                spaceBTW: 1.w,
              ),
            ),
            Expanded(
              child: _TrackPackagesItemKeyValueBuilder(
                subTitle: item.userName,
                title: 'User Name:',
                mainAxisAlignment: MainAxisAlignment.end,
                spaceBTW: 1.w,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.2.h),
        ActionButton(
          title: 'Invoice Detail',
          width: context.width,
          height: 5.h,
          onTap: () {
            final bottomNavNestedID =
                find<BottomNavController>().bottomNavNestedID;
            Get.toNamed(
              AppPages.invoiceDetails,
              id: bottomNavNestedID,
              arguments: item.invoiceNo.toString(),
            );
          },
        ),
        SizedBox(height: 1.2.h),
      ],
    );
  }
}

class _TotalAmount extends StatelessWidget {
  const _TotalAmount();

  @override
  Widget build(BuildContext context) {
    final controller = find<UnpaidInvoicesController>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'Total Amount Due',
              style: TextStyle(
                color: Color(0xFF090D1B),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => Text(
                controller.totalAmount.toString(),
                style: const TextStyle(
                  color: Color(0xFF087C25),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _NoOfPackages extends StatelessWidget {
  const _NoOfPackages();

  @override
  Widget build(BuildContext context) {
    final controller = find<UnpaidInvoicesController>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'Total Invoices',
              style: TextStyle(
                color: Color(0xFF090D1B),
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => Text(
                controller.selectedItems.length.toString(),
                style: const TextStyle(
                  color: Color(0xFF087C25),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _TrackPackagesItemKeyValueBuilder extends StatelessWidget {
  final String title;
  final String? subTitle;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final double spaceBTW;
  final MainAxisSize mainAxisSize;
  final Widget? customSubTitle;
  const _TrackPackagesItemKeyValueBuilder({
    required this.title,
    this.subTitle,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.spaceBTW = 0,
    this.mainAxisSize = MainAxisSize.max,
    this.customSubTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: [
        Text(
          title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: const Color(0xFF090D1B),
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: spaceBTW),
        customSubTitle ??
            Text(
              subTitle ?? '',
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF087C25),
                fontSize: 9.sp,
                fontWeight: FontWeight.w400,
                overflow: TextOverflow.ellipsis,
              ),
            )
      ],
    );
  }
}

class _CheckBoxTitle extends StatelessWidget {
  const _CheckBoxTitle({
    required this.onChanged,
    required this.item,
  });

  final void Function(bool?)? onChanged;
  final UnpaidInvoice item;

  @override
  Widget build(BuildContext context) {
    bool? isChecked = item.isToggleOn;
    return Row(
      children: [
        StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              height: 2.h,
              width: 4.w,
              child: Checkbox(
                value: isChecked,
                onChanged: (e) {
                  item.isToggleOn = e ?? false;
                  onChanged?.call(e);
                  setState(() {
                    isChecked = e;
                  });
                },
                activeColor: const Color(0xFF087C25),
                tristate: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
