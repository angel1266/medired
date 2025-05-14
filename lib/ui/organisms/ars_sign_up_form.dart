import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:medired/core/value_objects/value_objects_export.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/authentication/presentation/bloc/auth_info/auth_info_bloc.dart';
import 'package:medired/features/authentication/presentation/bloc/base_info/base_info_bloc.dart';
import 'package:medired/features/authentication/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:medired/ui/atoms/accept_terms_button.dart';
import 'package:medired/ui/molecules/custom_password_form_field.dart';
import 'package:medired/ui/molecules/custom_text_form_field.dart';
import 'package:medired/ui/molecules/have_an_account_button.dart';

class ArsSignUpForm extends StatefulWidget {
  const ArsSignUpForm({super.key});

  @override
  State<ArsSignUpForm> createState() => _ArsSignUpFormState();
}

class _ArsSignUpFormState extends State<ArsSignUpForm> {
  bool _termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseInfoBloc, BaseInfoState>(
      builder: (context, state) {
        if (state is LoadedCompanyInfo) {
          var baseInfo = state.baseInfo;
          return Column(
            children: [
              CustomTextFormField(
                'ARS',
                initialValue: baseInfo.name,
                hintText: 'Mapfre Salud, ARS Universal, ARS Futuro...',
                keyboardType: TextInputType.name,
                onChanged: (value) => context
                    .read<BaseInfoBloc>()
                    .add(UpdateCompanyInfo(baseInfo.copyWith(name: value))),
              ),
              CustomTextFormField(
                'Número telefónico',
                hintText: '8495559911',
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.phone,
                maxLength: 10,
                onChanged: (value) => context.read<BaseInfoBloc>().add(
                        UpdateCompanyInfo(baseInfo.copyWith(phoneNumber: [
                      baseInfo.phoneNumber.first.copyWith(phoneNumber: value)
                    ]))),
              ),
              BlocBuilder<AuthInfoBloc, AuthInfoState>(
                builder: (context, state) {
                  var authInfo = state.authInfo;
                  return CustomTextFormField(
                    'Correo electrónico',
                    hintText: 'maria@medired.com',
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => context
                        .read<AuthInfoBloc>()
                        .add(UpdateAuthInfo(authInfo.copyWith(email: value))),
                    validator: (value) => authInfo.validateEmail,
                  );
                },
              ),
              CustomTextFormField(
                'RNC',
                hintText: '',
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                onChanged: (value) => context.read<BaseInfoBloc>().add(
                        UpdateCompanyInfo(baseInfo.copyWith(documents: [
                      baseInfo.documents.first.copyWith(value: value)
                    ]))),
              ),
              BlocBuilder<AuthInfoBloc, AuthInfoState>(
                builder: (context, state) {
                  var authInfo = state.authInfo;
                  return CustomPasswordFormField(
                    'Contraseña',
                    hintText: '',
                    onChanged: (value) => context.read<AuthInfoBloc>().add(
                        UpdateAuthInfo(authInfo.copyWith(password: value))),
                    validator: (value) => authInfo.validatePassword,
                  );
                },
              ),
              const SizedBox(height: 20),
              AcceptTermsButton(
                isAccepted: _termsAccepted,
                onChanged: (value) {
                  setState(() {
                    _termsAccepted = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),
              const HaveAnAccountButton(),
              const SizedBox(height: 20),
              Builder(builder: (context) {
                var baseInfoState = context.watch<BaseInfoBloc>().state;
                var authInfoState = context.watch<AuthInfoBloc>().state;
                return ElevatedButton(
                  onPressed: baseInfoState.isValid &&
                          authInfoState.isValid &&
                          baseInfoState is LoadedCompanyInfo
                      ? () => context.read<SignUpBloc>().add(SignUpUser<ARS>(
                            email: authInfoState.authInfo.email!,
                            password: authInfoState.authInfo.password,
                            auth: ARS.fromSignUp(
                              authInfo: authInfoState.authInfo,
                              memberInfo: MemberInfo.fromEmpty(
                                  memberType: UserType.ars),
                              companyInfo: baseInfoState.baseInfo,
                            ),
                          ))
                      : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Finalizar'),
                );
              }),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
