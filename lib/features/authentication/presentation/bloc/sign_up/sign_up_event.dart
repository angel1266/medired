part of 'sign_up_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

final class SignUpUser<T extends Authentication> extends SignUpEvent {
  final String email;
  final String password;
  final T auth;
  const SignUpUser(
      {required this.email, required this.password, required this.auth});

  @override
  List<Object> get props => [email, password];
}

final class SendEmailVerification extends SignUpEvent {
  final User firebaseUser;
  const SendEmailVerification({required this.firebaseUser});

  @override
  List<Object> get props => [firebaseUser];
}
