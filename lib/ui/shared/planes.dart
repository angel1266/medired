import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/app_styles.dart';
import 'package:medired/ui/molecules/custom_text_form_field.dart';
import 'package:medired/ui/shared/alert_helper.dart';
import 'package:medired/ui/shared/table_membresia.dart';

class PlanesView extends StatefulWidget {
  const PlanesView({
    super.key,
  });

  @override
  State<PlanesView> createState() => _PlanesViewState();
}

class _PlanesViewState extends State<PlanesView> {
  final _formKey = GlobalKey<FormState>();
  late bool isExpanded;
  final planNameController = TextEditingController();
  final planCostController = TextEditingController();
  final planConsultasController = TextEditingController();
  final planLaboratoriosController = TextEditingController();
  final planImagenesController = TextEditingController();
  final planAudiometriaController = TextEditingController();
  final planOdontologiaController = TextEditingController();

  @override
  void initState() {
    isExpanded = false; // Inicializar la expansión como cerrada
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded; // Cambiar el valor de expansión
            });
          },
          child: Text(
            isExpanded ? 'Contraer' : 'Desplegar',
            style: const TextStyle(color: Colors.blue),
          ),
        ),
        const SizedBox(height: 10),
        ExpansionPanelList(
          elevation: 1,
          expandedHeaderPadding: EdgeInsets.zero,
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              this.isExpanded = !isExpanded; // Usar el controlador separado
            });
          },
          children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return const ListTile(
                  title: Text('Crear Plan'),
                );
              },
              body: PlanFormWidget(
                formKey: _formKey,
                planNameController: planNameController,
                planCostController: planCostController,
                planConsultasController: planConsultasController,
                planLaboratoriosController: planLaboratoriosController,
                planImagenesController: planImagenesController,
                planAudiometriaController: planAudiometriaController,
                planOdontologiaController: planOdontologiaController,
              ),
              isExpanded: isExpanded,
            ),
          ],
        ),
        const SizedBox(height: 10),
        const PlanListWidget()
      ],
    );
  }
}

class CustomCheckboxListTile extends StatefulWidget {
  const CustomCheckboxListTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  State<CustomCheckboxListTile> createState() => _CustomCheckboxListTileState();
}

class _CustomCheckboxListTileState extends State<CustomCheckboxListTile> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(widget.title),
      value: widget.value,
      onChanged: (bool? value) {
        if (value != null) {
          widget.onChanged(value);
          setState(() {});
        }
      },
    );
  }
}

class PlanListWidget extends StatelessWidget {
  const PlanListWidget({super.key});

