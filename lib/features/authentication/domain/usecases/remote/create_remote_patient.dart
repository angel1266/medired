import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/domain/entities/patient.dart';
import 'package:medired/features/authentication/domain/repository/patient_repository.dart';

class CreateRemotePatientUseCase {
  final PatientRepository _patientRepository;

  CreateRemotePatientUseCase(this._patientRepository);

  Future<DataState<Patient>> call({required Patient patient}) async {
    return await _patientRepository.createRemotePatient(patient);
  }
}
