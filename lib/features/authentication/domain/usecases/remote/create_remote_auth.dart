import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/authentication_export.dart';

class CreateRemoteAuthUseCase {
  final AuthRepo _repo;
  CreateRemoteAuthUseCase(this._repo);

  Future<DataState<User>> call<T extends Authentication>(
      {required String email,
      required String password,
      required T auth}) async {
    try {
      var user = await _repo.createUserWithEmailAndPassword(
        email,
        password,
      );
      if (user != null) {
        await _repo.createRemoteMember<T>(auth.copyWith(
          authInfo: auth.authInfo.copyWith(
            uid: user.uid,
          ),
        ) as T);
        return Right(user);
      } else {
        log('User still dont exist');
        return const Left('Ocurrió un error al crear el usuario');
      }
    } catch (e) {
      log(e.toString());
      if (e.toString() ==
          '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        return const Left('Ya existe una cuenta con el mismo correo');
      }
      return const Left('Ocurrió un error al crear el usuario');
    }
  }
}
