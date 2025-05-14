import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:fpdart/fpdart.dart';
import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/domain/repository/auth_repo_impl.dart';

class SendEmailVerificationUseCase {
  final AuthRepo _repo;

  SendEmailVerificationUseCase(this._repo);

  Future<DataState<Unit>> call(firebase.User user) async {
    try {
      await _repo.sendEmailVerification(user);
      return const Right(unit);
    } on firebase.FirebaseException catch (e) {
      return Left(e.message!);
    } on NoSuchMethodError catch (e) {
      return Left(e.toString());
    }
  }
}
