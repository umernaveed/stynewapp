import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/util/flush_snackbar.dart';
import 'package:straight_to_yard/data/models/dashboard_address_data/dashboard_address_data.dart';
import 'package:straight_to_yard/presentation/dashboard/controllers/dashboard_address_controller.dart';
import 'package:straight_to_yard/presentation/widgets/shimmer_widget.dart';

class Address extends GetView<DashboardAddressController> {
  const Address({super.key});

  static const _green = Color(0xFF087C25);
  static const _deepGreen = Color(0xFF006A1E);
  static const _yellow = Color(0xFFF9C80E);
  static const _text = Color(0xFF090D1B);
  static const _muted = Color(0xFF6D717C);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: _green,
      onRefresh: controller.refreshData,
      child: controller.obx(
        onLoading: const _Shimmerloading(),
        onEmpty: const _StateMessage('No data found'),
        onError: (error) => const _StateMessage(
          'Something went wrong try again late',
        ),
        (state) {
          if (state == null) return const SizedBox.shrink();
          return LayoutBuilder(
            builder: (context, constraints) {
              final horizontal = constraints.maxWidth >= 600 ? 8.w : 3.w;
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(horizontal, 1.2.h, horizontal, 3.h),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Column(
                      children: [
                        const _AddressHeader(),
                        SizedBox(height: 3.h),
                        const _ShippingHeroCard(),
                        SizedBox(height: 2.6.h),
                        AddressItemWidget.air(data: state),
                        SizedBox(height: 2.h),
                        AddressItemWidget.sea(data: state),
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

class _AddressHeader extends StatelessWidget {
  const _AddressHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 4.h,
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tight(Size(6.h, 6.h)),
          onPressed: () {},
          icon: const Icon(Icons.menu_rounded, color: Address._green),
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
            color: Address._green,
          ),
        ),
      ],
    );
  }
}

class _ShippingHeroCard extends StatelessWidget {
  const _ShippingHeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 19.h,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Address._green,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x16000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: CustomPaint(
        painter: const _AddressHeroPainter(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.2.w),
          child: Row(
            children: [
              Container(
                width: 8.2.h,
                height: 8.2.h,
                decoration: BoxDecoration(
                  color: Address._green.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Address._yellow, width: 2),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: Colors.white,
                  size: 54,
                ),
              ),
              SizedBox(width: 3.2.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Shipping Addresses',
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.08,
                        ),
                      ),
                    ),
                    SizedBox(height: 0.9.h),
                    Text(
                      'Copy the correct warehouse\naddress for each shipping method.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.2.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.18,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              Icon(
                Icons.flight_takeoff_rounded,
                color: Address._yellow,
                size: 8.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddressItemWidget extends StatelessWidget {
  const AddressItemWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.name,
    required this.address1,
    required this.address2,
    required this.city,
    required this.state,
    required this.country,
    required this.zipCode,
    required this.headerIcon,
  });

  factory AddressItemWidget.air({required DashboardAddressData data}) {
    return AddressItemWidget(
      title: 'Air Shipping Address',
      subtitle: 'Use this address for regular air freight.',
      name: data.userInfo.userName,
      address1: data.setting.packageShippingAddress1,
      address2: data.userInfo.addressLine2.isNotEmpty
          ? data.userInfo.addressLine2
          : data.setting.packageShippingAddress2,
      city: data.setting.city,
      state: data.setting.state,
      country: data.setting.country,
      zipCode: data.setting.zip,
      headerIcon: Icons.flight_takeoff_rounded,
    );
  }

  factory AddressItemWidget.sea({required DashboardAddressData data}) {
    return AddressItemWidget(
      title: 'Sea Shipping Address',
      subtitle: 'Use this address for sea freight shipments.',
      name: data.userInfo.userName,
      address1: data.setting.seaShippingAddress1,
      address2: data.setting.seaShippingAddress2,
      city: data.setting.seaCity,
      state: data.setting.seaState,
      country: data.setting.seaCountry,
      zipCode: data.setting.seaZip,
      headerIcon: Icons.directions_boat_outlined,
    );
  }

  final String title;
  final String subtitle;
  final String name;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String country;
  final String zipCode;
  final IconData headerIcon;

  @override
  Widget build(BuildContext context) {
    final fields = [
      _AddressField(Icons.person_outline_rounded, 'Name', name),
      _AddressField(Icons.home_outlined, 'Address Line 1', address1),
      _AddressField(Icons.business_rounded, 'Address Line 2', address2),
      _AddressField(Icons.location_city_rounded, 'City', city),
      if (state.trim().isNotEmpty)
        _AddressField(Icons.map_outlined, 'State', state),
      _AddressField(Icons.public_rounded, 'Country', country),
      _AddressField(Icons.local_post_office_outlined, 'Zip Code', zipCode),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 2.7.h),
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
          Row(
            children: [
              _IconBadge(icon: headerIcon, size: 7.9.h),
              SizedBox(width: 3.2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        maxLines: 1,
                        style: TextStyle(
                          color: Address._deepGreen,
                          fontSize: 20.5.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                        ),
                      ),
                    ),
                    SizedBox(height: 0.8.h),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Address._muted,
                        fontSize: 12.7.sp,
                        fontWeight: FontWeight.w400,
                        height: 1.18,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              _CopyButton(
                onTap: () => _copy(context, _fullAddress),
                size: 7.9.h,
              ),
            ],
          ),
          SizedBox(height: 2.6.h),
          ...fields.map(
            (field) => Padding(
              padding: EdgeInsets.only(bottom: 1.15.h),
              child: _AddressRow(field: field),
            ),
          ),
          SizedBox(height: 1.h),
          SizedBox(
            width: double.infinity,
            height: 6.6.h,
            child: ElevatedButton.icon(
              onPressed: () => _copy(context, _fullAddress),
              icon: Icon(Icons.copy_rounded, size: 2.8.h),
              label: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Copy Full Address',
                  style: TextStyle(
                    fontSize: 15.5.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Address._green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get _fullAddress {
    return [
      name,
      address1,
      address2,
      city,
      state,
      country,
      zipCode,
    ].where((value) => value.trim().isNotEmpty).join('\n');
  }

  static Future<void> _copy(BuildContext context, String value) async {
    await Clipboard.setData(ClipboardData(text: value));
    FlushSnackbar.showSnackBar('Copied to Clipboard');
  }
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({required this.field});

  final _AddressField field;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 1.45.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE6EAED)),
      ),
      child: Row(
        children: [
          _IconBadge(icon: field.icon, size: 5.6.h),
          SizedBox(width: 3.7.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  field.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Address._deepGreen,
                    fontSize: 12.3.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 0.45.h),
                Text(
                  field.value.isEmpty ? '-' : field.value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Address._text,
                    fontSize: 12.9.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.18,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          _CopyButton(onTap: () => AddressItemWidget._copy(context, field.value)),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.size});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF7F1),
        borderRadius: BorderRadius.circular(size * 0.23),
      ),
      child: Icon(icon, color: Address._deepGreen, size: size * 0.52),
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({required this.onTap, this.size});

  final VoidCallback onTap;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 5.8.h;
    return Material(
      color: const Color(0xFFEFF7F1),
      borderRadius: BorderRadius.circular(buttonSize * 0.23),
      child: InkWell(
        borderRadius: BorderRadius.circular(buttonSize * 0.23),
        onTap: onTap,
        child: SizedBox(
          width: buttonSize,
          height: buttonSize,
          child: Icon(
            Icons.copy_rounded,
            color: Address._deepGreen,
            size: buttonSize * 0.5,
          ),
        ),
      ),
    );
  }
}

