import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/presentation/auth/controllers/forget_password_controller.dart';
import 'package:straight_to_yard/presentation/auth/views/login_screen.dart';
import 'package:straight_to_yard/presentation/auth/widgets/auth_app_bar.dart';
import 'package:straight_to_yard/presentation/auth/widgets/auth_surface.dart';
import 'package:straight_to_yard/presentation/auth/widgets/text_field.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';

class ForgetPasswordScreen extends GetView<ForgetPasswordController> {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      wrapWithAnnotatedRegion: true,
      value: SystemUiOverlayStyle.dark,
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: const AuthCustomAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(4.2.w, 1.5.h, 4.2.w, 4.h),
        child: FormBuilder(
          key: controller.formKey,
          child: AuthSurface(
            title: 'Forgot Password',
            subtitle: 'Enter your email and we will help you reset access.',
            icon: Icons.lock_reset_rounded,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  name: 'email',
                  title: 'Email',
                  hint: 'imshuvo97@gmail.com',
                  validator: FormBuilderValidators.compose(
                    [
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ],
                  ),
                ),
                SizedBox(height: 2.5.h),
                AppButton(
                  title: 'Submit',
                  onTap: () => controller.onSubmit(),
                ),
                SizedBox(height: 2.2.h),
                AuthWidgetSpanBuilder(
                  firstTitle: 'Already have an account? ',
                  secondTitle: 'Sign In',
                  onTap: () => Get.back(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
