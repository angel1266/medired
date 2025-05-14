import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medired/core/utils/responsive.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/authentication/presentation/bloc/auth_info/auth_info_bloc.dart';
import 'package:medired/features/authentication/presentation/bloc/base_info/base_info_bloc.dart';
import 'package:medired/features/authentication/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:medired/ui/constants/app_styles.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/atoms/accept_terms_button.dart';
import 'package:medired/ui/molecules/custom_dropdown_field.dart';
import 'package:medired/ui/molecules/custom_dropdown_field_sex.dart';
import 'package:medired/ui/molecules/custom_password_form_field.dart';
import 'package:medired/ui/molecules/custom_text_form_field.dart';
import 'package:medired/ui/molecules/have_an_account_button.dart';
import 'package:medired/ui/molecules/identification_card.dart';
import 'package:medired/ui/organisms/country_form.dart';
import 'package:medired/ui/organisms/identification_form.dart';
import 'package:http/http.dart' as http;

import '../../core/value_objects/value_objects_export.dart';

class PatientSignUpForm extends StatefulWidget {
  const PatientSignUpForm({
    super.key,
    required this.correo,
    required this.apellido,
    required this.nombre,
    required this.telefono,
    required this.token_facebook,
    required this.token_google,
  });
  final String nombre;
  final String apellido;
  final String correo;
  final String token_facebook;
  final String token_google;
  final String telefono;
  @override
  State<PatientSignUpForm> createState() => _PatientSignUpFormState();
}

class _PatientSignUpFormState extends State<PatientSignUpForm> {
  int _currentStep = 0;
  bool _termsAccepted = false;

  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  String createdViewId = 'map_element';

  late TextEditingController _birthdateController;

  @override
  void initState() {
    super.initState();
    _birthdateController = TextEditingController(
      text: _dateFormat.format(PersonalInfo.fromSignUp().birthdate),
    );
  }

