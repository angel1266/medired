part of 'auth_info_bloc.dart';

sealed class AuthInfoEvent extends Equatable {
  const AuthInfoEvent();

  @override
  List<Object> get props => [];
}

final class UpdateAuthInfo extends AuthInfoEvent {
  final AuthInfo authInfo;

  const UpdateAuthInfo(this.authInfo);
}
