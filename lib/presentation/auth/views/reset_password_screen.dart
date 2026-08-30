import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/routes/app_pages.dart';
import 'package:straight_to_yard/app/util/flush_snackbar.dart';
import 'package:straight_to_yard/presentation/auth/controllers/reset_password_controller.dart';
import 'package:straight_to_yard/presentation/auth/views/login_screen.dart';
import 'package:straight_to_yard/presentation/auth/widgets/auth_app_bar.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';

class ResetPasswordScreen extends GetView<ResetPasswordController> {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      wrapWithAnnotatedRegion: true,
      value: SystemUiOverlayStyle.dark,
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: const AuthCustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.2.w),
          child: FormBuilder(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.5.h),
                Text(
                  'Re-set Password',
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF090D1B),
                    fontSize: 15.2.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Old Password',
                  style: TextStyle(
                    color: const Color(0xFF7C7C7C),
                    fontSize: 9.2.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                FormBuilderTextField(
                  name: 'old_pass',
                  obscureText: true,
                  obscuringCharacter: '●',
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(6),
                    ],
                  ),
                  style: TextStyle(
                    color: const Color(0xFF181725),
                    fontSize: 10.6.sp,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: '●●●●●●●',
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.remove_red_eye),
                    ),
                  ),
                ),
                SizedBox(height: 5.4.h),
                Text(
                  'New Password',
                  style: TextStyle(
                    color: const Color(0xFF7C7C7C),
                    fontSize: 9.2.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                FormBuilderTextField(
                  name: 'new_pass',
                  obscureText: true,
                  obscuringCharacter: '●',
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(6),
                    ],
                  ),
                  style: TextStyle(
                    color: const Color(0xFF181725),
                    fontSize: 10.6.sp,
                    letterSpacing: 3,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: '●●●●●●●',
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.remove_red_eye),
                    ),
                  ),
                ),
                SizedBox(height: 4.5.h),
                AppButton(
                  title: 'Submit',
                  onTap: () {
                    controller.onSubmit().then((value) {
                      final isDone = value.isDone;
                      final message = value.message;
                      if (isDone) Get.offAllNamed(AppPages.login);
                      if (message.isNotEmpty) {
                        FlushSnackbar.showSnackBar(message);
                      }
                    });
                  },
                ),
                SizedBox(height: 3.h),
                AuthWidgetSpanBuilder(
                  firstTitle: 'Already have an account? ',
                  secondTitle: 'Sing In',
                  onTap: () => Get.offAllNamed(AppPages.login),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