  @override
  void dispose() {
    _birthdateController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Stepper(
      physics: const NeverScrollableScrollPhysics(),
      type: StepperType.vertical,
      currentStep: _currentStep,
      onStepContinue: () {
        if (_currentStep < 1) {
          setState(() {
            _currentStep++;
          });
        }
      },
      onStepCancel: () {
        if (_currentStep > 0) {
          setState(() {
            _currentStep--;
          });
        }
      },
      steps: [
        Step(
          title: const Text(
            'Datos personales',
            style: AppStyles.input,
          ),
          content: firstStep(context),
        ),
        Step(
          title:  Text(
           widget.correo.isEmpty ?  'Datos de Usuario' : 'Términos y Condiciones',
            style: AppStyles.input,
          ),
          content: secondStep(),
        ),
      ],
      controlsBuilder: (context, details) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(
              builder: (context) {
                final baseInfoState = context.watch<BaseInfoBloc>().state;

                final authInfoState = context.watch<AuthInfoBloc>().state;

                if (details.stepIndex == 1 &&
                    baseInfoState is LoadedPersonalInfo &&
                    authInfoState is LoadedAuthInfo) {
                  return Expanded(
                    child: ElevatedButton(
                      // onPressed: () async {
                      //   await showAdaptiveSheet(
                      //       context: context,
                      //       body: PaymentSubscriptionPage(
                      //           auth: Patient(
                      //               arsuid: '',
                      //               company: '',
                      //               contractNumber: '',
                      //               memberInfo: const MemberInfo(
                      //                   memberType: UserType.patient,
                      //                   subscriptionType: SubscriptionType.none,
                      //                   payments: [],
                      //                   sessions: []),
                      //               personalInfo: baseInfoState.baseInfo,
                      //               authInfo: authInfoState.authInfo.copyWith(
                      //                   uid: 'cf8eDRkvi2bTJN3vwNOmlW1f1au2'))),
                      //       bottomSheetHeight: 0.8);
                      // },
                      onPressed: baseInfoState.isValid &&
                              authInfoState.isValid &&
                              _termsAccepted
                          ? () {
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
                                  <p>Hola ${'${baseInfoState.baseInfo.firstName} ${baseInfoState.baseInfo.lastName}'},</p>
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

                              sendEmail(
                                  authInfoState.authInfo.email!, emailHTML);
                              context
                                  .read<SignUpBloc>()
                                  .add(SignUpUser<Patient>(
                                    email: authInfoState.authInfo.email!,
                                    password: authInfoState.authInfo.password,
                                    auth: Patient.fromSignUp(
                                        authInfo: authInfoState.authInfo,
                                        personalInfo: baseInfoState.baseInfo,
                                        arsuid: '',
                                        company: '',
                                        contractNumber: ''),
                                  ));
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Comprar membresía'),
                    ),
                  );
                }
                return Expanded(
                  child: ElevatedButton(
                    onPressed: baseInfoState.isValid && _selectedSex
                        ? details.onStepContinue
                        : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Continuar'),
                  ),
                );
              },
            ),
            if (details.stepIndex != 0) ...[
              const SizedBox(width: 8),
              Expanded(
                child: TextButton(
                  onPressed: details.onStepCancel,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Atrás'),
                ),
              ),
            ]
          ],
        );
      },
    );
  }

  bool _selectedSex = false;
  bool _showSexError = false;

  Widget firstStep(BuildContext context) =>
      BlocBuilder<BaseInfoBloc, BaseInfoState>(
        builder: (context, state) {
          if (state is LoadedPersonalInfo) {
            var baseInfo = state.baseInfo;
            if (widget.correo.isNotEmpty) {
              context.read<BaseInfoBloc>().add(UpdatePersonalInfo(
                  baseInfo.copyWith(
                      lastName: widget.apellido,
                      firstName: widget.nombre,
                      token_facebook: widget.token_facebook,
                      token_google: widget.token_google)));
                      print("el correo no esta vacio "+widget.correo);
            } 

            print("mi nombre es " + baseInfo.toString());

            return Column(
              children: [
                widget.nombre.isEmpty
                    ? CustomTextFormField(
                        'Nombres',
                        initialValue: baseInfo.firstName,
                        // controller: firstName,
                        hintText: 'Maria',
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) {
                          context.read<BaseInfoBloc>().add(UpdatePersonalInfo(
                              baseInfo.copyWith(firstName: value)));
                          print(value);
                        },
                        validator: (value) =>
                            baseInfo.validateValue(baseInfo.firstName),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))
                        ],
                        // onChanged: (value) => ,
                      )
                    : Container(),
                widget.apellido.isEmpty
                    ? CustomTextFormField(
                        'Apellidos',
                        // controller: lastName,
                        initialValue: baseInfo.lastName,
                        hintText: 'Vargas',
                        keyboardType: TextInputType.name,

                        textCapitalization: TextCapitalization.words,
                        onChanged: (value) => context.read<BaseInfoBloc>().add(
                            UpdatePersonalInfo(
                                baseInfo.copyWith(lastName: value))),
                        validator: (value) =>
                            baseInfo.validateValue(baseInfo.lastName),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))
                        ],
                      )
                    : Container(),
                widget.telefono.isNotEmpty
                    ? Container()
                    : CustomTextFormField(
                        'Teléfono',
                        // controller: phoneNumber,
                        initialValue: baseInfo.phoneNumber.first.phoneNumber,
                        hintText: '(849)-555-9911',
                        keyboardType: TextInputType.phone,

                        onChanged: (value) => context.read<BaseInfoBloc>().add(
                                UpdatePersonalInfo(baseInfo.copyWith(
                                    phoneNumber: [
                                  baseInfo.phoneNumber.first
                                      .copyWith(phoneNumber: value)
                                ]))),

                        validator: (value) =>
                            baseInfo.phoneNumber.first.validateAll,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                CustomTextFormField(
                  'Fecha de nacimiento',
                  hintText: '30/12/2004',
                  controller: _birthdateController,
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.date_range,
                      color: AppColors.blueBackground,
                    ),
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: baseInfo.birthdate,
                        firstDate: DateTime(1900),
                        lastDate: PersonalInfo.fromSignUp().birthdate,
                        currentDate: PersonalInfo.fromSignUp().birthdate,
                        initialDatePickerMode: DatePickerMode.year,
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                      ).then((value) {
                        if (!context.mounted) return;
                        if (value != null) {
                          context.read<BaseInfoBloc>().add(UpdatePersonalInfo(
                              baseInfo.copyWith(birthdate: value)));
                        }
                        setState(() {
                          _birthdateController.text =
                              _dateFormat.format(value!);
                        });
                      });
                    },
                  ),
                ),
                CustomDropdownFormFieldSex<Sex>('Sexo',
                    currentValue: null,
                    onChanged: (newValue) {
                      Sex? sex = newValue;
                      context
                          .read<BaseInfoBloc>()
                          .add(UpdatePersonalInfo(baseInfo.copyWith(sex: sex)));
                      setState(() {
                        _selectedSex = true;
                        _showSexError = false;
                      });
                    },
                    options: sexToString,
                    validator: (value) {
                      if (_showSexError && value == null) {
                        return 'Seleccione su sexo';
                      }
                      return null;
                    }),
                CustomTextFormField(
                  'Documento',
                  controller: TextEditingController(
                      text: baseInfo.documents.first.value),
                  hintText: '',
                  keyboardType: TextInputType.phone,
                  readOnly: true,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.badge,
                      color: AppColors.blueBackground,
                    ),
                    onPressed: () => _onDocumentPressed(context),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          }
          return const SizedBox();
        },
      );

  void _onDocumentPressed(BuildContext context) async {
    if (!_selectedSex) {
      setState(() {
        _showSexError = true; // Mostrar el mensaje de error
      });
      return; // Salir del método si el sexo no ha sido seleccionado
    }

    await showAdaptiveSheet(
      context: context,
      bottomSheetHeight: 0.8,
      body: BlocProvider.value(
        value: context.read<BaseInfoBloc>(),
        child: BlocBuilder<BaseInfoBloc, BaseInfoState>(
          builder: (contexts, state) {
            if (state is LoadedPersonalInfo) {
              var baseInfo = state.baseInfo;
              return _identificationForm(baseInfo, context);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  IdentificationForm _identificationForm(
      PersonalInfo baseInfo, BuildContext context) {
    return IdentificationForm(
      document: baseInfo.documents.first,
      onDocumentChanged: (newValue) => context.read<BaseInfoBloc>().add(
              UpdatePersonalInfo(baseInfo.copyWith(documents: [
            baseInfo.documents.first.copyWith(documentType: newValue, value: '')
          ]))),
      onCountryPressed: () async {
        await showAdaptiveSheet(
            context: context,
            bottomSheetHeight: 0.8,
            body: CountryForm(
              onPressed: (country) => context
                  .read<BaseInfoBloc>()
                  .add(UpdatePersonalInfo(baseInfo.copyWith(
                    documents: [
                      baseInfo.documents.first.copyWith(country: country)
                    ],
                    nationality: country,
                  ))),
            ));
      },
      onChanged: (value) => context.read<BaseInfoBloc>().add(UpdatePersonalInfo(
          baseInfo.copyWith(
              documents: [baseInfo.documents.first.copyWith(value: value)]))),
      identificationCard: IdentificationCard(
        birthdate: baseInfo.birthdate,
        country: baseInfo.documents.first.country,
        documentType: baseInfo.documents.first.documentType,
        documentValue: baseInfo.documents.first.formatValue(),
        firstName: baseInfo.firstName,
        lastName: baseInfo.lastName,
        sex: baseInfo.sex,
      ),
    );
  }

  Widget secondStep() => BlocBuilder<AuthInfoBloc, AuthInfoState>(
        builder: (context, state) {
          var authInfo = state.authInfo;
          if (widget.correo.isNotEmpty) {
            context.read<AuthInfoBloc>().add(UpdateAuthInfo(authInfo.copyWith(
                email: widget.correo,
                password: widget.token_facebook != ""
                    ? widget.token_facebook
                    : widget.token_google)));
          }
          return Column(
            children: [
              widget.correo.isNotEmpty
                  ? Container()
                  : CustomTextFormField(
                      'Correo electrónico',
                      initialValue: authInfo.email,
                      hintText: 'maria@medired.com',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => context
                          .read<AuthInfoBloc>()
                          .add(UpdateAuthInfo(authInfo.copyWith(email: value))),
                      validator: (value) => state.authInfo.validateEmail,
                    ),
              widget.correo.isNotEmpty
                  ? Container()
                  : CustomPasswordFormField(
                      'Contraseña',
                      initialValue: authInfo.password,
                      hintText: '',
                      onChanged: (value) => context.read<AuthInfoBloc>().add(
                          UpdateAuthInfo(authInfo.copyWith(password: value))),
                      validator: (value) => state.authInfo.validatePassword,
                    ),
              const SizedBox(height: 20),

              /*Container(
                child: HtmlElementView(
                  viewType: createdViewId,
                ),
              ),*/
              AcceptTermsButton(
                isAccepted: _termsAccepted,
                onChanged: (value) {
                  setState(() {
                    _termsAccepted = value ?? false;
                  });
                },
              ),
              const HaveAnAccountButton()
            ],
          );
        },
      );
}
