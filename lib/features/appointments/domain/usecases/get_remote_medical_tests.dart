import 'package:medired/core/core_export.dart';
import 'package:medired/features/appointments/domain/entities/medical_test.dart';
import 'package:medired/features/appointments/domain/repository/medical_test_repo.dart';

class GetRemoteMedicalTestsUseCase {
  final MedicalTestRepo _medicalTestRepo;

  GetRemoteMedicalTestsUseCase(this._medicalTestRepo);

  Future<DataState<List<MedicalTest>>> call() async {
    return _medicalTestRepo.getMedicalTests();
  }
}
