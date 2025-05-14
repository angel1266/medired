import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_styles.dart';
import 'package:medired/ui/atoms/dropdown.dart';

class CustomDropdownFormFieldSex<T> extends StatelessWidget {
  const CustomDropdownFormFieldSex(
    this.labelText, {
    this.textStyle = AppStyles.input,
    required this.onChanged,
    required this.options,
    this.currentValue,
    this.validator, // Validador opcional
    super.key,
  });

  final String labelText;
  final TextStyle? textStyle;
  final void Function(T? newValue) onChanged;
  final Map<T, String> options;
  final T? currentValue;
  final String? Function(T? value)? validator; // Validador opcional

  @override
  Widget build(BuildContext context) {
    String? errorMessage;
    if (validator != null) {
      errorMessage = validator!(currentValue);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: textStyle,
        ),
        Dropdown<T>(
          currentValue: currentValue,
          onChanged: (newValue) => onChanged(newValue),
          options: options,
        ),
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              errorMessage,
              style: const TextStyle(
                  color: Colors.red), // Mensaje de error en rojo
            ),
          ),
      ],
    );
  }
}
