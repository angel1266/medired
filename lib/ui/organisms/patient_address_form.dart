import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/molecules/custom_text_form_field.dart';
import 'package:side_sheet/side_sheet.dart';

class PatientAddressForm extends StatefulWidget {
  const PatientAddressForm({super.key});

  @override
  State<PatientAddressForm> createState() => _PatientAddressFormState();
}

class _PatientAddressFormState extends State<PatientAddressForm> {
  TextEditingController mapPlaceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CustomTextFormField(
            'Provincia',
            labelStyle: TextStyle(
              color: AppColors.blueBackground,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: Colors.black12,
          ),
          const CustomTextFormField(
            'Ciudad',
            labelStyle: TextStyle(
              color: AppColors.blueBackground,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: Colors.black12,
          ),
          const CustomTextFormField(
            'Calle',
            labelStyle: TextStyle(
              color: AppColors.blueBackground,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: Colors.black12,
          ),
          const CustomTextFormField(
            'Notas',
            labelStyle: TextStyle(
              color: AppColors.blueBackground,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: Colors.black12,
          ),
          CustomTextFormField(
            'MapPlace',
            labelStyle: const TextStyle(
              color: AppColors.blueBackground,
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: Colors.black12,
            readOnly: true,
            controller: mapPlaceController,
            onTap: () {
              SideSheet.right(
                body: FlutterLocationPicker(
                  onPicked: (ubicacion) {
                    mapPlaceController.text = ubicacion.address;
                    Navigator.pop(context);
                  },
                  trackMyPosition: true,
                ),
                context: context,
              );
            },
          ),
        ],
      ),
    );
  }
}
