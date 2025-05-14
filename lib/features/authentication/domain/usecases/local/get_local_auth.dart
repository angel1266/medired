import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/domain/entities/authentication.dart';
import 'package:medired/features/authentication/domain/repository/auth_repo_impl.dart';

class GetLocalAuthUseCase {
  final AuthRepo _repo;
  GetLocalAuthUseCase(this._repo);
  Future<DataState<List<Authentication>>> call({void params}) async {
    return await _repo.getLocalAuthentications();
  }
}
