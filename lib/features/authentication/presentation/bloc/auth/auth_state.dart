part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class UnauthenticatedState extends AuthState {
  const UnauthenticatedState();

  @override
  List<Object?> get props => [];
}

final class AuthenticatedState<T extends Authentication> extends AuthState {
  final T user;
  const AuthenticatedState({required this.user});

  @override
  List<Object?> get props => [user];
}

final class LoadingAuthState extends AuthState {
  const LoadingAuthState();

  @override
  List<Object?> get props => [];
}

final class SuccessAuthState extends UnauthenticatedState {
  final String message;

  const SuccessAuthState(
    this.message,
  );

  @override
  List<Object?> get props => [message];
}

final class ErrorAuthState extends UnauthenticatedState {
  final String message;

  const ErrorAuthState(this.message);

  @override
  List<Object?> get props => [message];
}

final class ErrorEmailUnverifiedState extends ErrorAuthState {
  final auth.User user;
  const ErrorEmailUnverifiedState(super.message, {required this.user});

  @override
  List<Object?> get props => [message, user];
}

final class ErrorMessageAuthState extends ErrorAuthState {
  const ErrorMessageAuthState(super.message);
}
