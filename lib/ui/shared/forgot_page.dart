import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medired/core/router/router.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/shared/custom_flat_button.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key, required this.sizewidth});
  final double sizewidth;
  @override
  State<ForgotPage> createState() => _ForgotState();
}

class _ForgotState extends State<ForgotPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBorder,
        border: Border.all(color: Colors.transparent),
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.width * 0.05),
      ),
      child: Row(
        children: [
          SizedBox(
            width: widget.sizewidth * 0.55,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Restablecer Contraseña',
                    style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: (widget.sizewidth * 0.55) * 0.07,
                        fontWeight: FontWeight.w300,
                        color: AppColors.blueBackground),
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Correo Electrónico',
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(30, 30, 30, 0.7)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: SizedBox(
                          width: (widget.sizewidth * 0.55) * 0.7,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'media@gmail.com',
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(33, 57, 118, 0.4)),
                              alignLabelWithHint: true,
                              filled: true,
                              fillColor: Colors.blueGrey[90],
                              labelStyle: const TextStyle(fontSize: 12),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none, // No border
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none, // No border
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            cursorColor:
                                Colors.blue, // Cambio de color de cursor
                            validator: (value) {
                              value = value!.trim();
                              final emailRegExp = RegExp(
                                  r'''(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])''');
                              if (value.isEmpty) {
                                return 'Rellena este campo';
                              } else if (!emailRegExp.hasMatch(value)) {
                                return 'Correo inválido';
                              } else {
                                return null;
                              }
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿No tienes una cuenta?'),
                      TextButton(
                        onPressed: () => router.push(RoutePath.signUp),
                        child: const Text(
                          'Regístrate aquí',
                          style: TextStyle(
                              color: Color.fromRGBO(95, 125, 201, 1),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomFlatButton(
                    text: 'Continuar',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(SendEmailPasswordReset(
                            email: emailController.text));
                        final snackBar = SnackBar(
                          content: const Text(
                              'Se envió un email para que se pueda cambiar la contraseña'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.only(
                              top: 20,
                              right: 20,
                              left: 20), // Ajuste de posición
                          duration:
                              const Duration(seconds: 4), // Duración visible
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    fontsize: 30,
                    circularradius: 30,
                    textColor: AppColors.whiteBackground,
                    buttonColor: AppColors.blueBackground,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: widget.sizewidth * 0.45,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.015),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.015),
                  child: Image(
                    image: const AssetImage('assets/images/doc2.png'),
                    width: widget.sizewidth * 0.45,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color.fromRGBO(33, 57, 118, 0.88)
                            .withOpacity(0.8),
                        const Color.fromRGBO(95, 125, 201, 0.88)
                            .withOpacity(0.65),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.015),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Bienvenido de vuelta.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: widget.sizewidth * 0.05,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const Image(
                        image: AssetImage('assets/images/logob.png'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
