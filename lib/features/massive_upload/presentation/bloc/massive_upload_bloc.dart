import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/massive_upload/domain/usecases/get_excel_patients.dart';

part 'massive_upload_event.dart';
part 'massive_upload_state.dart';

class MassiveUploadBloc extends Bloc<MassiveUploadEvent, MassiveUploadState> {
  final CreateRemoteAuthUseCase _createRemoteAuth;
  final CreateRemotePatientUseCase _createRemotePatient;
  final GetExcelPatientsUseCase _getExcelPatients;
  final ARSRepository _arsRepository;

  List<String> uids = [];

  MassiveUploadBloc(this._createRemoteAuth, this._createRemotePatient,
      this._getExcelPatients, this._arsRepository)
      : super(const LoadedPatientListState(patients: [])) {
    on<UploadUsers>(_uploadUsers);
    on<SignUpPatient>(_signUpPatient);
    on<ReadFile>(_readFile);
    on<SavePatient>(_savePatient);
    on<CancelUpload>(_cancelUpload);
    // on<UploadUIDs>(_uploadUIDs);
  }

  Future<void> _uploadUsers(
    UploadUsers event,
    Emitter<MassiveUploadState> emit,
  ) async {
    emit(LoadingMassiveUploadState());

    double amountDue = 0;
    for (Patient patient in event.patientList) {
      amountDue += subscriptionPrice[patient.memberInfo.subscriptionType] ?? 0;

      add(SignUpPatient(patient: patient));
    }

    _arsRepository.updateARS(event.arsUID, {'amountDue': amountDue.toString()});

    emit(const SuccessMassiveUploadState('Usuarios creados exitosamente'));
    await Future.delayed(const Duration(seconds: 1));
    emit(const LoadedPatientListState(patients: []));
  }

  Future<void> _signUpPatient(
    SignUpPatient event,
    Emitter<MassiveUploadState> emit,
  ) async {
    var today = DateTime.now();
    var randomWord = _generateRandomWord(4);
    var password = '${today.year}${today.month}${today.day}$randomWord!';
    DataState<auth.User> result = await _createRemoteAuth.call<Patient>(
      auth: event.patient,
      email: event.patient.authInfo.email!,
      password: password,
    );

    return await result.fold(
        (l) => emit(ErrorMassiveUploadState(l)),
        (r) => add(
            SavePatient(user: r, patient: event.patient, password: password)));
  }

  Future<void> _readFile(
    ReadFile event,
    Emitter<MassiveUploadState> emit,
  ) async {
    emit(LoadingMassiveUploadState());
    var result = await _getExcelPatients.call(
      bytes: event.bytes,
      arsUID: event.arsUID,
    );

    return await result.fold(
      (l) => emit(ErrorMassiveUploadState(l)),
      (r) => emit(LoadedPatientListState(patients: r)),
    );
  }

  Future<void> _savePatient(
    SavePatient event,
    Emitter<MassiveUploadState> emit,
  ) async {
    var newPatient = event.patient.copyWith(
      memberInfo: event.patient.memberInfo.copyWith(
        authInfo: AuthenticationModel.fromFirebaseUser(
          event.user,
          password: event.password,
          isEnabled: true,
        ).authInfo,
      ),
    );
    uids.add(event.user.uid);

    DataState<Patient> result =
        await _createRemotePatient.call(patient: newPatient);

    return await result.fold(
      (l) => emit(ErrorMassiveUploadState(l)),
      (r) => null,
    );
  }

  Future<void> _cancelUpload(
    CancelUpload event,
    Emitter<MassiveUploadState> emit,
  ) async {
    emit(const LoadedPatientListState(patients: []));
  }

  // Future<void> __uploadUIDs(
  //   UploadUIDs event,
  //   Emitter<MassiveUploadState> emit,
  // ) async {

  // }

  String _generateRandomWord(int length) {
    Random random = Random();
    // ASCII values for A-Z and a-z
    const uppercaseLetters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercaseLetters = 'abcdefghijklmnopqrstuvwxyz';

    // Generate one random uppercase and one random lowercase letter
    String randomUppercase =
        uppercaseLetters[random.nextInt(uppercaseLetters.length)];
    String randomLowercase =
        lowercaseLetters[random.nextInt(lowercaseLetters.length)];

    // Generate random letters (could be either uppercase or lowercase)
    String allLetters = uppercaseLetters + lowercaseLetters;
    String randomLetters = '';
    for (int i = 0; i < length - 2; i++) {
      randomLetters += allLetters[random.nextInt(allLetters.length)];
    }

    // Combine the letters and shuffle them to ensure randomness
    String combined = randomUppercase + randomLowercase + randomLetters;
    List<String> splitList = combined.split('');
    splitList.shuffle(random);
    return splitList.join().substring(0, length);
  }
}
