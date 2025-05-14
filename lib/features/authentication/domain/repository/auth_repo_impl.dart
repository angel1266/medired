import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:medired/core/database/collections.dart';
import 'package:medired/core/usecases/usecases.dart';
import 'package:medired/features/authentication/data/data_source/local/DAO/authentication_dao.dart';
import 'package:medired/features/authentication/data/models/authentication_model.dart';
import 'package:medired/features/authentication/domain/entities/authentication.dart';

abstract class AuthRepo {
  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  );

  Future<DataState<User>> signInWithEmailAndPassword(
    String email,
    String password,
  );

  Future<Unit> createRemoteMember<T extends Authentication>(T auth);

  Future<DataState<User>> signInWithGoogle();

  Future<DataState<User>> signInWithFacebook();

  Future<DataState<Authentication>> getAuthenticatedUser(String path);
  //Database methods
  Future<DataState<List<Authentication>>> getLocalAuthentications();

  Future<DataState<Unit>> saveLocalAuthentication(Authentication auth);

  Future<DataState<Unit>> removeLocalAuthentication(Authentication auth);

  Future<void> logoutUser();

  Future<void> sendEmailVerification(User user);

  Future<Unit> sendEmailPasswordReset(String email);
}

class AuthRepoImpl implements AuthRepo {
  final AuthenticationDao _dao;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookSignIn;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  AuthRepoImpl(
    this._dao,
    this._googleSignIn,
    this._facebookSignIn,
    this._firestore,
    this._auth,
  );

  @override
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  }

  @override
  Future<DataState<User>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return const Left('user not found');
      }
      return Right(userCredential.user!);
    } on FirebaseException {
      /*if (error.message ==
          'The supplied auth credential is incorrect, malformed or has expired.') {
        return Left(
            'Credenciales inválidas.\nSi no posee usuario, por favor le sugerimos registrarse seleccionando la opción "Regístrate aquí"');
      }
      else if(error.message ==
          'The email address is badly formatted.'){

          }*/

      return const Left(
          'Credenciales inválidas.\nSi no posee usuario, por favor le sugerimos registrarse seleccionando la opción "Regístrate aquí"');
    } catch (error) {
      return const Left('An error has ocurred while authenticating a user');
    }
  }

  @override
  Future<DataState<User>> signInWithGoogle() async {
    try {
      // Cerrar sesión previa y revocar acceso para forzar nueva selección de cuenta
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect();

      // Intentar iniciar sesión nuevamente
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // El usuario canceló la selección de cuenta
        return const Left('No account selected.');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

     /* // Validar tokens
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        return const Left('El usuario no existe en googleee');
      }*/

      // Crear credenciales para Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Iniciar sesión en Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (userCredential.user == null) {
        return const Left('User not found after signing in.');
      }

      return Right(userCredential.user!);
    } on FirebaseAuthException catch (error) {
      print("FirebaseAuthException: ${error.message}");
      return Left(error.message ?? 'Unknown Firebase authentication error.');
    } catch (error) {
      print("Error general: $error");
      return const Left('Error authenticating Google user');
    }
  }

  Future<void> signOutGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.disconnect();
      await googleSignIn.signOut();
      print("Usuario desconectado exitosamente");
    } catch (error) {
      print("Error al cerrar sesión: $error");
    }
  }

  Future<DataState<User>> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user == null) {
          return const Left('user not found');
        }
        return Right(user!);
      } else {
        return const Left('user not found');
      }
    } on FirebaseException catch (error) {
      return Left(error.message!);
    } catch (error) {
      return const Left('Error authenticating Facebook user');
    }
  }

  @override
  Future<DataState<Authentication>> getAuthenticatedUser(String path) async {
    try {
      DocumentSnapshot doc = await _firestore.doc(path).get();
      if (doc.data() == null) {
        return const Left('No document found');
      }
      var data = doc.data() as Map<String, dynamic>;
      AuthenticationModel model = AuthenticationModel.fromJson(data);
      return Right(Authentication.toEntity(model));
    } on FirebaseException catch (error) {
      return Left(error.message!);
    }
  }

  @override
  Future<DataState<List<Authentication>>> getLocalAuthentications() async {
    try {
      return Right(await _dao.getAllSortedByName());
    } catch (error) {
      return const Left('An error has ocurred while saving authentications');
    }
  }

  @override
  Future<DataState<Unit>> removeLocalAuthentication(Authentication auth) async {
    try {
      await _dao.deleteAuthentication(AuthenticationModel.fromEntity(auth));
      return const Right(unit);
    } catch (error) {
      return const Left(
          'An error has ocurred while removing a local authentication');
    }
  }

  @override
  Future<DataState<Unit>> saveLocalAuthentication(Authentication auth) async {
    try {
      await _dao.insertAuthentication(AuthenticationModel.fromEntity(auth));
      return const Right(unit);
    } catch (error) {
      return const Left(
          'An error has ocurred while saving a local authentication');
    }
  }

  @override
  Future<DataState<Unit>> logoutUser() async {
    try {
      await _auth.signOut();
      return const Right(unit);
    } on FirebaseException catch (error) {
      return Left(error.message!);
    }
  }

  @override
  Future<DataState<Unit>> sendEmailVerification(User? user) async {
    try {
      await user?.sendEmailVerification();
      return const Right(unit);
    } catch (error) {
      return const Left(
          'An error has ocurred while sending an email verification');
    }
  }

  @override
  Future<Unit> sendEmailPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
    return unit;
  }

  @override
  Future<Unit> createRemoteMember<T extends Authentication>(T auth) async {
    log('${auth.toJson()}');
    await _firestore
        .collection(Collections.member)
        .doc(auth.authInfo.uid!)
        .set(auth.toJson());

    return unit;
  }
}
