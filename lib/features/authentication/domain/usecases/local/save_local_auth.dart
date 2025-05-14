import 'package:fpdart/fpdart.dart';
import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/domain/entities/authentication.dart';
import 'package:medired/features/authentication/domain/repository/auth_repo_impl.dart';

class SaveLocalAuthUseCase {
  final AuthRepo _repo;
  SaveLocalAuthUseCase(this._repo);
  Future<DataState<Unit>> call({required Authentication auth}) async {
    return await _repo.saveLocalAuthentication(auth);
  }
}
