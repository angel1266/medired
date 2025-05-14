import 'package:flutter/material.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/ui_helper.dart';

class SheetsAddress extends StatefulWidget {
  const SheetsAddress({super.key});

  @override
  State<SheetsAddress> createState() => _SheetsAddressState();
}

class _SheetsAddressState extends State<SheetsAddress> {
  TextEditingController provinceController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool device = context.screenType() == ScreenType.desktop;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(top: device ? 70 : 46),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Lista de Direcciones',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: device ? (width * 0.56) * 0.06 : (width) * 0.06,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: AppColors.blueBackground,
            ),
          ),
          ListTile(
            dense: false,
            title: Text(
              'Agregar Nueva Dirección',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: device ? (width * 0.56) * 0.03 : (width) * 0.04,
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
                color: AppColors.blueBackground,
              ),
            ),
            leading: const Icon(
              Icons.add,
              color: AppColors.greenBackground,
            ),
            onTap: () {
              _showAddAddressDialog(context);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 0,
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, index) {
                var address = const Address(
                  country: 59,
                  region: 'region',
                  city: 'city',
                  street: 'street',
                  zip: 'zip',
                );
                return Dismissible(
                  key: const Key(''),
                  confirmDismiss: (direction) async {
                    return await _showConfirmDeleteDialog(context, address);
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {},
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          _showEditAddressDialog(context, address, index);
                        },
                        child: const Icon(
                          Icons.edit,
                          color: AppColors.blueBackground,
                        ),
                      ),
                      dense: false,
                      title: Text(
                        'Provincia: ${address.region}\nCiudad: ${address.city}',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize:
                              device ? (width * 0.56) * 0.025 : (width) * 0.025,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0,
                          color: AppColors.blueBackground,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Nueva Dirección'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: provinceController,
                decoration: const InputDecoration(labelText: 'Provincia'),
              ),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'Ciudad'),
              ),
              TextField(
                controller: streetController,
                decoration: const InputDecoration(labelText: 'Calle'),
              ),
              TextField(
                controller: postalCodeController,
                decoration: const InputDecoration(labelText: 'Código Postal'),
              ),
              TextField(
                controller: locationController,
                decoration:
                    const InputDecoration(labelText: 'Ubicación en el Mapa'),
              ),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notas'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Agregar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showConfirmDeleteDialog(
      BuildContext context, Address address) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text(
              '¿Estás seguro de que quieres eliminar esta dirección?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditAddressDialog(
      BuildContext context, Address address, int index) {
    provinceController.text = address.region;
    cityController.text = address.city;
    streetController.text = address.street;
    postalCodeController.text = address.zip;
    locationController.text = '${address.latitude}, ${address.longitude}';
    notesController.text = address.notes;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Dirección'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: provinceController,
                decoration: const InputDecoration(labelText: 'Provincia'),
              ),
              TextField(
                controller: cityController,
                decoration: const InputDecoration(labelText: 'Ciudad'),
              ),
              TextField(
                controller: streetController,
                decoration: const InputDecoration(labelText: 'Calle'),
              ),
              TextField(
                controller: postalCodeController,
                decoration: const InputDecoration(labelText: 'Código Postal'),
              ),
              TextField(
                controller: locationController,
                decoration:
                    const InputDecoration(labelText: 'Ubicación en el Mapa'),
              ),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notas'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
