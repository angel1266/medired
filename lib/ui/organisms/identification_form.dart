import 'package:flutter/material.dart';
import 'package:medired/core/value_objects/value_objects_export.dart';
import 'package:medired/features/authentication/domain/entities/document.dart';
import 'package:medired/ui/organisms/document_country_form.dart';
import 'package:medired/ui/organisms/document_type_form.dart';
import 'package:medired/ui/organisms/document_value_form.dart';

class IdentificationForm extends StatefulWidget {
  const IdentificationForm({
    required this.document,
    required this.onDocumentChanged,
    required this.onCountryPressed,
    required this.onChanged,
    required this.identificationCard,
    super.key,
  });

  final Document document;
  final Widget identificationCard;
  final void Function(DocumentType? newValue) onDocumentChanged;
  final void Function() onCountryPressed;
  final void Function(String value)? onChanged;

  @override
  State<IdentificationForm> createState() => _IdentificationStepperState();
}

class _IdentificationStepperState extends State<IdentificationForm>
    with TickerProviderStateMixin {
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 2) {
                setState(() {
                  _currentStep++;
                });
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() {
                  _currentStep--;
                });
              } else {
                Navigator.pop(context);
              }
            },
            controlsBuilder: (context, details) {
              return Row(
                children: [
                  const SizedBox(width: 8),
                  _button(
                      onPressed: details.onStepCancel,
                      icon: Icons.arrow_back,
                      label: 'Atrás'),
                  const SizedBox(width: 8),
                  if (_currentStep < 2)
                    _button(
                        onPressed: details.onStepContinue,
                        icon: Icons.arrow_forward,
                        label: 'Continuar'),
                  if (_currentStep == 2)
                    _button(
                        onPressed: widget.document.validateAll == null
                            ? () => Navigator.pop(context)
                            : null,
                        icon: Icons.check,
                        label: 'Finalizar'),
                  const SizedBox(width: 8),
                ],
              );
            },
            steps: [
              Step(
                title: _title(0, 'Elige un documento'),
                content: DocumentTypeForm(
                  identificationCard: widget.identificationCard,
                  documentType: widget.document.documentType,
                  onDocumentChanged: widget.onDocumentChanged,
                ),
              ),
              Step(
                title: _title(1, 'Elige un país'),
                content: DocumentCountryForm(
                  identificationCard: widget.identificationCard,
                  country: widget.document.country,
                  documentType: widget.document.documentType,
                  onCountryPressed: widget.onCountryPressed,
                ),
              ),
              Step(
                title: _title(2, 'Ingresa el valor'),
                content: DocumentValueForm(
                  identificationCard: widget.identificationCard,
                  onChanged: widget.onChanged,
                  document: widget.document,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  AnimatedSize _title(int step, String title) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: _currentStep == step
          ? Text(title, key: Key(step.toString()))
          : const Text(''),
    );
  }

  Expanded _button({
    required Function()? onPressed,
    required IconData icon,
    required String label,
  }) {
    return Expanded(
      child: TextButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
