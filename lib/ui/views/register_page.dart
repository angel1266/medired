import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medired/core/bloc/message/message_bloc.dart';
import 'package:medired/core/router/router.dart';
import 'package:medired/core/utils/responsive.dart';
import 'package:medired/core/value_objects/value_objects_export.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/authentication/presentation/bloc/base_info/base_info_bloc.dart';
import 'package:medired/features/authentication/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:medired/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:medired/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/asset.dart';
import 'package:medired/ui/organisms/ars_sign_up_form.dart';
import 'package:medired/ui/atoms/dropdown.dart';
import 'package:medired/ui/organisms/insurance_broker_sign_up_form.dart';
import 'package:medired/ui/organisms/patient_sign_up_form.dart';
import 'package:medired/ui/organisms/service_provider_sign_up_form.dart';
import 'package:medired/ui/template/register_template.dart';
import 'package:medired/ui/views/payment_subscription_page.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({
    super.key,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  UserType? _selectedUser;
  int typeRegister = 0;
  String nombre = "";
  String apellido = "";
  String telefono = "";
  String correo = "";
  String token_facebook = "";
  String token_google = "";

  @override
  void initState() {
    signOutFacebook();
    super.initState();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<void> saveAccessToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('access_token', token);
}

Future<String?> getAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token');
}

