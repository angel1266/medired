import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/authentication/domain/usecases/remote/get_remote_facebook_auth.dart';
import 'package:medired/features/authentication/domain/usecases/remote/send_email_password_reset.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends HydratedBloc<AuthEvent, AuthState> {
  // remote usecases
  // auth
  final GetRemoteAuthUseCase _getRemoteAuth;
  final GetRemoteGoogleAuthUseCase _getRemoteGoogleAuth;
  final GetRemoteFacebookAuthUseCase _getRemoteFacebookAuth;
  final SendEmailPasswordResetUseCase _sendEmailPasswordReset;
  final UnathenticateRemoteUserUseCase _unathenticateRemoteUser;
  // generic user
  final GetRemoteMemberUseCase _getRemoteMember;
  // patient
  final GetRemotePatientUseCase _getRemotePatient;
  // service provider
  final GetRemoteServiceProviderUseCase _getRemoteServiceProvider;
  // ars
  final GetRemoteARSUseCase _getRemoteARS;
  // broker
  final GetRemoteBrokerUseCase _getRemoteBroker;
  // admin
  final GetRemoteAdminUseCase _getRemoteAdmin;
  // local usecases
  final GetLocalAuthUseCase _getLocalAuth;
  final SaveLocalAuthUseCase _saveLocalAuth;
  final DeleteLocalAuthUseCase _deleteLocalAuth;

  StreamSubscription? authSubscription;

  AuthBloc(
    this._getRemoteAuth,
    this._getRemoteGoogleAuth,
    this._getRemoteFacebookAuth,
    this._sendEmailPasswordReset,
    this._unathenticateRemoteUser,
    this._getRemoteMember,
    this._getRemotePatient,
    this._getRemoteServiceProvider,
    this._getRemoteARS,
    this._getRemoteBroker,
    this._getRemoteAdmin,
    this._getLocalAuth,
    this._saveLocalAuth,
    this._deleteLocalAuth,
  ) : super(const UnauthenticatedState()) {
    on<InitializeAuth>(init);
    on<LoginMember>(loginMember);
    on<LoginAdmin>(_loginAdmin);
    on<LogOut>(logoutUser);
    on<LoginWithGoogle>(loginWithGoogle);
    on<LoginWithFacebook>(loginWithFacebook);
    on<SendEmailPasswordReset>(_sendEmailPassword);
  }

  Future<void> init(
    InitializeAuth event,
    Emitter<AuthState> emit,
  ) async {
    DataState<List<Authentication>> result = await _getLocalAuth.call();

    return await result.fold(
      (l) => emit(const UnauthenticatedState()),
      (r) {
        if (r.isEmpty || r.last.authInfo.email == null) {
          emit(const UnauthenticatedState());
        } else {
          var authInfo = r.last.authInfo;
          add(LoginMember(email: authInfo.email!, password: authInfo.password));
        }
      },
    );
  }

  Future<void> _loginUser(
    LogIn event,
    Emitter<AuthState> emit,
    Future<void> Function(LogIn, Emitter<AuthState>, auth.User) handleUser,
  ) async {
    emit(const LoadingAuthState());

    DataState<auth.User> result = await _getRemoteAuth.call(
      email: event.email,
      password: event.password,
    );

    return await result.fold(
      (l) => emit(ErrorMessageAuthState(l)),
      (r) async => await handleUser(event, emit, r),
    );
  }

  Future<void> loginMember(
    LogIn event,
    Emitter<AuthState> emit,
  ) async {
    await _loginUser(
      event,
      emit,
      (event, emit, user) async {
        // if (user.emailVerified) {
        await getMember(event, emit, user);
        // } else {
        //   emit(ErrorEmailUnverifiedState(
        //     'Verifica tu correo para iniciar sesión',
        //     user: user,
        //   ));
        // }
      },
    );
  }

  Future<void> _loginAdmin(
    LogIn event,
    Emitter<AuthState> emit,
  ) async {
    await _loginUser(
      event,
      emit,
      (event, emit, user) async => await _getAdmin(event, emit, user),
    );
  }

  Future<void> _getAdmin(
    LogIn event,
    Emitter<AuthState> emit,
    auth.User firebaseUser,
  ) async {
    DataState<Admin> result = await _getRemoteAdmin.call(
      uid: firebaseUser.uid,
    );

    return await result.fold(
      (l) => null,
      (r) => emit(AuthenticatedState<Admin>(user: r)),
    );
  }

  Future<void> getMember(
    LogIn event,
    Emitter<AuthState> emit,
    auth.User firebaseUser,
  ) async {
    log('getMember ${event.email} ${event.password}');
    DataState<Member> result = await _getRemoteMember.call(
      uid: firebaseUser.uid,
    );
    return await result.fold((l) => null, (r) async {
      switch (r.memberInfo.memberType) {
        case UserType.patient:
          await getUser<Patient>(event, emit, r.authInfo.uid!);
          break;
        case UserType.provider:
          await getUser<ServiceProvider>(event, emit, r.authInfo.uid!);
          break;
        case UserType.ars:
          await getUser<ARS>(event, emit, r.authInfo.uid!);
          break;
        case UserType.broker:
          await getUser<Broker>(event, emit, r.authInfo.uid!);
          break;
        default:
          emit(const ErrorMessageAuthState('Invalid user type'));
      }
    });
  }

  Future<void> getUser<U extends Authentication>(
    LogIn event,
    Emitter<AuthState> emit,
    String uid,
  ) async {
    final result = await getRemoteUser<U>(uid);

    if (result == null) {
      emit(const ErrorMessageAuthState('Error getting remote user'));
      return;
    }

    return await result.fold(
      (l) => emit(ErrorMessageAuthState(l)),
      (r) async {
        bool existsUser = await checkIfUserExists(r, uid);
        if (!existsUser) {
          await saveLocalMember(event, emit, r);
        }
        emit(AuthenticatedState<U>(user: r));
      },
    );
  }

  Future<DataState<U>>? getRemoteUser<U extends Authentication>(String uid) {
    if (U == Patient) {
      return _getRemotePatient.call(uid: uid) as Future<DataState<U>>;
    } else if (U == ServiceProvider) {
      return _getRemoteServiceProvider.call(uid: uid) as Future<DataState<U>>;
    } else if (U == ARS) {
      return _getRemoteARS.call(uid: uid) as Future<DataState<U>>;
    } else if (U == Broker) {
      return _getRemoteBroker.call(uid: uid) as Future<DataState<U>>;
    }
    return null;
  }

  Future<bool> checkIfUserExists(
    Authentication auth,
    String uid,
  ) async {
    DataState<List<Authentication>> result = await _getLocalAuth.call();
    return await result.fold(
      (l) => false,
      (r) => r.any((auth) => auth.authInfo.uid == uid),
    );
  }

  Future<void> saveLocalMember(
    LogIn event,
    Emitter<AuthState> emit,
    Authentication auth,
  ) async {
    DataState<Unit> result = await _saveLocalAuth.call(auth: auth);
    return await result.fold(
        (l) => emit(ErrorMessageAuthState(l)), (r) => null);
  }

  Future<void> _sendEmailPassword(
    SendEmailPasswordReset event,
    Emitter<AuthState> emit,
  ) async {
    var result = await _sendEmailPasswordReset.call(email: event.email);

    return await result.fold(
      (l) => emit(ErrorMessageAuthState(l)),
      (r) => emit(SuccessAuthState(
        'Se ha enviado un correo a ${event.email}',
      )),
    );
  }

  Future<void> loginWithGoogle(
    LoginWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(const LoadingAuthState());
    DataState<auth.User> result = await _getRemoteGoogleAuth.call();

    return result.fold((l) => emit(ErrorMessageAuthState(l)), (r) async {
      var user = await _getRemotePatient.call(uid: r.uid);

      user.fold(
        (l) => emit(ErrorMessageAuthState(l)),
        (r) => emit(AuthenticatedState<Patient>(user: r)),
      );
    });
  }

    Future<void> loginWithFacebook(
    LoginWithFacebook event,
    Emitter<AuthState> emit,
  ) async {
    emit(const LoadingAuthState());
    DataState<auth.User> result = await _getRemoteFacebookAuth.call();

    return result.fold((l) => emit(ErrorMessageAuthState(l)), (r) async {
      var user = await _getRemotePatient.call(uid: r.uid);

      user.fold(
        (l) => emit(ErrorMessageAuthState(l)),
        (r) => emit(AuthenticatedState<Patient>(user: r)),
      );
    });
  }

  Future<void> logoutUser(
    LogOut event,
    Emitter<AuthState> emit,
  ) async {
    var result2 = await _deleteLocalAuth.call(event.auth);
    DataState<Unit> result = await _unathenticateRemoteUser.call();

    return await result.fold(
      (l) => emit(ErrorMessageAuthState(l)),
      (r) => emit(const SuccessAuthState('Deslogueado')),
    );
  }

  @override
  Future<void> close() {
    authSubscription?.cancel();
    return super.close();
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    return null;
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    if (state is AuthenticatedState) {
      return AuthenticationModel.fromEntity(state.user).toJson();
    } else {
      return null;
    }
  }
}
