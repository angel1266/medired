import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/authentication_export.dart';

class GetRemoteAuthUseCase {
  final AuthRepo _repo;
  GetRemoteAuthUseCase(this._repo);
  Future<DataState<auth.User>> call(
      {required String email, required String password}) async {
    return await _repo.signInWithEmailAndPassword(
      email,
      password,
    );
  }
}
