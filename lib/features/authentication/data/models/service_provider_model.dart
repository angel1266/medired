import 'package:json_annotation/json_annotation.dart';
import 'package:medired/core/value_objects/medical_specialization.dart';
import 'package:medired/features/appointments/data/models/medical_test_model.dart';
import 'package:medired/features/appointments/domain/entities/medical_test.dart';
import 'package:medired/features/authentication/data/models/authentication_model_export.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

part 'service_provider_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ServiceProviderModel extends ServiceProvider {
  @JsonKey(name: 'personalInfo')
  final PersonalInfoModel personalInfoModel;

  @JsonKey(name: 'companyInfo')
  final CompanyInfoModel companyInfoModel;

  @JsonKey(name: 'medicalTests')
  final List<MedicalTestModel> medicalTestModel;

  @JsonKey(name: 'memberInfo')
  final MemberInfoModel memberInfoModel;

  @JsonKey(name: 'authInfo')
  final AuthInfoModel authInfoModel;

  const ServiceProviderModel({
    // required super.medicalCondition,
    // required super.weight,
    // required super.socialSecurity,
    // required super.symptomps,
    required this.personalInfoModel,
    required this.companyInfoModel,
    required this.medicalTestModel,
    required this.memberInfoModel,
    required this.authInfoModel,
    required super.medicalSpecializations,
  }) : super(
          personalInfo: personalInfoModel,
          companyInfo: companyInfoModel,
          medicalTests: medicalTestModel,
          memberInfo: memberInfoModel,
          authInfo: authInfoModel,
        );

  factory ServiceProviderModel.fromMemberEntity({
    required MemberInfoModel memberInfoModel,
    required AuthInfoModel authInfoModel,
    required PersonalInfoModel personalInfoModel,
    required CompanyInfo companyInfo,
    required List<MedicalTest> medicalTests,
    required List<MedicalSpecialization> medicalSpecializations,
  }) {
    return ServiceProviderModel(
      memberInfoModel: memberInfoModel,
      authInfoModel: authInfoModel,
      personalInfoModel: personalInfoModel,
      companyInfoModel: CompanyInfoModel.fromEntity(companyInfo),
      medicalTestModel:
          medicalTests.map((e) => MedicalTestModel.fromEntity(e)).toList(),
      medicalSpecializations: medicalSpecializations,
    );
  }

  factory ServiceProviderModel.fromEntity(ServiceProvider serviceProvider) {
    return ServiceProviderModel(
      // medicalCondition: patient.medicalCondition,
      // socialSecurity: patient.socialSecurity,
      // symptomps: patient.symptomps,
      // weight: patient.weight,
      memberInfoModel: MemberInfoModel.fromEntity(serviceProvider.memberInfo),
      authInfoModel: AuthInfoModel.fromEntity(serviceProvider.authInfo),
      companyInfoModel:
          CompanyInfoModel.fromEntity(serviceProvider.companyInfo),
      personalInfoModel:
          PersonalInfoModel.fromEntity(serviceProvider.personalInfo),
      medicalSpecializations: serviceProvider.medicalSpecializations,
      medicalTestModel: serviceProvider.medicalTests
          .map((e) => MedicalTestModel.fromEntity(e))
          .toList(),
    );
  }

  factory ServiceProviderModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceProviderModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ServiceProviderModelToJson(this);
}
