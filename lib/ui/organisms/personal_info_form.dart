import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medired/core/value_objects/country.dart';
import 'package:medired/core/value_objects/document_type.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/authentication/domain/usecases/remote/update_remote_member.dart';
import 'package:medired/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/molecules/custom_text_form_field.dart';

class PersonalInfoForm extends StatefulWidget {
  PersonalInfoForm({
    required this.firstName,
    required this.lastName,
    required this.country,
    required this.documentType,
    required this.documentValue,
    required this.sex,
    required this.firstNameController,
    required this.lastNameController,
    required this.rncController,
    super.key,
  });
  final String? firstName;
  final String? lastName;
  final String? country;
  final String? documentType;
  final String? documentValue;
  final String? sex;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController rncController;

  @override
  State<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  @override
  void initState() {
    super.initState();
    widget.firstNameController.text = widget.firstName ?? '';
    widget.lastNameController.text = widget.lastName ?? '';
    widget.rncController.text = widget.documentValue ?? '';
  }

  @override
  void dispose() {
    widget.firstNameController.dispose();
    widget.lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthenticatedState<Patient>) {
          return Column(
            children: [
              CustomTextFormField(
                'Nombres',
                controller: widget.firstNameController,
                backgroundColor: Colors.black12,
                enabled: true,
                labelStyle: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: AppColors.blueBackground),
                readOnly: false,
                maxLength: 45,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'El campo no puede estar vacío';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                /*onChanged: (value) {
                  setState(() {
                    _actualFirstName = value;
                  });
                },
                suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.save,
                      color: AppColors.blueBackground,
                    ),
                    onPressed: () =>
                        _updateUserInfo(context, isFirstName: true)),*/
              ),
              CustomTextFormField(
                'Apellidos',
                controller: widget.lastNameController,
                backgroundColor: Colors.black12,
                enabled: true,
                labelStyle: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: AppColors.blueBackground),
                readOnly: false,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                ],
                maxLength: 45,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'El campo no puede estar vacío';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                /*onChanged: (value) {
                  setState(() {
                    _actualLastName = value;
                  });
                },
                suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.save,
                      color: AppColors.blueBackground,
                    ),
                    onPressed: () =>
                        _updateUserInfo(context, isFirstName: false)),*/
              ),
              CustomTextFormField(
                'Sexo',
                controller: TextEditingController(text: widget.sex),
                backgroundColor: Colors.black12,
                enabled: false,
                labelStyle: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: AppColors.blueBackground),
              ),
            ],
          );
        } else if (authState is AuthenticatedState<ServiceProvider>) {
          return Column(
            children: [
              CustomTextFormField(
                'RNC',
                controller: widget.rncController,
                backgroundColor: Colors.black12,
                enabled: false,
                labelStyle: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(color: AppColors.blueBackground),
                readOnly: false,
                maxLength: 9,
                validator: (value) {
                  if (value!.length != 9) {
                    return 'El RNC debe tener 9 dígitos';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                autovalidateMode: AutovalidateMode.onUserInteraction,
              )
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
