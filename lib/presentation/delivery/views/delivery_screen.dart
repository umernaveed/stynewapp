import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/presentation/auth/widgets/auth_app_bar.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';
import 'package:straight_to_yard/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({super.key});

  static const _green = Color(0xFF087C25);
  static const _deepGreen = Color(0xFF006A1E);
  static const _yellow = Color(0xFFFFB800);
  static const _text = Color(0xFF090D1B);
  static const _muted = Color(0xFF757987);
  static const _line = Color(0xFFE4E8EA);
  static const _background = Color(0xFFF8FBFF);
  static const _whatsAppNumber = '18762998543';
  static const _displayPhone = '(876) 299-8543';

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
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(horizontal, 1.2.h, horizontal, 2.5.h),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  children: [
                    const _DeliveryHero(),
                    SizedBox(height: 1.6.h),
                    const _InstructionCard(),
                    SizedBox(height: 1.6.h),
                    const _CutoffNotice(),
                    SizedBox(height: 1.6.h),
                    const _RatesCard(
                      title: 'Portmore, Spanish Town & Nearby',
                      rates: _portmoreRates,
                    ),
                    SizedBox(height: 1.6.h),
                    const _RatesCard(
                      title: 'Kingston Delivery Fees',
                      rates: _kingstonRates,
                    ),
                    SizedBox(height: 10.5.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static Future<void> openWhatsApp() async {
    final message = Uri.encodeComponent(
      'Hello Straight To Yard Couriers,\n\n'
      'I would like to request a delivery.\n\n'
      'Full name: \n'
      'Intended delivery address: \n'
      'Payment method: Cash/Transfer\n'
      'Additional delivery note: ',
    );
    final uri = Uri.parse('https://wa.me/$_whatsAppNumber?text=$message');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

const List<_DeliveryRate> _portmoreRates = [
  _DeliveryRate('Central Portmore', '550'),
  _DeliveryRate('Greater Portmore', '600'),
  _DeliveryRate('Dunbeholding', '700'),
  _DeliveryRate('Central Village', '700'),
  _DeliveryRate('St. John\'s Road', '800'),
  _DeliveryRate('Job\'s Lane', '800'),
  _DeliveryRate('Green Acres', '1200'),
  _DeliveryRate('Eltham', '800'),
  _DeliveryRate('Brunswick', '900'),
  _DeliveryRate('Angels', '900'),
  _DeliveryRate('Tryall Heights', '900'),
  _DeliveryRate('Fairview Park', '700'),
  _DeliveryRate('Ensom', '800'),
  _DeliveryRate('Marchpen Road', '700'),
  _DeliveryRate('Hagley Park Rd', '700'),
  _DeliveryRate('Three Miles', '700'),
  _DeliveryRate('Washington Boulevard', '700'),
  _DeliveryRate('Constant Spring', '800'),
];

const List<_DeliveryRate> _kingstonRates = [
  _DeliveryRate('Downtown', '700'),
  _DeliveryRate('Ferry', '900'),
  _DeliveryRate('White Hall', '700'),
  _DeliveryRate('Lady Musgrave Rd', '800'),
  _DeliveryRate('Grants Pen', '800'),
  _DeliveryRate('Knutsford Blvd', '700'),
  _DeliveryRate('New Kingston', '800'),
  _DeliveryRate('Half Way Tree', '800'),
  _DeliveryRate('Roehampton Circle', '800'),
  _DeliveryRate('Eliston Rd', '700'),
  _DeliveryRate('Molynes Rd', '800'),
  _DeliveryRate('Mountain View', '800'),
  _DeliveryRate('South Camp Rd', '700'),
  _DeliveryRate('Heroes Circle', '800'),
  _DeliveryRate('Duhaney Park', '700'),
  _DeliveryRate('Red Hills', '700'),
  _DeliveryRate('Maxfield Ave', '700'),
  _DeliveryRate('Dunrobin Ave', '700'),
  _DeliveryRate('August Town', '1100'),
  _DeliveryRate('Oxford Rd', '800'),
];

class _DeliveryHero extends StatelessWidget {
  const _DeliveryHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(4.2.w, 2.2.h, 4.2.w, 2.2.h),
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
              Icons.delivery_dining_rounded,
              color: Colors.white,
              size: 4.2.h,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Requests',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.8.sp,
                    fontWeight: FontWeight.w900,
                    height: 1.05,
                  ),
                ),
                SizedBox(height: 0.7.h),
                Text(
                  'All deliveries are requested through WhatsApp.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 9.8.sp,
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

class _InstructionCard extends StatelessWidget {
  const _InstructionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(4.w, 2.2.h, 4.w, 2.1.h),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconBox(
                icon: Icons.chat_rounded,
                color: DeliveryScreen._green,
                background: const Color(0xFFEFF7F1),
              ),
              SizedBox(width: 3.2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Message us on WhatsApp',
                      style: TextStyle(
                        color: DeliveryScreen._text,
                        fontSize: 12.2.sp,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      DeliveryScreen._displayPhone,
                      style: TextStyle(
                        color: DeliveryScreen._green,
                        fontSize: 11.3.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Please provide:',
            style: TextStyle(
              color: DeliveryScreen._text,
              fontSize: 10.4.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 1.1.h),
          const _ChecklistItem(
            icon: Icons.person_outline_rounded,
            title: 'Full name',
          ),
          const _ChecklistItem(
            icon: Icons.location_on_outlined,
            title: 'Intended delivery address',
          ),
          const _ChecklistItem(
            icon: Icons.payments_outlined,
            title: 'Payment method',
            subtitle: 'Cash or Transfer',
          ),
          const _ChecklistItem(
            icon: Icons.sticky_note_2_outlined,
            title: 'Additional delivery note',
          ),
          SizedBox(height: 1.8.h),
          SizedBox(
            width: double.infinity,
            height: 5.8.h,
            child: ElevatedButton(
              onPressed: DeliveryScreen.openWhatsApp,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: DeliveryScreen._green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_rounded, size: 2.4.h),
                  SizedBox(width: 2.w),
                  Text(
                    'Open WhatsApp',
                    style: TextStyle(
                      fontSize: 10.6.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CutoffNotice extends StatelessWidget {
  const _CutoffNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(4.w, 1.7.h, 4.w, 1.7.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5DF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFE2A5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBox(
            icon: Icons.schedule_rounded,
            color: DeliveryScreen._yellow,
            background: Colors.white,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'To be fulfilled for same-day delivery, please request before 11:55 a.m. Requests after 11:55 a.m. will be considered for the next day.',
              style: TextStyle(
                color: DeliveryScreen._text,
                fontSize: 9.4.sp,
                fontWeight: FontWeight.w700,
                height: 1.28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatesCard extends StatelessWidget {
  const _RatesCard({required this.title, required this.rates});

  final String title;
  final List<_DeliveryRate> rates;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(3.6.w, 2.h, 3.6.w, 1.6.h),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconBox(
                icon: Icons.price_check_rounded,
                color: DeliveryScreen._green,
                background: const Color(0xFFEFF7F1),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: DeliveryScreen._text,
                    fontSize: 11.4.sp,
                    fontWeight: FontWeight.w900,
                    height: 1.12,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FBFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: DeliveryScreen._line),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Location',
                    style: _headerStyle(),
                  ),
                ),
                Text('Price', style: _headerStyle()),
              ],
            ),
          ),
          SizedBox(height: 0.5.h),
          ...rates.map((rate) => _RateRow(rate: rate)),
          SizedBox(height: 0.8.h),
          Text(
            'Prices are subject to change based on package size and delivery distance.',
            style: TextStyle(
              color: DeliveryScreen._muted,
              fontSize: 8.4.sp,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() {
    return TextStyle(
      color: DeliveryScreen._muted,
      fontSize: 8.6.sp,
      fontWeight: FontWeight.w800,
    );
  }
}

class _RateRow extends StatelessWidget {
  const _RateRow({required this.rate});

  final _DeliveryRate rate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.05.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: DeliveryScreen._line, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              rate.location,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: DeliveryScreen._text,
                fontSize: 9.4.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            '\$${rate.price}',
            style: TextStyle(
              color: DeliveryScreen._green,
              fontSize: 9.6.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({
    required this.icon,
    required this.title,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          _IconBox(
            icon: icon,
            color: DeliveryScreen._green,
            background: const Color(0xFFEFF7F1),
            compact: true,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: title),
                  if (subtitle != null)
                    TextSpan(
                      text: ' - $subtitle',
                      style: TextStyle(
                        color: DeliveryScreen._muted,
                        fontSize: 9.2.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              style: TextStyle(
                color: DeliveryScreen._text,
                fontSize: 9.6.sp,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  const _IconBox({
    required this.icon,
    required this.color,
    required this.background,
    this.compact = false,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 4.6.h : 5.8.h;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(compact ? 12 : 15),
      ),
      child: Icon(icon, color: color, size: compact ? 2.4.h : 3.h),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(color: DeliveryScreen._line),
    boxShadow: const [
      BoxShadow(
        color: Color(0x10000000),
        blurRadius: 18,
        offset: Offset(0, 8),
      ),
    ],
  );
}

class _DeliveryRate {
  const _DeliveryRate(this.location, this.price);

  final String location;
  final String price;
}
