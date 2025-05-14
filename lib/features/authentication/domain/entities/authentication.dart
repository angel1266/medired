import 'package:equatable/equatable.dart';
import 'package:medired/core/utils/json_serializable/serializable.dart';
import 'package:medired/features/authentication/authentication_export.dart';

class Authentication extends Equatable implements Serializable {
  final int? id;
  final AuthInfo authInfo;

  const Authentication({
    required this.authInfo,
    this.id,
  });

  Authentication copyWith({
    int? id,
    AuthInfo? authInfo,
  }) =>
      Authentication(
        id: id ?? this.id,
        authInfo: authInfo ?? this.authInfo,
      );

  factory Authentication.toEntity(AuthenticationModel authModel) {
    return Authentication(
      id: authModel.id,
      authInfo: authModel.authInfo,
    );
  }

  @override
  List<Object?> get props => [
        id,
        authInfo,
      ];

  @override
  Map<String, dynamic> toJson() =>
      AuthenticationModel.fromEntity(this).toJson();

  @override
  Serializable fromJson(Map<String, dynamic> json) =>
      AuthenticationModel.fromJson(json);
}
