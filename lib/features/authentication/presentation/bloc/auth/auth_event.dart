part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();
}

final class InitializeAuth extends AuthEvent {
  const InitializeAuth();
}

final class LogIn extends AuthEvent {
  final String email;
  final String password;

  const LogIn({
    required this.email,
    required this.password,
  });
}

final class LoginMember extends LogIn {
  const LoginMember({required super.email, required super.password});
}

final class LoginAdmin extends LogIn {
  const LoginAdmin({required super.email, required super.password});
}

final class SendEmailPasswordReset extends AuthEvent {
  final String email;

  const SendEmailPasswordReset({required this.email});
}

final class LogOut extends AuthEvent {
  final Authentication auth;
  const LogOut({
    required this.auth,
  });
}

final class LoginWithGoogle extends AuthEvent {
  const LoginWithGoogle();
}

final class LoginWithFacebook extends AuthEvent {
  const LoginWithFacebook();
}

