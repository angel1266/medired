import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/organisms/patient_address_form.dart';
import 'package:side_sheet/side_sheet.dart';

class AddressPicker extends StatelessWidget {
  const AddressPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lista de Direcciones',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: AppColors.blueBackground,
                fontSize: 30,
              ),
            ),
            TextButton(
              onPressed: () {
                SideSheet.right(
                body: const PatientAddressForm(),
                context: context,
              );
              },
              child: const Text(
                'Agregar Dirreción',
                style: TextStyle(fontSize: 20),
              ),
            ),
            /*Esto es sólo para mostrar una previsualización,
            debe ser quitado cuando el código para enumerar
            las direcciones del paciente sea añadido*/
            selectableAddress()
          ],
        ),
      ),
    );
  }

  Widget selectableAddress() {
    return const Placeholder();
  }
}
