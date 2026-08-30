import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/routes/app_pages.dart';
import 'package:straight_to_yard/presentation/auth/controllers/signup_controller.dart';
import 'package:straight_to_yard/presentation/auth/views/login_screen.dart';
import 'package:straight_to_yard/presentation/auth/widgets/auth_app_bar.dart';
import 'package:straight_to_yard/presentation/auth/widgets/auth_surface.dart';
import 'package:straight_to_yard/presentation/auth/widgets/drop_down.dart';
import 'package:straight_to_yard/presentation/auth/widgets/text_field.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      wrapWithAnnotatedRegion: true,
      value: SystemUiOverlayStyle.dark,
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: const AuthCustomAppBar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(4.2.w, 1.5.h, 4.2.w, 5.h),
            sliver: SliverToBoxAdapter(
              child: FormBuilder(
                key: controller.formKey,
                clearValueOnUnregister: true,
                autovalidateMode: AutovalidateMode.disabled,
                child: AuthSurface(
                  title: 'Sign Up',
                  subtitle: 'Create your Straight To Yard account.',
                  icon: Icons.person_add_alt_1_rounded,
                  bottomPadding: 2.4.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FormSectionTitle('Account Type'),
                      const AuthFormGap(height: 1.2),
                      GetBuilder<SignUpController>(
                        id: 'managers',
                        builder: (_) {
                          if (_.managers.managers.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            children: [
                              CustomDropDown<OutLetPair>(
                                name: 'managerId',
                                title: 'Managers (Optional)',
                                onItemSelected: (e) {},
                                validator: FormBuilderValidators.compose([]),
                                hint: 'Select Manager',
                                items: controller.managers.managers
                                    .map(
                                      (e) => OutLetPair(
                                        key: e.id.toString(),
                                        value: e.name,
                                      ),
                                    )
                                    .toList(),
                              ),
                              const AuthFormGap(),
                            ],
                          );
                        },
                      ),
                      GetBuilder<SignUpController>(
                        id: 'outLet',
                        builder: (_) {
                          return CustomDropDown<OutLetPair>(
                            name: 'outletId',
                            title: 'Outlet',
                            onItemSelected: (e) {},
                            hint: 'Select Outlet',
                            items: controller.outLet.outLets
                                .map(
                                  (e) => OutLetPair(
                                    key: e.outletId,
                                    value: e.outletName,
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                      const AuthFormGap(),
                      CustomDropDown<NormalString>(
                        name: 'userType',
                        title: 'User Type',
                        onItemSelected: (e) {
                          controller.onUserTypeSelect(e?.key ?? 'Personal');
                        },
                        hint: 'Personal',
                        items: const ['Personal', 'Business']
                            .map((e) => NormalString(key: e, value: e))
                            .toList(),
                      ),
                      SizedBox(height: 2.4.h),
                      const _FormSectionTitle('Personal Details'),
                      const AuthFormGap(height: 1.2),
                      AppTextField(
                        name: 'firstName',
                        title: 'First Name',
                        hint: 'Enter first name',
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()],
                        ),
                      ),
                      const AuthFormGap(),
                      AppTextField(
                        name: 'lastName',
                        title: 'Last Name',
                        hint: 'Enter last name',
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()],
                        ),
                      ),
                      const AuthFormGap(),
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
                      AppTextField(
                        name: 'confirm_email',
                        title: 'Confirm Email',
                        hint: 'imshuvo97@gmail.com',
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email(),
                            (value) {
                              final email = controller
                                  .formKey.currentState?.instantValue['email']
                                  ?.toString()
                                  .toLowerCase();
                              return value?.toLowerCase() == email
                                  ? null
                                  : 'Emails do not match';
                            },
                          ],
                        ),
                      ),
                      SizedBox(height: 2.4.h),
                      const _FormSectionTitle('Security'),
                      const AuthFormGap(height: 1.2),
                      ValueListenableBuilder<bool>(
                        valueListenable: controller.passwordVisibility,
                        builder: (context, value, child) {
                          return AppTextField(
                            name: 'password',
                            title: 'Password',
                            obscureText: value,
                            onPasswordToggle: () =>
                                controller.onPasswordToggle(),
                            type: FieldType.passowrd,
                            hintColor: const Color(0x337C7C7C),
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(6),
                              ],
                            ),
                          );
                        },
                      ),
                      const AuthFormGap(),
                      ValueListenableBuilder<bool>(
                        valueListenable: controller.confirmPasswordVisibility,
                        builder: (context, value, child) {
                          return AppTextField(
                            name: 'confirm_password',
                            title: 'Re-type Password',
                            type: FieldType.passowrd,
                            obscureText: value,
                            onPasswordToggle: () =>
                                controller.onConfirmPasswordToggle(),
                            validator: FormBuilderValidators.compose(
                              [
                                FormBuilderValidators.required(),
                                FormBuilderValidators.minLength(6),
                                (value) {
                                  final pwd = controller.formKey.currentState
                                      ?.instantValue['password']
                                      ?.toString()
                                      .toLowerCase();
                                  return value?.toLowerCase() == pwd
                                      ? null
                                      : 'Passwords do not match';
                                },
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 2.4.h),
                      const _FormSectionTitle('Contact'),
                      const AuthFormGap(height: 1.2),
                      AppTextField(
                        name: 'phone',
                        title: 'Phone (Optional)',
                        hint: 'Phone #',
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.numeric()],
                        ),
                      ),
                      const AuthFormGap(),
                      AppTextField(
                        name: 'address1',
                        title: 'Address 1 (Optional)',
                        hint: 'Address 1',
                      ),
                      SizedBox(height: 2.8.h),
                      AppButton(
                        title: 'Create New Account',
                        onTap: () => controller.onSignUpPress(),
                      ),
                      SizedBox(height: 2.2.h),
                      AuthWidgetSpanBuilder(
                        firstTitle: 'Already have an account? ',
                        secondTitle: 'Log In',
                        onTap: () => Get.offAllNamed(AppPages.login),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormSectionTitle extends StatelessWidget {
  const _FormSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 0.9.h,
          height: 0.9.h,
          decoration: const BoxDecoration(
            color: AuthSurface.yellow,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          title,
          style: context.textTheme.bodyMedium?.copyWith(
            color: AuthSurface.text,
            fontSize: 10.2.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
