import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medired/core/value_objects/subscription_type.dart';
import 'package:medired/core/value_objects/user_sex.dart';
import 'package:medired/features/authentication/presentation/bloc/auth/auth_bloc.dart';
import 'package:medired/features/massive_upload/presentation/bloc/massive_upload_bloc.dart';
import 'package:medired/services/locator.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/molecules/custom_table.dart';
import 'package:medired/ui/template/massive_upload_template.dart';

class MassiveUploadPage extends StatefulWidget {
  const MassiveUploadPage({super.key});

  @override
  State<MassiveUploadPage> createState() => _MassiveUploadPageState();
}

class _MassiveUploadPageState extends State<MassiveUploadPage> {
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final MassiveUploadBloc _massiveUploadBloc = sl<MassiveUploadBloc>();

  @override
  Widget build(BuildContext context) {
    const tableHeaderTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    return BlocProvider(
      create: (context) => _massiveUploadBloc,
      child: BlocConsumer<MassiveUploadBloc, MassiveUploadState>(
        listener: _listener,
        builder: (context, state) {
          return MassiveUploadTemplate(
            isLoading: state is LoadingMassiveUploadState,
            table: (state is LoadedPatientListState) &&
                    state.patients.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomTable(
                        header: const [],
                        rows: [
                          const [
                            Text(
                              'Nombres',
                              style: tableHeaderTextStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Apellidos',
                              style: tableHeaderTextStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Teléfono',
                              style: tableHeaderTextStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Correo',
                              style: tableHeaderTextStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Fecha de nacimiento',
                              style: tableHeaderTextStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Sexo',
                              style: tableHeaderTextStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Cédula',
                              style: tableHeaderTextStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Suscripción',
                              style: tableHeaderTextStyle,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Amount Due',
                              style: tableHeaderTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                          ...state.patients.map(
                            (e) => [
                              Text(e.personalInfo.firstName),
                              Text(e.personalInfo.lastName),
                              Text(
                                  e.personalInfo.phoneNumber.first.phoneNumber),
                              Text(e.authInfo.email ?? ''),
                              Text(
                                  _dateFormat.format(e.personalInfo.birthdate)),
                              Text(
                                e.personalInfo.sex == Sex.masculine
                                    ? 'Masculino'
                                    : 'Femenino',
                              ),
                              Text(e.personalInfo.documents.first.value),
                              Text(
                                  '${subscriptionTypeToString[e.memberInfo.subscriptionType]}'),
                              Text(
                                  '${subscriptionPrice[e.memberInfo.subscriptionType]}'),
                            ],
                          ),
                        ],
                        headerDecoration: const BoxDecoration(
                            color: AppColors.blueBackground),
                        rowsDecoration: const [
                          null,
                          BoxDecoration(color: AppColors.greenBackground)
                        ],
                      ),
                      Text(
                        'Total Amount Due: ${state.patients.fold(0.0, (previousValue, element) {
                          previousValue += subscriptionPrice[
                                  element.memberInfo.subscriptionType] ??
                              0;
                          return previousValue;
                        })}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      )
                    ],
                  )
                : const Center(
                    child: Text('Toca el boton para visualizar usuarios')),
            uploadFile: (state is LoadedPatientListState) &&
                    state.patients.isEmpty
                ? BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: state is AuthenticatedState
                            ? () async {
                                var bloc = context.read<MassiveUploadBloc>();
                                var result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowMultiple: false,
                                  allowedExtensions: ['xlsx'],
                                );

                                if (result != null) {
                                  Uint8List? fileBytes;
                                  if (kIsWeb) {
                                    fileBytes = result.files.first.bytes!;
                                  } else {
                                    File file = File(result.files.first.path!);
                                    fileBytes = await file.readAsBytes();
                                  }

                                  bloc.add(
                                    ReadFile(
                                      bytes: fileBytes,
                                      arsUID: state.user.authInfo.uid!,
                                    ),
                                  );
                                }
                              }
                            : null,
                        child: const Text('Subir xlsx'),
                      );
                    },
                  )
                : const SizedBox.shrink(),
            uploadBatch:
                (state is LoadedPatientListState) && state.patients.isNotEmpty
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () => context.read<MassiveUploadBloc>().add(
                            UploadUsers(
                                patientList: state.patients,
                                arsUID: (context.read<AuthBloc>().state
                                        as AuthenticatedState)
                                    .user
                                    .authInfo
                                    .uid as String)),
                        child: const Text('Upload users'),
                      )
                    : const SizedBox.shrink(),
            cancel:
                (state is LoadedPatientListState) && state.patients.isNotEmpty
                    ? TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () => context
                            .read<MassiveUploadBloc>()
                            .add(const CancelUpload()),
                        child: const Text('Cancel'),
                      )
                    : const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  void _listener(BuildContext context, MassiveUploadState state) {
    if (state is ErrorMassiveUploadState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    } else if (state is SuccessMassiveUploadState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  }
}
