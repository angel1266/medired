import 'package:json_annotation/json_annotation.dart';
import 'package:medired/features/authentication/data/models/authentication_model_export.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

part 'company_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CompanyModel extends Company {
  @JsonKey(name: 'memberInfo')
  final MemberInfoModel memberInfoModel;

  @JsonKey(name: 'companyInfo')
  final CompanyInfoModel companyInfoModel;

  @JsonKey(name: 'authInfo')
  final AuthInfoModel authInfoModel;

  const CompanyModel({
    required this.companyInfoModel,
    required this.memberInfoModel,
    required this.authInfoModel,
  }) : super(
          companyInfo: companyInfoModel,
          memberInfo: memberInfoModel,
          authInfo: authInfoModel,
        );
  factory CompanyModel.fromMemberEntity({
    required MemberInfo memberInfo,
    required CompanyInfo companyInfo,
    required AuthInfo authInfo,
  }) {
    return CompanyModel(
      companyInfoModel: CompanyInfoModel.fromEntity(companyInfo),
      memberInfoModel: MemberInfoModel.fromEntity(memberInfo),
      authInfoModel: AuthInfoModel.fromEntity(authInfo),
    );
  }

  factory CompanyModel.fromEntity(Company company) {
    return CompanyModel(
      // medicalCondition: patient.medicalCondition,
      // socialSecurity: patient.socialSecurity,
      // symptomps: patient.symptomps,
      // weight: patient.weight,
      companyInfoModel: CompanyInfoModel.fromEntity(company.companyInfo),
      memberInfoModel: MemberInfoModel.fromEntity(company.memberInfo),
      authInfoModel: AuthInfoModel.fromEntity(company.authInfo),
    );
  }

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);
}
