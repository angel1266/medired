import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/authentication_export.dart';

class UpdateRemotePatientUseCase {
  final PatientRepository _patientRepository;

  UpdateRemotePatientUseCase(this._patientRepository);

  Future<DataState<Patient>> call({required Patient patient}) async {
    return await _patientRepository.updateRemotePatient(patient);
  }
}
