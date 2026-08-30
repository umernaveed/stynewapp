import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/presentation/auth/views/login_screen.dart';
import 'package:straight_to_yard/presentation/dashboard/controllers/dashboard_controller.dart';

class AppUpdateDialog extends StatelessWidget {
  const AppUpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 1.h),
            Text(
              'App Update',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF090D1B),
                fontSize: 11.8.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'A new version of straight_to_yard is Available.\n Do you want to Upgrade?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF757987),
                fontSize: 9.8.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 5.5.h,
                    child: AppButton(
                      title: 'Later',
                      buttonBorderRadius: 12,
                      backgroundColor: Colors.red,
                      onTap: () => Get.back(),
                    ),
                  ),
                ),
                SizedBox(width: 1.h),
                Expanded(
                  child: SizedBox(
                    height: 5.5.h,
                    child: AppButton(
                      title: 'Upgrade',
                      buttonBorderRadius: 12,
                      onTap: () {
                        Get.back();
                        final bNC = find<DashboardController>();
                        bNC.launchStore();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
