import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reportes_medired/my_home_page.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:reportes_medired/validators/emailValidator.dart';
import 'package:reportes_medired/validators/passwordValidator.dart';

class ServiceProviderEditForm extends StatefulWidget {
  final String id;

  ServiceProviderEditForm({required this.id});

  @override
  _ServiceProviderEditFormState createState() =>
      _ServiceProviderEditFormState();
}

class _ServiceProviderEditFormState extends State<ServiceProviderEditForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String _providerName = '';
  String _RNC = '';
  String _phoneNumber = '';
  String _email = '';
  final String _password = '';
  final TextEditingController _providerNameController = TextEditingController();
  final TextEditingController _RNCController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final List<bool> _selectedSpecializations = List.generate(8, (_) => false);
  final Map<String, bool> _selectedTests = {
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

  Future<void> _loadMemberData(String id) async {
    DocumentSnapshot memberDoc =
        await _firestore.collection('member').doc(id).get();

    if (memberDoc.exists) {
      Map<String, dynamic> data = memberDoc.data() as Map<String, dynamic>;

      setState(() {
        _providerName = data['companyInfo']['name'] ?? '';
        _RNC = data['companyInfo']['documents'][0]['value'] ?? '';
        _phoneNumber =
            data['companyInfo']['phoneNumber'][0]['phoneNumber'] ?? '';
        _email = data['authInfo']['email'] ?? '';
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
    } else {
      _showErrorSnackbar(context, 'Documento no encontrado');
    }
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
        companyInfoUpdates['address'] = [];
        updates['companyInfo'] = companyInfoUpdates;
      }



      // Realizar la actualización
      await memberDocRef.update(updates);

      _showErrorSnackbar(context, 'Datos actualizados correctamente');
    } catch (e) {
      _showErrorSnackbar(context, 'Error al actualizar los datos: $e');
    }
  }

  String? _emailError;

  @override
  void initState() {
    super.initState();
    
  }

  @override
  void dispose() {
    _providerNameController.dispose();
    _RNCController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior
          .floating, // Esto hace que la barra no se adhiera al borde inferior
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar de Prestador de Servicios')),
      body: Center(
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
                        TextFormField(
                            controller: _providerNameController,
                            decoration: InputDecoration(
                              labelText: 'Nombre del prestador de servicios',
                              counterText: '${_providerName.length}/50',
                            ),
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => value!.length != 9
                              ? 'Ingrese un RNC de 9 dígitos'
                              : null,
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          readOnly: true,
                          enabled: false,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            var emailValidator = EmailValidator(email: value);
                            return emailValidator.validateEmail;
                          },
                          onChanged: (value) {
                            var emailValidator = EmailValidator(email: value);
                            setState(() {
                              _email = value;
                              _emailError = emailValidator.validateEmail;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        ExpansionTile(
                          title: const Text('Especialidades'),
                          leading: const Icon(Icons.medical_services),
                          children: _buildSpecializationListTiles(
                              _specializations, _selectedSpecializations),
                        ),
                        ExpansionTile(
                          title: const Text('Pruebas'),
                          leading: const Icon(Icons.science),
                          children: _buildMedicalTestsListTiles(
                              _testsDescriptions, _selectedTests),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: _submitForm,
                          child: const Text('Guardar cambios'),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey, // Background color
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
    );
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
      updateMemberData(widget.id);
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
      } else {
        _showErrorSnackbar(context, e.message ?? 'Error creando el usuario');
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

      originalData['companyInfo']['name'] = _providerName;
      if (originalData['companyInfo']['documents'] != null &&
          originalData['companyInfo']['documents'].isNotEmpty) {
        originalData['companyInfo']['documents'][0]['value'] = _RNC;
      }

      if (originalData['phoneNumber'] != null &&
          originalData['phoneNumber'].isNotEmpty) {
        originalData['phoneNumber'][0]['phoneNumber'] = _phoneNumber;
      }

      // Actualizar especializaciones médicas y pruebas
      List<int> specializationIndices = _selectedSpecializations
          .asMap()
          .entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      List<Map<String, dynamic>> selectedMedicalTests = _selectedTests.entries
          .where((entry) => entry.value)
          .map((entry) => {
                'category': _testsDescriptions[entry.key]!['category'],
                'description': _testsDescriptions[entry.key]!['description'],
                'durationDescription':
                    _testsDescriptions[entry.key]!['durationDescription'],
                'id': entry.key,
                'name': _testsDescriptions[entry.key]!['name'],
              })
          .toList();

      originalData['medicalSpecializations'] = specializationIndices;
      originalData['medicalTests'] = selectedMedicalTests;

      // Crear un nuevo documento en Firestore con el userId como ID del documento
      DocumentReference newDocRef =
          _firestore.collection('member').doc(newUserId);
      await newDocRef.set(originalData);
      print('New document created with user ID: $newUserId');
    } else {
      print("Source document does not exist.");
    }

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
