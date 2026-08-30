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
import 'package:straight_to_yard/presentation/auth/widgets/auth_surface.dart';
import 'package:straight_to_yard/presentation/auth/widgets/text_field.dart';
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
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(4.2.w, 1.5.h, 4.2.w, 4.h),
        child: FormBuilder(
          key: controller.formKey,
          child: AuthSurface(
            title: 'Reset Password',
            subtitle: 'Create a new password for your account.',
            icon: Icons.password_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  name: 'old_pass',
                  title: 'Old Password',
                  type: FieldType.passowrd,
                  obscureText: true,
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(6),
                    ],
                  ),
                ),
                const AuthFormGap(height: 2),
                AppTextField(
                  name: 'new_pass',
                  title: 'New Password',
                  type: FieldType.passowrd,
                  obscureText: true,
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.minLength(6),
                    ],
                  ),
                ),
                SizedBox(height: 2.6.h),
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
                SizedBox(height: 2.2.h),
                AuthWidgetSpanBuilder(
                  firstTitle: 'Already have an account? ',
                  secondTitle: 'Sign In',
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
