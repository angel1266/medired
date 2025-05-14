import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medired/ui/atoms/accept_terms_button.dart';
import 'package:medired/ui/molecules/custom_password_form_field.dart';
import 'package:medired/ui/molecules/custom_text_form_field.dart';
import 'package:medired/ui/molecules/have_an_account_button.dart';

class InsurenceBrokerSigUpForm extends StatefulWidget {
  const InsurenceBrokerSigUpForm({super.key});

  @override
  State<InsurenceBrokerSigUpForm> createState() =>
      _InsurenceBrokerSigUpFormState();
}

class _InsurenceBrokerSigUpFormState extends State<InsurenceBrokerSigUpForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomTextFormField(
          'Nombre de la empresa',
          hintText: '',
          keyboardType: TextInputType.name,
        ),
        CustomTextFormField(
          'RNC',
          hintText: '',
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
        ),
        const CustomTextFormField(
          'Correo electronico',
          hintText: 'maria@medired.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const CustomPasswordFormField(
          'Contraseña',
          hintText: '',
          onChanged: null,
          validator: null,
        ),
        const SizedBox(height: 20),
        AcceptTermsButton(
          isAccepted: false,
          onChanged: (value) {
            setState(() {
              // _termsAccepted = value ?? false;
            });
          },
        ),
        const SizedBox(height: 20),
        const HaveAnAccountButton(),
        const SizedBox(height: 20),
        // ElevatedButton(
        //   onPressed: () => context.read<AuthBloc>().add(const SignUpBroker(name: '', documentValue: '', email: '', password: '')),
        //   style: ElevatedButton.styleFrom(
        //     minimumSize: const Size(double.infinity, 50),
        //   ),
        //   child: const Text('Finalizar'),
        // ),
      ],
    );
  }
}
