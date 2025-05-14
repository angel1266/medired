import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medired/core/router/router.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/app_styles.dart';
import 'package:medired/ui/constants/asset.dart';
import 'package:medired/ui/molecules/custom_password_form_field.dart';
import 'package:medired/ui/molecules/custom_text_form_field.dart';
import 'package:medired/ui/template/register_template.dart';

class LoginAdminPage extends StatefulWidget {
  const LoginAdminPage({super.key});

  @override
  State<LoginAdminPage> createState() => _LoginAdminPageState();
}

class _LoginAdminPageState extends State<LoginAdminPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: _listener,
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
            CustomTextFormField(
              'Correo electrónico',
              labelStyle:
                  AppStyles.input.copyWith(color: AppColors.blueBackground),
              controller: email,
              hintText: 'admin@medired.com',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ingresa el correo';
                }
                return null;
              },
            ),
            CustomPasswordFormField(
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
            ),
            ElevatedButton(
              onPressed: () => context
                  .read<AuthBloc>()
                  .add(LoginAdmin(email: email.text, password: password.text)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blueBackground,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Iniciar sesión'),
            ),
          ],
          adChildren: [
            Text(
              'Bienvenido de vuelta Admin',
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
    );
  }

  void _listener(BuildContext context, AuthState state) {
    if (state is ErrorEmailUnverifiedState) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(state.message),
      //   action: SnackBarAction(
      //     label: 'Reenviar correo',
      //     onPressed: () => context.read<SignUpBloc>().add(SendEmailVerification(
      //           user: state.user,
      //         )),
      //   ),
      // ));
    }
    if (state is ErrorMessageAuthState) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(state.message)));
    }
    if (state is AuthenticatedState) {
      router.push(RoutePath.profile);
    }
  }
}
