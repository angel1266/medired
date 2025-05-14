import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medired/core/value_objects/country.dart';
import 'package:medired/core/value_objects/document_type.dart';
import 'package:medired/core/value_objects/subscription_type.dart';
import 'package:medired/core/value_objects/user_sex.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:medired/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/molecules/profile_picture.dart';
import 'package:medired/ui/organisms/company_update_info_form.dart';
import 'package:medired/ui/organisms/patient_update_info_form.dart';
import 'package:medired/ui/organisms/personal_info_form.dart';
import 'package:medired/ui/organisms/subscription_info.dart';
import 'package:medired/ui/template/profile_template.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:medired/core/database/collections.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController rncController = TextEditingController();
  late TextEditingController phoneNumberController = TextEditingController();
  List<SuscripcionModel> suscripcion = [];

  Future getDocs() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('servicios').get();

    List<QueryDocumentSnapshot> documentos = querySnapshot.docs;
    documentos.sort((a, b) => a['nombre'].compareTo(b['nombre']));

    List<dynamic> list = [];

    for (var doc in documentos) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      list.add([data['nombre'], doc.id]);
    }

    return list;
  }

  Future<List<dynamic>> getDocss(String table, String field, dynamic filter,
      {String tipo = "servicio", fecha = false, bool igual = true}) async {
    final QuerySnapshot? querySnapshot;

    if (fecha) {
      querySnapshot = await FirebaseFirestore.instance
          .collection(table)
          .where(field, isGreaterThan: filter)
          .get();
    } else {
      if (igual) {
        querySnapshot = await FirebaseFirestore.instance
            .collection(table)
            .where(field, isEqualTo: filter)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection(table)
            .where(field, isNotEqualTo: filter)
            .get();
      }
    }

    List<QueryDocumentSnapshot> documentos = querySnapshot.docs;
    if (tipo == "servicio") {
      documentos.sort((a, b) => a['nombre'].compareTo(b['nombre']));
    } else if (tipo == "miembros") {
      documentos.sort((a, b) => a['personalInfo']["firstName"]
          .compareTo(b['personalInfo']["firstName"]));
    }

    List<dynamic> list = [];

    for (var doc in documentos) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      list.add([data, doc.id]);
    }
    return list;
  }

  Future<void> _fetchSuscripcion() async {
    try {
      List<dynamic> fetchedData = await getDocss(
          'subscription', 'setDate', Timestamp.now(),
          tipo: "suscripcion", fecha: true);

      setState(() {
        suscripcion = fetchedData.map((entry) {
          return SuscripcionModel(
              id: entry[1], uid: entry[0]["uid"], setDate: entry[0]["setDate"]);
        }).toList();
      });
      print("tienes " + suscripcion.length.toString());
    } catch (e) {
      debugPrint('Error prestador fetching data: $e');
    }
  }

  @override
  void initState() {
    _fetchSuscripcion();
    super.initState();
    var state = context.read<AuthBloc>().state;
    if (state is AuthenticatedState) {
      context.read<ProfileBloc>().add(LoadProfile(auth: state.user));
      context
          .read<SubscriptionBloc>()
          .add(StartListeningSubscription(uid: state.user.authInfo.uid!));
      context
          .read<SubscriptionBloc>()
          .add(ListenSubscription(uid: state.user.authInfo.uid!));
      context
          .read<SubscriptionBloc>()
          .add(GetSubscription(uid: state.user.authInfo.uid!));

      // Inicializar el controlador RNC si el usuario es un ServiceProvider
      if (state.user is ServiceProvider) {
        rncController.text = (state.user as ServiceProvider)
                .companyInfo
                .documents
                .isNotEmpty
            ? (state.user as ServiceProvider).companyInfo.documents[0].value ??
                ''
            : '';
      }
    }
  }

  String getInitials(String? name, String? id) {
    if (name == null || name.isEmpty) {
      return '';
    }
    return name
            .split(' ')
            .map((word) => word.isNotEmpty ? word[0] : "")
            .join() +
        (id!.substring(id.length - 4));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) =>
              (previous is AuthenticatedState &&
                      current is AuthenticatedState) &&
                  (previous.user != current.user) ||
              (previous is LoadingAuthState && current is AuthenticatedState),
          listener: _authListener,
        ),
        BlocListener<SubscriptionBloc, SubscriptionState>(
          listener: _subscriptionListener,
        )
      ],
      child: Container(
        margin: EdgeInsets.only(top: 20),
        child: ProfileTemplate(
          profilePicture: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              String names = (state is ProfileLoaded<Patient>)
                  ? getInitials(state.user.personalInfo.firstName,
                      state.user.authInfo.uid)
                  : "";

              print("es paciente " +
                  (state is ProfileLoaded<Patient>).toString());
              return ProfilePicture(
                suscripcion: suscripcion,
                membresia: '$names',
                paciente: (state is ProfileLoaded<Patient>) ? state.user : null,
                isLoading: state is ProfileLoading,
                photoUrl: (state is ProfileLoaded)
                    ? state.user.authInfo.photoUrl
                    : null,
                onPhotoChanged: (state is ProfileLoaded<Patient>)
                    ? state.user.memberInfo.memberType.toString == "2"
                        ? null
                        : (state is ProfileLoaded)
                            ? (imageBytes) => context.read<ProfileBloc>().add(
                                  UpdateProfilePhoto(
                                    uid: state.user.authInfo.uid!,
                                    imageBytes: imageBytes,
                                  ),
                                )
                            : null
                    : null,
              );
            },
          ),
          tarjeta: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded && state.user is Patient) {
                var uid = "";
                var names = "";

                if ((state.user as Patient).points == 0) {
                  names = '';
                  uid = '';
                } else {
                   names = getInitials((state.user as Patient).personalInfo.firstName,(state.user as Patient).authInfo.uid);
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
                    builder: (context, subscriptionState) {
                      var user = state.user;
                      return ElevatedButton(
                        onPressed: subscriptionState is SuccessGetSubscription
                            ? () async {
                                var servicios = await getDocs();
                                
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return MembershipCard(
                                          expirationDate: subscriptionState
                                              .subscription.setDate,
                                          membershipCode: '$names',
                                          medicalConsultation: subscriptionState
                                              .subscription.medicalConsultation,
                                          medicalImage: subscriptionState
                                              .subscription.medicalImage,
                                          medicalTest: subscriptionState
                                              .subscription.medicalTest,
                                          points: (user as Patient).points,
                                          servicios: servicios);
                                    },
                                  );
                                
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: AppColors
                              .greenBackground, // Establece el color de fondo a blanco
                          elevation: 5, // Añade una pequeña sombra de elevación
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: (state is ProfileLoaded<Patient>)
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '$names',
                                    style: const TextStyle(
                                        fontSize: 28,
                                        fontFamily: 'Outfit',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),

                                  SizedBox(
                                    width: ((MediaQuery.of(context).size.width *
                                                0.55) *
                                            0.65) *
                                        0.01,
                                  ), // Agrega una pequeña separación horizontal
                                  const Image(
                                    image:
                                        AssetImage('assets/images/logop.png'),
                                    //    height:
                                    //        24, // Ajusta la altura de la imagen según tus necesidades
                                  ),
                                ],
                              )
                            : const Row(),
                      );
                    },
                  ),
                ); // Puedes cambiar 'Número de membresía' por el valor que desees
              }
              return const SizedBox.shrink();
            },
          ),
          editableInfoForm: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                AuthInfo authInfo = state.user.authInfo;
                PersonalInfo? personalInfo;
                Address? address;
                Document? document;
                PhoneNumber? phoneNumber;
                if (state.user is Patient) {
                  personalInfo = (state.user as Patient).personalInfo;
                  address = personalInfo.address.isNotEmpty
                      ? personalInfo.address.first
                      : null;

                  phoneNumber = personalInfo.phoneNumber.isNotEmpty
                      ? personalInfo.phoneNumber.first
                      : null;

                  document = personalInfo.documents.isNotEmpty
                      ? personalInfo.documents.first
                      : null;
                  phoneNumberController.text = (state.user as Patient)
                      .personalInfo
                      .phoneNumber
                      .first
                      .phoneNumber;
                  return Column(
                    children: [
                      PatientUpdateInfoForm(
                        email: authInfo.email,
                        nationality: document != null
                            ? countryToString[document.country]
                            : null,
                        address:
                            '${address?.notes ?? ''} ${address?.street ?? ''} ${address?.region ?? ''} ${address?.city ?? ''} ${address?.country ?? ''}',
                        phoneNumber: phoneNumber?.phoneNumber,
                        documentValue: document?.value,
                        birthday: DateFormat('dd/MM/yyyy')
                            .format(personalInfo.birthdate),
                        phoneNumberController: phoneNumberController,
                      ),
                      const SizedBox(
                          height:
                              20), // Espaciado entre el formulario y el botón
                      ElevatedButton(
                        onPressed: () {
                          if (state.user is Patient &&
                              firstNameController.text.isNotEmpty &&
                              lastNameController.text.isNotEmpty) {
                            if (phoneNumberController.text.length != 10) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Corrige el número telefónico')));
                            } else {
                              var newuser = (state.user as Patient).copyWith(
                                  personalInfo: (state.user as Patient)
                                      .personalInfo
                                      .copyWith(
                                          firstName: firstNameController.text,
                                          lastName: lastNameController.text,
                                          phoneNumber: [
                                    PhoneNumber(
                                        type: 0,
                                        phoneNumber: phoneNumberController.text,
                                        country: Country.DO)
                                  ]));
                              context
                                  .read<ProfileBloc>()
                                  .add(UpdateUserInfo(newUser: newuser));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Datos actualizados correctamente')));
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 40),
                          backgroundColor: AppColors.greenBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Guardar Cambios',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  );
                } else if (state.user is ServiceProvider || state.user is ARS) {
                  CompanyInfo? companyInfo;
                  PhoneNumber? companyPhoneNumber;
                  Address? companyAddress;
                  if (state.user is ServiceProvider) {
                    personalInfo = (state.user as ServiceProvider).personalInfo;
                    companyInfo = (state.user as ServiceProvider).companyInfo;
                  } else {
                    companyInfo = (state.user as ARS).companyInfo;
                  }
                  companyPhoneNumber = companyInfo.phoneNumber.isNotEmpty
                      ? companyInfo.phoneNumber.first
                      : null;
                  companyAddress = companyInfo.address.isNotEmpty
                      ? companyInfo.address.first
                      : null;
                  firstNameController.text = companyInfo.name;
                  phoneNumberController.text =
                      companyInfo.phoneNumber.isNotEmpty
                          ? companyInfo.phoneNumber.first.phoneNumber
                          : '';
                  return Column(
                    children: [
                      CompanyUpdateInfoForm(
                        email: authInfo.email,
                        companyName: companyInfo.name,
                        address:
                            '${companyAddress?.notes ?? ''} ${companyAddress?.street ?? ''} ${companyAddress?.region ?? ''} ${companyAddress?.city ?? ''} ${companyAddress?.country ?? ''}',
                        phoneNumber: companyPhoneNumber?.phoneNumber,
                        nameController: firstNameController,
                        phoneNumberController: phoneNumberController,
                      ),
                      const SizedBox(height: 20),
                      /*ElevatedButton(
                        onPressed: () {
                          if (state.user is ServiceProvider &&
                              phoneNumberController.text.isNotEmpty &&
                              firstNameController.text.isNotEmpty &&
                              rncController.text.isNotEmpty) {
                            if (phoneNumberController.text.length != 10) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Corrige el número de teléfono')));
                            } else if (rncController.text.length != 9) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Corrige el RNC')));
                            } else {
                              var newUser = (state.user as ServiceProvider)
                                  .copyWith(
                                      companyInfo: (state.user as ServiceProvider)
                                          .companyInfo
                                          .copyWith(
                                              name: firstNameController.text,
                                              phoneNumber: [
                                    PhoneNumber(
                                        type: 0,
                                        phoneNumber: phoneNumberController.text,
                                        country: Country.DO)
                                  ],
                                              documents: [
                                    Document(
                                        value: rncController.text,
                                        country: Country.DO,
                                        documentType: DocumentType.rnc,
                                        expirationDate: DateTime.now())
                                  ]));
                              context
                                  .read<ProfileBloc>()
                                  .add(UpdateUserInfo(newUser: newUser));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Datos actualizados correctamente')));
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 40),
                          backgroundColor: AppColors.greenBackground,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Guardar Cambios',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    */
                    ],
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
          personalInfoForm: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              var documentValue = '';
              if (state is ProfileLoaded) {
                PersonalInfo? personalInfo;
                Document? document;
                if (state.user is Patient) {
                  personalInfo = (state.user as Patient).personalInfo;
                  documentValue = document?.value ?? '';
                } else if (state.user is ServiceProvider) {
                  personalInfo = (state.user as ServiceProvider).personalInfo;
                  documentValue = (state.user as ServiceProvider)
                      .companyInfo
                      .documents[0]
                      .value;
                  rncController.text =
                      documentValue; // Actualizar el controlador aquí
                  document = personalInfo.documents.isNotEmpty
                      ? personalInfo.documents.first
                      : null;
                } else if (state.user is ARS) {
                  return const SizedBox.shrink();
                }
                return PersonalInfoForm(
                  firstName: personalInfo?.firstName,
                  lastName: personalInfo?.lastName,
                  documentType:
                      '${document != null ? documentTypeToString[document.documentType] : ''}',
                  country:
                      '${document != null ? countryToEmoji[document.country] : ''}',
                  documentValue: documentValue,
                  sex: sexToString[personalInfo?.sex],
                  firstNameController: firstNameController,
                  lastNameController: lastNameController,
                  rncController: rncController,
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  void _authListener(BuildContext context, AuthState state) {
    if (state is AuthenticatedState) {
      context.read<ProfileBloc>().add(LoadProfile(auth: state.user));
      context
          .read<SubscriptionBloc>()
          .add(StartListeningSubscription(uid: state.user.authInfo.uid!));
      context
          .read<SubscriptionBloc>()
          .add(GetSubscription(uid: state.user.authInfo.uid!));
    }
  }

  void _subscriptionListener(BuildContext context, SubscriptionState state) {
    if (state is SuccessGetSubscription) {
      var profileState = context.read<ProfileBloc>().state;
      if (profileState is ProfileLoaded<Patient>) {
        context.read<ProfileBloc>().add(LoadProfile(
              auth: profileState.user.copyWith(
                memberInfo: profileState.user.memberInfo.copyWith(
                  subscriptionType: state.subscription.subscriptionType,
                ),
              ),
            ));
      }
    } else if (state is SuccessListenSubscription) {
      var profileState = context.read<ProfileBloc>().state;
      if (profileState is ProfileLoaded<Patient>) {
        context.read<ProfileBloc>().add(LoadProfile(
              auth: profileState.user.copyWith(
                memberInfo: profileState.user.memberInfo.copyWith(
                  subscriptionType: state.subscription.subscriptionType,
                ),
              ),
            ));
      }
    }
  }
}