class _AddressField {
  const _AddressField(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;
}

class _AddressHeroPainter extends CustomPainter {
  const _AddressHeroPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()..color = Colors.white.withOpacity(0.08);
    for (double x = size.width * 0.44; x < size.width * 0.78; x += 6) {
      for (double y = 0; y < size.height * 0.75; y += 6) {
        final dx = (x / size.width) - 0.58;
        final dy = (y / size.height) - 0.28;
        if ((dx * dx * 3.3 + dy * dy * 1.4) < 0.12) {
          canvas.drawCircle(Offset(x, y), 1.05, dotPaint);
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
        size.height * 0.12,
        size.width * 1.55,
        size.height * 1.35,
      ),
      0.7,
      1.25,
      false,
      darkSweep,
    );

    final yellowSweep = Paint()
      ..color = Address._yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
    canvas.drawArc(
      Rect.fromLTWH(
        size.width * -0.2,
        size.height * 0.08,
        size.width * 1.5,
        size.height * 1.32,
      ),
      0.72,
      1.25,
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
              color: Address._text,
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _Shimmerloading extends StatelessWidget {
  const _Shimmerloading();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.2.h),
      child: Column(
        children: [
          ShimmerWidget(
            radius: BorderRadius.circular(25),
            child: SizedBox(width: context.width, height: 19.h),
          ),
          SizedBox(height: 2.6.h),
          const ShimmerAddressItemWidget(),
        ],
      ),
    );
  }
}

class ShimmerAddressItemWidget extends StatelessWidget {
  const ShimmerAddressItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      radius: BorderRadius.circular(25),
      child: SizedBox(width: context.width, height: 72.h),
    );
  }
}
