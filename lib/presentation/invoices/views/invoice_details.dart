import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/extensions/string_ext.dart';
import 'package:straight_to_yard/app/util/flush_snackbar.dart';
import 'package:straight_to_yard/data/models/invoice_detail/invoice_detail.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';
import 'package:straight_to_yard/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:straight_to_yard/presentation/invoices/controller/invoice_detail_controller.dart';
import 'package:straight_to_yard/presentation/widgets/shimmer_widget.dart';

class InvoiceDetails extends GetView<InvoiceDetailController> {
  const InvoiceDetails({super.key});

  static const _green = Color(0xFF087C25);
  static const _blue = Color(0xFF1167E8);
  static const _deepBlue = Color(0xFF0044BA);
  static const _yellow = Color(0xFFFFC531);
  static const _purple = Color(0xFF4C2EAE);
  static const _text = Color(0xFF090D1B);
  static const _muted = Color(0xFF596070);
  static const _line = Color(0xFFE4E8EA);

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    if (args != null) {
      controller.getInviceDetails(args.toString());
    }

    return BaseScreen(
      showGradients: false,
      wrapWithAnnotatedRegion: true,
      backgroundColor: const Color(0xFFF8FBFD),
      value: SystemUiOverlayStyle.dark,
      body: SafeArea(
        bottom: false,
        child: controller.obx(
          onLoading: const _ShimmerWidget(),
          onError: (error) => const _StateMessage(
            'Something went wrong try again late',
          ),
          (state) {
            if (state == null) return const SizedBox.shrink();
            return LayoutBuilder(
              builder: (context, constraints) {
                final horizontal = constraints.maxWidth >= 600 ? 8.w : 3.6.w;
                return SingleChildScrollView(
                  padding:
                      EdgeInsets.fromLTRB(horizontal, 1.2.h, horizontal, 3.h),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Column(
                        children: [
                          const _DetailHeader(),
                          SizedBox(height: 2.4.h),
                          _InvoiceHero(data: state),
                          SizedBox(height: 1.8.h),
                          _BillToCard(data: state),
                          SizedBox(height: 1.8.h),
                          _InfoCards(data: state),
                          SizedBox(height: 1.8.h),
                          _ChargesBreakdown(data: state),
                          SizedBox(height: 1.8.h),
                          _PaymentAndTimeline(data: state),
                          SizedBox(height: 1.5.h),
                          _ActionButtons(data: state),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader();

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
              Get.back(id: Get.find<BottomNavController>().bottomNavNestedID);
            } else {
              Get.back();
            }
          },
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: InvoiceDetails._green,
          ),
        ),
        const Spacer(),
        SvgPicture.asset(
          'assets/svgs/app_logo_straight_to_yard.svg',
          width: math.min(context.width * 0.36, 180.0),
          fit: BoxFit.contain,
        ),
        const Spacer(),
        IconButton(
          iconSize: 3.2.h,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tight(Size(6.h, 6.h)),
          onPressed: () {},
          icon: const Icon(Icons.more_vert_rounded, color: InvoiceDetails._green),
        ),
      ],
    );
  }
}

class _InvoiceHero extends StatelessWidget {
  const _InvoiceHero({required this.data});

  final InvoiceDetailResponse data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 27.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [InvoiceDetails._deepBlue, InvoiceDetails._blue],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x180044BA),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: CustomPaint(
        painter: const _HeroPatternPainter(),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.receipt_long_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Invoice Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.6.h),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '#${data.invoiceNo}',
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.5.h),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(width: 1.4.w),
                        Text(
                          _date(data.datePaid),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.6.h),
                    const _UnpaidPill(),
                    SizedBox(height: 1.8.h),
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.2.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.7.h),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _money(data.grandTotal),
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.w800,
                          height: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Icon(
                    Icons.receipt_long_rounded,
                    color: Colors.white.withOpacity(0.85),
                    size: 13.h,
                  ),
                  Container(
                    width: 6.7.h,
                    height: 6.7.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5D9DFF),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 4.h,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BillToCard extends StatelessWidget {
  const _BillToCard({required this.data});

  final InvoiceDetailResponse data;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      child: Row(
        children: [
          const _SmallHeaderIcon(icon: Icons.person_outline_rounded),
          SizedBox(width: 2.5.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionTitle('Bill To'),
                SizedBox(height: 1.h),
                Text(
                  _dash(data.userName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 0.7.h),
                Text(
                  'Account No: ${_dash(data.mailboxNo)}',
                  style: _bodyStyle(context),
                ),
                SizedBox(height: 0.4.h),
                Text(
                  _dash(data.email),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _bodyStyle(context),
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          _IconBubble(
            icon: Icons.mail_outline_rounded,
            color: InvoiceDetails._blue,
            background: const Color(0xFFEAF4FF),
            size: 7.5.h,
          ),
        ],
      ),
    );
  }
}

class _InfoCards extends StatelessWidget {
  const _InfoCards({required this.data});

  final InvoiceDetailResponse data;

  @override
  Widget build(BuildContext context) {
    final detail = data.invoiceDetail.isNotEmpty ? data.invoiceDetail.first : null;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _CompanyCard(data: data)),
        SizedBox(width: 2.w),
        Expanded(child: _ShipmentCard(data: data, detail: detail)),
      ],
    );
  }
}

