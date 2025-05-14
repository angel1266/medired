import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/domain/entities/patient.dart';
import 'package:medired/features/authentication/domain/repository/patient_repository.dart';

class GetRemotePatientUseCase {
  final PatientRepository _patientRepository;
  GetRemotePatientUseCase(this._patientRepository);

  Future<DataState<Patient>> call({required String uid}) {
    return _patientRepository.getRemotePatient(uid);
  }
}
