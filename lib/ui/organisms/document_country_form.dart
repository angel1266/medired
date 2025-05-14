import 'package:flutter/material.dart';
import 'package:medired/core/value_objects/country.dart';
import 'package:medired/core/value_objects/document_type.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/molecules/custom_text_form_field.dart';

class DocumentCountryForm extends StatelessWidget {
  const DocumentCountryForm({
    super.key,
    required this.identificationCard,
    required this.documentType,
    required this.country,
    required this.onCountryPressed,
  });

  final Widget identificationCard;
  final DocumentType documentType;
  final Country country;

  final void Function() onCountryPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        identificationCard,
        CustomTextFormField(
          'Pais del documento',
          hintText: '${countryToString[country]}',
          controller:
              TextEditingController(text: '${countryToString[country]}'),
          keyboardType: TextInputType.text,
          readOnly: true,
          suffixIcon: documentType != DocumentType.idCard
              ? IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: AppColors.blueBackground,
                  ),
                  onPressed: onCountryPressed,
                )
              : null,
        ),
      ],
    );
  }
}