class _CompanyCard extends StatelessWidget {
  const _CompanyCard({required this.data});

  final InvoiceDetailResponse data;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      minHeight: 21.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _SmallHeaderIcon(icon: Icons.business_rounded),
              SizedBox(width: 2.w),
              Expanded(child: _SectionTitle('Company Details')),
            ],
          ),
          SizedBox(height: 1.6.h),
          Text(
            _dash(data.companyName),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: InvoiceDetails._green,
              fontSize: 12.3.sp,
              fontWeight: FontWeight.w800,
              height: 1.16,
            ),
          ),
          SizedBox(height: 1.5.h),
          Text(
            _dash(data.localAddress),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: _bodyStyle(context),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Icon(Icons.phone_rounded, color: InvoiceDetails._green, size: 2.5.h),
              SizedBox(width: 1.5.w),
              Expanded(
                child: Text(
                  _dash(data.phone),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _bodyStyle(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShipmentCard extends StatelessWidget {
  const _ShipmentCard({required this.data, required this.detail});

  final InvoiceDetailResponse data;
  final InvoiceDetail? detail;

  @override
  Widget build(BuildContext context) {
    final freight = data.freightType.toLowerCase() == 'straight_to_yard'
        ? 'Regular Air Freight'
        : data.freightType.trim().isEmpty
            ? 'Regular Air Freight'
            : data.freightType;
    return _WhiteCard(
      minHeight: 21.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _SmallHeaderIcon(icon: Icons.inventory_2_outlined),
              SizedBox(width: 2.w),
              Expanded(child: _SectionTitle('Shipment Details')),
            ],
          ),
          SizedBox(height: 1.6.h),
          _KeyValueLine('HAWB', _dash(detail?.manifestNo ?? '')),
          _KeyValueLine('Weight', '${detail?.packageWeight ?? 0} lbs'),
          _KeyValueLine('Freight Type', freight),
          _KeyValueLine('Description', _dash(detail?.packageDescription ?? '')),
        ],
      ),
    );
  }
}

class _ChargesBreakdown extends StatelessWidget {
  const _ChargesBreakdown({required this.data});

  final InvoiceDetailResponse data;

