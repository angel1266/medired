import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/ui_helper.dart';

class SheetsPhone extends StatefulWidget {
  const SheetsPhone({super.key});

  @override
  State<SheetsPhone> createState() => _SheetsPhoneState();
}

class _SheetsPhoneState extends State<SheetsPhone> {
  List<String> phones = ['Teléfono 1', 'Teléfono 2', 'Teléfono 3'];
  TextEditingController newPhoneController = TextEditingController();
  TextEditingController editPhoneController = TextEditingController();

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
            'Lista de Teléfonos',
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
              'Agregar Nuevo',
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
              _showAddPhoneDialog(context);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: phones.length,
              padding: const EdgeInsets.all(0),
              itemBuilder: (context, index) {
                final phone = phones[index];
                return Dismissible(
                  key: Key(phone),
                  confirmDismiss: (direction) async {
                    return await _showConfirmDeleteDialog(context, phone);
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      phones.removeAt(index);
                    });
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          _showEditPhoneDialog(context, phone, index);
                        },
                        child: const Icon(
                          Icons.edit,
                          color: AppColors.blueBackground,
                        ),
                      ),
                      dense: false,
                      title: Text(
                        phone,
                        textAlign: TextAlign.left,
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

  void _showAddPhoneDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar Nuevo Teléfono'),
          content: TextField(
            controller: newPhoneController,
            decoration: const InputDecoration(labelText: 'Número de Teléfono'),
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
                setState(() {
                  phones.add(newPhoneController.text);
                  newPhoneController.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showConfirmDeleteDialog(
      BuildContext context, String phone) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text(
              '¿Estás seguro de que quieres eliminar este teléfono?'),
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

  void _showEditPhoneDialog(BuildContext context, String phone, int index) {
    editPhoneController.text = phone;
    int editPhoneIndex = index;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Teléfono'),
          content: TextField(
            controller: editPhoneController,
            decoration: const InputDecoration(labelText: 'Número de Teléfono'),
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
                setState(() {
                  phones[editPhoneIndex] = editPhoneController.text;
                  editPhoneController.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
