import 'package:flutter/material.dart';
import 'package:medired/core/value_objects/document_type.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/app_styles.dart';
import 'package:medired/ui/molecules/custom_dropdown_field.dart';

class DocumentTypeForm extends StatelessWidget {
  const DocumentTypeForm({
    super.key,
    required this.identificationCard,
    required this.documentType,
    required this.onDocumentChanged,
  });

  final Widget identificationCard;

  final DocumentType documentType;
  final Function(DocumentType? newValue) onDocumentChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        identificationCard,
        CustomDropdownFormField<DocumentType>(
          'Tipo de documento',
          options: documentTypeToString
            ..removeWhere((key, value) =>
                key == DocumentType.rnc || key == DocumentType.residence),
          textStyle: AppStyles.input.copyWith(color: AppColors.blueBackground),
          onChanged: (newValue) => onDocumentChanged(newValue),
          currentValue: documentType,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
