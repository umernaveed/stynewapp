import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/routes/app_pages.dart';
import 'package:straight_to_yard/app/util/flush_snackbar.dart';
import 'package:straight_to_yard/presentation/auth/controllers/login_controller.dart';
import 'package:straight_to_yard/presentation/auth/widgets/auth_app_bar.dart';
import 'package:straight_to_yard/presentation/auth/widgets/auth_surface.dart';
import 'package:straight_to_yard/presentation/auth/widgets/text_field.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      wrapWithAnnotatedRegion: true,
      value: SystemUiOverlayStyle.dark,
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: const AuthCustomAppBar(backButtonVisible: false),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(4.2.w, 1.5.h, 4.2.w, 4.h),
        child: FormBuilder(
          key: controller.formKey,
          clearValueOnUnregister: true,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: AuthSurface(
            title: 'Log In',
            subtitle: 'Enter your email and password to continue.',
            icon: Icons.login_rounded,
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
                const AuthFormGap(),
                ValueListenableBuilder<bool>(
                  valueListenable: controller.passwordVisibility,
                  builder: (context, value, child) {
                    return AppTextField(
                      name: 'password',
                      title: 'Password',
                      type: FieldType.passowrd,
                      obscureText: value,
                      onPasswordToggle: () => controller.onPasswordToggle(),
                      validator: FormBuilderValidators.compose(
                        [
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(6),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 0.6.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.toNamed(AppPages.forgetPassword),
                    child: Text(
                      'Forgot Password?',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: AuthSurface.green,
                        fontSize: 9.6.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 1.4.h),
                AppButton(
                  title: 'Log In',
                  onTap: () {
                    controller.onLoginPress().then((value) {
                      final isDone = value.isDone;
                      final message = value.message;
                      if (isDone) {
                        Get.offAllNamed(AppPages.bottomNav);
                      } else {
                        if (message.isEmpty) return;
                        FlushSnackbar.showSnackBar(message);
                      }
                    });
                  },
                ),
                SizedBox(height: 2.2.h),
                AuthWidgetSpanBuilder(
                  firstTitle: 'Don\'t have an account? ',
                  secondTitle: 'Signup',
                  onTap: () => Get.toNamed(AppPages.signUp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthWidgetSpanBuilder extends StatelessWidget {
  const AuthWidgetSpanBuilder({
    super.key,
    required this.firstTitle,
    required this.secondTitle,
    this.onTap,
  });

  final String firstTitle;
  final String secondTitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: firstTitle,
              style: context.textTheme.bodySmall?.copyWith(
                color: AuthSurface.text,
                fontSize: 9.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: InkWell(
                splashColor: AuthSurface.green.withOpacity(0.08),
                borderRadius: BorderRadius.circular(5),
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0.6.w),
                  child: Text(
                    secondTitle,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AuthSurface.green,
                      fontSize: 10.2.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.title,
    this.onTap,
    this.backgroundColor,
    this.textColor,
    this.side = BorderSide.none,
    this.buttonBorderRadius = 12,
    this.height = 6.2,
    this.fontSize,
    this.width,
  });

  final String title;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderSide side;
  final double buttonBorderRadius;
  final double height;
  final double? width;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? context.width,
      height: height.h,
      child: TextButton(
        style: TextButton.styleFrom(
          disabledBackgroundColor: Colors.black12.withOpacity(0.1),
          backgroundColor: backgroundColor ?? AuthSurface.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonBorderRadius),
            side: side,
          ),
        ),
        onPressed: onTap,
        child: Text(
          title,
          style: TextStyle(
            color: textColor ?? const Color(0xFFFFF9FF),
            fontSize: fontSize ?? 10.8.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
