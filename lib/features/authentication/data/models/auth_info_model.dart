import 'package:json_annotation/json_annotation.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

part 'auth_info_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthInfoModel extends AuthInfo {
  const AuthInfoModel({
    required super.email,
    required super.password,
    super.uid,
    super.providerId,
    super.photoUrl,
    super.isEnabled,
  });

  factory AuthInfoModel.fromEntity(AuthInfo authInfo) => AuthInfoModel(
        email: authInfo.email,
        password: authInfo.password,
        uid: authInfo.uid,
        providerId: authInfo.providerId,
        photoUrl: authInfo.photoUrl,
        isEnabled: authInfo.isEnabled,
      );

  factory AuthInfoModel.fromJson(Map<String, dynamic> json) =>
      _$AuthInfoModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AuthInfoModelToJson(this);
}
