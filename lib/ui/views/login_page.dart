import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:medired/core/bloc/message/message_bloc.dart';
import 'package:medired/core/router/router.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/authentication/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/app_styles.dart';
import 'package:medired/ui/constants/asset.dart';
import 'package:medired/ui/molecules/custom_password_form_field.dart';
import 'package:medired/ui/molecules/custom_text_form_field.dart';
import 'package:medired/ui/molecules/custom_password_form_field_withSubmitAction.dart';
import 'package:medired/ui/molecules/custom_text_form_field_withSubmitAction.dart';
import 'package:medired/ui/template/register_template.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: _listener,
          listenWhen: (previous, current) =>
              previous is LoadingAuthState &&
              (current is ErrorAuthState ||
                  current is ErrorEmailUnverifiedState ||
                  current is AuthenticatedState),
        ),
      ],
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return RegisterTemplate(
            backgroundColor: AppColors.lightBorder,
            imageBackground: Asset.doc2,
            gradientColors: [
              const Color.fromRGBO(33, 57, 118, 0.88).withOpacity(0.8),
              const Color.fromRGBO(95, 125, 201, 0.88).withOpacity(0.65),
            ],
            formChildren: [
              Text(
                'Ingresar',
                style: Theme.of(context).textTheme.headlineMedium!,
              ),
              ElevatedButton.icon(
                icon: const Image(
                  image: AssetImage(Asset.facebook),
                  height: 30,
                ),
                onPressed: () => context.read<AuthBloc>().add(const LoginWithFacebook()),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.disabled)) {
                        return Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.12); // Default disabled color
                      }
                      return Colors
                          .white; // Use the color for the enabled state
                    },
                  ),
                  minimumSize:
                      WidgetStateProperty.all(const Size(double.infinity, 50)),
                ),
                label: const Text('Login con Facebook'),
              ),
              ElevatedButton.icon(
                icon: const Image(
                  image: AssetImage(Asset.google),
                  height: 30,
                ),
                onPressed: () =>
                    context.read<AuthBloc>().add(const LoginWithGoogle()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.whiteBackground,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                label: const Text('Login con Google'),
              ),
              CustomTextFormFieldWithSubmitAction(
                'Correo electrónico',
                labelStyle:
                    AppStyles.input.copyWith(color: AppColors.blueBackground),
                controller: email,
                hintText: 'maria@medired.com',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa el correo';
                  }
                  return null;
                },
              ),
              CustomPasswordFormFieldWithSubmitAction(
                'Contraseña',
                onChanged: null,
                textStyle:
                    AppStyles.input.copyWith(color: AppColors.blueBackground),
                controller: password,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa la contraseña';
                  }
                  return null;
                },
                onFieldSubmitted: (value) {
                  context.read<AuthBloc>().add(LoginMember(
                        email: email.text.trim(),
                        password: password.text.trim(),
                      ));
                },
              ),
              ElevatedButton(
                onPressed: () => context.read<AuthBloc>().add(LoginMember(
                    email: email.text.trim(), password: password.text.trim())),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blueBackground,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Iniciar sesión',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿No tienes una cuenta?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
              TextButton(
                onPressed: () => router.push(RoutePath.forgotPassword),
                child: const Text(
                  '¿Olvidaste tu contraseña?',
                  style: TextStyle(
                      color: Color.fromRGBO(95, 125, 201, 1),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
            adChildren: [
              Text(
                'Bienvenido de vuelta',
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
        },
      ),
    );
  }

  void _listener(BuildContext context, AuthState state) {
    if (state is ErrorEmailUnverifiedState) {
      context.read<MessageBloc>().add(DisplayMessage(
            state.message,
            action: MapEntry(
                'Reenviar correo',
                () => context
                    .read<SignUpBloc>()
                    .add(SendEmailVerification(firebaseUser: state.user))),
          ));
    } else if (state is ErrorMessageAuthState) {
      context.read<MessageBloc>().add(DisplayMessage(state.message));
    } else if (state is AuthenticatedState) {
      context.go(RoutePath.profile);
    }
  }
}
