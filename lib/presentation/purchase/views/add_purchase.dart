import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/core/get_di.dart';
import 'package:straight_to_yard/app/util/flush_snackbar.dart';
import 'package:straight_to_yard/data/models/purchase/purchase.dart';
import 'package:straight_to_yard/presentation/account/views/account_screen.dart';
import 'package:straight_to_yard/presentation/auth/views/login_screen.dart';
import 'package:straight_to_yard/presentation/auth/widgets/auth_app_bar.dart';
import 'package:straight_to_yard/presentation/auth/widgets/text_field.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';
import 'package:straight_to_yard/presentation/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:straight_to_yard/presentation/purchase/controllers/add_purchase_controller.dart';

class AddPurchase extends GetView<AddPurchaseController> {
  const AddPurchase({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final isEditing = args == null ? false : true;
    final item = isEditing ? args as Purchase : Purchase.empty();
    return BaseScreen(
      wrapWithAnnotatedRegion: true,
      backgroundColor: const Color(0xFFF8FBFF),
      value: SystemUiOverlayStyle.dark,
      appBar: const AuthCustomAppBar.withSmallAppLogo(
        backButtonVisible: true,
        usingNavigator: true,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Container(
          width: context.width,
          margin:
              EdgeInsets.only(left: 4.2.w, right: 4.2.w, top: 2.h, bottom: 2.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: const Color(0xFFE4E8EA)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x10000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              )
            ],
          ),
          child: FormBuilder(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 4.w, right: 4.w, top: 2.2.h, bottom: 1.7.h),
                  child: Text(
                    isEditing
                        ? 'Update Purchase Request'
                        : 'Add Purchase Request',
                    style: TextStyle(
                      color: const Color(0xFF090D1B),
                      fontSize: 11.8.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const AppDivider(),
                // const AccountHolderInfo(),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.2.h),
                  child: Column(
                    children: [
                      AppTextField(
                        title: 'Name',
                        hint: 'Name',
                        name: 'name',
                        initialValue: item.name,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      SizedBox(height: 1.8.h),
                      AppTextField(
                        title: 'Link',
                        hint: 'Link',
                        name: 'link',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.url(),
                        ]),
                        initialValue: item.link,
                      ),
                      SizedBox(height: 1.8.h),
                      AppTextField(
                        title: 'Quantity',
                        hint: 'Quantity',
                        name: 'qty',
                        keyboardType: TextInputType.number,
                        initialValue: isEditing ? item.qty.toString() : '',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      SizedBox(height: 1.8.h),
                      AppTextField(
                        title: 'Notes',
                        hint: 'Notes',
                        maxLines: 10,
                        minLines: 5,
                        initialValue: item.notes,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        type: FieldType.normal,
                        name: 'notes',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      SizedBox(height: 2.8.h),
                      AppButton(
                        title: 'Submit',
                        onTap: () {
                          final bottomNavNestedID =
                              find<BottomNavController>().bottomNavNestedID;
                          controller
                              .onSubmit(
                            isUpdating: isEditing,
                            updateID: item.id,
                          )
                              .then((value) {
                            final isDone = value.isDone;
                            final message = value.message;
                            if (isDone) {
                              Get.back(id: bottomNavNestedID);
                              if (message.isEmpty) return;
                              FlushSnackbar.showSnackBar(message);
                            }
                          });
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountHolderInfo extends StatelessWidget {
  const AccountHolderInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: 4.h,
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      margin: EdgeInsets.only(left: 6.5.w, right: 6.5.w, top: 2.h),
      decoration: ShapeDecoration(
        color: const Color(0xFFF4F4F4),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: Colors.black.withOpacity(0.30000001192092896),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Rizwan javed Account no: SPJ-06849',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF7C7C7C),
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SvgPicture.asset('assets/svgs/ic_drop_down.svg')
        ],
      ),
    );
  }
}
