import 'package:json_annotation/json_annotation.dart';
import 'package:medired/features/authentication/data/models/authentication_model_export.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

part 'admin_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AdminModel extends Admin {
  @JsonKey(name: 'authInfo')
  final AuthInfoModel authInfoModel;

  @JsonKey(name: 'personalInfo')
  final PersonalInfoModel personalInfoModel;
  const AdminModel({
    required this.authInfoModel,
    required super.adminType,
    required this.personalInfoModel,
  }) : super(
          authInfo: authInfoModel,
          personalInfo: personalInfoModel,
        );

  factory AdminModel.fromAuthEntity({
    required int adminType,
    required AuthInfo authInfo,
    required PersonalInfo personalInfo,
  }) {
    return AdminModel(
      adminType: adminType,
      authInfoModel: AuthInfoModel.fromEntity(authInfo),
      personalInfoModel: PersonalInfoModel.fromEntity(personalInfo),
    );
  }

  factory AdminModel.fromEntity(Admin admin) {
    return AdminModel(
      adminType: admin.adminType,
      authInfoModel: AuthInfoModel.fromEntity(admin.authInfo),
      personalInfoModel: PersonalInfoModel.fromEntity(admin.personalInfo),
    );
  }

  factory AdminModel.fromJson(Map<String, dynamic> json) =>
      _$AdminModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AdminModelToJson(this);
}
