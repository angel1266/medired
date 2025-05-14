import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medired/ui/constants/app_styles.dart';
import 'package:medired/ui/atoms/base_form_field.dart';

class CustomTextFormFieldWithSubmitAction extends StatelessWidget {
  const CustomTextFormFieldWithSubmitAction(this.labelText,
      {this.hintText = '',
      this.labelStyle = AppStyles.input,
      this.hintstyle,
      this.textstyle,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.textInputAction = TextInputAction.next,
      this.textCapitalization = TextCapitalization.none,
      this.readOnly = false,
      this.enabled,
      this.keyboardType,
      this.initialValue,
      this.controller,
      this.suffixIcon,
      this.validator,
      this.onChanged,
      super.key,
      this.inputFormatters,
      this.maxLength,
      this.backgroundColor,
      this.onTap,
      this.counterStyle,
      this.onFieldSubmitted});

  final String labelText;
  final String hintText;
  final TextStyle? hintstyle;
  final TextStyle? textstyle;
  final AutovalidateMode autovalidateMode;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final TextStyle? labelStyle;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool? enabled;
  final TextInputType? keyboardType;
  final String? initialValue;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final String? Function(String? value)? validator;
  final int? maxLength;
  final void Function(String value)? onChanged;
  final Color? backgroundColor;
  final Function()? onTap;
  final TextStyle? counterStyle;
  final void Function(String value)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return BaseFormField(
      Text(
        labelText,
        style: labelStyle,
      ),
      formField: TextFormField(
        maxLength: maxLength,
        textAlign: TextAlign.center,
        initialValue: initialValue,
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        onTap: onTap,
        autovalidateMode: autovalidateMode,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        keyboardType: keyboardType,
        readOnly: readOnly,
        style: textstyle,
        enabled: enabled,
        inputFormatters: inputFormatters,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: hintstyle,
            suffixIcon: suffixIcon,
            fillColor: backgroundColor,
            counterStyle: counterStyle),
      ),
    );
  }
}
