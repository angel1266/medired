import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/massive_upload/domain/repository/user_excel_repo.dart';

class GetExcelPatientsUseCase {
  final UserExcelRepo _userExcelRepo;

  GetExcelPatientsUseCase(this._userExcelRepo);

  Future<DataState<List<Patient>>> call({
    required Uint8List bytes,
    required String arsUID,
  }) =>
      _userExcelRepo.getExcelPatients(bytes, arsUID);
}
