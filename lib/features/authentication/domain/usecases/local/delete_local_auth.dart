import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/domain/entities/authentication.dart';
import 'package:medired/features/authentication/domain/repository/auth_repo_impl.dart';

class DeleteLocalAuthUseCase {
  final AuthRepo _repo;
  DeleteLocalAuthUseCase(this._repo);
  Future<DataState<void>> call(Authentication auth) async {
    return await _repo.removeLocalAuthentication(auth);
  }
}
