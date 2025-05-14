import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/authentication_export.dart';

class GetRemoteAdminUseCase {
  final AdminRepo _adminRepoImpl;

  GetRemoteAdminUseCase(this._adminRepoImpl);

  Future<DataState<Admin>> call({required String uid}) async {
    return await _adminRepoImpl.getRemoteAdmin(uid);
  }
}