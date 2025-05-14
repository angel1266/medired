import 'package:flutter/material.dart';
import 'package:medired/features/authentication/domain/entities/document.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/app_styles.dart';
import 'package:medired/ui/molecules/custom_text_form_field.dart';

class DocumentValueForm extends StatefulWidget {
  const DocumentValueForm(
      {super.key,
      required this.identificationCard,
      required this.onChanged,
      required this.document});

  final Widget identificationCard;
  final void Function(String)? onChanged;
  final Document document;

  @override
  State<DocumentValueForm> createState() => _DocumentValueFormState();
}

class _DocumentValueFormState extends State<DocumentValueForm> {
  final TextEditingController _valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _valueController.text = widget.document.value;
  }

  @override
  void didUpdateWidget(DocumentValueForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.document.value.isEmpty) {
      _valueController.text = widget.document.value;
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        widget.identificationCard,
        CustomTextFormField(
          'Número de documento',
          labelStyle: AppStyles.input.copyWith(color: AppColors.blueBackground),
          // initialValue: widget.document.value,
          controller: _valueController,
          hintText: '123456',
          keyboardType: widget.document.isDominicanId
              ? TextInputType.number
              : TextInputType.text,
          onChanged: (value) => widget.onChanged?.call(value),
          validator: (value) => widget.document.validateAll,
        ),
      ],
    );
  }
}
