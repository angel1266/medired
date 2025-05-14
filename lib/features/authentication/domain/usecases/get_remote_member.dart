import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';
import 'package:medired/features/authentication/domain/repository/patient_repository.dart';

class GetRemoteMemberUseCase {
  final PatientRepository _patientRepository;
  GetRemoteMemberUseCase(this._patientRepository);

  Future<DataState<MemberInfo>> call({required String uid}) async {
    return await _patientRepository.getRemoteMember(
      uid,
    );
  }
}
