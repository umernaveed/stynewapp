import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

abstract class Pair {
  final String value;
  final String key;

  Pair({required this.value, required this.key});
}

class OutLetPair extends Pair {
  OutLetPair({required super.value, required super.key});
}

class NormalString extends Pair {
  NormalString({
    required super.value,
    required super.key,
  });
}

class CustomDropDown<T extends Pair> extends StatefulWidget {
  final String title;
  final List<T> items;
  final Function(T?) onItemSelected;
  final String hint;
  final String name;
  final T? initialValue;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? disabledBorder;
  final InputBorder? errorBorder;
  final bool? isDense;
  final double? spaceBTW;
  final String? Function(T?)? validator;

  const CustomDropDown({
    Key? key,
    required this.title,
    required this.items,
    required this.onItemSelected,
    required this.hint,
    required this.name,
    this.initialValue,
    this.focusedBorder,
    this.enabledBorder,
    this.disabledBorder,
    this.isDense,
    this.spaceBTW,
    this.errorBorder,
    this.validator,
  }) : super(key: key);

  @override
  CustomDropDownState<T> createState() => CustomDropDownState<T>();
}

class CustomDropDownState<T extends Pair> extends State<CustomDropDown<T>> {
  T? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = null; // Initialize with null to show the hint
    if (widget.initialValue != null) {
      selectedValue = widget.initialValue;
    }
  }

  T? getInitValue() {
    final value = widget.initialValue;
    if (value == null) return null;
    final item = widget.items.firstWhereOrNull(
      (e) => e.key.toLowerCase() == value.key.toLowerCase(),
    );
    return item;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: context.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF7C7C7C),
            fontSize: 9.2.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: widget.spaceBTW ?? 0.65.h),
        FormBuilderDropdown<T>(
          name: widget.name,
          decoration: InputDecoration(
            hintText: widget.hint,
            isDense: widget.isDense ?? true,
            filled: true,
            fillColor: const Color(0xFFFBFCFE),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 3.4.w,
              vertical: 1.65.h,
            ),
            errorBorder: widget.errorBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(color: Color(0xFFE94B4E)),
                ),
            enabledBorder: widget.enabledBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(color: Color(0xFFE4E8EA)),
                ),
            focusedBorder: widget.focusedBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide:
                      const BorderSide(color: Color(0xFF087C25), width: 1.2),
                ),
            disabledBorder: widget.disabledBorder ??
                OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: const BorderSide(color: Color(0xFFE4E8EA)),
                ),
            hintStyle: context.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF8A8E99),
              fontSize: 10.2.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          validator: widget.validator ??
              FormBuilderValidators.compose(
                [
                  FormBuilderValidators.required(),
                ],
              ),
          isExpanded: true,
          initialValue: getInitValue(),
          alignment: Alignment.centerLeft,
          elevation: 1,
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.black,
            fontSize: 10.6.sp,
            fontWeight: FontWeight.w600,
          ),
          onChanged: (newValue) {
            setState(() {
              selectedValue = newValue;
              widget.onItemSelected(selectedValue);
            });
          },
          items: widget.items.map(
            (item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  item.value,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                    fontSize: 10.6.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
