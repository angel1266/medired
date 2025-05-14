import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/domain/repository/auth_repo_impl.dart';

class GetRemoteFacebookAuthUseCase {
  final AuthRepo _repo;
  GetRemoteFacebookAuthUseCase(this._repo);
  Future<DataState<auth.User>> call({void params}) async {
    return await _repo.signInWithFacebook();
  }
}
