import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medired/core/value_objects/country.dart';
import 'package:medired/features/authentication/domain/entities/patient.dart';
import 'package:medired/features/authentication/domain/entities/phone_number.dart';
import 'package:medired/features/authentication/presentation/bloc/auth/auth_bloc.dart';
import 'package:medired/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/molecules/custom_text_form_field.dart';
import 'package:medired/ui/organisms/address_picker.dart';
import 'package:side_sheet/side_sheet.dart';

class PatientUpdateInfoForm extends StatelessWidget {
  const PatientUpdateInfoForm({
    super.key,
    required this.email,
    required this.nationality,
    required this.address,
    required this.phoneNumber,
    required this.documentValue,
    required this.birthday,
    required this.phoneNumberController,
  });

  final String? email;
  final String? nationality;
  final String? address;
  final String? phoneNumber;
  final String? documentValue;
  final String? birthday;
  final TextEditingController phoneNumberController;

  static const inputLabelStyle = TextStyle(
    color: AppColors.blueBackground,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          'Correo electrónico',
          controller: TextEditingController(text: email),
          readOnly: true,
          enabled: false,
          labelStyle: inputLabelStyle,
        ),
        CustomTextFormField(
          'Nacionalidad',
          controller: TextEditingController(text: nationality),
          labelStyle: inputLabelStyle,
          readOnly: true,
          enabled: false,
          onTap: () {
            // SideSheet.right(
            //   body: CountryForm(onPressed: (country) {
            //     nacionalidadController.text = '${countryToString[country]}';
            //   }),
            //   context: context,
            // );
          },
        ),
        CustomTextFormField(
          'Documento',
          controller: TextEditingController(text: documentValue),
          labelStyle: inputLabelStyle,
          readOnly: true,
          enabled: false,
        ),
        CustomTextFormField(
          'Fecha de nacimiento',
          controller: TextEditingController(text: birthday),
          labelStyle: inputLabelStyle,
          readOnly: true,
          enabled: false,
        ),
        /*CustomTextFormField(
          'Dirección',
          controller: TextEditingController(text: address),
          labelStyle: inputLabelStyle,
          readOnly: true,
          // suffixIcon: IconButton(
          //   icon: const Icon(
          //     Icons.edit,
          //     color: AppColors.blueBackground,
          //   ),
          //   onPressed: () => SideSheet.right(
          //     body: const AddressPicker(),
          //     context: context,
          //   ),
          // ),
        ),*/
        CustomTextFormField(
          'Teléfono móvil',
          controller: phoneNumberController,
          labelStyle: inputLabelStyle,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 10,
          enabled: true,
          readOnly: false,
          validator: (value) {
            if (value!.length != 10) {
              return 'El número telefónico debe tener 10 dígitos';
            }
            return null;
          },
        ),
      ],
    );
  }
}
