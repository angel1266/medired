import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medired/features/authentication/authentication_export.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final CreateRemoteAuthUseCase _createRemoteAuth;
  final SendEmailVerificationUseCase _sendEmailVerification;

  SignUpBloc(this._createRemoteAuth, this._sendEmailVerification)
      : super(UnloadedSignUp()) {
    on<SignUpUser>(_onSignUpUser);
    on<SendEmailVerification>(_onSendEmailVerification);
  }

  Future<void> _onSignUpUser(
      SignUpUser event, Emitter<SignUpState> emit) async {
    emit(LoadingSignUpUser());
    var result = await _createRemoteAuth.call(
        email: event.email, password: event.password, auth: event.auth);

    result.fold(
        (l) => emit(ErrorSignUpUser(l)),
        (r) => emit(SuccessSignUpUser(
            firebaseUser: r,
            auth: event.auth.copyWith(
                authInfo: event.auth.authInfo.copyWith(uid: r.uid)))));
  }

  Future<void> _onSendEmailVerification(
      SendEmailVerification event, Emitter<SignUpState> emit) async {
    emit(LoadingSendEmailVerification());
    var result = await _sendEmailVerification.call(event.firebaseUser);

    result.fold((l) => emit(ErrorSendEmailVerification(l)),
        (r) => emit(SuccessSendEmailVerification()));
  }
}
