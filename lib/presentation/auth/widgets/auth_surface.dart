import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class AuthSurface extends StatelessWidget {
  const AuthSurface({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.icon = Icons.lock_outline_rounded,
    this.bottomPadding,
  });

  static const green = Color(0xFF087C25);
  static const yellow = Color(0xFFFFB800);
  static const text = Color(0xFF090D1B);
  static const muted = Color(0xFF757987);
  static const line = Color(0xFFE4E8EA);

  final String title;
  final String subtitle;
  final Widget child;
  final IconData icon;
  final double? bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(4.2.w, 2.2.h, 4.2.w, 2.2.h),
              decoration: BoxDecoration(
                color: green,
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
                    width: 6.8.h,
                    height: 6.8.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(color: yellow, width: 1.2),
                    ),
                    child: Icon(icon, color: Colors.white, size: 3.6.h),
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontSize: 15.2.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w900,
                            height: 1.05,
                          ),
                        ),
                        SizedBox(height: 0.65.h),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodyMedium?.copyWith(
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
            ),
            SizedBox(height: 1.8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                4.w,
                2.2.h,
                4.w,
                bottomPadding ?? 2.2.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: line),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x10000000),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class AuthFormGap extends StatelessWidget {
  const AuthFormGap({super.key, this.height = 1.8});

  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(height: height.h);
}