  @override
  Widget build(BuildContext context) {
    final detail = data.invoiceDetail.isNotEmpty ? data.invoiceDetail.first : null;
    final freight = data.freightType.toLowerCase() == 'straight_to_yard'
        ? 'Regular Air Freight'
        : data.freightType.trim().isEmpty
            ? 'Regular Air Freight'
            : data.freightType;
    final fees = data.additionalFee ?? [];

    return _WhiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4.h,
                height: 4.h,
                decoration: const BoxDecoration(
                  color: InvoiceDetails._green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.attach_money, color: Colors.white),
              ),
              SizedBox(width: 2.w),
              _SectionTitle('Charges Breakdown'),
            ],
          ),
          SizedBox(height: 1.6.h),
          _ChargeLine(freight, _money(detail?.packagePrice ?? '0')),
          _ChargeLine('Service Fee', _money(detail?.serviceFee ?? '0')),
          _ChargeLine('Custom Fee', _money(detail?.customFee ?? '0')),
          _ChargeLine('GCT', _money(data.gstTotal.isEmpty ? '0' : data.gstTotal)),
          ...fees.map((fee) => _ChargeLine(fee.name, _money(fee.serviceFee))),
          if (data.discountPrice.trim().isNotEmpty)
            _ChargeLine('Discount', _money(data.discountPrice)),
          SizedBox(height: 1.2.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF7F1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Total Amount',
                    style: TextStyle(
                      color: InvoiceDetails._green,
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  _money(data.grandTotal),
                  style: TextStyle(
                    color: InvoiceDetails._green,
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w800,
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

class _PaymentAndTimeline extends StatelessWidget {
  const _PaymentAndTimeline({required this.data});

  final InvoiceDetailResponse data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _TimelineCard(data: data)),
        SizedBox(width: 2.w),
        Expanded(child: _AmountDueCard(data: data)),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.data});

  final InvoiceDetailResponse data;

  @override
  Widget build(BuildContext context) {
    return _WhiteCard(
      minHeight: 17.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _SmallHeaderIcon(icon: Icons.schedule_rounded),
              SizedBox(width: 2.w),
              Expanded(child: _SectionTitle('Invoice Timeline')),
            ],
          ),
          SizedBox(height: 1.3.h),
          _TimelineItem(
            title: 'Invoice Created',
            subtitle: _date(data.datePaid),
            active: true,
          ),
          const _TimelineItem(title: 'Payment Pending'),
          const _TimelineItem(title: 'Package Released'),
        ],
      ),
    );
  }
}

class _AmountDueCard extends GetView<InvoiceDetailController> {
  const _AmountDueCard({required this.data});

  final InvoiceDetailResponse data;

  @override
  Widget build(BuildContext context) {
    return Container(
      minHeight: 17.h,
      padding: EdgeInsets.all(3.2.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF7F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: InvoiceDetails._line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 15,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Amount Due',
            style: TextStyle(
              color: InvoiceDetails._green,
              fontSize: 12.4.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 1.h),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _money(data.grandTotal),
              style: TextStyle(
                color: InvoiceDetails._text,
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            height: 5.5.h,
            child: ElevatedButton(
              onPressed: controller.startPayment,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: InvoiceDetails._green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Pay Now',
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(Icons.arrow_forward_rounded, size: 3.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.data});

  final InvoiceDetailResponse data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MiniAction(
            icon: Icons.file_download_outlined,
            label: 'Download PDF',
            onTap: () => _unavailable('PDF download'),
          ),
        ),
        SizedBox(width: 1.8.w),
        Expanded(
          child: _MiniAction(
            icon: Icons.share_outlined,
            label: 'Share Invoice',
            onTap: () async {
              await Clipboard.setData(
                ClipboardData(
                  text:
                      'Invoice #${data.invoiceNo}\nAmount: ${_money(data.grandTotal)}',
                ),
              );
              FlushSnackbar.showSnackBar('Invoice summary copied');
            },
          ),
        ),
        SizedBox(width: 1.8.w),
        Expanded(
          child: _MiniAction(
            icon: Icons.support_agent_rounded,
            label: 'Contact Support',
            onTap: () => _unavailable('Support contact'),
          ),
        ),
      ],
    );
  }

