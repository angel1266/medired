import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reportes_medired/alerts/create_service_alert.dart';
import 'package:reportes_medired/layout_main.dart';
import 'package:reportes_medired/models/especialidades_model.dart';
import 'package:reportes_medired/my_home_page.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reportes_medired/repository/prestador_repository.dart';
import 'package:reportes_medired/validators/emailValidator.dart';
import 'package:reportes_medired/validators/passwordValidator.dart';
import 'package:http/http.dart' as http;
import 'package:reportes_medired/widgets/upload_image.dart';

void main() => runApp(MaterialApp(
      home: ServiceProviderSignUpForm(),
      theme: ThemeData(
        primarySwatch: Colors.red,
        hintColor: Colors.red,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(
              0xFF96A30D), // Color for secondary (used for floating action buttons, selection controls, etc.)
        ),
        highlightColor: const Color(0xFF96A30D),
      ),
    ));

class ServiceProviderSignUpForm extends StatefulWidget {
  final String id;
  ServiceProviderSignUpForm({this.id = ""});
  @override
  _ServiceProviderSignUpFormState createState() =>
      _ServiceProviderSignUpFormState();
}

class _ServiceProviderSignUpFormState extends State<ServiceProviderSignUpForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String _providerName = '';
  String _RNC = '';
  String _phoneNumber = '';
  String _email = '';
  String _password = '';
  List<Map<String, dynamic>> servicios = [];
  List<bool> _selectedSpecializations = List.generate(8, (_) => false);
  List<Map<String, dynamic>> planes = [];
  List<EspecialidadesModel> especialidades = [];
  List<EspecialidadesModel> especialidadesAsig = [];
  PrestadorRepository prestadorRepository = PrestadorRepository();
  final TextEditingController _providerNameController = TextEditingController();
  final TextEditingController _RNCController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _latitudController = TextEditingController();
  final TextEditingController _longitudController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCurrentController =
      TextEditingController();
  String emailCurrent = "";
  String urlImage = "";
  bool create = false;

  String? selectedPlan;
  String? selectedServicio;

  Map<String, bool> _selectedTests = {
    "Cn4By04i9R5h3pnVvETD": false,
    "E6IAL4tpTY0tw0Ayd2Ws": false,
    "RT6ijZLjwI2PJUBVXvyV": false,
    "dJMcwE7v3jmwop4gOgkL": false,
    "khafrdu1XlABE5AZZctF": false,
    "nJjkdHHEc5HGRMPyC1tU": false,
    "tdA9ubpgjjdAQQYP1twX": false,
    "udvAFm25vTRvVGXp5yAt": false,
  };

  final List<String> _specializations = [
    'Ginecología',
    'Medicina Interna',
    'Pediatría',
    'Medicina General',
    'Urología',
    'Oftalmología',
    'Odontología',
    'Audiometría',
  ];

  final Map<String, Map<String, dynamic>> _testsDescriptions = {
    "Cn4By04i9R5h3pnVvETD": {
      "category": 0,
      "description":
          "Una técnica de imagen diagnóstica que utiliza radiación electromagnética para producir imágenes de estructuras internas del cuerpo, comúnmente utilizada para evaluar fracturas óseas y exámenes de tórax.",
      "durationDescription": "5-15 minutos",
      "id": "Cn4By04i9R5h3pnVvETD",
      "name": "Rayos X"
    },
    "E6IAL4tpTY0tw0Ayd2Ws": {
      "category": 2,
      "description":
          "Una prueba realizada en una muestra de orina para verificar varios trastornos, incluyendo infecciones del tracto urinario, enfermedad renal y diabetes.",
      "durationDescription":
          "Variable; la recolección es rápida pero el análisis puede tardar horas hasta un día",
      "id": "E6IAL4tpTY0tw0Ayd2Ws",
      "name": "Análisis de Orina"
    },
    "RT6ijZLjwI2PJUBVXvyV": {
      "category": 0,
      "description":
          "Una técnica de imagen diagnóstica que utiliza ondas sonoras de alta frecuencia para crear imágenes de órganos internos y tejidos, comúnmente utilizada en obstetricia, cardiología y para examinar órganos abdominales.",
      "durationDescription": "15-30 minutos",
      "id": "RT6ijZLjwI2PJUBVXvyV",
      "name": "Sonografía"
    },
    "dJMcwE7v3jmwop4gOgkL": {
      "category": 4,
      "description":
          "Una prueba que mide la actividad eléctrica del corazón y se utiliza para detectar anomalías cardíacas, arritmias y enfermedades del corazón.",
      "durationDescription": "10-15 minutos",
      "id": "dJMcwE7v3jmwop4gOgkL",
      "name": "Electrocardiograma"
    },
    "khafrdu1XlABE5AZZctF": {
      "category": 1,
      "description":
          "Una prueba de sangre que cuenta las células que componen tu sangre: glóbulos rojos, glóbulos blancos y plaquetas.",
      "durationDescription":
          "Variable; la extracción de sangre toma unos minutos",
      "id": "khafrdu1XlABE5AZZctF",
      "name": "Hemograma"
    },
    "nJjkdHHEc5HGRMPyC1tU": {
      "category": 4,
      "description":
          "Una prueba de ultrasonido del corazón que proporciona imágenes en movimiento e información sobre el tamaño, forma y función del corazón.",
      "durationDescription": "30-60 minutos",
      "id": "nJjkdHHEc5HGRMPyC1tU",
      "name": "Eco Cardiaco"
    },
    "tdA9ubpgjjdAQQYP1twX": {
      "category": 1,
      "description":
          "Una prueba de sangre que mide los niveles de lípidos en la sangre, como el colesterol y los triglicéridos, para evaluar el riesgo de enfermedad cardiovascular.",
      "durationDescription":
          "Variable; la extracción de sangre toma unos minutos",
      "id": "tdA9ubpgjjdAQQYP1twX",
      "name": "Perfil Lipídico"
    },
    "udvAFm25vTRvVGXp5yAt": {
      "category": 1,
      "description":
          "Una prueba de sangre para medir los niveles de glucosa (azúcar) en tu sangre, comúnmente utilizada para diagnosticar y monitorear la diabetes.",
      "durationDescription":
          "Variable; la extracción de sangre toma unos minutos",
      "id": "udvAFm25vTRvVGXp5yAt",
      "name": "Glucosa"
    },
  };

  String? _emailError;
  String? _passwordError;

  void _showErrorSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior
          .floating, // Esto hace que la barra no se adhiera al borde inferior
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<List<Map<String, dynamic>>> getServicios(id) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('servicios')
        .where('id_plan', isEqualTo: id)
        .get();

    var data = querySnapshot.docs
        .map((doc) => {
              'id': doc.id,
              'data': doc.data() as Map<String, dynamic>,
            })
        .toList();
    setState(() {
      servicios = data;
    });

    return data;
  }

  getImage(img) {
    setState(() {
      urlImage = img;
    });
  }

  Future<List<EspecialidadesModel>> getEspecialidadesAsig() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('espescialidades_asignadas')
        .where('prestador_id', isEqualTo: widget.id)
        .get();

    especialidadesAsig = querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;

      List<ItemEspecialidadesModel> list = [];

      data["especialidades"].forEach((key, value) {
        list.add(ItemEspecialidadesModel(
            focusNode: FocusNode(),
            name: value[0],
            key: key.toString(),
            descuento: TextEditingController(text: value[1]),
            status: true));
      });
      return EspecialidadesModel(
          id: doc.id,
          id_servicio: data["id_servicio"],
          especialidades: list,
          id_prestador: data["prestador_id"]);
    }).toList();
    setState(() {});

    return especialidadesAsig;
  }

  Future<List<EspecialidadesModel>> getEspecialidades() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('especialidades')
        .where('id_servicio', isEqualTo: selectedServicio)
        .get();
    setState(() {
      if (especialidadesAsig
          .where((element) =>
              element.id_servicio.toString() == selectedServicio.toString())
          .isEmpty) {
        especialidades = querySnapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          List<ItemEspecialidadesModel> list = [];

          data["especialidades"].forEach((key, value) {
            list.add(ItemEspecialidadesModel(
              focusNode: FocusNode(),
                name: value[0],
                key: key.toString(),
                descuento: TextEditingController(text: "0"),
                status: false));
          });
          return EspecialidadesModel(
              id: doc.id, id_servicio: selectedServicio!, especialidades: list);
        }).toList();
      } else {
        var data = querySnapshot.docs[0].data() as Map<String, dynamic>;
        List<ItemEspecialidadesModel> list = [];

        data["especialidades"].forEach((key, value) {
          bool check = especialidadesAsig
              .firstWhere((element) =>
                  element.id_servicio.toString() == selectedServicio.toString())
              .especialidades
              .where((element) => element.name == value[0])
              .isEmpty;
          if (!check) {
            if (especialidadesAsig
                .firstWhere((element) =>
                    element.id_servicio.toString() ==
                    selectedServicio.toString())
                .especialidades
                .where((element) => element.name == value[0])
                .isEmpty) {
              especialidadesAsig
                  .firstWhere((element) =>
                      element.id_servicio.toString() ==
                      selectedServicio.toString())
                  .especialidades
                  .add(ItemEspecialidadesModel(
                    focusNode: FocusNode(),
                      name: value[0],
                      key: key.toString(),
                      descuento: TextEditingController(text: "0"),
                      status: false));
            }
          } else {
            if (especialidadesAsig
                .firstWhere((element) =>
                    element.id_servicio.toString() ==
                    selectedServicio.toString())
                .especialidades
                .where(
                    (element) => element.name.toString() == value[0].toString())
                .isEmpty) {
              especialidadesAsig
                  .firstWhere((element) =>
                      element.id_servicio.toString() ==
                      selectedServicio.toString())
                  .especialidades
                  .add(ItemEspecialidadesModel(
                    focusNode: FocusNode(),
                      name: value[0],
                      key: key.toString(),
                      descuento: TextEditingController(text: "0"),
                      status: false));
            }
          }
        });

        especialidades = especialidadesAsig
            .where((element) =>
                element.id_servicio.toString() == selectedServicio.toString())
            .toList();
      }
    });
    setState(() {});

    return especialidades;
  }

  Future<List<Map<String, dynamic>>> getPlans() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('planes')
        .where('status', isEqualTo: "1")
        .get();
    var data = querySnapshot.docs
        .map((doc) => {
              'id': doc.id,
              'data': doc.data() as Map<String, dynamic>,
            })
        .toList();
    setState(() {
      planes = data;
    });

    return data;
  }

  @override
  void initState() {
    if (widget.id != "") {
      prestadorRepository.loadMemberData(widget.id, context, (data) {
        getEspecialidadesAsig();
        setState(() {
          _providerName = data['companyInfo']['name'] ?? '';
          _RNC = data['companyInfo']['documents'][0]['value'] ?? '';
          _phoneNumber =
              data['companyInfo']['phoneNumber'][0]['phoneNumber'] ?? '';
          _addressController.text =
              data['companyInfo']['address'][0]['direccion'] ?? '';
          _latitudController.text =
              data['companyInfo']['address'][0]['latitude'].toString() ?? '';
          _longitudController.text =
              data['companyInfo']['address'][0]['longitude'].toString() ?? '';

          urlImage = data['authInfo']['photoUrl'] ?? '';
          _email = data['authInfo']['email'] ?? '';
          emailCurrent = data['authInfo']['email'] ?? '';
          _providerNameController.text = _providerName;
          _RNCController.text = _RNC;
          _phoneNumberController.text = _phoneNumber;
          _emailController.text = _email;
          List<int> selectedSpecializations =
              List<int>.from(data['medicalSpecializations']);

          // Marcar las especializaciones seleccionadas en _selectedSpecializations
          for (var index in selectedSpecializations) {
            if (index >= 0 && index < _selectedSpecializations.length) {
              _selectedSpecializations[index] = true;
            }
          }

          // Obtener el mapa de pruebas desde el documento Firestore
          List<Map<String, dynamic>> tests =
              List<Map<String, dynamic>>.from(data['medicalTests']);

          // Recorrer las pruebas del documento
          for (var test in tests) {
            String testId = test['id'];

            // Verificar si el ID de la prueba existe en _selectedTests
            if (_selectedTests.containsKey(testId)) {
              // Marcar la prueba como seleccionada en _selectedTests
              _selectedTests[testId] = true;
            }
          }
        });
      });
    }
    getPlans();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LayoutMain(
      child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxWidth: 600), // Maximum width of the form
                  child: Card(
                    margin: const EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            UploadImageScreen(
                              getUrl: getImage,
                              image: urlImage,
                            ),
                            TextFormField(
                                controller: _providerNameController,
                                decoration: InputDecoration(
                                    labelText:
                                        'Nombre del prestador de servicios',
                                    counterText: '${_providerName.length}/50'),
                                maxLength: 50,
                                validator: (value) =>
                                    value!.isEmpty ? 'Ingrese un nombre' : null,
                                onChanged: (value) {
                                  setState(() {
                                    _providerName = value;
                                  });
                                }),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _RNCController,
                              decoration: InputDecoration(
                                  labelText: 'RNC',
                                  counterText: '${_RNC.length}/9'),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(9)
                              ],
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.length != 9) {
                                  return 'Ingrese un RNC de 9 dígitos';
                                } else if (value
                                    .split('')
                                    .every((char) => char == value[0])) {
                                  return 'No se admite un RNC con numeración consecutiva';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _RNC = value;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _phoneNumberController,
                              decoration: InputDecoration(
                                  labelText: 'Número telefónico',
                                  counterText: '${_phoneNumber.length}/10'),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10)
                              ],
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) => value!.length != 10
                                  ? 'Ingrese un número de 10 dígitos'
                                  : null,
                              onChanged: (value) {
                                setState(() {
                                  _phoneNumber = value;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                  labelText: 'Correo electrónico',
                                  errorText: _emailError),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                var emailValidator =
                                    EmailValidator(email: value);
                                return emailValidator.validateEmail;
                              },
                              onChanged: (value) {
                                var emailValidator =
                                    EmailValidator(email: value);
                                setState(() {
                                  _email = value;
                                  _emailError = emailValidator.validateEmail;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _addressController,
                              decoration: InputDecoration(
                                labelText: 'Dirección',
                              ),
                              validator: (value) => value!.isEmpty
                                  ? "ingrese la dirección"
                                  : null,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _latitudController,
                              decoration: InputDecoration(
                                labelText: 'Latitud',
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? "ingrese la latitud" : null,
                            ),
                            TextFormField(
                              controller: _longitudController,
                              decoration: InputDecoration(
                                labelText: 'Longitud',
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? "ingrese la longitud" : null,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                errorText: _passwordError,
                              ),
                              obscureText: true,
                              validator: (value) => widget.id != ""
                                  ? null
                                  : value!.length < 6
                                      ? 'La contraseña debe tener al menos 6 caracteres'
                                      : null,
                              onChanged: (value) {
                                var passwordValidator =
                                    PasswordValidator(password: value);
                                setState(() {
                                  _password = value;
                                  _passwordError =
                                      passwordValidator.validatePassword;
                                });
                              },
                            ),
                            _passwordController.text == "" || widget.id == ""
                                ? Container()
                                : const SizedBox(height: 10),
                            _passwordController.text == "" || widget.id != ""
                                ? Container()
                                : TextFormField(
                                    controller: _passwordCurrentController,
                                    decoration: InputDecoration(
                                      labelText: 'Contraseña Actual',
                                      errorText: _passwordError,
                                    ),
                                    obscureText: true,
                                    validator: (value) => value!.length < 6
                                        ? 'La contraseña debe tener al menos 6 caracteres'
                                        : null,
                                    onChanged: (value) {
                                      var passwordValidator =
                                          PasswordValidator(password: value);
                                      setState(() {
                                        _password = value;
                                        _passwordError =
                                            passwordValidator.validatePassword;
                                      });
                                    },
                                  ),
                            const SizedBox(height: 20),
                            Container(
                              child: Row(
                                children: [
                                  const Icon(Icons.medical_services),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                      'Servicios (${especialidadesAsig.length})'),
                                  const Spacer(),
                                  MouseRegion(
                                      cursor: WidgetStateMouseCursor.clickable,
                                      child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedPlan = null;
                                              selectedServicio = null;
                                              especialidades = [];
                                              create = true;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.orange),
                                            child: const Center(
                                              child: Row(
                                                children: [
                                                  Icon(Icons.select_all_sharp,
                                                      color: Colors.white),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "Agregar Servicios",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ))),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                              ),
                              onPressed: _submitForm,
                              child: widget.id != ""
                                  ? const Text('Guardar')
                                  : const Text('Registrar'),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.grey, // Background color
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MyHomePage()));
                              },
                              child: const Text('Volver'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          !create
              ? Container()
              : Positioned(
                  right: 0,
                  child: Container(
                    width: 430,
                    height: MediaQuery.of(context).size.height,
                    child: Card(
                        elevation: 2,
                        child: SingleChildScrollView(
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      children: [
                                        const Text("Asignar Servicios"),
                                        const Spacer(),
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          onPressed: () {
                                            setState(() {
                                              create = false;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                width: 1,
                                                color: const Color.fromARGB(
                                                    255, 72, 71, 71))),
                                        child: DropdownButton<String>(
                                          hint: const Text('Planes'),
                                          value: selectedPlan,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedPlan = newValue;
                                              getServicios(newValue);
                                            });
                                          },
                                          items: planes.map((item) {
                                            return DropdownMenuItem<String>(
                                              value: item["id"],
                                              child: Text("Plan " +
                                                  item["data"]["costo"]),
                                            );
                                          }).toList(),
                                          underline: const SizedBox(),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                width: 1,
                                                color: const Color.fromARGB(
                                                    255, 72, 71, 71))),
                                        child: DropdownButton<String>(
                                          hint: const Text(
                                              'Seleccione un servicio'),
                                          value: selectedServicio,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedServicio = newValue;
                                              getEspecialidades();
                                            });
                                          },
                                          items: servicios.map((item) {
                                            return DropdownMenuItem<String>(
                                              value: item["id"],
                                              child:
                                                  Text(item["data"]["nombre"]),
                                            );
                                          }).toList(),
                                          underline: const SizedBox(),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      MouseRegion(
                                          cursor:
                                              WidgetStateMouseCursor.clickable,
                                          child: GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Crear Servicios'),
                                                      content: Container(
                                                        height: 300,
                                                        width: 200,
                                                        child:
                                                            CreateServiceAlert(
                                                          mycontext: context,
                                                          update: getServicios,
                                                          idPlan: selectedPlan!,
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: const Text(
                                                              'Cerrar'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.green),
                                                child: const Center(
                                                  child: Icon(
                                                      Icons.medication_outlined,
                                                      color: Colors.white),
                                                ),
                                              )))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Row(
                                    children: [
                                      Text(
                                        "Especialidades",
                                        style: TextStyle(fontSize: 17),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  especialidades.isEmpty
                                      ? const Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Seleccione un servicio.",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.grey),
                                          ))
                                      : Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          child: ListView.builder(
                                            itemCount: especialidades.length,
                                            itemBuilder: (context, index) {
                                              var especialidadesMap =
                                                  especialidades[index]
                                                      .especialidades;
                                              return Column(
                                                  children: especialidadesMap
                                                      .map<Widget>(
                                                          (ItemEspecialidadesModel
                                                              especialidad) {
                                                return CheckableListTile(
                                                  especialidad: especialidad,
                                                );
                                              }).toList());
                                            },
                                          ),
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 150,
                                    child: MouseRegion(
                                        cursor:
                                            WidgetStateMouseCursor.clickable,
                                        child: GestureDetector(
                                            onTap: () {
                                              if (selectedPlan == null) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    backgroundColor:
                                                        Colors.orange,
                                                    content: Text(
                                                        'Debe Seleccionar un plan'),
                                                  ),
                                                );
                                              } else if (selectedServicio ==
                                                  null) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    backgroundColor:
                                                        Colors.orange,
                                                    content: Text(
                                                        'Debe Seleccionar un Servicio'),
                                                  ),
                                                );
                                              } else if (!especialidades
                                                      .isEmpty &&
                                                  selectedPlan != null &&
                                                  selectedServicio != null) {
                                                especialidades.forEach(
                                                    (EspecialidadesModel esp) {
                                                  if (esp.especialidades
                                                      .where((element) =>
                                                          element.status ==
                                                          true)
                                                      .isEmpty) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        backgroundColor:
                                                            Colors.orange,
                                                        content: Text(
                                                            'Debe Seleccionar por lo menos 1 especialidad'),
                                                      ),
                                                    );
                                                  } else {
                                                    esp.especialidades.forEach(
                                                        (ItemEspecialidadesModel
                                                            esp2) {
                                                      if (esp2.status &&
                                                          (double.parse(esp2
                                                                  .descuento
                                                                  .text) <=
                                                              0)) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            backgroundColor:
                                                                Colors.orange,
                                                            content: Text(
                                                                'Debe Agregar el porcentaje de descuento'),
                                                          ),
                                                        );
                                                      } else {
                                                        if (!especialidadesAsig
                                                            .isEmpty) {
                                                          if (especialidadesAsig
                                                              .where((element) =>
                                                                  element
                                                                      .id_servicio
                                                                      .toString() ==
                                                                  selectedServicio
                                                                      .toString())
                                                              .isEmpty) {
                                                            especialidadesAsig
                                                                .addAll(
                                                                    especialidades);
                                                          } else {
                                                            especialidadesAsig.removeWhere((element) =>
                                                                element
                                                                    .id_servicio
                                                                    .toString() ==
                                                                selectedServicio
                                                                    .toString());
                                                            especialidadesAsig
                                                                .addAll(
                                                                    especialidades);
                                                          }
                                                        } else {
                                                          especialidadesAsig
                                                              .addAll(
                                                                  especialidades);
                                                        }
                                                      }
                                                    });
                                                  }
                                                });
                                              }
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  backgroundColor: Colors.green,
                                                  content: Text(
                                                      'Servicio y especialidades agregadas'),
                                                ),
                                              );
                                              setState(() {});
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.orange),
                                              child: const Center(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                        Icons.save_alt_outlined,
                                                        color: Colors.white),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "Guardar",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ))),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
        ],
      ),
    ));
  }

  List<Widget> _buildSpecializationListTiles(
      List<String> titles, List<bool> values) {
    return List.generate(titles.length, (index) {
      return CheckboxListTile(
        value: values[index],
        title: Text(titles[index]),
        onChanged: (bool? value) {
          setState(() {
            values[index] = value!;
          });
        },
      );
    });
  }

  List<Widget> _buildMedicalTestsListTiles(
      Map<String, Map<String, dynamic>> tests,
      Map<String, bool> selectedTests) {
    return tests.entries.map((entry) {
      return CheckboxListTile(
        value: selectedTests[entry.key],
        title: Text(entry.value['name']),
        subtitle: Text(entry.value['description']),
        onChanged: (bool? value) {
          setState(() {
            selectedTests[entry.key] = value!;
          });
        },
      );
    }).toList();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (especialidadesAsig.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debes asignar servicios y especialidades.'),
          ),
        );
      } else {
        widget.id != ""
            ? updateMemberData(widget.id)
            : copyAndUpdateDocument(_email, _password);
      }
    }
  }

  void registerMember() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference members = firestore.collection('member');

    // Genera un nuevo ID de documento
    DocumentReference newMemberRef = members.doc();

    // Fecha actual para usar en varios campos
    DateTime now = DateTime.now();

    // Crear un nuevo documento con un ID generado aleatoriamente
    await newMemberRef.set({
      'authInfo': {
        'email': _email,
        'isEnabled': true,
        'password': _password,
        'photoUrl': null,
        'providerId': null,
        'uid': newMemberRef.id,
      },
      'companyInfo': {
        'address': [],
        'documents': [
          {
            'country': 59,
            'documentType': 1,
            'expirationDate': now,
            'photos': [],
            'value': _RNC,
          },
        ],
        'language': 0,
        'name': _providerName,
      },
      'phoneNumber': [
        {
          'country': 59,
          'phoneNumber': _phoneNumber,
          'type': 0,
        },
      ],
      'medicalSpecializations': _selectedSpecializations
          .asMap()
          .entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList(),
      'medicalTests': _selectedTests.entries
          .where((entry) => entry.value)
          .map((entry) => {
                'category': _testsDescriptions[entry.key]!['category'],
                'description': _testsDescriptions[entry.key]!['description'],
                'durationDescription':
                    _testsDescriptions[entry.key]!['durationDescription'],
                'id': entry.key,
                'name': _testsDescriptions[entry.key]!['name'],
              })
          .toList(),
      'memberInfo': {
        'memberType': 2,
        'payments': [],
        'sessions': [],
        'subscriptionType': 0,
      },
      'personalInfo': {
        'address': [],
        'birthdate': now,
        'documents': [
          {
            'country': 59,
            'documentType': 0,
            'expirationDate': now,
            'photos': [],
            'value': '',
          },
        ],
      },
      'firstName': '',
      'language': 0,
      'lastName': '',
      'nationality': 59,
      'phoneNumber': [
        {
          'country': 59,
          'phoneNumber': '',
          'type': 0,
        },
      ],
      'sex': 0,
    });

    //print('Member registered with ID: ${newMemberRef.id}');
  }

  void sendEmail(String email, String mensaje) async {
    final to = Uri.encodeComponent(email);
    final subject = Uri.encodeComponent('Bienvenido a Medired');
    final text = Uri.encodeComponent(mensaje);

    final url = Uri.parse(
        'https://us-central1-medired-f442d.cloudfunctions.net/email?to=$to&subject=$subject&text=$text');

    final response = await http.get(url);

    if (response.statusCode == 200) {
    } else {}
  }

  void updateMemberData(String id) async {
    try {
      DocumentReference memberDocRef = _firestore.collection('member').doc(id);

      // Obtener el documento actual
      DocumentSnapshot docSnapshot = await memberDocRef.get();
      Map<String, dynamic> currentData =
          docSnapshot.data() as Map<String, dynamic>;

      // Preparar las actualizaciones
      Map<String, dynamic> updates = {};

      // Actualizar companyInfo
      if (currentData.containsKey('companyInfo')) {
        Map<String, dynamic> companyInfoUpdates = {};

        companyInfoUpdates['name'] = _providerName;

        if (currentData['companyInfo'].containsKey('documents') &&
            currentData['companyInfo']['documents'] is List &&
            currentData['companyInfo']['documents'].isNotEmpty) {
          List<dynamic> documents =
              List.from(currentData['companyInfo']['documents']);
          if (documents[0] is Map<String, dynamic>) {
            documents[0]['value'] = _RNC;
          }
          companyInfoUpdates['documents'] = documents;
        }

        if (currentData['companyInfo'].containsKey('phoneNumber') &&
            currentData['companyInfo']['phoneNumber'] is List &&
            currentData['companyInfo']['phoneNumber'].isNotEmpty) {
          List<dynamic> phoneNumbers =
              List.from(currentData['companyInfo']['phoneNumber']);
          if (phoneNumbers[0] is Map<String, dynamic>) {
            phoneNumbers[0]['phoneNumber'] = _phoneNumber;
          }
          companyInfoUpdates['phoneNumber'] = phoneNumbers;
        }
        companyInfoUpdates['language'] = 0;
        companyInfoUpdates['address'] = [
          {
            'direccion': _addressController.text,
            'latitude': double.parse(_latitudController.text),
            'longitude': double.parse(_longitudController.text),
            'stree': "test",
          }
        ];
        updates['companyInfo'] = companyInfoUpdates;
      }

      await memberDocRef.update(updates);

      if (_passwordController.text != "") {
        // Realizar la actualización

        // Suponemos que el usuario ya ha iniciado sesión
        User? user;
        try {
          print(
              'email: ${emailCurrent} pass: ${_passwordCurrentController.text}');
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailCurrent,
            password: _passwordCurrentController.text,
          );

          user = userCredential.user;
        } catch (e) {
          print('Error al iniciar sesión: $e');
          return;
        }

        if (user != null) {
          // Nuevos datos

          // Actualizar correo electrónico
          await prestadorRepository.actualizarCorreo(
              user, _emailController.text);

          // Actualizar contraseña
          await prestadorRepository.actualizarContrasena(
              user, _passwordController.text);

          await memberDocRef.set({
            'authInfo': {
              'email': _emailController.text,
              'password': _passwordController.text,
              'photoUrl': urlImage,
            }
          }, SetOptions(merge: true));
          print('Para verificar');
        } else {
          print('Entrar');

          print('No hay usuario autenticado.');
        }
      } else {
        await memberDocRef.set({
          'authInfo': {
            'photoUrl': urlImage,
          }
        }, SetOptions(merge: true));
      }

      QuerySnapshot querySnapshot = await _firestore
          .collection('espescialidades_asignadas')
          .where('prestador_id', isEqualTo: widget.id)
          .get();
      List<Map<String, dynamic>> data = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'data': doc.data() as Map<String, dynamic>,
              })
          .toList();
      List<ItemEspecialidadesModel> misEspecialidadesList = [];
      List<EspecialidadesModel> misEspecialidades = [];
      if (data.isNotEmpty) {
        for (var i = 0; i < data.length; i++) {
          data[i]["data"]["especialidades"].forEach((key, value) {
            misEspecialidadesList.add(ItemEspecialidadesModel(
                name: value[0],
                descuento: TextEditingController(text: value[1]),
                focusNode: FocusNode(),
                key: key,
                status: true));
          });
          misEspecialidades.add(EspecialidadesModel(
              especialidades: misEspecialidadesList,
              id: data[i]["id"],
              id_servicio: data[i]["data"]["id_servicio"],
              id_prestador: data[i]["data"]["prestador_id"]));
        }
      }

      especialidadesAsig.forEach((EspecialidadesModel element) async {
        List<ItemEspecialidadesModel> espS = element.especialidades
            .where((element) => element.status == true)
            .toList();

        Map<String, dynamic> espAsig = {
          'prestador_id': widget.id,
          'id_servicio': element.id_servicio,
          'especialidades': {
            for (var i = 0; i < espS.length; i++)
              '${espS[i].key}': ["${espS[i].name}", "${espS[i].descuento.text}"]
          }
        };

        List<EspecialidadesModel> checkData = misEspecialidades
            .where((elemento) =>
                elemento.id_servicio.toString() ==
                element.id_servicio.toString())
            .toList();

        if (checkData.isEmpty) {
          _firestore.collection('espescialidades_asignadas').add(espAsig);
        } else {
          _firestore
              .collection('espescialidades_asignadas')
              .doc(checkData[0].id)
              .set(espAsig);
        }
      });

      _showErrorSnackbar(context, 'Datos actualizados correctamente');
    } catch (e) {
      _showErrorSnackbar(context, 'Error al actualizar los datos: $e');
    }
  }

  Future<void> copyAndUpdateDocument(String email, String password) async {
    DateTime now = DateTime.now();
    // Intentar crear un usuario en FirebaseAuth
    UserCredential userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _showErrorSnackbar(
            context, 'El email ya está en uso. Utiliza uno diferente.');
      } else if (e.code == 'invalid-email') {
        _showErrorSnackbar(context, 'El email es inválido');
      } else {
        _showErrorSnackbar(context, e.code ?? 'Error creando el usuario');
      }
      return;
    }

    // Obtener el documento original
    DocumentReference sourceDocRef =
        _firestore.collection('member').doc('Nv044fsBNjhl6HeBGBqUh7awIRy1');
    DocumentSnapshot snapshot = await sourceDocRef.get();

    if (snapshot.exists) {
      // Copiar los datos y preparar para el nuevo documento
      Map<String, dynamic> originalData =
          snapshot.data() as Map<String, dynamic>;
      String newUserId = userCredential.user!.uid;

      originalData['personalInfo']['birthdate'] = now;

      // Preparar los nuevos datos con el userId
      originalData['authInfo']['uid'] = newUserId;
      originalData['authInfo']['email'] =
          email; // Actualiza el email en caso de que se haya pasado uno nuevo
      originalData['authInfo']['password'] =
          password; // Asegúrate de no almacenar contraseñas en texto plano en la práctica
      originalData['authInfo']['photoUrl'] = urlImage;

      originalData['companyInfo']['name'] = _providerName;
      if (originalData['companyInfo']['documents'] != null &&
          originalData['companyInfo']['documents'].isNotEmpty) {
        originalData['companyInfo']['documents'][0]['value'] = _RNC;
      }

      if (originalData['companyInfo']['phoneNumber'] != null &&
          originalData['companyInfo']['phoneNumber'].isNotEmpty) {
        originalData['companyInfo']['phoneNumber'][0]['phoneNumber'] =
            _phoneNumber;
      }
      originalData['companyInfo']['address'] = [
        {
          'direccion': _addressController.text,
          'latitude': double.parse(_latitudController.text),
          'longitude': double.parse(_longitudController.text),
          'stree': "test",
        }
      ];
      _phoneNumber;

      // Actualizar especializaciones médicas y pruebas

      originalData['medicalSpecializations'] = [0];
      originalData['medicalTests'] = [
        {
          'category': 0,
          'description': "",
          'durationDescription': "5-15 minutos",
          'id': 'Cn4By04i9R5h3pnVvETD',
          'name': "Rayos X"
        }
      ];

      // Crear un nuevo documento en Firestore con el userId como ID del documento

      DocumentReference newDocRef =
          _firestore.collection('member').doc(newUserId);
      await newDocRef.set(originalData);

      especialidadesAsig.forEach((EspecialidadesModel element) {
        List<ItemEspecialidadesModel> espS = element.especialidades
            .where((element) => element.status == true)
            .toList();

        Map<String, dynamic> espAsig = {
          'prestador_id': newUserId,
          'id_servicio': element.id_servicio,
          'especialidades': {
            for (var i = 0; i < espS.length; i++)
              '${espS[i].key}': ["${espS[i].name}", "${espS[i].descuento.text}"]
          }
        };
        _firestore.collection('espescialidades_asignadas').add(espAsig);
      });

      //print('New document created with user ID: $newUserId');
    } else {
      //print("Source document does not exist.");
    }

    String emailHTML = """
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bienvenido a Medired</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      margin: 0;
      padding: 0;
    }
    .container {
      max-width: 600px;
      margin: 20px auto;
      background-color: #ffffff;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    h1 {
      color: #00a859;
    }
    p {
      color: #333333;
      line-height: 1.6;
    }
    .button {
      display: inline-block;
      background-color: #00a859;
      color: #ffffff;
      padding: 10px 20px;
      text-align: center;
      text-decoration: none;
      border-radius: 5px;
      margin-top: 20px;
      font-weight: bold;
    }
    .button:hover {
      background-color: #007d44;
    }
    .footer {
      text-align: center;
      margin-top: 20px;
      color: #777777;
      font-size: 12px;
    }
    .footer a {
      color: #00a859;
      text-decoration: none;
    }
  </style>
</head>
<body>

<div class="container">
  <h1>¡Bienvenido a Medired!</h1>
  <p>Hola $_providerName,</p>
  <p>Nos alegra mucho que te hayas unido a nosotros. A partir de ahora, serás parte de una comunidad que se preocupa por tu bienestar.</p>
  
  <p>Queremos que te sientas cómodo/a y disfrutes de los beneficios que ofrecemos. Si tienes alguna pregunta o necesitas asistencia, no dudes en contactarnos. Estamos aquí para ayudarte.</p>

  <a href="https://medired-f442d.web.app/#/login" class="button">Acceder a mi cuenta</a>

  <p>¡Gracias por confiar en nosotros!</p>

  <p>Saludos cordiales,<br>
  El equipo de Medired</p>

</div>

</body>
</html>

""";

    sendEmail(email, emailHTML);
    setState(() {
      create = false;
    });
    // Mostrar mensaje de éxito
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Éxito"),
          content: const Text("Usuario creado exitosamente."),
          actions: [
            TextButton(
              child: const Text("OK"),
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

class CheckableListTile extends StatefulWidget {
  final ItemEspecialidadesModel especialidad;
  CheckableListTile({required this.especialidad});
  @override
  _CheckableListTileState createState() => _CheckableListTileState();
}

class _CheckableListTileState extends State<CheckableListTile> {
  bool isChecked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Checkbox(
          value: widget.especialidad.status,
          onChanged: (bool? value) {
            setState(() {
              widget.especialidad.status = value ?? false;
            });
          },
        ),
        title: Text(widget.especialidad.name),
        trailing: Container(
          width: 150,
          child: TextField(
            focusNode: widget.especialidad.focusNode,
            controller: widget.especialidad.descuento,
            keyboardType: TextInputType.number,
            enabled: widget.especialidad.status,
            decoration: const InputDecoration(
              hintText: 'Descuento',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
            ),
          ),
        ));
  }
}
