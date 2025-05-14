part of 'auth_info_bloc.dart';

sealed class AuthInfoState extends Equatable with Mappable {
  final AuthInfo authInfo;
  const AuthInfoState({required this.authInfo});

  bool get isValid;

  @override
  Map<String, dynamic> toMap() => {
        'authInfo': AuthInfoModel.fromEntity(authInfo).toJson(),
      };

  @override
  List<Object> get props => [authInfo];
}

final class LoadedAuthInfo extends AuthInfoState {
  const LoadedAuthInfo({required super.authInfo});

  @override
  bool get isValid =>
      authInfo.validateEmail == null && authInfo.validatePassword == null;
}