  static void _unavailable(String label) {
    FlushSnackbar.showSnackBar('$label is not available', isError: true);
  }
}

class _WhiteCard extends StatelessWidget {
  const _WhiteCard({required this.child, this.minHeight});

  final Widget child;
  final double? minHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: minHeight ?? 0),
      padding: EdgeInsets.all(3.2.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: InvoiceDetails._line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 15,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({
    required this.icon,
    required this.color,
    required this.background,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color, size: size * 0.52),
    );
  }
}

class _SmallHeaderIcon extends StatelessWidget {
  const _SmallHeaderIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: InvoiceDetails._green, size: 3.3.h);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: InvoiceDetails._text,
        fontSize: 10.8.sp,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _KeyValueLine extends StatelessWidget {
  const _KeyValueLine(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.35.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(width: 1.w),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: 10.2.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChargeLine extends StatelessWidget {
  const _ChargeLine(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.15.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: 10.8.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.black,
              fontSize: 10.8.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.title,
    this.subtitle,
    this.active = false,
  });

  final String title;
  final String? subtitle;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 0.7.w, bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 2.1.h,
            height: 2.1.h,
            margin: EdgeInsets.only(top: 0.25.h),
            decoration: BoxDecoration(
              color: active ? InvoiceDetails._green : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: active ? InvoiceDetails._green : const Color(0xFFAEB4C0),
                width: 2,
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: InvoiceDetails._text,
                    fontSize: 9.6.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 0.2.h),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: InvoiceDetails._text,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniAction extends StatelessWidget {
  const _MiniAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 6.3.h,
          padding: EdgeInsets.symmetric(horizontal: 1.5.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: InvoiceDetails._line),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0B000000),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: InvoiceDetails._green, size: 2.8.h),
              SizedBox(width: 1.4.w),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 9.4.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnpaidPill extends StatelessWidget {
  const _UnpaidPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.9.h),
      decoration: BoxDecoration(
        color: InvoiceDetails._yellow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        'UNPAID',
        style: TextStyle(
          color: Colors.black,
          fontSize: 9.8.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _HeroPatternPainter extends CustomPainter {
  const _HeroPatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    for (double i = 0; i < 12; i++) {
      final rect = Rect.fromCenter(
        center: Offset(size.width * 0.58, size.height * 0.72),
        width: size.width * (0.25 + i * 0.06),
        height: size.height * (0.2 + i * 0.04),
      );
      canvas.drawArc(rect, -0.7, 3.2, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ShimmerWidget extends StatelessWidget {
  const _ShimmerWidget();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 3.6.w, vertical: 1.2.h),
      child: Column(
        children: [
          ShimmerWidget(
            radius: BorderRadius.circular(22),
            child: SizedBox(width: context.width, height: 27.h),
          ),
          SizedBox(height: 1.8.h),
          ShimmerWidget(
            radius: BorderRadius.circular(16),
            child: SizedBox(width: context.width, height: 17.h),
          ),
          SizedBox(height: 1.8.h),
          ShimmerWidget(
            radius: BorderRadius.circular(16),
            child: SizedBox(width: context.width, height: 42.h),
          ),
        ],
      ),
    );
  }
}

class _StateMessage extends StatelessWidget {
  const _StateMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height / 1.5,
      width: context.width,
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: InvoiceDetails._text,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

String _dash(String value) {
  return value.trim().isEmpty ? '-' : value.trim();
}

String _date(String value) {
  final formatted = value.toDDMMYYYY;
  return formatted.trim().isEmpty ? '-' : formatted;
}

String _money(dynamic value) {
  final text = value?.toString().trim() ?? '';
  if (text.isEmpty) return '-';
  return text.toUpperCase().contains('JMD') ? text : 'JMD $text';
}

TextStyle _bodyStyle(BuildContext context) {
  return TextStyle(
    color: InvoiceDetails._text,
    fontSize: 10.6.sp,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );
}
