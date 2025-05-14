import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medired/core/utils/responsive.dart';
import 'package:medired/core/value_objects/medical_specialization.dart';
import 'package:medired/features/appointments/domain/entities/medical_test.dart';
import 'package:medired/features/authentication/domain/entities/service_provider.dart';
import 'package:medired/features/authentication/presentation/bloc/auth_info/auth_info_bloc.dart';
import 'package:medired/features/authentication/presentation/bloc/base_info/base_info_bloc.dart';
import 'package:medired/features/authentication/presentation/bloc/medical_tests/medical_tests_bloc.dart';
import 'package:medired/features/authentication/presentation/bloc/sign_up/sign_up_bloc.dart';
import 'package:medired/ui/atoms/accept_terms_button.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/molecules/custom_password_form_field.dart';
import 'package:medired/ui/molecules/custom_text_form_field.dart';
import 'package:medired/ui/molecules/have_an_account_button.dart';
import 'package:medired/ui/template/selectable_list_template.dart';

class ServiceProviderSigUpForm extends StatefulWidget {
  const ServiceProviderSigUpForm({
    super.key,
  });

  @override
  State<ServiceProviderSigUpForm> createState() =>
      _ServiceProviderSigUpFormState();
}

class _ServiceProviderSigUpFormState extends State<ServiceProviderSigUpForm> {
  bool _termsAccepted = false;
  List<MapEntry<MedicalSpecialization, bool>> medicalSpecializations = [];
  List<MapEntry<MedicalTest, bool>> medicalTests = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseInfoBloc, BaseInfoState>(
      builder: (context, state) {
        if (state is LoadedCompanyInfo) {
          var baseInfo = state.baseInfo;
          return Column(
            children: [
              CustomTextFormField(
                'Nombre del proveedor de servicios',
                hintText: '',
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
                  return CustomTextFormField(
                    'Correo electronico',
                    hintText: 'maria@medired.com',
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => context
                        .read<AuthInfoBloc>()
                        .add(UpdateAuthInfo(authInfo.copyWith(email: value))),
                    validator: (value) => authInfo.validateEmail,
                  );
                },
              ),
              BlocBuilder<MedicalTestsBloc, MedicalTestsState>(
                builder: (context, state) {
                  if (state is SuccessGetMedicalTests) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                          'Especialidad',
                          readOnly: true,
                          controller: TextEditingController(
                              text: medicalSpecializations
                                  .where((e) => e.value == true)
                                  .map((e) =>
                                      medicalSpecializationToString[e.key])
                                  .toList()
                                  .join(', ')),
                          suffixIcon: IconButton(
                            onPressed: () => showAdaptiveSheet(
                              context: context,
                              bottomSheetHeight: 0.8,
                              body: SelectableListTemplate(
                                items: medicalSpecializations.isEmpty
                                    ? medicalSpecializationToString.keys
                                        .map((e) => MapEntry(e, false))
                                        .toList()
                                    : medicalSpecializations,
                                options: medicalSpecializationToString.values
                                    .toList(),
                                onSubmit: (items) => setState(() {
                                  medicalSpecializations = items;
                                }),
                              ),
                            ),
                            icon: const Icon(Icons.medical_services,
                                color: AppColors.blueBackground),
                          ),
                        ),
                        CustomTextFormField(
                          'Tipo de prueba',
                          readOnly: true,
                          controller: TextEditingController(
                              text: medicalTests
                                  .where((e) => e.value == true)
                                  .map((e) => e.key.name)
                                  .toList()
                                  .join(', ')),
                          suffixIcon: IconButton(
                            onPressed: () => showAdaptiveSheet(
                              context: context,
                              bottomSheetHeight: 0.8,
                              body: SelectableListTemplate(
                                items: medicalTests.isEmpty
                                    ? state.medicalTests
                                        .map((e) => MapEntry(e, false))
                                        .toList()
                                    : medicalTests,
                                options: state.medicalTests
                                    .map((e) => e.name)
                                    .toList(),
                                onSubmit: (items) => setState(() {
                                  medicalTests = items;
                                }),
                              ),
                            ),
                            icon: const Icon(Icons.medical_services,
                                color: AppColors.blueBackground),
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
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
              AcceptTermsButton(
                isAccepted: _termsAccepted,
                onChanged: (value) {
                  setState(() {
                    _termsAccepted = value ?? false;
                  });
                },
              ),
              const HaveAnAccountButton(),
              Row(
                children: [
                  Expanded(
                    child: Builder(builder: (context) {
                      final baseInfoState = context.watch<BaseInfoBloc>().state;
                      final authInfoState = context.watch<AuthInfoBloc>().state;
                      return ElevatedButton(
                        onPressed: baseInfoState.isValid &&
                                authInfoState.isValid &&
                                baseInfoState is LoadedCompanyInfo
                            ? () {
                                context
                                    .read<SignUpBloc>()
                                    .add(SignUpUser<ServiceProvider>(
                                      email: authInfoState.authInfo.email!,
                                      password: authInfoState.authInfo.password,
                                      auth: ServiceProvider.fromSignUp(
                                        authInfo: authInfoState.authInfo,
                                        companyInfo: baseInfoState.baseInfo,
                                        medicalTests: medicalTests
                                            .where((e) => e.value == true)
                                            .map((e) => e.key)
                                            .toList(),
                                        medicalSpecializations:
                                            medicalSpecializations
                                                .where((e) => e.value == true)
                                                .map((e) => e.key)
                                                .toList(),
                                      ),
                                    ));
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Finalizar'),
                      );
                    }),
                  )
                ],
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
