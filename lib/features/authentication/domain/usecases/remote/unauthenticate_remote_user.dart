import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:fpdart/fpdart.dart';
import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/domain/repository/auth_repo_impl.dart';

class UnathenticateRemoteUserUseCase {
  final AuthRepo _repo;
  UnathenticateRemoteUserUseCase(this._repo);
  Future<DataState<Unit>> call() async {
    try {
      await _repo.logoutUser();
      return const Right(unit);
    } on auth.FirebaseAuthException catch (e) {
      return Left(e.message!);
    } on NoSuchMethodError catch (e) {
      return Left(e.toString());
    }
  }
}
