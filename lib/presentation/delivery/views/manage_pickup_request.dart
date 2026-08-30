import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/data/models/manage_pick_up_request_meta/area.dart';
import 'package:straight_to_yard/data/models/manage_pick_up_request_meta/day.dart';
import 'package:straight_to_yard/presentation/auth/views/login_screen.dart';
import 'package:straight_to_yard/presentation/auth/widgets/auth_app_bar.dart';
import 'package:straight_to_yard/presentation/auth/widgets/drop_down.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';
import 'package:straight_to_yard/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:straight_to_yard/presentation/delivery/controllers/manage_pickup_request_controller.dart';

class ManagePickupRequest extends GetView<ManagePickUpRequestController> {
  const ManagePickupRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final instantUser = controller.getInstantUser();
    return BaseScreen(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AuthCustomAppBar.withSmallAppLogo(
        backID: find<BottomNavController>().bottomNavNestedID,
      ),
      value: SystemUiOverlayStyle.dark,
      body: SingleChildScrollView(
        child: FormBuilder(
          clearValueOnUnregister: true,
          key: controller.formKey,
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.only(
                left: 4.2.w,
                right: 4.2.w,
                top: 1.4.h,
                bottom: 2.h,
              ),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.2.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: const Color(0xFFE4E8EA)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x10000000),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: GetBuilder<ManagePickUpRequestController>(
                id: 'manage_pickup_request',
                builder: (_) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Manage Delivery Request',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF090D1B),
                          fontSize: 11.8.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      _FieldWithLable(
                        name: 'name',
                        hint: 'Johan Doe',
                        initialValue: instantUser.userName,
                        lable: 'who should we expecting',
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()],
                        ),
                      ),
                      SizedBox(height: 1.8.h),
                      _FieldWithLable(
                        name: 'contact',
                        lable: 'Contact',
                        initialValue: instantUser.phone,
                        hint: '#####',
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()],
                        ),
                      ),
                      SizedBox(height: 1.8.h),
                      CustomDropDown<Day>(
                        name: 'select_day',
                        spaceBTW: 10,
                        title: 'Select Day',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide:
                              const BorderSide(color: Color(0xFFE4E8EA)),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide:
                              const BorderSide(color: Color(0xFFE4E8EA)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(
                            color: Color(0xFF087C25),
                            width: 1.2,
                          ),
                        ),
                        onItemSelected: (e) {},
                        hint: 'Monday',
                        items: controller.days,
                      ),
                      SizedBox(height: 1.8.h),
                      CustomDropDown<Area>(
                        name: 'select_area',
                        title: 'Select Area',
                        onItemSelected: (e) {
                          if (e == null) return;
                          controller.onAreaChange(e);
                        },
                        spaceBTW: 10,
                        hint: 'CITY CENTER',
                        isDense: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide:
                              const BorderSide(color: Color(0xFFE4E8EA)),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide:
                              const BorderSide(color: Color(0xFFE4E8EA)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(
                            color: Color(0xFF087C25),
                            width: 1.2,
                          ),
                        ),
                        items: controller.areas,
                      ),
                      SizedBox(height: 1.8.h),
                      _FieldWithLable(
                        name: 'delivery_coast',
                        lable: 'Delivery Coast',
                        hint: '00.00',
                        controller: controller.coastController,
                        readOnly: true,
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()],
                        ),
                      ),
                      SizedBox(height: 1.8.h),
                      _FieldWithLable(
                        name: 'address',
                        lable: 'Address',
                        initialValue: instantUser.address1,
                        hint: 'CITY CENTER, JERUSALEM',
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()],
                        ),
                      ),
                      SizedBox(height: 1.8.h),
                      _FieldWithLable(
                        name: 'notes',
                        lable: 'Notes',
                        maxLines: 5,
                        hint: 'Notes',
                        validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required()],
                        ),
                      ),
                      SizedBox(height: 2.6.h),
                      AppButton(
                        title: 'Schedule Delivery',
                        buttonBorderRadius: 10,
                        backgroundColor: const Color(0xFF087C25),
                        onTap: () => controller.onSchedule(),
                      ),
                      SizedBox(height: 1.2.h),
                      AppButton(
                        title: 'Cancel',
                        buttonBorderRadius: 10,
                        backgroundColor: Colors.transparent,
                        textColor: const Color(0xFF087C25),
                        side: const BorderSide(
                          color: Color(0xFFD8E9DD),
                          width: 0.5,
                        ),
                        onTap: () => Get.back(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldWithLable extends StatelessWidget {
  const _FieldWithLable({
    required this.lable,
    required this.name,
    required this.validator,
    required this.hint,
    this.maxLines,
    this.inputDecoration,
    this.initialValue,
    this.readOnly = false,
    this.controller,
  });
  final String lable;
  final String name;
  final String? Function(String?)? validator;
  final String hint;
  final int? maxLines;
  final InputDecoration? inputDecoration;
  final String? initialValue;
  final bool readOnly;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lable,
          style: TextStyle(
            color: const Color(0xFF7C7C7C),
            fontSize: 9.2.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 0.65.h),
        FormBuilderTextField(
          name: name,
          maxLines: maxLines,
          readOnly: readOnly,
          controller: controller,
          initialValue: initialValue,
          decoration: inputDecoration ??
              InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 3.4.w,
                  vertical: 1.65.h,
                ),
                hintText: hint,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(color: Color(0xFFE4E8EA)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(color: Color(0xFFE4E8EA)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide:
                      const BorderSide(color: Color(0xFF087C25), width: 1.2),
                ),
              ),
          validator: validator,
          style: const TextStyle(
            color: Color(0xFF090D1B),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
