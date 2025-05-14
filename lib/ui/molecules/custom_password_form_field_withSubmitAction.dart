import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medired/ui/atoms/base_form_field.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/app_styles.dart';

class CustomPasswordFormFieldWithSubmitAction extends StatefulWidget {
  const CustomPasswordFormFieldWithSubmitAction(this.data,
      {super.key,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.textInputAction = TextInputAction.next,
      this.textCapitalization = TextCapitalization.none,
      this.readOnly = false,
      this.enabled,
      this.initialValue,
      this.controller,
      required this.validator,
      required this.onChanged,
      this.inputFormatters,
      this.maxLength,
      this.textStyle = AppStyles.input,
      this.hintText = '',
      this.onFieldSubmitted});

  final String data;
  final String? hintText;
  final AutovalidateMode autovalidateMode;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool? enabled;
  final TextStyle? textStyle;
  final String? initialValue;
  final TextEditingController? controller;
  final String? Function(String? value)? validator;
  final int? maxLength;
  final void Function(String value)? onChanged;
  final void Function(String value)? onFieldSubmitted;

  @override
  State<CustomPasswordFormFieldWithSubmitAction> createState() =>
      _CustomPasswordFormFieldState();
}

class _CustomPasswordFormFieldState
    extends State<CustomPasswordFormFieldWithSubmitAction> {
  _CustomPasswordFormFieldState();
  bool obscureText = true;

  void toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseFormField(
        Text(
          widget.data,
          style: widget.textStyle,
        ),
        formField: TextFormField(
          maxLength: widget.maxLength,
          textAlign: TextAlign.center,
          initialValue: widget.initialValue,
          controller: widget.controller,
          onChanged: widget.onChanged,
          validator: widget.validator,
          autovalidateMode: widget.autovalidateMode,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          keyboardType: TextInputType.visiblePassword,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          inputFormatters: widget.inputFormatters,
          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                color: AppColors.blueBackground,
              ),
              onPressed: toggleObscureText,
            ),
          ),
          obscureText: obscureText,
        ));
  }
}
