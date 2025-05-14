import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medired/core/value_objects/country.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/authentication/presentation/bloc/auth/auth_bloc.dart';
import 'package:medired/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/molecules/custom_text_form_field.dart';
import 'package:medired/ui/organisms/address_picker.dart';
import 'package:side_sheet/side_sheet.dart';

class CompanyUpdateInfoForm extends StatelessWidget {
  const CompanyUpdateInfoForm({
    super.key,
    required this.email,
    required this.companyName,
    required this.address,
    required this.phoneNumber,
    required this.nameController,
    required this.phoneNumberController,
  });

  final String? email;
  final String? companyName;
  final String? address;
  final String? phoneNumber;
  final TextEditingController nameController;
  final TextEditingController phoneNumberController;

  static const inputLabelStyle = TextStyle(
    color: AppColors.blueBackground,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CustomTextFormField(
        'Correo electrónico',
        controller: TextEditingController(text: email),
        readOnly: true,
        enabled: false,
        labelStyle: inputLabelStyle,
      ),
      BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        return CustomTextFormField(
          'Nombre de la empresa',
          controller: nameController,
          labelStyle: inputLabelStyle,
          readOnly: false,
          enabled: (state is ProfileLoaded<Patient>)
              ? state.user.memberInfo.memberType.toString == "2"
                  ? false
                  : true
              : false,
          maxLength: 60,
          validator: (value) {
            if (value!.isEmpty) {
              return 'El campo no puede estar vacío';
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        );
      }),
      /*CustomTextFormField(
          'Dirección',
          controller: TextEditingController(text: address),
          labelStyle: inputLabelStyle,
          readOnly: true,
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.edit,
              color: AppColors.blueBackground,
            ),
            onPressed: () => SideSheet.right(
              body: const AddressPicker(),
              context: context,
            ),
          ),
        ),*/
      BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        return CustomTextFormField('Teléfono móvil',
            controller: phoneNumberController,
            labelStyle: inputLabelStyle,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            maxLength: 10,
            enabled: (state is ProfileLoaded<Patient>)
                ? state.user.memberInfo.memberType.toString == "2"
                    ? false
                    : true
                : false,
            readOnly: false, validator: (value) {
          if (value!.length != 10) {
            return 'El número telefónico debe tener 10 dígitos';
          }
          return '';
        });
      }),
    ]);
  }
}
