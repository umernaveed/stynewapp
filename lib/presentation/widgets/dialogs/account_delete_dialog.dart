import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/presentation/auth/views/login_screen.dart';

class AccountDeleteConfirmationDialog extends StatelessWidget {
  const AccountDeleteConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
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
              'A New Version of straight_to_yard is available ',
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
                  child: AppButton(
                    title: 'Update',
                    buttonBorderRadius: 12,
                    backgroundColor: Colors.red,
                    onTap: () {},
                  ),
                ),
                SizedBox(width: 1.h),
                Expanded(
                  child: AppButton(
                    title: 'Cancel',
                    buttonBorderRadius: 12,
                    onTap: () => Get.back(),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