  Future<void> deletePlanInFirebase(
      String documentId, BuildContext context) async {
    final collectionReference =
        firestore.FirebaseFirestore.instance.collection('planes');
    try {
      await collectionReference.doc(documentId).delete();
      // Operación exitosa
      AlertHelper().show('Plan eliminado exitosamente.', context);
    } catch (e) {
      // Manejar errores
      AlertHelper().show('Error al eliminar el plan: $e', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: firestore.FirebaseFirestore.instance.collection('planes').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Text('Error al obtener los datos');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Text('No hay planes disponibles');
        }

        return Column(
          children: [
            const Text('Planes Disponibles'),
            ...snapshot.data!.docs.map((document) {
              return ListTile(
                title: Text(document['name']),
                subtitle: Text('Costo: ${document['costo']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // Abre el formulario de edición con los datos del plan seleccionado
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _buildPlanDetailsDialog(context, document);
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deletePlanInFirebase(document.id, context);
                        // Implementa la lógica para eliminar el plan
                      },
                    ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Widget _buildPlanDetailsDialog(
      BuildContext context, QueryDocumentSnapshot<Object?> document) {
    return AlertDialog(
      title: const Text('Detalles del Plan'),
      content: SingleChildScrollView(
        child: PlanFormWidget(
          formKey: GlobalKey<FormState>(),
          planNameController: TextEditingController(),
          planCostController: TextEditingController(),
          planConsultasController: TextEditingController(),
          planLaboratoriosController: TextEditingController(),
          planImagenesController: TextEditingController(),
          planAudiometriaController: TextEditingController(),
          planOdontologiaController: TextEditingController(),
          initialData: {
            'id': document.id,
            'name': document['name'],
            'costo': document['costo'],
            'consultas': document['consultas'],
            'laboratorios': document['laboratorios'],
            'imagenes': document['imagenes'],
            'audiometria': document['audiometria'],
            'odontologia': document['odontologia'],
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}

class PlanFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController planNameController;
  final TextEditingController planCostController;
  final TextEditingController planConsultasController;
  final TextEditingController planLaboratoriosController;
  final TextEditingController planImagenesController;
  final TextEditingController planAudiometriaController;
  final TextEditingController planOdontologiaController;

  final Map<String, dynamic>? initialData;

  const PlanFormWidget({
    super.key,
    required this.formKey,
    required this.planNameController,
    required this.planCostController,
    required this.planConsultasController,
    required this.planLaboratoriosController,
    required this.planImagenesController,
    required this.planAudiometriaController,
    required this.planOdontologiaController,
    this.initialData,
  });

  @override
  State<PlanFormWidget> createState() => _PlanFormWidgetState();
}

class _PlanFormWidgetState extends State<PlanFormWidget> {
  Future<void> _uploadPlansToFirebase(List<Plan> plans) async {
    final collectionReference =
        firestore.FirebaseFirestore.instance.collection('planes');
    try {
      for (var plan in plans) {
        await collectionReference.add({
          'name': plan.name,
          'costo': plan.costo,
          'consultas': plan.consultas,
          'laboratorios': plan.laboratorios,
          'imagenes': plan.imagenes,
          'audiometria': plan.audiometria,
          'odontologia': plan.odontologia,
        });
      }
      // Operación exitosa
      AlertHelper().show('Planes subidos exitosamente.', context);
      setState(() {});
    } catch (e) {
      // Manejar errores
      AlertHelper().show('Error al subir los planes', context);
    }
  }

  Future<void> updatePlanInFirebase(String documentId) async {
    final collectionReference =
        firestore.FirebaseFirestore.instance.collection('planes');
    try {
      await collectionReference.doc(documentId).update({
        'name': widget.planNameController.text,
        'costo': widget.planCostController.text,
        'consultas': int.parse(widget.planConsultasController.text),
        'laboratorios': int.parse(widget.planLaboratoriosController.text),
        'imagenes': int.parse(widget.planImagenesController.text),
        'audiometria': int.parse(widget.planAudiometriaController.text),
        'odontologia': int.parse(widget.planOdontologiaController.text),
      });
      // Operación exitosa
      AlertHelper().show('Plan actualizado exitosamente.', context);
      Navigator.pop(context);
    } catch (e) {
      // Manejar errores
      AlertHelper().show('Error al actualizar el plan', context);
    }
  }

  // ... (el resto del código de la clase _PlanFormWidgetState)

  @override
  void initState() {
    widget.planNameController.text =
        widget.initialData?['name']!.toString() ?? '';

    widget.planCostController.text =
        widget.initialData?['costo']?.toString() ?? '';
    widget.planConsultasController.text =
        widget.initialData?['consultas']?.toString() ?? '';
    widget.planLaboratoriosController.text =
        widget.initialData?['laboratorios']?.toString() ?? '';
    widget.planImagenesController.text =
        widget.initialData?['imagenes']?.toString() ?? '';
    widget.planAudiometriaController.text =
        widget.initialData?['audiometria']?.toString() ?? '';
    widget.planOdontologiaController.text =
        widget.initialData?['odontologia']?.toString() ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormField(
                'Nombre del plan',
                backgroundColor: AppColors.blueBackground,
                labelStyle: const TextStyle(color: AppColors.blueBackground),
                hintstyle: AppStyles.input,
                textstyle: AppStyles.input,
                hintText: 'Ingrese el nombre del plan',
                controller: widget.planNameController,
                //  initialValue: initialName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre del plan es obligatorio';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                'Costo del plan',
                hintText: 'Ingrese el costo del plan',
                backgroundColor: AppColors.blueBackground,
                labelStyle: const TextStyle(color: AppColors.blueBackground),
                hintstyle: AppStyles.input,
                textstyle: AppStyles.input,
                keyboardType: TextInputType.number,
                controller: widget.planCostController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El costo del plan es obligatorio';
                  }
                  try {
                    double.parse(value);
                  } catch (e) {
                    return 'El costo del plan debe ser un número válido';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                'Consultas',
                hintText: 'Ingrese el número de consultas',
                keyboardType: TextInputType.number,
                backgroundColor: AppColors.blueBackground,
                labelStyle: const TextStyle(color: AppColors.blueBackground),
                hintstyle: AppStyles.input,
                textstyle: AppStyles.input,
                controller: widget.planConsultasController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El número de consultas es obligatorio';
                  }
                  try {
                    int.parse(value);
                  } catch (e) {
                    return 'El número de consultas debe ser un número válido';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                'Laboratorios',
                hintText: 'Ingrese el número de laboratorios',
                keyboardType: TextInputType.number,
                backgroundColor: AppColors.blueBackground,
                labelStyle: const TextStyle(color: AppColors.blueBackground),
                hintstyle: AppStyles.input,
                textstyle: AppStyles.input,
                controller: widget.planLaboratoriosController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El número de laboratorios es obligatorio';
                  }
                  try {
                    int.parse(value);
                  } catch (e) {
                    return 'El número de laboratorios debe ser un número válido';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                'Imagenes',
                hintText: 'Ingrese el número de imagenes',
                keyboardType: TextInputType.number,
                backgroundColor: AppColors.blueBackground,
                labelStyle: const TextStyle(color: AppColors.blueBackground),
                hintstyle: AppStyles.input,
                textstyle: AppStyles.input,
                controller: widget.planImagenesController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El número de imagenes es obligatorio';
                  }
                  try {
                    int.parse(value);
                  } catch (e) {
                    return 'El número de imagenes debe ser un número válido';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                'Audiometria',
                hintText: 'Ingrese el número de audiometria',
                keyboardType: TextInputType.number,
                backgroundColor: AppColors.blueBackground,
                labelStyle: const TextStyle(color: AppColors.blueBackground),
                hintstyle: AppStyles.input,
                textstyle: AppStyles.input,
                controller: widget.planAudiometriaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El número de audiometria es obligatorio';
                  }
                  try {
                    int.parse(value);
                  } catch (e) {
                    return 'El número de audiometria debe ser un número válido';
                  }
                  return null;
                },
              ),
              CustomTextFormField(
                'Odontologia',
                hintText: 'Ingrese el número de odontologia',
                keyboardType: TextInputType.number,
                backgroundColor: AppColors.blueBackground,
                labelStyle: const TextStyle(color: AppColors.blueBackground),
                hintstyle: AppStyles.input,
                textstyle: AppStyles.input,
                controller: widget.planOdontologiaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El número de odontologia es obligatorio';
                  }
                  try {
                    int.parse(value);
                  } catch (e) {
                    return 'El número de odontologia debe ser un número válido';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (widget.formKey.currentState!.validate()) {
                      if (widget.initialData == null) {
                        // Crear un nuevo plan
                        var plan = Plan(
                          name: widget.planNameController.text,
                          costo: widget.planCostController.text,
                          consultas:
                              int.parse(widget.planConsultasController.text),
                          laboratorios:
                              int.parse(widget.planLaboratoriosController.text),
                          imagenes:
                              int.parse(widget.planImagenesController.text),
                          audiometria:
                              int.parse(widget.planAudiometriaController.text),
                          odontologia:
                              int.parse(widget.planOdontologiaController.text),
                        );
                        await _uploadPlansToFirebase([plan]);
                      } else {
                        // Actualizar el plan existente
                        await updatePlanInFirebase(widget.initialData!['id']);
                      }
                      // Realiza la acción deseada
                      // ...
                    }
                  },
                  child: Text(widget.initialData != null
                      ? 'Actualizar plan'
                      : 'Crear plan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
