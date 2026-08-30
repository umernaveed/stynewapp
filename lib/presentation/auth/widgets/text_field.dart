import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

enum FieldType {
  passowrd,
  withOutTitle,
  paragraph,
  normal;

  bool get isPassword => this == FieldType.passowrd;
  bool get isParagraph => this == FieldType.paragraph;
}

class AppTextField extends StatelessWidget {
  final String title;
  final String? hint;
  final Color? titleColor;
  final FieldType type;
  final Color? hintColor;
  final double? height;
  final ValueChanged<String?>? onChange;
  final int? maxLines;
  final TextInputType? keyboardType;
  final int? minLines;
  final TextInputAction? textInputAction;
  final String name;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool obscureText;
  final void Function()? onPasswordToggle;
  final String? initialValue;
  final bool readOnly;
  const AppTextField({
    super.key,
    required this.title,
    this.onChange,
    this.hint,
    this.titleColor,
    this.type = FieldType.normal,
    this.hintColor,
    this.height,
    this.maxLines,
    this.keyboardType,
    this.minLines,
    this.textInputAction,
    required this.name,
    this.validator,
    this.controller,
    this.obscureText = false,
    this.onPasswordToggle,
    this.initialValue,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final field = FormBuilderTextField(
      name: name,
      obscureText: obscureText,
      // maxLines: maxLines,
      // minLines: minLines,
      validator: validator,
      readOnly: readOnly,
      controller: controller,
      initialValue: initialValue,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      obscuringCharacter: '●',
      onChanged: onChange,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 3.4.w,
          vertical: type.isParagraph ? 1.5.h : 1.65.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFE4E8EA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFE4E8EA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFF087C25), width: 1.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(color: Color(0xFFE94B4E)),
        ),
        hintStyle: context.theme.inputDecorationTheme.hintStyle?.copyWith(
          color: hintColor ?? const Color(0xFF8A8E99),
          fontSize: 10.2.sp,
          fontWeight: FontWeight.w400,
        ),
        hintText: type.isPassword ? '●●●●●●●' : hint,
        suffixIcon: type.isPassword
            ? IconButton(
                onPressed: onPasswordToggle,
                icon: Icon(
                  !obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              )
            : const SizedBox.shrink(),
      ),
      style: TextStyle(
        color: const Color(0xFF090D1B),
        fontSize: 10.6.sp,
        letterSpacing: type.isPassword ? 3 : 0,
        fontWeight: FontWeight.w600,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor ?? const Color(0xFF7C7C7C),
            fontSize: 9.2.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 0.65.h),
        if (type.isParagraph) ...[
          Expanded(child: field),
        ] else ...[
          field,
        ]
      ],
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({super.key, this.hint = 'Search', this.controller});
  final String hint;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: 7.2.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E8EA)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: TextFormField(
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        controller: controller,
        decoration: InputDecoration(
          isDense: false,
          contentPadding: EdgeInsets.symmetric(vertical: 1.65.h),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: const Color(0xFF087C25),
            size: 3.4.h,
          ),
          // suffixIcon: IconButton(
          //   icon: Icon(
          //     Icons.mic,
          //     color: Colors.black,
          //     size: 2.5.h,
          //   ),
          //   onPressed: () {},
          // ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintStyle: context.theme.inputDecorationTheme.hintStyle?.copyWith(
            color: const Color(0xFF757987),
            fontSize: 10.2.sp,
            fontWeight: FontWeight.w400,
          ),
          hintText: hint,
        ),
        style: TextStyle(
          color: const Color(0xFF090D1B),
          fontSize: 10.2.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
