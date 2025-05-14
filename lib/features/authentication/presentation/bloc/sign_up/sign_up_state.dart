part of 'sign_up_bloc.dart';

sealed class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

final class UnloadedSignUp extends SignUpState {}

/*
--- 🌟⏳ Loading ⏳🌟 ---
*/
final class LoadingSignUp extends SignUpState {}

final class LoadingSignUpUser extends SignUpState {}

final class LoadingSendEmailVerification extends SignUpState {}

/*
--- 🌟✅ Success ✅🌟 ---
*/
final class SuccessSignUp extends SignUpState {
  const SuccessSignUp();
}

final class SuccessSignUpUser<T extends Authentication> extends SignUpState {
  final User firebaseUser;
  final T auth;
  const SuccessSignUpUser({required this.firebaseUser, required this.auth});

  @override
  List<Object> get props => [firebaseUser];
}

final class SuccessSendEmailVerification extends SignUpState {}

/*
--- 🌟🚨 Error 🚨🌟 ---
*/
final class ErrorSignUp extends SignUpState {
  final String error;
  const ErrorSignUp(this.error);
  String get genericError => 'Error sign up';

  @override
  List<Object> get props => [error];
}

final class ErrorSignUpUser extends ErrorSignUp {
  const ErrorSignUpUser(super.error);

  @override
  String get genericError => 'Error sign up user';
}

final class ErrorSendEmailVerification extends ErrorSignUp {
  const ErrorSendEmailVerification(super.error);

  @override
  String get genericError => 'Error send email verification';
}
