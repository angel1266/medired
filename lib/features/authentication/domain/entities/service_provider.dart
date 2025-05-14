import 'package:medired/core/value_objects/medical_specialization.dart';
import 'package:medired/core/value_objects/user_type.dart';
import 'package:medired/features/appointments/domain/entities/medical_test.dart';
import 'package:medired/features/authentication/authentication_export.dart';

class ServiceProvider extends Member {
  final PersonalInfo personalInfo;
  final CompanyInfo companyInfo;
  final List<MedicalTest> medicalTests;
  final List<MedicalSpecialization> medicalSpecializations;

  const ServiceProvider({
    required super.authInfo,
    required super.memberInfo,
    required this.companyInfo,
    required this.personalInfo,
    required this.medicalTests,
    required this.medicalSpecializations,
  });

  bool get isSpecializationProvider => medicalSpecializations.isNotEmpty;

  bool get isTestProvider => medicalTests.isNotEmpty;

  @override
  ServiceProvider copyWith({
    int? id,
    AuthInfo? authInfo,
    MemberInfo? memberInfo,
    CompanyInfo? companyInfo,
    PersonalInfo? personalInfo,
    List<MedicalTest>? medicalTests,
    List<MedicalSpecialization>? medicalSpecializations,
  }) {
    return ServiceProvider(
      authInfo: authInfo ?? this.authInfo,
      memberInfo: memberInfo ?? this.memberInfo,
      companyInfo: companyInfo ?? this.companyInfo,
      personalInfo: personalInfo ?? this.personalInfo,
      medicalTests: medicalTests ?? this.medicalTests,
      medicalSpecializations:
          medicalSpecializations ?? this.medicalSpecializations,
    );
  }

  factory ServiceProvider.toEntity(ServiceProviderModel serviceProviderModel) {
    return ServiceProvider(
      authInfo: serviceProviderModel.authInfo,
      memberInfo: serviceProviderModel.memberInfo,
      companyInfo: serviceProviderModel.companyInfo,
      personalInfo: serviceProviderModel.personalInfo,
      medicalTests: serviceProviderModel.medicalTests,
      medicalSpecializations: serviceProviderModel.medicalSpecializations,
    );
  }

  factory ServiceProvider.fromSignUp({
    required AuthInfo authInfo,
    required CompanyInfo companyInfo,
    required List<MedicalTest> medicalTests,
    required List<MedicalSpecialization> medicalSpecializations,
  }) {
    return ServiceProvider(
      authInfo: authInfo,
      memberInfo: MemberInfo.fromEmpty(memberType: UserType.provider),
      companyInfo: companyInfo,
      personalInfo: PersonalInfo.fromSignUp(),
      medicalTests: medicalTests,
      medicalSpecializations: medicalSpecializations,
    );
  }

  @override
  List<Object?> get props => [
        personalInfo,
        memberInfo,
        medicalTests,
        medicalSpecializations,
      ];

  @override
  toJson() => ServiceProviderModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) => ServiceProviderModel.fromJson(json);
}
