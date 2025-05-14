import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:json_annotation/json_annotation.dart';
import 'package:medired/features/authentication/data/models/authentication_model_export.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

part 'authentication_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthenticationModel extends Authentication {
  @JsonKey(name: 'authInfo')
  final AuthInfoModel authInfoModel;
  const AuthenticationModel({
    int? id,
    required this.authInfoModel,
  }) : super(
          authInfo: authInfoModel,
        );

  factory AuthenticationModel.fromEntity(Authentication auth) {
    return AuthenticationModel(
      id: auth.id,
      authInfoModel: AuthInfoModel.fromEntity(auth.authInfo),
    );
  }

  factory AuthenticationModel.fromFirebaseUser(
    firebase.User user, {
    required String password,
    required bool isEnabled,
  }) {
    return AuthenticationModel(
      authInfoModel: AuthInfoModel(
        email: user.email,
        password: password,
        uid: user.uid,
        providerId: user.providerData.first.providerId,
        photoUrl: user.photoURL,
        isEnabled: isEnabled,
      ),
    );
  }

  factory AuthenticationModel.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AuthenticationModelToJson(this);
}
