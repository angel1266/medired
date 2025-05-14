import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_styles.dart';
import 'package:medired/ui/atoms/base_form_field.dart';
import 'package:medired/ui/atoms/dropdown.dart';

class CustomDropdownFormField<T> extends StatelessWidget {
  const CustomDropdownFormField(
    this.data, {
    this.textStyle = AppStyles.input,
    required this.onChanged,
    required this.options,
    this.currentValue,
    super.key,
  });

  final String data;
  final TextStyle? textStyle;
  final void Function(T? newValue) onChanged;
  final Map<T, dynamic> options;
  final T? currentValue;
  @override
  Widget build(BuildContext context) {
    return BaseFormField(
      Text(
        data,
        style: textStyle,
      ),
      formField: Dropdown<T>(
        currentValue: currentValue,
        onChanged: (newValue) => onChanged(newValue),
        options: options,
      ),
    );
  }
}