Future<void> clearAccessToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('access_token');
}

  Future<void> signOutFacebook() async {
    Future<void> signOut() async {
      await _firebaseAuth.signOut();

      AccessToken? accessToken = await FacebookAuth.instance.accessToken;
      if (accessToken != null) {
        await FacebookAuth.instance.logOut();
        print('Sesión cerrada exitosamente.');
      } else {
        print(
            'No se encontró un token de acceso. No es necesario cerrar sesión en Facebook.');
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');
    }
  }

  Future<void> signUpWithFacebook() async {
    await Firebase.initializeApp();
      try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;
        if (accessToken != null) {
          await saveAccessToken(accessToken.tokenString);

          final AuthCredential credential = FacebookAuthProvider.credential(accessToken.tokenString);
          UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
          User? user = userCredential.user;

          if (user != null) {
            // Extrae el nombre y el apellido
            final displayName = user.displayName ?? '';
            final nameParts = displayName.split(' ');
            final firstName = nameParts.isNotEmpty ? nameParts.first : '';
            final lastName =
                nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

            // Registra el usuario en Firestore
            

            print('Usuario registrado con éxito: $firstName $lastName');
          } else {
            print('No se pudo obtener la información del usuario.');
          }
        } else {
          print('AccessToken es nulo.');
        }
      } else {
        print('El inicio de sesión con Facebook falló: ${result.status}');
      }
    } catch (e) {
      print('Error durante el inicio de sesión con Facebook: $e');
    }

    final LoginResult result = await FacebookAuth.instance.login();
        if (result.status == LoginStatus.success) {
          final AccessToken accessToken = result.accessToken!;
          final userData = await FacebookAuth.instance.getUserData();
          final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.tokenString);
            final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
            final User? user = userCredential.user;
          // Aquí puedes manejar el registro del usuario con los datos obtenidos de Facebook
          print('User Data: $userData');
          setState(() {
              final displayName = userData["name"] ?? '';
              final nameParts = displayName.split(' ');
              final firstName = nameParts.isNotEmpty ? nameParts.first : '';
              final lastName =
                  nameParts.length > 1 ? nameParts[1] : '';

              
              if (user != null) {
              typeRegister = 1;
              nombre = firstName ?? "";
              apellido = lastName ?? "";
              correo = userData["email"];
              token_facebook = user.uid;
              print("uid "+token_facebook);
            }
              
            });
        } else {
          print('Registration failed: ${result.status}');
        }
  }


  Future<dynamic> signInWithGoogle() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.addScope('https://www.googleapis.com/auth/userinfo.email');
      googleProvider
          .addScope('https://www.googleapis.com/auth/userinfo.profile');
      googleProvider.addScope('https://www.googleapis.com/auth/plus.login');
      googleProvider
          .addScope('https://www.googleapis.com/auth/user.birthday.read');
      googleProvider
          .addScope('https://www.googleapis.com/auth/user.phonenumbers.read');
      googleProvider
          .addScope('https://www.googleapis.com/auth/user.gender.read');
      googleProvider.setCustomParameters({'prompt': 'consent'});

      // Inicia sesión con Google
      GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: <String>[
          'email', // Permiso básico (ya se solicita por defecto)
          'profile', // Permiso para obtener el nombre y la foto de perfil
          'https://www.googleapis.com/auth/contacts.readonly', // Permiso para acceder a los contactos (ejemplo)
          'https://www.googleapis.com/auth/calendar.readonly',
          'https://www.googleapis.com/auth/user.birthday.readonly',
          'https://www.googleapis.com/auth/user.gender.readonly' // Permiso para acceder al calendario (ejemplo)
          // Agrega aquí los permisos adicionales que necesites
        ],
      ).signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Autentica con Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;

      // Verifica si el usuario está autenticado
      if (user != null) {
        print('Nombre del usuario: ${user.displayName}');
        token_google = user.uid;

        // Usa el token de acceso para obtener información del perfil del usuario
        final response = await http.get(
          Uri.parse(
              'https://people.googleapis.com/v1/people/me?personFields=emailAddresses,names,genders,phoneNumbers,birthdays&access_token=${googleAuth?.accessToken}'),
        );

        if (response.statusCode == 200) {
          final profile = json.decode(response.body);
          return profile;
        } else {
          return [];
          print(
              'Error al obtener la información del perfil: ${response.reasonPhrase}');
        }
      } else {
        return [];
        print('No se pudo obtener el usuario.');
      }
    } catch (e) {
      print('Error al iniciar sesión con Google: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return RegisterTemplate(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      imageBackground: Asset.doc3,
      gradientColors: [
        const Color.fromRGBO(33, 57, 118, 0.88).withOpacity(0.9),
        const Color.fromRGBO(95, 125, 201, 0.88).withOpacity(0.75),
      ],
      formChildren: [
        typeRegister != 0
            ? Container()
            : ElevatedButton.icon(
                icon: const Image(
                  image: AssetImage(Asset.facebook),
                  height: 30,
                ),
                onPressed: () {
                  signUpWithFacebook();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.whiteBackground,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                label: const Text('Registro con Facebook'),
              ),
        typeRegister != 0
            ? Container()
            : ElevatedButton.icon(
                icon: const Image(
                  image: AssetImage(Asset.google),
                  height: 30,
                ),
                onPressed: () {
                  signInWithGoogle().then((data) {
                    if (data.length > 0) {
                      setState(() {
                        typeRegister = 2;
                        nombre = data['names']?.first['givenName'] ?? "";
                        apellido = data['names']?.first['familyName'] ?? "";
                        correo = data['emailAddresses']?.first['value'] ?? "";
                        telefono = data['phoneNumbers']?.first['value'] ?? "";
                        print("mi nombree es " + nombre);
                      });
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.whiteBackground,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                label: const Text('Registro con Google'),
              ),
        typeRegister != 0
            ? Container()
            : ElevatedButton.icon(
                icon: Icon(
                  Icons.email,
                  size: 30,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    typeRegister = 3;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.whiteBackground,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                label: const Text('Registro con Email'),
              ),
        typeRegister == 0
            ? Container()
            : Column(
                children: [
                  Text(
                    'Cuéntanos sobre tí \n Me gustaría registrarme como:',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: Colors.white),
                  ),
                  Dropdown<UserType>(
                    options: Map.fromEntries(
                      userTypeToString.entries.where((entry) =>
                          entry.key != UserType.provider &&
                          entry.key != UserType.ars &&
                          entry.key != UserType.broker),
                    ),
                    currentValue: _selectedUser,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedUser = newValue;
                        if (newValue == UserType.patient) {
                          context.read<BaseInfoBloc>().add(
                              UpdatePersonalInfo(PersonalInfo.fromSignUp()));
                        } else if (newValue == UserType.provider) {
                          context
                              .read<BaseInfoBloc>()
                              .add(UpdateCompanyInfo(CompanyInfo.fromSignUp()));
                        } else if (newValue == UserType.ars) {
                          context
                              .read<BaseInfoBloc>()
                              .add(UpdateCompanyInfo(CompanyInfo.fromSignUp()));
                        }
                      });
                    },
                  ),
                  MultiBlocListener(
                    listeners: [
                      BlocListener<SignUpBloc, SignUpState>(
                        listener: _signUpListener,
                      ),
                      BlocListener<SubscriptionBloc, SubscriptionState>(
                        listener: _subscriptionListener,
                      ),
                    ],
                    child: formBuilder(),
                  ),
                ],
              )
      ],
      adChildren: [
        Text(
          'Somos una red de privilegios para cuidar tu salud',
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: Colors.white),
        ),
        const Image(
          image: AssetImage(Asset.logob),
        ),
      ],
    );
  }

  Widget formBuilder() {
    switch (_selectedUser) {
      case UserType.patient:
        return PatientSignUpForm(
          correo: correo,
          nombre: nombre,
          apellido: apellido,
          telefono: telefono,
          token_facebook: token_facebook,
          token_google: token_google,
        );
      case UserType.provider:
        return const ServiceProviderSigUpForm();
      case UserType.ars:
        return const ArsSignUpForm();
      case UserType.broker:
        return const InsurenceBrokerSigUpForm();
      default:
        return const SizedBox.shrink();
    }
  }

  void _signUpListener(BuildContext context, SignUpState state) {
    if (state is SuccessSignUpUser) {
      context.read<ProfileBloc>().add(LoadProfile(auth: state.auth));
      // context.read<SignUpBloc>().add(SendEmailVerification(
      //       firebaseUser: state.firebaseUser,
      //     ));
      if (state.auth is Patient) {
        context.read<SubscriptionBloc>().add(CreateSubscription(
              uid: state.firebaseUser.uid,
            ));
      } else if (state.auth is ServiceProvider) {
        context
            .read<MessageBloc>()
            .add(const DisplayMessage('Se ha creado tu cuenta'));
        router.go(RoutePath.login);
      }
    } else if (state is SuccessSendEmailVerification) {
      context.read<MessageBloc>().add(const DisplayMessage(
          'Se ha enviado un correo electrónico de verificación'));
      // router.go(RoutePath.login);
    } else if (state is ErrorSignUp) {
      context.read<MessageBloc>().add(DisplayMessage(state.error));
    }
  }

  void _subscriptionListener(
      BuildContext context, SubscriptionState state) async {
    if (state is SuccessCreateSubscription) {
      var patient =
          (context.read<ProfileBloc>().state as ProfileLoaded<Patient>).user;
      log('👤👤👤👤👤👤👤 ${patient.runtimeType}');
      await showAdaptiveSheet(
          context: context,
          body: PaymentSubscriptionPage(auth: patient),
          bottomSheetHeight: 0.8);
      if (!context.mounted) return;
      context.read<AuthBloc>().add(LoginMember(
            email: patient.authInfo.email!,
            password: patient.authInfo.password,
          ));
    } else if (state is ErrorSubscriptionState) {
      context.read<MessageBloc>().add(DisplayMessage(state.message));
    }
  }
}
