import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:straight_to_yard/app/util/flush_snackbar.dart';
import 'package:straight_to_yard/presentation/account/controllers/add_alert_controller.dart';
import 'package:straight_to_yard/presentation/account/views/account_screen.dart';
import 'package:straight_to_yard/presentation/auth/views/login_screen.dart';
import 'package:straight_to_yard/presentation/auth/widgets/auth_app_bar.dart';
import 'package:straight_to_yard/presentation/auth/widgets/text_field.dart';
import 'package:straight_to_yard/presentation/base_screen.dart';

class AddPreAlertScreen extends GetView<AddPreAlertController> {
  const AddPreAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 4.w, right: 4.w, top: 2.2.h, bottom: 1.7.h),
                child: Text(
                  'Add Pre-Alert',
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
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.2.h),
                child: FormBuilder(
                  key: controller.formKey,
                  clearValueOnUnregister: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        title: 'Name',
                        hint: 'Name',
                        name: 'nick_name',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      SizedBox(height: 1.8.h),
                      AppTextField(
                        title: 'Merchant',
                        hint: 'Merchant',
                        name: 'merchant',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      SizedBox(height: 1.8.h),
                      AppTextField(
                        title: 'Carrier',
                        hint: 'Carrier',
                        name: 'courier',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      SizedBox(height: 1.8.h),
                      AppTextField(
                        title: 'Carrier tracking number',
                        hint: 'Carrier tracking number',
                        maxLines: 10,
                        minLines: 5,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        type: FieldType.normal,
                        name: 'supplier_tracking_no',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      SizedBox(height: 1.8.h),
                      AppTextField(
                        title: 'Weight',
                        hint: 'Weight',
                        maxLines: 10,
                        minLines: 5,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        type: FieldType.normal,
                        name: 'weight',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      SizedBox(height: 1.8.h),
                      AppTextField(
                        title: 'Value (US \$)',
                        hint: 'Value (US \$)',
                        maxLines: 10,
                        minLines: 5,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        type: FieldType.normal,
                        name: 'price',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      SizedBox(height: 1.8.h),
                      AppTextField(
                        title: 'Description',
                        hint: 'Description',
                        maxLines: 10,
                        minLines: 5,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        type: FieldType.normal,
                        name: 'item_description',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'Attach an invoice',
                        style: TextStyle(
                          color: const Color(0xFF7C7C7C),
                          fontSize: 9.2.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      const FilePickerWidget(),
                      SizedBox(height: 2.2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: AppButton(
                              title: 'Submit',
                              onTap: () {
                                controller.onSubmit().then((value) {
                                  final isDone = value.isDone;
                                  final message = value.message;
                                  if (isDone) {
                                    Get.back();
                                    if (message.isEmpty) return;
                                    FlushSnackbar.showSnackBar(message);
                                  }
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 6.2.w),
                          Expanded(
                            child: AppButton(
                              title: 'Clear',
                              onTap: () {
                                controller.clearFile();
                              },
                              backgroundColor: Colors.white,
                              side: BorderSide(
                                width: 1,
                                color: Colors.black
                                    .withOpacity(0.30000001192092896),
                              ),
                              textColor: const Color(0xFF7C7C7C),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FilePickerWidget extends StatelessWidget {
  const FilePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddPreAlertController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Container(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            width: context.width,
            decoration: ShapeDecoration(
              color: const Color(0xFFF8FBFF),
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xFFE4E8EA)),
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            child: controller.pickedFile.value.path.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: Text(
                      'No file choosen',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: const Color(0xFF757987),
                        fontSize: 9.4.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(left: 2.w),
                    child: Row(
                      children: [
                        const Icon(Icons.file_open_rounded),
                        SizedBox(width: 2.w),
                        Flexible(
                          child: Text(
                            controller.pickedFileName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF090D1B),
                              fontSize: 9.4.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        Obx(
          () => Visibility(
            visible: !controller.isFilePicked,
            child: Text(
              controller.filePickError.value,
              style: TextStyle(
                color: Colors.red,
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        SizedBox(height: 3.w),
        Obx(
          () => Visibility(
            visible: !controller.isFilePicked,
            child: GestureDetector(
              onTap: () {
                controller.pickFile();
              },
              child: Container(
                width: 131,
                height: 4.6.h,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: const Color(0xFFEAF5ED),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0xFFD8E9DD)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Choose File',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF087C25),
                    fontSize: 9.6.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
